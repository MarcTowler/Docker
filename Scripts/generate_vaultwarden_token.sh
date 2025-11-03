#!/usr/bin/env bash
# ==========================================================
# deploy_vaultwarden.sh
# ----------------------------------------------------------
# Generates a secure Vaultwarden admin token,
# creates/updates a Swarm secret, and deploys the stack.
# ==========================================================
set -euo pipefail

STACK_NAME="vaultwarden"
COMPOSE_FILE="vw-stack.yml"
SECRET_NAME="vaultwarden_admin_token"

# 1️⃣ Generate a secure random admin token (32 chars)
ADMIN_TOKEN=$(openssl rand -base64 32)
echo "🔐 Generated admin token: $ADMIN_TOKEN"

# 2️⃣ Save token to temporary file
TMP_FILE=$(mktemp)
echo "$ADMIN_TOKEN" > "$TMP_FILE"

# 3️⃣ Create or update Swarm secret
if docker secret ls --format '{{.Name}}' | grep -q "^${SECRET_NAME}$"; then
    echo "♻️  Removing existing secret..."
    docker secret rm "$SECRET_NAME"
fi

docker secret create "$SECRET_NAME" "$TMP_FILE"
rm "$TMP_FILE"
echo "✅ Swarm secret '$SECRET_NAME' created"

# 4️⃣ Deploy the stack
echo "🚀 Deploying Vaultwarden stack..."
docker stack deploy -c "$COMPOSE_FILE" "$STACK_NAME"

echo
echo "🎉 Deployment complete!"
echo "Use the following admin token to log in at https://vault.itslit/admin"
echo "$ADMIN_TOKEN"
