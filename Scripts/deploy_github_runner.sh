#!/bin/bash
set -e

STACK_NAME="github-runners"
SECRET_NAME="github_actions_pat"
YAML_FILE="runner-stack.yml"
VAULT_ITEM_NAME="github_actions_pat"
VAULT_USER="svc-docker@itslit"

# === Allow self-signed certs ===
export NODE_TLS_REJECT_UNAUTHORIZED=0

echo "[*] Configuring Bitwarden/Vaultwarden server (if not already)..."
bw config server https://vault.itslit >/dev/null 2>&1 || true

echo "[*] Unlocking Vaultwarden (you may be prompted)..."
bw login "$VAULT_USER" || true
export BW_SESSION=$(bw unlock --raw)

if [ -z "$BW_SESSION" ]; then
  echo "[!] ERROR: Failed to unlock Vaultwarden session"
  exit 1
fi

echo "[*] Retrieving PAT from Vaultwarden item '$VAULT_ITEM_NAME'..."
PAT=$(bw get password "$VAULT_ITEM_NAME")

if [ -z "$PAT" ]; then
  echo "[!] ERROR: Could not retrieve PAT from Vaultwarden item '$VAULT_ITEM_NAME'"
  exit 1
fi

echo "[*] Updating Docker secret '$SECRET_NAME'..."
docker secret rm "$SECRET_NAME" >/dev/null 2>&1 || true
printf '%s' "$PAT" | docker secret create "$SECRET_NAME" -

echo "[*] Deploying stack '$STACK_NAME' using '$YAML_FILE'..."
docker stack deploy -c "../Runner/$YAML_FILE" "$STACK_NAME"

echo "[✔] Done. Check your GitHub org + repo settings for new runners."
