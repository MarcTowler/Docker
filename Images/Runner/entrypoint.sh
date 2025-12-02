#!/usr/bin/env bash
set -euo pipefail

# --------------------------------------------
# Required environment variables
# --------------------------------------------
: "${GH_SCOPE:?GH_SCOPE must be 'org' or 'repo'}"
: "${GH_OWNER:?Must specify GH_OWNER}"
: "${GH_RUNNER_NAME_PREFIX:=swarm-runner}"
: "${GH_LABELS:=self-hosted,swarm}"
: "${GH_APP_ID_FILE:?Must specify GH_APP_ID_FILE}"
: "${GH_INSTALLATION_ID_FILE:?Must specify GH_INSTALLATION_ID_FILE}"
: "${GH_APP_PK_FILE:?Must specify GH_APP_PK_FILE}"
: "${GH_RUNNER_GROUP:=Default}"

# --------------------------------------------
# Load secrets from Docker secret files
# --------------------------------------------
if [[ ! -f "$GH_APP_ID_FILE" ]]; then
  echo "ERROR: GitHub App ID file not found: $GH_APP_ID_FILE"
  exit 1
fi
GH_APP_ID=$(cat "$GH_APP_ID_FILE")

if [[ ! -f "$GH_INSTALLATION_ID_FILE" ]]; then
  echo "ERROR: Installation ID file not found: $GH_INSTALLATION_ID_FILE"
  exit 1
fi
GH_INSTALLATION_ID=$(cat "$GH_INSTALLATION_ID_FILE")

if [[ ! -f "$GH_APP_PK_FILE" ]]; then
  echo "ERROR: GitHub App private key not found: $GH_APP_PK_FILE"
  exit 1
fi

API_URL="https://api.github.com"
RUNNER_NAME="${GH_RUNNER_NAME_PREFIX}-$(hostname)"

echo "[entrypoint] Starting GitHub App authentication…"
echo "[entrypoint] App ID: $GH_APP_ID"
echo "[entrypoint] Installation ID: $GH_INSTALLATION_ID"

# --------------------------------------------
# Generate JWT for GitHub App
# --------------------------------------------
JWT=$(python3 - <<EOF
import jwt, time, sys
with open("$GH_APP_PK_FILE", "r") as f:
    pk = f.read()
now = int(time.time())
payload = {
    "iat": now - 60,
    "exp": now + (9 * 60),
    "iss": int("$GH_APP_ID"),
}
token = jwt.encode(payload, pk, algorithm="RS256")
sys.stdout.write(token)
EOF
)

# --------------------------------------------
# Exchange JWT → Installation Access Token
# --------------------------------------------
INSTALL_TOKEN=$(curl -sX POST \
  -H "Authorization: Bearer ${JWT}" \
  -H "Accept: application/vnd.github+json" \
  "${API_URL}/app/installations/${GH_INSTALLATION_ID}/access_tokens" \
  | jq -r '.token')

if [[ -z "$INSTALL_TOKEN" || "$INSTALL_TOKEN" == "null" ]]; then
  echo "ERROR: Could not obtain installation token"
  exit 1
fi

# --------------------------------------------
# Request runner registration token
# --------------------------------------------
if [[ "$GH_SCOPE" == "org" ]]; then
  RUNNER_URL="https://github.com/${GH_OWNER}"
  TOKEN_URL="${API_URL}/orgs/${GH_OWNER}/actions/runners/registration-token"
elif [[ "$GH_SCOPE" == "repo" ]]; then
  : "${GH_REPOSITORY:?GH_REPOSITORY is required when GH_SCOPE=repo}"
  RUNNER_URL="https://github.com/${GH_OWNER}/${GH_REPOSITORY}"
  TOKEN_URL="${API_URL}/repos/${GH_OWNER}/${GH_REPOSITORY}/actions/runners/registration-token"
fi

REG_TOKEN=$(curl -sX POST \
  -H "Authorization: Bearer ${INSTALL_TOKEN}" \
  -H "Accept: application/vnd.github+json" \
  "$TOKEN_URL" | jq -r '.token')

if [[ -z "$REG_TOKEN" || "$REG_TOKEN" == "null" ]]; then
  echo "ERROR: Could not obtain GitHub registration token"
  exit 1
fi

# --------------------------------------------
# Configure Runner
# --------------------------------------------
echo "[entrypoint] Configuring runner…"

CONFIG_ARGS=(
  --unattended
  --url "$RUNNER_URL"
  --token "$REG_TOKEN"
  --name "$RUNNER_NAME"
  --labels "$GH_LABELS"
  --replace
)

# Runner groups only apply to org runners
if [[ "$GH_SCOPE" == "org" && -n "$GH_RUNNER_GROUP" ]]; then
  CONFIG_ARGS+=( --runnergroup "$GH_RUNNER_GROUP" )
fi

./config.sh "${CONFIG_ARGS[@]}"

# --------------------------------------------
# Cleanup on Exit
# --------------------------------------------
cleanup() {
  echo "[entrypoint] Deregistering runner…"
  ./config.sh remove --unattended --token "$REG_TOKEN" || true
}
trap cleanup EXIT

# --------------------------------------------
# Start Runner
# --------------------------------------------
echo "[entrypoint] Runner is starting."
exec ./run.sh
