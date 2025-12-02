#!/usr/bin/env bash
set -euo pipefail

export BW_SERVER="https://vault.itslit"
BW_EMAIL="svc-docker@itslit"

if [ -z "${BW_PASSWORD:-}" ]; then
  echo "BW_PASSWORD not set"
  exit 1
fi

bw logout >/dev/null 2>&1 || true
bw login "$BW_EMAIL" "$BW_PASSWORD" --raw > /tmp/bw_session
export BW_SESSION="$(cat /tmp/bw_session)"

bw sync >/dev/null

APP_ID="$(bw get password 'GH_APP_ID')"
INST_ORG="$(bw get password 'GH_INSTALLATION_ID_ORG')"
INST_PERSONAL="$(bw get password 'GH_INSTALLATION_ID_PERSONAL')"
APP_PK="$(bw get notes 'GH_APP_PRIVATE_KEY')"  # or get password - depends how you store

if [ -z "$APP_ID" ] || [ -z "$INST_ORG" ] || [ -z "$INST_PERSONAL" ] || [ -z "$APP_PK" ]; then
  echo "Missing one or more GitHub App secrets in Vaultwarden"
  exit 1
fi

# Recreate Docker secrets
docker secret rm gh_app_id gh_installation_id_org gh_installation_id_personal gh_app_private_key \
  >/dev/null 2>&1 || true

printf "%s" "$APP_ID" | docker secret create gh_app_id -
printf "%s" "$INST_ORG" | docker secret create gh_installation_id_org -
printf "%s" "$INST_PERSONAL" | docker secret create gh_installation_id_personal -
printf "%s" "$APP_PK" | docker secret create gh_app_private_key -
