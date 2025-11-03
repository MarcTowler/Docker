#!/usr/bin/env bash
set -e

# Generate random admin password
ADMIN_PASS=$(openssl rand -base64 24)

# Generate the Argon2 hash inside a Vaultwarden container
ADMIN_HASH=$(docker run --rm --entrypoint /usr/local/bin/vaultwarden vaultwarden/server hash <<< "$ADMIN_PASS")

echo "🔐 Vaultwarden admin credentials generated:"
echo "------------------------------------------"
echo "Admin password: $ADMIN_PASS"
echo "Admin token (hash): $ADMIN_HASH"
echo
echo "➡️  Save this hash in your .env file as:"
echo "ADMIN_TOKEN=$ADMIN_HASH"
