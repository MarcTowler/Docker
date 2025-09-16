#!/bin/bash
set -e

# Required env vars:
#   GITHUB_URL
#   GH_PAT
#
# Optional:
#   RUNNER_GROUP  (default: "Default")
#   RUNNER_LABELS (default: "self-hosted,Linux,X64")
#   CLEANUP_AT    (default: "02:00", UTC time for daily cleanup)

if [[ -z "${GITHUB_URL}" || -z "${GH_PAT}" ]]; then
  echo "ERROR: GITHUB_URL and GH_PAT must be set"
  exit 1
fi

RUNNER_GROUP=${RUNNER_GROUP:-"Default"}
RUNNER_LABELS=${RUNNER_LABELS:-"self-hosted,Linux,X64"}
CLEANUP_AT=${CLEANUP_AT:-"02:00"}

cd /home/runner/actions-runner || exit 1

# Strip trailing slash
URL_CLEAN="${GITHUB_URL%/}"

# Detect repo vs org for API
if [[ "$URL_CLEAN" =~ github.com/([^/]+)/([^/]+)$ ]]; then
  OWNER="${BASH_REMATCH[1]}"
  REPO="${BASH_REMATCH[2]}"
  API_URL="https://api.github.com/repos/${OWNER}/${REPO}/actions/runners/registration-token"
  REMOVE_API="https://api.github.com/repos/${OWNER}/${REPO}/actions/runners"
  GROUPS_API="https://api.github.com/repos/${OWNER}/${REPO}/actions/runner-groups"
elif [[ "$URL_CLEAN" =~ github.com/([^/]+)$ ]]; then
  ORG="${BASH_REMATCH[1]}"
  API_URL="https://api.github.com/orgs/${ORG}/actions/runners/registration-token"
  REMOVE_API="https://api.github.com/orgs/${ORG}/actions/runners"
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

# Graceful cleanup on exit
cleanup() {
  echo "🧹 Removing runner ${RUNNER_NAME} from GitHub..."
  RUNNER_ID=$(curl -s -H "Authorization: token ${GH_PAT}" \
    -H "Accept: application/vnd.github.v3+json" \
    "${REMOVE_API}" | jq -r ".runners[] | select(.name==\"${RUNNER_NAME}\") | .id")

  if [[ -n "${RUNNER_ID}" && "${RUNNER_ID}" != "null" ]]; then
    curl -s -X DELETE \
      -H "Authorization: token ${GH_PAT}" \
      -H "Accept: application/vnd.github.v3+json" \
      "${REMOVE_API}/${RUNNER_ID}" >/dev/null
    echo "✅ Runner ${RUNNER_NAME} removed."
  fi
}
trap cleanup EXIT

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

# Start background cleanup job (at CLEANUP_AT daily, UTC)
(
  while true; do
    now=$(date -u +%H:%M)
    if [ "$now" == "$CLEANUP_AT" ]; then
      echo "🧹 Daily cleanup started..."
      rm -rf /home/runner/actions-runner/_work/* || true
      rm -rf /home/runner/actions-runner/_tool/* || true
      # Prune unused Docker images, containers, and volumes
      docker system prune -af --volumes || true
      echo "✅ Cleanup complete."
      sleep 60  # avoid multiple triggers in same minute
    fi
    sleep 30
  done
) &

# Start runner
exec ./run.sh