#!/bin/sh
# mirror-images.sh
# Sync selected Docker Hub images into your local registry

set -e

# Local namespace in your registry
LOCAL_REGISTRY="registry.itslit"

# List of images to mirror (Docker Hub format)
IMAGES="
mysql:8.0
php:8.1-apache
node:current-alpine
redis:7-alpine
nginx:stable-alpine
vaultwarden/server:latest
"

echo "=== Starting registry mirror sync at $(date) ==="

for IMAGE in $IMAGES; do
  # Pull from Docker Hub (via pull-through)
  echo "Pulling docker.io/$IMAGE ..."
  docker pull "docker.io/$IMAGE"

  # Retag to your local registry
  LOCAL_IMAGE="${LOCAL_REGISTRY}/$(basename $(echo $IMAGE | cut -d/ -f2-))"
  echo "Retagging $IMAGE -> $LOCAL_IMAGE ..."
  docker tag "$IMAGE" "$LOCAL_IMAGE"

  # Push into local registry
  echo "Pushing $LOCAL_IMAGE ..."
  docker push "$LOCAL_IMAGE"
done

echo "=== Mirror sync complete at $(date) ==="
