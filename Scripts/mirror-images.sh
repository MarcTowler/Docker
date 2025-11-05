#!/bin/sh
# mirror-images.sh
# Automatically updates all existing images in your local registry from Docker Hub

set -e

REGISTRY="registry.itslit"
LOG_DIR="/var/lib/registry/logs"
LOG_FILE="${LOG_DIR}/mirror.log"

mkdir -p "${LOG_DIR}"

echo "=== Starting registry mirror sync at $(date) ===" | tee -a "$LOG_FILE"

# Use curl to list repositories in your local registry
REPOS=$(curl -s "https://${REGISTRY}/v2/_catalog" | jq -r '.repositories[]' || true)

if [ -z "$REPOS" ]; then
  echo "⚠️  No repositories found in ${REGISTRY}." | tee -a "$LOG_FILE"
  exit 0
fi

for REPO in $REPOS; do
  echo "" | tee -a "$LOG_FILE"
  echo "📦 Checking repository: ${REPO}" | tee -a "$LOG_FILE"

  TAGS=$(curl -s "https://${REGISTRY}/v2/${REPO}/tags/list" | jq -r '.tags[]' || true)

  if [ -z "$TAGS" ]; then
    echo "  ❌ No tags found for ${REPO}" | tee -a "$LOG_FILE"
    continue
  fi

  for TAG in $TAGS; do
    IMAGE="${REPO}:${TAG}"
    LOCAL_TAG="${REGISTRY}/${IMAGE}"

    echo "  🔄 Updating ${IMAGE}..." | tee -a "$LOG_FILE"

    # Pull the latest image from Docker Hub
    docker pull "${IMAGE}" 2>&1 | tee -a "$LOG_FILE" || {
      echo "  ⚠️  Failed to pull ${IMAGE} from Docker Hub" | tee -a "$LOG_FILE"
      continue
    }

    # Retag for the local registry
    docker tag "${IMAGE}" "${LOCAL_TAG}"

    # Push to the local registry
    docker push "${LOCAL_TAG}" 2>&1 | tee -a "$LOG_FILE" || {
      echo "  ⚠️  Failed to push ${LOCAL_TAG}" | tee -a "$LOG_FILE"
      continue
    }

    # Clean up local cache
    docker image rm "${IMAGE}" "${LOCAL_TAG}" >/dev/null 2>&1 || true

    echo "  ✅ Updated ${LOCAL_TAG}" | tee -a "$LOG_FILE"
  done
done

echo "" | tee -a "$LOG_FILE"
echo "✅ Mirror sync complete at $(date)" | tee -a "$LOG_FILE"
