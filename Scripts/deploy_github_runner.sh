#!/usr/bin/env bash
set -euo pipefail
export NODE_TLS_REJECT_UNAUTHORIZED=0
STACK_FILE="$(dirname "$0")/../Runner/runner-stack.yml"
STACK_NAME="github-runners"

export BW_SERVER="https://vault.itslit"
BW_EMAIL="svc-docker@itslit"

# Expect BW_PASSWORD in the environment
if [ -z "${BW_PASSWORD:-}" ]; then
  echo "BW_PASSWORD is not set. Export it before running."
  exit 1
fi

echo "[*] Logging into Vaultwarden..."
bw logout >/dev/null 2>&1 || true
bw login "$BW_EMAIL" "$BW_PASSWORD" --raw > /tmp/bw_session
export BW_SESSION="$(cat /tmp/bw_session)"

echo "[*] Syncing Bitwarden/Vaultwarden..."
bw sync >/dev/null

echo "[*] Fetching GitHub PATs from Vaultwarden..."
GH_PAT_ORG="$(bw get password 'GH_PAT_ORG')"
GH_PAT_PERSONAL="$(bw get password 'GH_PAT_PERSONAL')"

if [ -z "$GH_PAT_ORG" ] || [ -z "$GH_PAT_PERSONAL" ]; then
  echo "ERROR: one or both PATs not found (GH_PAT_ORG / GH_PAT_PERSONAL)"
  exit 1
fi

echo "[*] Recreating Docker secrets..."
docker secret rm gh_pat_org >/dev/null 2>&1 || true
docker secret rm gh_pat_personal >/dev/null 2>&1 || true

printf "%s" "$GH_PAT_ORG" | docker secret create gh_pat_org -
printf "%s" "$GH_PAT_PERSONAL" | docker secret create gh_pat_personal -

echo "[*] Deploying stack '${STACK_NAME}'..."
docker stack deploy -c "${STACK_FILE}" "${STACK_NAME}"

echo "[*] Done."
