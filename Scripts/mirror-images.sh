#!/bin/sh
# mirror-images.sh
# Sync selected Docker Hub images into your local registry cache

set -e

REGISTRY="registry.itslit/library"
CLEAN_REGISTRY="registry.itslit"

# List of images to mirror
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
  echo "Pulling ${REGISTRY}/${IMAGE} ..."
  docker pull ${REGISTRY}/${IMAGE}

  echo "Retagging to ${CLEAN_REGISTRY}/${IMAGE} ..."
  docker tag ${REGISTRY}/${IMAGE} ${CLEAN_REGISTRY}/${IMAGE}
  docker push ${CLEAN_REGISTRY}/${IMAGE}
done

echo "=== Mirror sync complete at $(date) ==="
