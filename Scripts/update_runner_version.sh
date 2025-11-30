#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
DOCKERFILE="${ROOT_DIR}/Dockerfile"
IMAGE_TAG="registry.itslit/library/github-runner:latest"

echo "[*] Fetching latest GitHub Actions Runner version..."
LATEST_TAG="$(curl -s https://api.github.com/repos/actions/runner/releases/latest | jq -r '.tag_name')"

if [ -z "$LATEST_TAG" ] || [ "$LATEST_TAG" = "null" ]; then
  echo "ERROR: Could not determine latest runner version"
  exit 1
fi

# Tag is like "v2.319.1" -> strip 'v'
LATEST_VERSION="${LATEST_TAG#v}"

echo "[*] Latest runner version: ${LATEST_VERSION}"

echo "[*] Updating RUNNER_VERSION in Dockerfile..."
# Replace the line: ARG RUNNER_VERSION="..."
sed -i "s/^ARG RUNNER_VERSION=\".*\"/ARG RUNNER_VERSION=\"${LATEST_VERSION}\"/" "$DOCKERFILE"

echo "[*] Building new image..."
cd "$ROOT_DIR"
docker build -t "${IMAGE_TAG}" .

echo "[*] Pushing image to registry..."
docker push "${IMAGE_TAG}"

echo "[*] Image updated. Now redeploy the stack:"
echo "    ./scripts/deploy-github-runners.sh"
