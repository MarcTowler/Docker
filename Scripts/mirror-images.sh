#!/bin/sh
set -e

# Local registry hostname (the one Traefik exposes)
LOCAL_REGISTRY="registry.itslit"
LOCAL_REGISTRY_URL="https://${LOCAL_REGISTRY}"

# Directory to store logs
LOG_DIR="/var/log/registry-mirror"
mkdir -p "$LOG_DIR"
LOG_FILE="${LOG_DIR}/mirror-$(date +%F).log"

# Certificate for the local registry (if using self-signed certs)
CERT_FILE="/usr/local/share/ca-certificates/wildcard.crt"
if [ -f "$CERT_FILE" ]; then
  update-ca-certificates >/dev/null 2>&1 || true
fi

echo "=== Registry Mirror Sync started at $(date) ===" | tee -a "$LOG_FILE"

# Function: fetch list of repositories from local registry
get_repositories() {
  curl -s --insecure "${LOCAL_REGISTRY_URL}/v2/_catalog" | jq -r '.repositories[]' 2>/dev/null || true
}

# Function: fetch tags for a given repo
get_tags() {
  local repo=$1
  curl -s --insecure "${LOCAL_REGISTRY_URL}/v2/${repo}/tags/list" | jq -r '.tags[]' 2>/dev/null || true
}

# Pull, tag, and push each image
sync_image() {
  local repo=$1
  local tag=$2
  local local_image="${LOCAL_REGISTRY}/${repo}:${tag}"
  local remote_image="${repo}:${tag}"

  echo "→ Syncing ${remote_image}" | tee -a "$LOG_FILE"

  # Pull latest from Docker Hub
  if docker pull "$remote_image" >>"$LOG_FILE" 2>&1; then
    # Retag and push to local registry
    docker tag "$remote_image" "$local_image"
    docker push "$local_image" >>"$LOG_FILE" 2>&1
    echo "✓ Updated ${local_image}" | tee -a "$LOG_FILE"
  else
    echo "✗ Failed to pull ${remote_image}" | tee -a "$LOG_FILE"
  fi
}

# Ensure Docker is available
if ! docker info >/dev/null 2>&1; then
  echo "Docker not available. Exiting." | tee -a "$LOG_FILE"
  exit 1
fi

# Loop through all repositories
for repo in $(get_repositories); do
  echo "Checking repository: ${repo}" | tee -a "$LOG_FILE"
  for tag in $(get_tags "$repo"); do
    sync_image "$repo" "$tag"
  done
done

echo "=== Registry Mirror Sync completed at $(date) ===" | tee -a "$LOG_FILE"
