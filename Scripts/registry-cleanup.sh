#!/bin/bash
#
# registry-cleanup.sh
# Simple maintenance script for Docker Registry (v2) pull-through cache
#
# Usage:
#   ./registry-cleanup.sh [--list | --delete <image:tag> | --gc]
#
# Examples:
#   ./registry-cleanup.sh --list
#   ./registry-cleanup.sh --delete php:8.1
#   ./registry-cleanup.sh --gc
#

REGISTRY_URL="https://registry.itslit"
CONFIG_PATH="/etc/docker/registry/config.yml"
CONTAINER_NAME="registry_registry_1"  # change if your container name differs
CERT_OPT="-k"  # remove if you have valid CA-signed certs

list_images() {
  echo "Fetching repository list from $REGISTRY_URL..."
  repos=$(curl -s $CERT_OPT "$REGISTRY_URL/v2/_catalog" | jq -r '.repositories[]')
  echo ""
  echo "Repositories:"
  for repo in $repos; do
    echo "  - $repo"
  done
}

delete_image() {
  local image_tag="$1"
  if [[ -z "$image_tag" ]]; then
    echo "Error: No image:tag provided"
    exit 1
  fi
  local image="${image_tag%%:*}"
  local tag="${image_tag##*:}"
  echo "Deleting $image:$tag ..."

  digest=$(curl -sI $CERT_OPT "$REGISTRY_URL/v2/$image/manifests/$tag" | grep Docker-Content-Digest | awk '{print $2}' | tr -d $'\r')
  if [[ -z "$digest" ]]; then
    echo "❌ Unable to find digest for $image:$tag"
    exit 1
  fi
  curl -s -X DELETE $CERT_OPT "$REGISTRY_URL/v2/$image/manifests/$digest" && echo "✅ Deleted manifest $digest"
}

run_gc() {
  echo "Running registry garbage collection inside container $CONTAINER_NAME..."
  docker exec -it "$CONTAINER_NAME" registry garbage-collect "$CONFIG_PATH"
  echo "✅ Garbage collection complete"
}

case "$1" in
  --list)
    list_images
    ;;
  --delete)
    delete_image "$2"
    ;;
  --gc)
    run_gc
    ;;
  *)
    echo "Usage: $0 [--list | --delete <image:tag> | --gc]"
    ;;
esac
