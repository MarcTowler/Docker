#!/bin/bash
set -euo pipefail

# === Project paths ===
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
STACK_FILE="$PROJECT_ROOT/php-site-stack.yaml"
PHP_DIR="/home/marctowler/Docker/php"
STACK_NAME="phpstack"
CHECKSUM_FILE="$PROJECT_ROOT/.siteini_checksums"
SECRETS_HASH_FILE="$PROJECT_ROOT/.secret_hashes"

# === Vaultwarden configuration ===
ITEM_NAME="MySQL"
VAULT_SERVER="https://vault.itslit"
VAULT_USER="svc-docker@itslit"

# === Discord notifications ===
DISCORD_WEBHOOK_URL="https://discord.com/api/webhooks/1437449186298826785/k-KUcJs2Zib1zAVRfzQkwGzvf0-xlcrt5kFpA1e4P4RQ0VlYRqFJKRUwVLcdwXbS6gbu"

notify_discord() {
  local color="$1"
  local title="$2"
  local message="$3"
  curl -s -H "Content-Type: application/json" -X POST \
    -d "$(jq -n --arg title "$title" --arg desc "$message" --argjson color "$color" \
      '{embeds:[{title:$title, description:$desc, color:$color}] }')" \
    "$DISCORD_WEBHOOK_URL" >/dev/null || true
}

# === Allow self-signed certs ===
export NODE_TLS_REJECT_UNAUTHORIZED=0

echo "📁 Working directory: $PROJECT_ROOT"
echo "📄 Stack file: $STACK_FILE"
echo "📂 PHP source directory: $PHP_DIR"

if [ ! -d "$PHP_DIR" ]; then
  echo "❌ PHP directory '$PHP_DIR' not found."
  exit 1
fi

# === Sync repos ===
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
      git reset --hard "origin/$DEFAULT_BRANCH" || git pull
    )
  else
    echo "⬇️ Cloning new repo: $dir"
    git clone "$repo" "$dir"
  fi
done
echo "✅ PHP repositories up to date."

# === Vaultwarden login ===
echo "🔐 Logging in to Vaultwarden..."
CURRENT_SERVER=$(bw config server | grep -Eo 'https?://[^[:space:]]+' || true)
if [ "$CURRENT_SERVER" != "$VAULT_SERVER" ]; then
  bw logout || true
  bw config server "$VAULT_SERVER"
fi
bw login "$VAULT_USER" || true

echo "🔓 Unlocking vault..."
BW_SESSION=$(bw unlock --raw)
if [ -z "$BW_SESSION" ]; then
  echo "❌ Vault unlock failed."
  notify_discord 15158332 "❌ Vault Unlock Failed" "Unable to unlock vault."
  exit 1
fi
bw sync --session "$BW_SESSION" >/dev/null

# === Fetch MySQL secrets ===
ITEM_ID=$(bw list items --session "$BW_SESSION" | jq -r --arg name "$ITEM_NAME" '.[] | select(.name==$name) | .id')
NOTES=$(bw get notes "$ITEM_ID" --session "$BW_SESSION" || true)
MYSQL_USER=$(bw get username "$ITEM_ID" --session "$BW_SESSION" || echo "$NOTES" | grep MYSQL_USER | cut -d '=' -f2-)
MYSQL_PASSWORD=$(bw get password "$ITEM_ID" --session "$BW_SESSION" || echo "$NOTES" | grep MYSQL_PASSWORD | cut -d '=' -f2-)
MYSQL_ROOT_PASSWORD=$(echo "$NOTES" | grep MYSQL_ROOT_PASSWORD | cut -d '=' -f2-)
MYSQL_DATABASE=$(echo "$NOTES" | grep MYSQL_DATABASE | cut -d '=' -f2-)

# === Create / Update secrets safely ===
echo "🐳 Checking Docker secrets..."
touch "$SECRETS_HASH_FILE"

safe_create_or_update_secret() {
  local name=$1
  local value=$2
  local tmpfile
  tmpfile=$(mktemp)

  echo -n "$value" >"$tmpfile"
  local new_hash
  new_hash=$(sha256sum "$tmpfile" | awk '{print $1}')
  local old_hash
  old_hash=$(grep "^${name}:" "$SECRETS_HASH_FILE" | cut -d':' -f2 || true)

  if [ "$new_hash" == "$old_hash" ]; then
    echo "✅ Secret '$name' unchanged."
    echo "${name}:$old_hash" >> "$SECRETS_HASH_FILE.tmp"
    rm -f "$tmpfile"
    return 0
  fi

  echo "🔁 Updating secret: $name"
  if docker secret inspect "$name" >/dev/null 2>&1; then
    local new_name="${name}_$(date +%s)"
    docker secret create "$new_name" "$tmpfile" >/dev/null
    docker secret rm "$name" >/dev/null 2>&1 || true
  fi
  docker secret create "$name" "$tmpfile" >/dev/null
  rm -f "$tmpfile"
  echo "${name}:$new_hash" >> "$SECRETS_HASH_FILE.tmp"
}

safe_create_or_update_secret mysql_user "$MYSQL_USER"
safe_create_or_update_secret mysql_password "$MYSQL_PASSWORD"
safe_create_or_update_secret mysql_root_password "$MYSQL_ROOT_PASSWORD"
safe_create_or_update_secret mysql_database "$MYSQL_DATABASE"

mv "$SECRETS_HASH_FILE.tmp" "$SECRETS_HASH_FILE"
echo "✅ Docker secrets updated."

# === Deploy stack ===
echo "🚀 Deploying stack '$STACK_NAME'"
(cd "$PROJECT_ROOT" && docker stack deploy -c "$STACK_FILE" "$STACK_NAME")
sleep 10

# === Generate site.ini per service ===
declare -A apps=(
  ["api"]="api-secrets"
  ["GAPI"]="gapi-secrets"
  ["RPG-Site"]="rpgsite-secrets"
  ["Website"]="website-secrets"
)
declare -A service_names=(
  ["api"]="phpstack_api"
  ["GAPI"]="phpstack_gapi"
  ["RPG-Site"]="phpstack_rpgsite"
  ["Website"]="phpstack_website"
)

touch "$CHECKSUM_FILE"
changed_services=()

normalize_file() {
  sed '/^;/d;/^$/d;s/[[:space:]]*$//' "$1" | LC_ALL=C sort
}

for app in "${!apps[@]}"; do
  VAULT_ITEM="${apps[$app]}"
  BW_ITEM=$(bw list items --search "$VAULT_ITEM" --session "$BW_SESSION" | jq -r '.[0]')
  if [[ "$BW_ITEM" == "null" || -z "$BW_ITEM" ]]; then
    continue
  fi
  CONFIG_DIR="$PHP_DIR/${app}/src/Config"
  CONFIG_PATH="$CONFIG_DIR/site.ini"
  mkdir -p "$CONFIG_DIR"

  get_field() {
    local key="$1"
    echo "$BW_ITEM" | jq -r --arg key "$key" '.fields[]? | select(.name==$key).value' | sed '/^null$/d;/^$/d'
  }

  TMP_FILE=$(mktemp)
  cat > "$TMP_FILE" <<EOF
; Auto-generated
[site]
TOKEN = "$(get_field TOKEN)"
BASE_URL = "$(get_field BASE_URL)"
[twitch]
CLIENT_ID = '$(get_field TWITCH_CLIENT_ID)'
TWITCH_SECRET = '$(get_field TWITCH_SECRET)'
WEBHOOK_SECRET = '$(get_field WEBHOOK_SECRET)'
[streamlabs]
SL_CLIENT_ID = '$(get_field SL_CLIENT_ID)'
SL_SECRET = '$(get_field SL_SECRET)'
[database]
DBHOST = "$(get_field DBHOST)"
PORT = $(get_field DBPORT)
DBNAME = "$(get_field DBNAME)"
DBUSER = "$(get_field DBUSER)"
DBPASS = "$(get_field DBPASS)"
EOF

  chmod 600 "$TMP_FILE"
  NEW_HASH=$(normalize_file "$TMP_FILE" | sha256sum | awk '{print $1}')
  OLD_HASH=$(grep "^${app}:" "$CHECKSUM_FILE" | cut -d':' -f2 || true)

  if [ "$NEW_HASH" != "$OLD_HASH" ]; then
    echo "🆕 Updated config for $app"
    mv "$TMP_FILE" "$CONFIG_PATH"
    echo "${app}:$NEW_HASH" >> "$CHECKSUM_FILE.tmp"
    changed_services+=("${service_names[$app]}")
  else
    echo "ℹ️ No change for $app"
    rm "$TMP_FILE"
    echo "${app}:$OLD_HASH" >> "$CHECKSUM_FILE.tmp"
  fi
done
mv "$CHECKSUM_FILE.tmp" "$CHECKSUM_FILE"

# === Retry service update with pre-pull ===
retry_service_update() {
  local svc="$1"
  local max_retries=15
  local delay=20
  for ((i=1; i<=max_retries; i++)); do
    local image
    image=$(docker service inspect "$svc" -f '{{.Spec.TaskTemplate.ContainerSpec.Image}}' 2>/dev/null || true)
    if [ -n "$image" ]; then
      docker pull "$(echo "$image" | cut -d'@' -f1)" >/dev/null 2>&1 || true
    fi

    if docker service update --force "$svc" >/tmp/docker_update.log 2>&1; then
      notify_discord 3066993 "✅ Service Restarted" "**$svc** restarted successfully."
      return 0
    fi
    if grep -q "no such image" /tmp/docker_update.log; then
      echo "⚠️ $svc: Image not found, retrying in $delay sec..."
      sleep $delay
      delay=$((delay + 10))
    else
      tail -n 10 /tmp/docker_update.log
      notify_discord 15158332 "❌ Service Update Failed" "**$svc** failed after attempt $i."
      return 1
    fi
  done
  notify_discord 15158332 "❌ Service Restart Failed" "**$svc** failed after $max_retries retries."
}

# === Restart changed services ===
if [ ${#changed_services[@]} -gt 0 ]; then
  notify_discord 3447003 "🔄 Config Changes Detected" "Restarting: ${changed_services[*]}"
  for svc in "${changed_services[@]}"; do
    retry_service_update "$svc"
  done
else
  notify_discord 3066993 "✅ No Config Changes" "No config updates detected."
fi

bw lock
notify_discord 3066993 "🎉 Deployment Complete" "Deployment and secret sync complete."
echo "🎉 Done!"
