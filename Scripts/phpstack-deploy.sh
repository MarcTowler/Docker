#!/bin/bash
set -euo pipefail

# === Configuration ===
ITEM_NAME="MySQL Database (Production)"
STACK_NAME="phpstack"
STACK_FILE="php-site-stack.yml"

# === Login and Unlock Vaultwarden ===
echo "🔐 Logging in to Vaultwarden..."
bw login svc-docker@itslit || true  # skip if already logged in

echo "🔓 Unlocking vault..."
BW_SESSION=$(bw unlock --raw)

# === Fetch Credentials from Vaultwarden ===
echo "📦 Fetching MySQL credentials from Vaultwarden..."

MYSQL_USER=$(bw get username "$ITEM_NAME" --session "$BW_SESSION")
MYSQL_PASSWORD=$(bw get password "$ITEM_NAME" --session "$BW_SESSION")

NOTES=$(bw get notes "$ITEM_NAME" --session "$BW_SESSION")

# Parse notes (key=value lines)
MYSQL_ROOT_PASSWORD=$(echo "$NOTES" | grep MYSQL_ROOT_PASSWORD | cut -d '=' -f2-)
MYSQL_DATABASE=$(echo "$NOTES" | grep MYSQL_DATABASE | cut -d '=' -f2-)

echo "✅ Credentials retrieved from Vaultwarden."

# === Create / Update Docker Secrets ===
echo "🐳 Updating Docker secrets..."

# Helper to recreate secrets safely (ignore if exist)
create_or_update_secret() {
  local name=$1
  local value=$2

  # Check if secret exists
  if docker secret inspect "$name" >/dev/null 2>&1; then
    echo "🔁 Updating secret: $name"
    echo "$value" | docker secret rm "$name" >/dev/null 2>&1 || true
  fi
  echo "$value" | docker secret create "$name" -
}

create_or_update_secret mysql_user "$MYSQL_USER"
create_or_update_secret mysql_password "$MYSQL_PASSWORD"
create_or_update_secret mysql_root_password "$MYSQL_ROOT_PASSWORD"
create_or_update_secret mysql_database "$MYSQL_DATABASE"

echo "✅ Docker secrets ready."

# === Deploy the stack ===
echo "🚀 Deploying stack: $STACK_NAME"
docker stack deploy -c "../$STACK_FILE" "$STACK_NAME"

echo "🎉 Deployment complete!"
