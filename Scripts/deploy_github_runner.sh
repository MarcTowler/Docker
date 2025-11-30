#!/bin/bash
set -e

############################################################
# CONFIGURATION
############################################################

VAULT_SERVER="https://vault.itslit"
VAULT_USER="svc-docker@itslit"       # Your service account username
VAULT_ITEM_NAME="github_actions_pat" # Name of PAT item in Vaultwarden

STACK_NAME="github-runners"
SECRET_NAME="github_actions_pat"
YAML_FILE="runner-stack.yml"

# === Allow self-signed certs ===
export NODE_TLS_REJECT_UNAUTHORIZED=0

############################################################
# FUNCTIONS
############################################################

ensure_bw_logged_in() {
    echo "[*] Ensuring Bitwarden server is set correctly..."

    # If bw refuses to set server because a login exists, logout first
    if ! bw config server "$VAULT_SERVER" >/dev/null 2>&1; then
        echo "[*] Bitwarden CLI requires logout before changing server. Logging out..."
        bw logout >/dev/null 2>&1 || true
        bw config server "$VAULT_SERVER"
    fi

    echo "[*] Checking Bitwarden login status..."
    BW_STATUS=$(bw status)

    if ! echo "$BW_STATUS" | grep -q "\"userEmail\""; then
        echo "[*] Not logged in. Logging in as $VAULT_USER ..."
        bw login "$VAULT_USER" || {
            echo "[!] ERROR: Failed to log in as $VAULT_USER"
            exit 1
        }
    fi

    # Confirm we are logged in as the correct user
    CURRENT_USER=$(bw status | jq -r '.userEmail')
    if [[ "$CURRENT_USER" != "$VAULT_USER" ]]; then
        echo "[!] ERROR: Logged in as wrong user: $CURRENT_USER"
        echo "    Expected: $VAULT_USER"
        echo "    Fixing this by logging out now…"
        bw logout >/dev/null 2>&1
        bw login "$VAULT_USER"
    fi

    echo "[✔] Correct Bitwarden user confirmed: $CURRENT_USER"
}


unlock_vault() {
    echo "[*] Unlocking vault..."
    export BW_SESSION=$(bw unlock --raw)

    if [ -z "$BW_SESSION" ]; then
        echo "[!] ERROR: Unable to unlock vault"
        exit 1
    fi

    echo "[✔] Vault unlocked"
}

get_pat() {
    echo "[*] Retrieving PAT: $VAULT_ITEM_NAME ..."
    PAT=$(bw get password "$VAULT_ITEM_NAME" 2>/dev/null || echo "")

    if [ -z "$PAT" ]; then
        echo "[!] ERROR: Unable to retrieve item '$VAULT_ITEM_NAME'"
        echo "    Ensure the item exists inside *this account's* vault."
        exit 1
    fi

    echo "[✔] PAT retrieved from Vaultwarden"
}

update_secret() {
    echo "[*] Updating Docker secret: $SECRET_NAME"

    docker secret rm "$SECRET_NAME" >/dev/null 2>&1 || true
    printf '%s' "$PAT" | docker secret create "$SECRET_NAME" -

    echo "[✔] Docker secret updated"
}

deploy_stack() {
    echo "[*] Deploying stack: $STACK_NAME"
    docker stack deploy -c "../Runner/$YAML_FILE" "$STACK_NAME"
    echo "[✔] Stack deployed"
}

############################################################
# EXECUTION
############################################################

ensure_bw_logged_in
unlock_vault
get_pat
update_secret
deploy_stack

echo ""
echo "=========================================================="
echo " 🚀 DONE — GitHub self-hosted runners deployed successfully"
echo "=========================================================="
