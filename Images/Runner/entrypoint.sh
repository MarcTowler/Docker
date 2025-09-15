#!/bin/bash
set -e

# Required env vars:
#   GITHUB_URL
#   GH_PAT
#
# Optional:
#   RUNNER_GROUP  (default: "Default")
#   RUNNER_LABELS (default: "self-hosted,Linux,X64")

if [[ -z "${GITHUB_URL}" || -z "${GH_PAT}" ]]; then
  echo "ERROR: GITHUB_URL and GH_PAT must be set"
  exit 1
fi

RUNNER_GROUP=${RUNNER_GROUP:-"ContainerRunners"}
RUNNER_LABELS=${RUNNER_LABELS:-"self-hosted,Linux,X64,docker"}

# Normalize URL
URL_CLEAN="${GITHUB_URL%/}"

cd /home/*/actions-runner || exit 1

# ensure _work/_tool is writable by runner
mkdir -p /home/runner/actions-runner/_work/_tool
chown -R $(id -u):$(id -g) /home/runner/actions-runner/_work


# Detect repo vs org
if [[ "$URL_CLEAN" =~ github.com/([^/]+)/([^/]+)$ ]]; then
  OWNER="${BASH_REMATCH[1]}"
  REPO="${BASH_REMATCH[2]}"
  API_URL="https://api.github.com/repos/${OWNER}/${REPO}/actions/runners/registration-token"
elif [[ "$URL_CLEAN" =~ github.com/([^/]+)$ ]]; then
  ORG="${BASH_REMATCH[1]}"
  API_URL="https://api.github.com/orgs/${ORG}/actions/runners/registration-token"
else
  echo "Invalid GITHUB_URL: $GITHUB_URL"
  exit 1
fi

# Request fresh token
RUNNER_TOKEN=$(curl -s -X POST \
  -H "Authorization: token ${GH_PAT}" \
  -H "Accept: application/vnd.github.v3+json" \
  "${API_URL}" | jq -r .token)

if [[ -z "${RUNNER_TOKEN}" || "${RUNNER_TOKEN}" == "null" ]]; then
  echo "ERROR: Failed to fetch runner token"
  exit 1
fi

# Generate unique runner name
RUNNER_NAME="$(hostname)-$(tr -dc 'a-z0-9' < /dev/urandom | fold -w 6 | head -n 1)"

# Remove old config (if container restarted)
if [ -f .runner ]; then
  ./config.sh remove --unattended --token "${RUNNER_TOKEN}" || true
fi

# Configure as ephemeral
./config.sh --unattended \
  --ephemeral \
  --url "${GITHUB_URL}" \
  --token "${RUNNER_TOKEN}" \
  --name "${RUNNER_NAME}" \
  --runnergroup "${RUNNER_GROUP}" \
  --labels "${RUNNER_LABELS}" \
  --work _work

exec ./run.sh
