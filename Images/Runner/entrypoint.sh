#!/bin/bash
set -e

# Required env vars:
#   GITHUB_URL -> e.g. https://github.com/yourorg/yourrepo
#   GH_PAT     -> Personal Access Token (permanent)

if [[ -z "${GITHUB_URL}" || -z "${GH_PAT}" ]]; then
  echo "ERROR: GITHUB_URL and GH_PAT must be set"
  exit 1
fi

cd /home/runner/actions-runner

# Detect repo vs org
if [[ "$GITHUB_URL" =~ github.com/([^/]+)/([^/]+) ]]; then
  OWNER="${BASH_REMATCH[1]}"
  REPO="${BASH_REMATCH[2]}"
  API_URL="https://api.github.com/repos/${OWNER}/${REPO}/actions/runners/registration-token"
elif [[ "$GITHUB_URL" =~ github.com/([^/]+)$ ]]; then
  ORG="${BASH_REMATCH[1]}"
  API_URL="https://api.github.com/orgs/${ORG}/actions/runners/registration-token"
else
  echo "Invalid GITHUB_URL: $GITHUB_URL"
  exit 1
fi

# Request fresh token from GitHub API
RUNNER_TOKEN=$(curl -s -X POST -H "Authorization: token ${GH_PAT}" -H "Accept: application/vnd.github.v3+json" "${API_URL}" | jq -r .token)

if [[ -z "${RUNNER_TOKEN}" || "${RUNNER_TOKEN}" == "null" ]]; then
  echo "ERROR: Failed to fetch runner token"
  exit 1
fi

# Remove previous config if container restarted
if [ -f .runner ]; then
  ./config.sh remove --unattended --token "${RUNNER_TOKEN}" || true
fi

./config.sh --unattended \
  --url "${GITHUB_URL}" \
  --token "${RUNNER_TOKEN}" \
  --name "$(hostname)" \
  --work _work

cleanup() {
  echo "Removing runner..."
  ./config.sh remove --unattended --token "${RUNNER_TOKEN}" || true
}
trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

exec ./run.sh
