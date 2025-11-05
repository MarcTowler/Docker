#!/bin/sh
# mirror-images.sh
# Update Docker Hub images in local registry nightly

set -e

REGISTRY="${REGISTRY:-https://registry.itslit}"  # local registry HTTPS
TEMP_LIST="/tmp/repos.txt"

# Ensure tools installed
apk add --no-cache curl jq docker-cli ca-certificates

update-ca-certificates

echo "=== Starting registry mirror sync at $(date) ==="

# Fetch all local registry repositories
REPOS=$(curl -sk "${REGISTRY}/v2/_catalog" | jq -r '.repositories[]') || true

if [ -z "$REPOS" ]; then
  echo "⚠️  No repositories found in ${REGISTRY}."
  exit 0
fi

for REPO in $REPOS; do
  echo -e "\n🔍 Checking repository: $REPO"

  # Skip local-only repos (those not on Docker Hub)
  HUB_REPO=$(echo "$REPO" | sed 's#^library/##')  # remove library prefix
  if ! curl -sfI "https://hub.docker.com/v2/repositories/${HUB_REPO}/tags/latest" >/dev/null 2>&1; then
    echo "  ⚠️  Skipping $REPO: not found on Docker Hub"
    continue
  fi

  TAGS=$(curl -sf "https://hub.docker.com/v2/repositories/${HUB_REPO}/tags/?page_size=1" | jq -r '.results[].name')

  for TAG in $TAGS; do
    echo "  🔄 Updating $REPO:$TAG..."

    docker pull "docker.io/$REPO:$TAG" || { echo "  ❌ Failed to pull $REPO:$TAG, skipping..."; continue; }

    docker tag "docker.io/$REPO:$TAG" "${REGISTRY}/${REPO}:$TAG"

    docker push --tlsverify=false "${REGISTRY}/${REPO}:$TAG" \
      || echo "  ❌ Failed to push $REPO:$TAG, check registry status."
  done
done

echo "=== Mirror sync complete at $(date) ==="
