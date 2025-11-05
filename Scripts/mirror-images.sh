#!/bin/sh
# mirror-images.sh — refresh images in the local registry nightly

set -e

echo "=== Starting registry mirror sync at $(date) ==="

REGISTRY_URL="${REGISTRY_URL:-http://registry:5000}"

echo "Installing curl, jq, and docker-cli..."
apk add --no-cache curl jq docker-cli > /dev/null

# Get list of repositories from the registry catalog
REPOS=$(curl -s "${REGISTRY_URL}/v2/_catalog" | jq -r '.repositories[]?' || true)

if [ -z "$REPOS" ]; then
  echo "⚠️  No repositories found in ${REGISTRY_URL}."
  exit 0
fi

for REPO in $REPOS; do
  echo "🔍 Checking repository: ${REPO}"

  TAGS=$(curl -s "${REGISTRY_URL}/v2/${REPO}/tags/list" | jq -r '.tags[]?' || true)
  if [ -z "$TAGS" ]; then
    echo "  ⚠️  No tags found for ${REPO}, skipping."
    continue
  fi

  for TAG in $TAGS; do
    LOCAL_IMAGE="${REGISTRY_URL#http://}/${REPO}:${TAG}"

    # Check image age (skip if < 24h old)
    IMAGE_INFO=$(docker image inspect "$LOCAL_IMAGE" --format '{{.Metadata.LastTagTime}}' 2>/dev/null || true)
    if [ -n "$IMAGE_INFO" ]; then
      LAST_PULL=$(date -d "$IMAGE_INFO" +%s 2>/dev/null || echo 0)
      NOW=$(date +%s)
      AGE=$(( (NOW - LAST_PULL) / 3600 ))
      if [ "$AGE" -lt 24 ]; then
        echo "  ⏩ ${LOCAL_IMAGE} is less than 24h old — skipping..."
        continue
      fi
    fi

    echo "  🔄 Updating ${REPO}:${TAG}..."
    docker pull "${REPO}:${TAG}" || {
      echo "  ❌ Failed to pull ${REPO}:${TAG}, skipping..."
      continue
    }

    docker tag "${REPO}:${TAG}" "${REGISTRY_URL#http://}/${REPO}:${TAG}"
    docker push "${REGISTRY_URL#http://}/${REPO}:${TAG}" || {
      echo "  ❌ Failed to push ${REPO}:${TAG}, check registry status."
      continue
    }

    echo "  ✅ Updated ${REPO}:${TAG}"
  done
done

echo "=== Mirror sync complete at $(date) ==="
