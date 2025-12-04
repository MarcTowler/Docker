#!/usr/bin/env bash
set -euo pipefail

# --------------------------
# Required environment vars
# --------------------------
: "${GH_SCOPE:?Must specify GH_SCOPE org|repo}"
: "${GH_OWNER:?Must specify GH_OWNER}"
: "${GH_APP_ID_FILE:?Must specify GH_APP_ID_FILE}"
: "${GH_INSTALLATION_ID_FILE:?Must specify GH_INSTALLATION_ID_FILE}"
: "${GH_APP_PK_FILE:?Must specify GH_APP_PK_FILE}"
: "${GH_RUNNER_NAME_PREFIX:=swarm-runner}"
: "${GH_LABELS:=self-hosted,swarm}"
: "${GH_RUNNER_GROUP:=Default}"

GH_APP_ID=$(cat $GH_APP_ID_FILE)
GH_INSTALLATION_ID=$(cat $GH_INSTALLATION_ID_FILE)
API_URL="https://api.github.com"
RUNNER_NAME="${GH_RUNNER_NAME_PREFIX}-$(hostname)"

echo "[entrypoint] Starting GitHub App authentication…"

# --------------------------
# Generate JWT
# --------------------------
JWT=$(python3 - <<EOF
import jwt, time, sys
with open("$GH_APP_PK_FILE") as f: pk = f.read()
now = int(time.time())
payload = {"iat": now-60, "exp": now+540, "iss": int("$GH_APP_ID")}
sys.stdout.write(jwt.encode(payload, pk, "RS256"))
EOF
)

# --------------------------
# Exchange JWT → installation token
# --------------------------
INSTALL_TOKEN=$(curl -sX POST \
  -H "Authorization: Bearer ${JWT}" \
  -H "Accept: application/vnd.github+json" \
  "$API_URL/app/installations/$GH_INSTALLATION_ID/access_tokens" \
  | jq -r '.token')

# --------------------------
# Determine scope (org | repo)
# --------------------------
if [[ "$GH_SCOPE" = "org" ]]; then
  TOKEN_URL="$API_URL/orgs/$GH_OWNER/actions/runners/registration-token"
  RUNNER_URL="https://github.com/$GH_OWNER"
else
  : "${GH_REPOSITORY:?GH_REPOSITORY required when GH_SCOPE=repo}"
  TOKEN_URL="$API_URL/repos/$GH_OWNER/$GH_REPOSITORY/actions/runners/registration-token"
  RUNNER_URL="https://github.com/$GH_OWNER/$GH_REPOSITORY"
fi

# --------------------------
# Get runner registration token
# --------------------------
REG_TOKEN=$(curl -sX POST \
  -H "Authorization: Bearer ${INSTALL_TOKEN}" \
  -H "Accept: application/vnd.github+json" \
  "$TOKEN_URL" | jq -r '.token')

# --------------------------
# Docker socket fixes
# --------------------------
if [ -S /var/run/docker.sock ]; then
  echo "[entrypoint] Fixing docker.sock permissions..."
  chown root:docker /var/run/docker.sock || true
  chmod 660 /var/run/docker.sock || true
fi

# --------------------------
# Build config args
# --------------------------
CONFIG_ARGS=(
  --unattended
  --replace
  --name "$RUNNER_NAME"
  --labels "$GH_LABELS"
  --url "$RUNNER_URL"
  --token "$REG_TOKEN"
)

if [[ "$GH_SCOPE" = "org" ]]; then
  CONFIG_ARGS+=(--runnergroup "$GH_RUNNER_GROUP")
fi

echo "[entrypoint] Configuring runner as non-root user..."

su runner -c "./config.sh ${CONFIG_ARGS[*]}"

cleanup() {
  echo "[entrypoint] Deregistering runner…"
  su runner -c "./config.sh remove --unattended --token $REG_TOKEN" || true
}
trap cleanup EXIT

echo "[entrypoint] Runner is starting…"
exec su runner -c "./run.sh"
