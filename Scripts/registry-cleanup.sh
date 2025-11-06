#!/bin/sh
set -e

REGISTRY_SERVICE="registry_registry"   # Stack name + service name (adjust if needed)
CONFIG_PATH="/etc/docker/registry/config.yml"

echo "=== Running Registry Garbage Collection at $(date) ==="

# Find the running container for the registry service
CONTAINER_ID=$(docker ps --filter "name=${REGISTRY_SERVICE}" --format "{{.ID}}" | head -n 1)

if [ -z "$CONTAINER_ID" ]; then
  echo "❌ Registry container not found!"
  exit 1
fi

# Run garbage collection
echo "🧹 Starting garbage-collect..."
docker exec "$CONTAINER_ID" registry garbage-collect "$CONFIG_PATH" --delete-untagged=true

echo "✅ Garbage collection completed at $(date)"
