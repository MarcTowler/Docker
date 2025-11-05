#!/bin/sh
# mirror-images.sh
# Automatically update and mirror all local registry images.

set -e

# Allow custom registry via environment variable
REGISTRY_URL="${REGISTRY_URL:-https://registry.itslit}"

echo "=== Starting registry mirror sync at $(date) ==="

# --- Install tools only once per container ---
if [ ! -f "/usr/bin/jq" ] || [ ! -f "/usr/bin/curl" ]; then
  echo "Installing curl, jq, and docker-cli..."
  apk add --no-cache curl jq docker-cli ca-certificates >/dev/null
  update-ca-certificates
else
  echo "✅ curl, jq, and docker-cli already installed"
fi

# --- Fetch repository list ---
REPOS=$(curl -ks "${REGISTRY_URL}/v2/_catalog" | jq -r '.repositories[]' || true)

if [ -z "$REPOS" ]; then
  echo "⚠️  No repositories found in ${REGISTRY_URL}."
  exit 0
fi

# --- Process each repository ---
for REPO in $REPOS; do
  echo "📦 Checking repository: ${REPO}"

  TAGS=$(curl -ks "${REGISTRY_URL}/v2/${REPO}/tags/list" | jq -r '.tags[]' || true)
  if [ -z "$TAGS" ]; then
    echo "  ⚠️  No tags found for ${REPO}, skipping..."
    continue
  fi

  for TAG in $TAGS; do
    FULL_IMAGE="docker.io/${REPO}:${TAG}"
    LOCAL_IMAGE="${REGISTRY_URL#https://}/${REPO}:${TAG}"

    echo "  🔄 Updating ${REPO}:${TAG}..."
    docker pull "${FULL_IMAGE}" >/dev/null 2>&1 || {
      echo "  ❌ Failed to pull ${FULL_IMAGE}, skipping..."
      continue
    }

    docker tag "${FULL_IMAGE}" "${LOCAL_IMAGE}"
    docker push "${LOCAL_IMAGE}" >/dev/null 2>&1 && echo "  ✅ Updated ${LOCAL_IMAGE}"
  done
done

echo "=== Mirror sync complete at $(date) ==="
