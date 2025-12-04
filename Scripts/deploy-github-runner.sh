#!/usr/bin/env bash
set -euo pipefail

STACK_FILE="../Runner/runner-stack.yml"
STACK_NAME="github-runners"

# === Allow self-signed certs ===
export NODE_TLS_REJECT_UNAUTHORIZED=0

export BW_SERVER="https://vault.itslit"
BW_EMAIL="svc-docker@itslit"

if [ -z "${BW_PASSWORD:-}" ]; then
  echo "BW_PASSWORD is not set. Export it before running."
  exit 1
fi

echo "[*] Logging into Vaultwarden..."
bw logout >/dev/null 2>&1 || true
bw login "$BW_EMAIL" "$BW_PASSWORD" --raw > /tmp/bw_session
export BW_SESSION="$(cat /tmp/bw_session)"

echo "[*] Syncing Vaultwarden..."
bw sync >/dev/null

echo "[*] Retrieving GitHub App Secrets..."

APP_ID="$(bw get password 'GH_APP_ID')"
INST_ORG="$(bw get password 'GH_INSTALLATION_ID_ORG')"
INST_PERSONAL="$(bw get password 'GH_INSTALLATION_ID_PERSONAL')"
APP_PK="$(bw get notes 'GH_APP_PRIVATE_KEY')" # or get password if stored that way

if [[ -z "$APP_ID" || -z "$INST_ORG" || -z "$INST_PERSONAL" || -z "$APP_PK" ]]; then
  echo "[!] ERROR: Missing one or more GitHub App secrets in Vaultwarden"
  exit 1
fi

echo "[*] Retrieving Discord webhook..."
DISCORD_WEBHOOK_URL="$(bw get password 'DISCORD_WEBHOOK_URL' || true)"

docker secret rm discord_webhook_url >/dev/null 2>&1 || true

if [[ -n "$DISCORD_WEBHOOK_URL" ]]; then
  printf "%s" "$DISCORD_WEBHOOK_URL" | docker secret create discord_webhook_url -
else
  echo "[!] Warning: DISCORD_WEBHOOK_URL not set – Discord alerts disabled."
fi

echo "[*] Recreating Docker secrets..."
docker secret rm gh_app_id gh_installation_id_org gh_installation_id_personal gh_app_private_key \
  >/dev/null 2>&1 || true

printf "%s" "$APP_ID" | docker secret create gh_app_id -
printf "%s" "$INST_ORG" | docker secret create gh_installation_id_org -
printf "%s" "$INST_PERSONAL" | docker secret create gh_installation_id_personal -
printf "%s" "$APP_PK" | docker secret create gh_app_private_key -

echo "[*] Deploying stack '${STACK_NAME}'..."
docker stack deploy -c "$STACK_FILE" "$STACK_NAME"

echo "[✓] Deployment complete."
echo "[*] Services deployed:"
echo "    - Organisation runners"
echo "    - Personal repo runners"
echo "    - Autoscaler"
echo "    - Dashboard (Traefik route: https://runners.itslit)"
echo "    - Webhook listener: https://github-webhook.itslit"