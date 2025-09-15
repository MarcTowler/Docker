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

RUNNER_GROUP=${RUNNER_GROUP:-"Default"}
RUNNER_LABELS=${RUNNER_LABELS:-"self-hosted,Linux,X64"}

cd /home/runner/actions-runner || exit 1

# Strip trailing slash
URL_CLEAN="${GITHUB_URL%/}"

# Detect repo vs org for API
if [[ "$URL_CLEAN" =~ github.com/([^/]+)/([^/]+)$ ]]; then
  OWNER="${BASH_REMATCH[1]}"
  REPO="${BASH_REMATCH[2]}"
  API_URL="https://api.github.com/repos/${OWNER}/${REPO}/actions/runners/registration-token"
  GROUPS_API="https://api.github.com/repos/${OWNER}/${REPO}/actions/runner-groups"
elif [[ "$URL_CLEAN" =~ github.com/([^/]+)$ ]]; then
  ORG="${BASH_REMATCH[1]}"
  API_URL="https://api.github.com/orgs/${ORG}/actions/runners/registration-token"
  GROUPS_API="https://api.github.com/orgs/${ORG}/actions/runner-groups"
else
  echo "Invalid GITHUB_URL: $GITHUB_URL"
  exit 1
fi

# Validate runner group (fallback to Default if missing)
AVAILABLE_GROUPS=$(curl -s -H "Authorization: token ${GH_PAT}" \
  -H "Accept: application/vnd.github.v3+json" \
  "${GROUPS_API}" | jq -r '.runner_groups[].name')

if ! echo "${AVAILABLE_GROUPS}" | grep -qw "${RUNNER_GROUP}"; then
  echo "⚠️ Runner group '${RUNNER_GROUP}' not found. Falling back to 'Default'."
  RUNNER_GROUP="Default"
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

# Remove previous config if container restarted
if [ -f .runner ]; then
  ./config.sh remove --unattended --token "${RUNNER_TOKEN}" || true
fi

# Configure ephemeral runner
./config.sh --unattended \
  --ephemeral \
  --url "${GITHUB_URL}" \
  --token "${RUNNER_TOKEN}" \
  --name "${RUNNER_NAME}" \
  --runnergroup "${RUNNER_GROUP}" \
  --labels "${RUNNER_LABELS}" \
  --work _work

exec ./run.sh
