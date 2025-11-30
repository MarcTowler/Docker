#!/bin/bash
set -e

echo "[INFO] Custom GitHub Runner entrypoint started"

# Debug mode – keeps the container alive for inspection
if [[ "$RUNNER_DEBUG" == "1" ]]; then
    echo "[DEBUG] Sleeping for 1 hour so you can inspect the container..."
    sleep 3600
fi

# Load PAT from Docker secret
if [[ -f /run/secrets/github_actions_pat ]]; then
    export ACCESS_TOKEN="$(cat /run/secrets/github_actions_pat)"
fi

if [[ -z "$ACCESS_TOKEN" ]]; then
    echo "[FATAL] ACCESS_TOKEN is empty — check the docker secret github_actions_pat"
    exit 1
fi

echo "[INFO] GitHub access token loaded OK."

# Required: runner name
if [[ -z "$RUNNER_NAME" ]]; then
    export RUNNER_NAME="$(hostname)"
fi

# Required: ephemeral (recommended)
if [[ -z "$RUNNER_EPHEMERAL" ]]; then
    export RUNNER_EPHEMERAL="1"
fi

# Validate repository vs organization mode
if [[ -z "$ORG_NAME" && -z "$REPO_URL" ]]; then
    echo "[FATAL] Set either ORG_NAME or REPO_URL."
    exit 1
fi

if [[ -n "$ORG_NAME" ]]; then
    CONFIG_ARGS="--url https://github.com/${ORG_NAME}"
else
    CONFIG_ARGS="--url ${REPO_URL}"
fi

#
# Configure runner
#
echo "[INFO] Configuring runner..."

./config.sh \
    ${CONFIG_ARGS} \
    --token "${ACCESS_TOKEN}" \
    --name "${RUNNER_NAME}" \
    --ephemeral "${RUNNER_EPHEMERAL}" \
    --labels "${RUNNER_LABELS}" \
    --work "_work" \
    --unattended \
    --replace

echo "[INFO] Runner configured. Starting service..."

# On runner exit, always remove the configuration
cleanup() {
    echo "[INFO] Cleaning up runner registration..."
    ./config.sh remove --token "${ACCESS_TOKEN}" || true
}
trap cleanup EXIT

exec ./run.sh
