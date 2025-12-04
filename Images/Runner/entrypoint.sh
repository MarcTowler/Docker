#!/bin/bash
set -euo pipefail

# --------------------------
# Required ENV
# --------------------------
: "${GH_SCOPE:?Must specify org|repo}"
: "${GH_OWNER:?Must specify GH_OWNER}"
: "${GH_APP_ID_FILE:?Must specify GH_APP_ID_FILE}"
: "${GH_INSTALLATION_ID_FILE:?Must specify GH_INSTALLATION_ID_FILE}"
: "${GH_APP_PK_FILE:?Must specify GH_APP_PK_FILE}"
: "${GH_RUNNER_NAME_PREFIX:=swarm-runner}"
: "${GH_LABELS:=self-hosted,swarm}"
: "${GH_RUNNER_GROUP:=Default}"
: "${DISCORD_WEBHOOK_URL:=}"
: "${DISCORD_WEBHOOK_FILE:=}"

# --------------------------
# Load Discord webhook from file if not set
# --------------------------
if [ -z "$DISCORD_WEBHOOK_URL" ] && [ -n "$DISCORD_WEBHOOK_FILE" ] && [ -f "$DISCORD_WEBHOOK_FILE" ]; then
  DISCORD_WEBHOOK_URL="$(cat "$DISCORD_WEBHOOK_FILE")"
fi

GH_APP_ID="$(cat "$GH_APP_ID_FILE")"
GH_INSTALLATION_ID="$(cat "$GH_INSTALLATION_ID_FILE")"
API_URL="https://api.github.com"
RUNNER_NAME="${GH_RUNNER_NAME_PREFIX}-$(hostname)"

# --------------------------
# Discord helper
# --------------------------
discord() {
  local msg="$1"
  if [ -z "$DISCORD_WEBHOOK_URL" ]; then
    echo "[discord] $msg"
    return
  fi
  local payload
  payload=$(jq -n --arg msg "$msg" '{content: $msg}')
  curl -s -H "Content-Type: application/json" \
    -X POST \
    -d "$payload" \
    "$DISCORD_WEBHOOK_URL" >/dev/null 2>&1 || true
}

discord "🚀 Runner container starting on *$(hostname)*"

echo "[entrypoint] Authenticating GitHub App…"

# --------------------------
# Create GitHub App JWT
# --------------------------
JWT=$(python3 - <<EOF
import jwt, time, sys
with open("$GH_APP_PK_FILE") as f: pk=f.read()
now=int(time.time())
payload={"iat":now-60,"exp":now+540,"iss":int("$GH_APP_ID")}
sys.stdout.write(jwt.encode(payload,pk,"RS256"))
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

if [ -z "$INSTALL_TOKEN" ] || [ "$INSTALL_TOKEN" = "null" ]; then
  echo "[entrypoint] ERROR: Failed to get installation token"
  discord "❌ Runner on *$(hostname)* failed to get installation token"
  exit 1
fi

# --------------------------
# Scope (org or repo)
# --------------------------
if [[ "$GH_SCOPE" == "org" ]]; then
  TOKEN_URL="$API_URL/orgs/$GH_OWNER/actions/runners/registration-token"
  RUNNER_URL="https://github.com/$GH_OWNER"
else
  : "${GH_REPOSITORY:?GH_REPOSITORY required for repo scope}"
  TOKEN_URL="$API_URL/repos/$GH_OWNER/$GH_REPOSITORY/actions/runners/registration-token"
  RUNNER_URL="https://github.com/$GH_OWNER/$GH_REPOSITORY"
fi

REG_TOKEN=$(curl -sX POST \
  -H "Authorization: Bearer ${INSTALL_TOKEN}" \
  -H "Accept: application/vnd.github+json" \
  "$TOKEN_URL" | jq -r '.token')

if [ -z "$REG_TOKEN" ] || [ "$REG_TOKEN" = "null" ]; then
  echo "[entrypoint] ERROR: Failed to get runner registration token"
  discord "❌ Runner on *$(hostname)* failed to get registration token"
  exit 1
fi

# --------------------------
# Light auto-update / dependencies
# --------------------------
echo "[entrypoint] Running runner dependency check/update…"
su runner -c "./bin/installdependencies.sh" || true
su runner -c "./bin/Runner.Listener --version" || true
discord "🔄 Runner dependency check completed on *$(hostname)*"

# --------------------------
# Fix docker.sock
# --------------------------
if [ -S /var/run/docker.sock ]; then
  echo "[entrypoint] Fixing docker.sock permissions…"
  chown root:docker /var/run/docker.sock || true
  chmod 660 /var/run/docker.sock || true
fi

# --------------------------
# Build config args
# --------------------------
ARGS=(
  --unattended
  --replace
  --name "$RUNNER_NAME"
  --labels "$GH_LABELS"
  --token "$REG_TOKEN"
  --url "$RUNNER_URL"
)

if [[ "$GH_SCOPE" == "org" ]]; then
  ARGS+=(--runnergroup "$GH_RUNNER_GROUP")
fi

echo "[entrypoint] Configuring runner as non-root…"

su runner -c "./config.sh ${ARGS[*]}"

cleanup() {
  echo "[entrypoint] Deregistering runner..."
  discord "⚠️ Runner *$RUNNER_NAME* on *$(hostname)* stopping"
  su runner -c "./config.sh remove --unattended --token $REG_TOKEN" || true
}
trap cleanup EXIT

discord "🟢 Runner *$RUNNER_NAME* is online and ready"
echo "[entrypoint] Runner is starting…"

exec su runner -c "./run.sh"
