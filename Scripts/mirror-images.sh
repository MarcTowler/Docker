#!/bin/sh
set -e

REGISTRY="registry.itslit"
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
  SRC="docker.io/library/${IMAGE}"
  DEST="${REGISTRY}/${IMAGE#library/}"

  # Skip if already in registry
  if curl -fsSL "https://${REGISTRY}/v2/${IMAGE#library/}/manifests/${IMAGE##*:}" >/dev/null 2>&1; then
    echo "[Skip] ${DEST} already exists in registry"
    continue
  fi

  echo "[Pull] ${SRC}"
  docker pull "${SRC}"

  echo "[Tag] ${SRC} -> ${DEST}"
  docker tag "${SRC}" "${DEST}"

  echo "[Push] ${DEST}"
  docker push "${DEST}"
done

echo "=== Mirror sync complete at $(date) ==="
