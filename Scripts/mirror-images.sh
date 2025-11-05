#!/bin/sh
# mirror-images.sh
# Sync and update all images currently stored in your local registry.

set -e

REGISTRY_HOST="registry.itslit"
REGISTRY_URL="https://${REGISTRY_HOST}"

echo "=== Starting registry mirror sync at $(date) ==="

# Ensure tools are installed
if ! command -v curl >/dev/null 2>&1; then
  echo "Installing curl, jq, and docker-cli..."
  apk add --no-cache curl jq docker-cli >/dev/null
fi

# Fetch repository list (ignore cert errors for self-signed)
REPOS=$(curl -ks ${REGISTRY_URL}/v2/_catalog | jq -r '.repositories[]' || true)

if [ -z "$REPOS" ]; then
  echo "⚠️  No repositories found in ${REGISTRY_URL}."
  exit 0
fi

# Loop through each repository and check tags
for REPO in $REPOS; do
  echo "📦 Checking repository: ${REPO}"

  TAGS=$(curl -ks ${REGISTRY_URL}/v2/${REPO}/tags/list | jq -r '.tags[]' || true)
  if [ -z "$TAGS" ]; then
    echo "  ⚠️  No tags found for ${REPO}, skipping..."
    continue
  fi

  for TAG in $TAGS; do
    FULL_IMAGE="docker.io/${REPO}:${TAG}"
    LOCAL_IMAGE="${REGISTRY_HOST}/${REPO}:${TAG}"

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
