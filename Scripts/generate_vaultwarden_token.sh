#!/usr/bin/env bash
# ==========================================================
# generate_vaultwarden_token.sh
# ----------------------------------------------------------
# Generates a secure random Vaultwarden admin password
# and Argon2id hash compatible with Vaultwarden’s ADMIN_TOKEN.
# Automatically updates .env file and backs up previous version.
# ----------------------------------------------------------
# Requirements:
#   - Docker
#   - OpenSSL
# ==========================================================

set -euo pipefail

ENV_FILE="../.env"   # adjust path relative to script
BACKUP_FILE="${ENV_FILE}.backup.$(date +%Y%m%d%H%M%S)"

echo "🔐 Generating Vaultwarden admin credentials..."
echo

# Backup existing .env if it exists
if [ -f "$ENV_FILE" ]; then
    cp "$ENV_FILE" "$BACKUP_FILE"
    echo "💾 Existing .env backed up to $BACKUP_FILE"
fi

# Generate random password (24 chars)
ADMIN_PASS=$(openssl rand -base64 24)
SALT=$(openssl rand -base64 16)

# Use lightweight Alpine container to compute Argon2 hash
ADMIN_HASH=$(docker run --rm alpine sh -c "
  apk add --no-cache argon2 >/dev/null
  echo '$ADMIN_PASS' | argon2 '$SALT' -id -t 2 -m 16 -p 1 | grep 'Encoded:' | awk '{print \$2}'
")

# Update or add ADMIN_TOKEN line in .env
if grep -q "^ADMIN_TOKEN=" "$ENV_FILE" 2>/dev/null; then
    sed -i "s|^ADMIN_TOKEN=.*|ADMIN_TOKEN=$ADMIN_HASH|" "$ENV_FILE"
else
    echo "ADMIN_TOKEN=$ADMIN_HASH" >> "$ENV_FILE"
fi

echo "✅ Vaultwarden .env updated with new ADMIN_TOKEN!"
echo
echo "------------------------------------------"
echo "Admin password: $ADMIN_PASS"
echo "Admin token (hash): $ADMIN_HASH"
echo
echo "⚠️  Keep this password safe — it will NOT be shown again."
echo "💾 Backup of previous .env saved as: $BACKUP_FILE"
