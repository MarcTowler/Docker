#!/bin/sh
set -e

# === CONFIGURATION ===
LOCAL_REGISTRY="registry.itslit"
LOCAL_REGISTRY_URL="https://${LOCAL_REGISTRY}"

# Directories and log setup
LOG_DIR="/var/log/registry-mirror"
mkdir -p "$LOG_DIR"
LOG_FILE="${LOG_DIR}/mirror-$(date +%F).log"

# Trust local cert if needed
CERT_FILE="/usr/local/share/ca-certificates/wildcard.crt"
if [ -f "$CERT_FILE" ]; then
  update-ca-certificates >/dev/null 2>&1 || true
fi

echo "=== Registry Mirror Sync started at $(date) ===" | tee -a "$LOG_FILE"

# === Helper Functions ===

# List all repositories from local registry
get_local_repositories() {
  curl -s --insecure "${LOCAL_REGISTRY_URL}/v2/_catalog?n=10000" | jq -r '.repositories[]' 2>/dev/null || true
}

# List tags for a repository in local registry
get_local_tags() {
  local repo="$1"
  curl -s --insecure "${LOCAL_REGISTRY_URL}/v2/${repo}/tags/list" | jq -r '.tags[]' 2>/dev/null || true
}

# List tags from Docker Hub (public)
get_remote_tags() {
  local repo="$1"
  # Handle official library images (e.g., "nginx" instead of "library/nginx")
  local api_repo
  if echo "$repo" | grep -q '^library/'; then
    api_repo=$(echo "$repo" | cut -d'/' -f2-)
  else
    api_repo="$repo"
  fi

  curl -s "https://registry.hub.docker.com/v2/repositories/${api_repo}/tags/?page_size=100" | jq -r '.results[].name' 2>/dev/null || true
}

# Delete tag from local registry
delete_local_tag() {
  local repo="$1"
  local tag="$2"
  echo "🗑  Removing obsolete tag: ${repo}:${tag}" | tee -a "$LOG_FILE"

  # Get the digest for the manifest, then delete it
  local digest
  digest=$(curl -sI --insecure -H "Accept: application/vnd.docker.distribution.manifest.v2+json" \
    "${LOCAL_REGISTRY_URL}/v2/${repo}/manifests/${tag}" | grep Docker-Content-Digest | awk '{print $2}' | tr -d '\r')

  if [ -n "$digest" ]; then
    curl -s -X DELETE --insecure \
      "${LOCAL_REGISTRY_URL}/v2/${repo}/manifests/${digest}" >>"$LOG_FILE" 2>&1
    echo "✓ Deleted ${repo}:${tag}" | tee -a "$LOG_FILE"
  else
    echo "⚠️  Could not find digest for ${repo}:${tag}" | tee -a "$LOG_FILE"
  fi
}

# Pull, tag, and push
sync_image() {
  local repo="$1"
  local tag="$2"
  local local_image="${LOCAL_REGISTRY}/${repo}:${tag}"
  local remote_image="${repo}:${tag}"

  echo "→ Syncing ${remote_image}" | tee -a "$LOG_FILE"

  if docker pull "$remote_image" >>"$LOG_FILE" 2>&1; then
    docker tag "$remote_image" "$local_image"
    docker push "$local_image" >>"$LOG_FILE" 2>&1
    echo "✓ Updated ${local_image}" | tee -a "$LOG_FILE"
  else
    echo "✗ Failed to pull ${remote_image}" | tee -a "$LOG_FILE"
  fi
}

# === MAIN ===

# Verify Docker is running
if ! docker info >/dev/null 2>&1; then
  echo "Docker unavailable. Exiting." | tee -a "$LOG_FILE"
  exit 1
fi

# Iterate over repos
for repo in $(get_local_repositories); do
  # Skip library images stored locally
  if echo "$repo" | grep -qE "^library(/|$)"; then
    echo "⚠️  Skipping internal repo: ${repo}" | tee -a "$LOG_FILE"
    continue
  fi

  echo "🔍 Checking repository: ${repo}" | tee -a "$LOG_FILE"

  local_tags=$(get_local_tags "$repo")
  remote_tags=$(get_remote_tags "$repo")

  # --- Delete tags not found upstream ---
  for tag in $local_tags; do
    if ! echo "$remote_tags" | grep -qx "$tag"; then
      delete_local_tag "$repo" "$tag"
    fi
  done

  # --- Sync or update upstream tags ---
  for tag in $remote_tags; do
    [ -z "$tag" ] && continue
    sync_image "$repo" "$tag"
  done
done

echo "=== Registry Mirror Sync completed at $(date) ===" | tee -a "$LOG_FILE"
