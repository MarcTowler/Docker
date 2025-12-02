#!/usr/bin/env bash
set -euo pipefail

STACK_FILE="../Runner/runner-stack.yml"
STACK_NAME="github-runners"

./scripts/deploy-secrets-from-vaultwarden.sh
docker stack deploy -c "$STACK_FILE" "$STACK_NAME"
