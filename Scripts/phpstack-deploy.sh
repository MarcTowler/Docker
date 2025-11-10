#!/bin/bash
set -euo pipefail

# === Project paths ===
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
STACK_FILE="$PROJECT_ROOT/php-site-stack.yaml"
PHP_DIR="/home/marctowler/Docker/php"  # Local path (exported via NFS)
STACK_NAME="phpstack"
CHECKSUM_FILE="$PROJECT_ROOT/.config_checksums"

# === Vaultwarden configuration ===
ITEM_NAME="MySQL"
VAULT_SERVER="https://vault.itslit"
VAULT_USER="svc-docker@itslit"

# === Allow self-signed certs (temporary) ===
export NODE_TLS_REJECT_UNAUTHORIZED=0

echo "📁 Working directory: $PROJECT_ROOT"
echo "📄 Stack file: $STACK_FILE"
echo "📂 PHP source directory: $PHP_DIR"

# === Verify PHP folder exists ===
if [ ! -d "$PHP_DIR" ]; then
  echo "❌ PHP directory '$PHP_DIR' not found. Please check your NFS export or path."
  exit 1
fi

# === Clone or update PHP projects (locally on NFS host) ===
declare -A REPOS=(
  ["api"]="git@github.com:ItsLit-Media-and-Development/api.git"
  ["Website"]="git@github.com:ItsLit-Media-and-Development/Website.git"
  ["GAPI"]="git@github.com:ItsLit-Media-and-Development/GAPI.git"
  ["RPG-Site"]="git@github.com:MarcTowler/RPG-Site.git"
)

echo "🌀 Syncing PHP project repositories..."
cd "$PHP_DIR"

for dir in "${!REPOS[@]}"; do
  repo="${REPOS[$dir]}"
  if [ -d "$dir/.git" ]; then
    echo "🔁 Updating existing repo: $dir"
    (
      cd "$dir"
      git fetch origin
      DEFAULT_BRANCH=$(git remote show origin | awk '/HEAD branch/ {print $NF}')
      echo "   ↳ Using default branch: $DEFAULT_BRANCH"
      git reset --hard "origin/$DEFAULT_BRANCH" || git pull
    )
  else
    echo "⬇️ Cloning new repo: $dir"
    git clone "$repo" "$dir"
  fi
done

echo "✅ PHP repositories up to date."

# === Vaultwarden login & unlock ===
echo "🔐 Logging in to Vaultwarden..."
CURRENT_SERVER=$(bw config server | grep -Eo 'https?://[^[:space:]]+' || true)
if [ "$CURRENT_SERVER" != "$VAULT_SERVER" ]; then
  echo "🧹 Different server config detected — logging out first..."
  bw logout || true
  bw config server "$VAULT_SERVER"
fi

bw login "$VAULT_USER" || true

echo "🔓 Unlocking vault..."
BW_SESSION=$(bw unlock --raw)
if [ -z "$BW_SESSION" ]; then
  echo "❌ Failed to unlock Vaultwarden."
  exit 1
fi
bw sync --session "$BW_SESSION" >/dev/null

# === Retrieve MySQL credentials ===
echo "📦 Fetching MySQL credentials from Vaultwarden..."
ITEM_ID=$(bw list items --session "$BW_SESSION" | jq -r --arg name "$ITEM_NAME" '.[] | select(.name==$name) | .id')

if [ -z "$ITEM_ID" ] || [ "$ITEM_ID" = "null" ]; then
  echo "❌ Could not find item '$ITEM_NAME' in the vault."
  exit 1
fi

MYSQL_USER=$(bw get username "$ITEM_ID" --session "$BW_SESSION" || true)
MYSQL_PASSWORD=$(bw get password "$ITEM_ID" --session "$BW_SESSION" || true)
NOTES=$(bw get notes "$ITEM_ID" --session "$BW_SESSION" || true)

# Fallback: Secure Note handling
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

    # Wait until the secret is actually removed from Swarm
    echo "⏳ Waiting for secret '$name' to be fully removed..."
    for i in {1..10}; do
      if ! docker secret inspect "$name" >/dev/null 2>&1; then
        break
      fi
      sleep 1
    done
  fi

  echo "$value" | docker secret create "$name" - >/dev/null 2>&1 || {
    echo "❌ Failed to create secret '$name'."
    exit 1
  }

  echo "✅ Secret '$name' created successfully."
}

create_or_update_secret mysql_user "$MYSQL_USER"
create_or_update_secret mysql_password "$MYSQL_PASSWORD"
create_or_update_secret mysql_root_password "$MYSQL_ROOT_PASSWORD"
create_or_update_secret mysql_database "$MYSQL_DATABASE"
echo "✅ Docker secrets updated."

# === Deploy the stack ===
echo "🚀 Deploying stack '$STACK_NAME' from: $STACK_FILE"
(cd "$PROJECT_ROOT" && docker stack deploy -c "$STACK_FILE" "$STACK_NAME")

echo "⏳ Waiting for services to start..."
sleep 10

# === Generate per-service config.ini from Vaultwarden ===
echo "📦 Generating config.ini files from Vaultwarden..."

declare -A apps=(
  ["api"]="api-secrets"
  ["GAPI"]="gapi-secrets"
  ["RPG-Site"]="rpgsite-secrets"
  ["Website"]="website-secrets"
)

# Map app names to Docker service names (explicit)
declare -A service_names=(
  ["api"]="phpstack_api"
  ["GAPI"]="phpstack_gapi"
  ["RPG-Site"]="phpstack_rpgsite"
  ["Website"]="phpstack_website"
)

touch "$CHECKSUM_FILE"
changed_services=()

for app in "${!apps[@]}"; do
  VAULT_ITEM="${apps[$app]}"
  echo "🔐 Fetching configuration for $app ($VAULT_ITEM)..."

  BW_ITEM=$(bw list items --search "$VAULT_ITEM" --session "$BW_SESSION" | jq -r '.[0]')
  if [[ "$BW_ITEM" == "null" || -z "$BW_ITEM" ]]; then
    echo "⚠️  No Vaultwarden item found for '$VAULT_ITEM' — skipping."
    continue
  fi

  CONFIG_DIR="$PHP_DIR/${app}/src/Config"
  CONFIG_PATH="$CONFIG_DIR/config.ini"
  mkdir -p "$CONFIG_DIR"

  # Helper to extract non-empty field
  get_field() {
    local key="$1"
    local value
    value=$(echo "$BW_ITEM" | jq -r --arg key "$key" '.fields[]? | select(.name==$key).value' | sed '/^null$/d;/^$/d')
    [ -n "$value" ] && echo "$value"
  }

  TMP_FILE=$(mktemp)
  cat > "$TMP_FILE" <<EOF
; Auto-generated from Vaultwarden
; Generated: $(date -u +"%Y-%m-%d %H:%M:%S UTC")

[site]
TOKEN = "$(get_field TOKEN)"
BASE_URL = "$(get_field BASE_URL)"

[twitch]
CLIENT_ID     = '$(get_field TWITCH_CLIENT_ID)'
TWITCH_SECRET = '$(get_field TWITCH_SECRET)'
WEBHOOK_SECRET = '$(get_field WEBHOOK_SECRET)'

[streamlabs]
SL_CLIENT_ID = '$(get_field SL_CLIENT_ID)'
SL_SECRET   = '$(get_field SL_SECRET)'

[database]
DBHOST = "$(get_field DBHOST)"
PORT   = $(get_field DBPORT)
DBNAME = "$(get_field DBNAME)"
DBUSER = "$(get_field DBUSER)"
DBPASS = "$(get_field DBPASS)"

[riot]
RIOT_API_KEY = "$(get_field RIOT_API_KEY)"

[twitter]
CONSUMER_KEY    = "$(get_field TWITTER_CONSUMER_KEY)"
CONSUMER_SECRET = "$(get_field TWITTER_CONSUMER_SECRET)"
OAUTH_TOKEN     = "$(get_field TWITTER_OAUTH_TOKEN)"
OAUTH_SECRET    = "$(get_field TWITTER_OAUTH_SECRET)"

[guilded]
TEAM_ID = "$(get_field GUILDED_TEAM_ID)"

[clan_events]
CE_API_KEY = "$(get_field CLAN_EVENTS_API_KEY)"
EOF

  chmod 600 "$TMP_FILE"

  # Checksum compare
  NEW_HASH=$(sha256sum "$TMP_FILE" | awk '{print $1}')
  OLD_HASH=$(grep "^${app}:" "$CHECKSUM_FILE" | cut -d':' -f2 || true)

  if [ "$NEW_HASH" != "$OLD_HASH" ]; then
    echo "🆕 Config for $app changed or new. Updating..."
    mv "$TMP_FILE" "$CONFIG_PATH"
    echo "${app}:$NEW_HASH" >> "$CHECKSUM_FILE.tmp"
    changed_services+=("${service_names[$app]}")
  else
    echo "ℹ️ Config for $app unchanged."
    rm "$TMP_FILE"
    echo "${app}:$OLD_HASH" >> "$CHECKSUM_FILE.tmp"
  fi
done

mv "$CHECKSUM_FILE.tmp" "$CHECKSUM_FILE"

# === Restart only changed services ===
if [ ${#changed_services[@]} -gt 0 ]; then
  echo "🔄 Config changed for: ${changed_services[*]}"
  for svc in "${changed_services[@]}"; do
    echo "🔁 Restarting service: $svc"
    docker service update --force "$svc"
  done
else
  echo "✅ No configuration changes detected — skipping service restarts."
fi

# === Lock vault ===
bw lock
echo "🔒 Vault locked."
echo "🎉 Deployment complete!"
