#!/usr/bin/env bash
# ==========================================================
# deploy_vaultwarden.sh
# ----------------------------------------------------------
# Generates a secure random Vaultwarden admin password,
# hashes it, creates a Swarm secret, and deploys the stack.
# ==========================================================
set -euo pipefail

STACK_NAME="vaultwarden"
COMPOSE_FILE="vw-stack.yml"
SECRET_NAME="vaultwarden_admin_token"

# 1️⃣ Generate random admin password
ADMIN_PASS=$(openssl rand -base64 24)
echo "🔐 Generated admin password: $ADMIN_PASS"

# 2️⃣ Generate Argon2id hash using Vaultwarden container
# 2️⃣ Generate Argon2id hash non-interactively
ADMIN_HASH=$(docker run --rm alpine sh -c "
  apk add --no-cache argon2 >/dev/null
  SALT=\$(openssl rand -base64 16)
  echo '$ADMIN_PASS' | argon2 \"\$SALT\" -id -t 2 -m 16 -p 1 | grep 'Encoded:' | awk '{print \$2}'
")
echo "✅ Generated Argon2id hash for Vaultwarden"

# 3️⃣ Create / update Swarm secret
if docker secret ls --format '{{.Name}}' | grep -q "^${SECRET_NAME}$"; then
    echo "♻️  Removing existing secret..."
    docker secret rm "$SECRET_NAME"
fi

echo "$ADMIN_HASH" | docker secret create "$SECRET_NAME" -
echo "✅ Swarm secret '$SECRET_NAME' created"

# 4️⃣ Deploy / update stack
echo "🚀 Deploying Vaultwarden stack..."
docker stack deploy -c "$COMPOSE_FILE" "$STACK_NAME"

echo
echo "🎉 Deployment complete!"
echo "Use the following admin password to log in at https://vault.itslit/admin"
echo "$ADMIN_PASS"
