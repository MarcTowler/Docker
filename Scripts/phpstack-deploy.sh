#!/bin/bash
set -euo pipefail

# === Project paths ===
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
STACK_FILE="$PROJECT_ROOT/php-site-stack.yaml"
STACK_NAME="phpstack"

# === Vaultwarden configuration ===
ITEM_NAME="MySQL"
VAULT_SERVER="https://vault.itslit"
VAULT_USER="svc-docker@itslit"

# === Allow self-signed certs (temporary measure) ===
export NODE_TLS_REJECT_UNAUTHORIZED=0

echo "📁 Working directory: $PROJECT_ROOT"
echo "📄 Stack file: $STACK_FILE"

# === Login & Unlock Vaultwarden ===
echo "🔐 Logging in to Vaultwarden..."

# If already logged in to a different server, logout first
CURRENT_SERVER=$(bw config server | grep -Eo 'https?://[^[:space:]]+' || true)
if [ "$CURRENT_SERVER" != "$VAULT_SERVER" ]; then
  echo "🧹 Different server config detected — logging out first..."
  bw logout || true
fi
bw config server "$VAULT_SERVER"
bw login "$VAULT_USER" || true

echo "🔓 Unlocking vault..."
BW_SESSION=$(bw unlock --raw)

# === Sync vault to ensure up-to-date secrets ===
bw sync --session "$BW_SESSION" >/dev/null

# === Locate item ===
echo "📦 Fetching MySQL credentials from Vaultwarden..."
ITEM_ID=$(bw list items --session "$BW_SESSION" | jq -r --arg name "$ITEM_NAME" '.[] | select(.name==$name) | .id')

if [ -z "$ITEM_ID" ] || [ "$ITEM_ID" = "null" ]; then
  echo "❌ Could not find item '$ITEM_NAME' in the vault."
  exit 1
fi

# === Retrieve secrets from Vaultwarden ===
MYSQL_USER=$(bw get username "$ITEM_ID" --session "$BW_SESSION" || true)
MYSQL_PASSWORD=$(bw get password "$ITEM_ID" --session "$BW_SESSION" || true)
NOTES=$(bw get notes "$ITEM_ID" --session "$BW_SESSION" || true)

# Fallback: if using a Secure Note instead of Login
if [ -z "$MYSQL_USER" ] || [ "$MYSQL_USER" = "Not found." ]; then
  MYSQL_USER=$(echo "$NOTES" | grep MYSQL_USER | cut -d '=' -f2-)
  MYSQL_PASSWORD=$(echo "$NOTES" | grep MYSQL_PASSWORD | cut -d '=' -f2-)
fi

MYSQL_ROOT_PASSWORD=$(echo "$NOTES" | grep MYSQL_ROOT_PASSWORD | cut -d '=' -f2-)
MYSQL_DATABASE=$(echo "$NOTES" | grep MYSQL_DATABASE | cut -d '=' -f2-)

echo "✅ Secrets retrieved from Vaultwarden."

# === Create / Update Docker secrets ===
echo "🐳 Creating Docker secrets..."

create_or_update_secret() {
  local name=$1
  local value=$2
  if docker secret inspect "$name" >/dev/null 2>&1; then
    echo "🔁 Updating secret: $name"
    docker secret rm "$name" >/dev/null 2>&1 || true
  fi
  echo "$value" | docker secret create "$name" -
}

create_or_update_secret mysql_user "$MYSQL_USER"
create_or_update_secret mysql_password "$MYSQL_PASSWORD"
create_or_update_secret mysql_root_password "$MYSQL_ROOT_PASSWORD"
create_or_update_secret mysql_database "$MYSQL_DATABASE"

echo "✅ Docker secrets updated."

# === Deploy the stack ===
echo "🚀 Deploying stack '$STACK_NAME' from: $STACK_FILE"
(cd "$PROJECT_ROOT" && docker stack deploy -c "$STACK_FILE" "$STACK_NAME")

# === Lock vault afterwards ===
bw lock
echo "🔒 Vault locked."

echo "🎉 Deployment complete!"
