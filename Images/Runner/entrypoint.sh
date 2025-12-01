#!/usr/bin/env bash
set -euo pipefail

: "${GH_SCOPE:?must be 'org' or 'repo'}"
: "${GH_OWNER:?GitHub org or user name}"
: "${GH_RUNNER_NAME_PREFIX:=swarm-runner}"
: "${GH_LABELS:=self-hosted,swarm}"
: "${GH_PAT_FILE:=/run/secrets/gh_pat}"
: "${GH_RUNNER_GROUP:=Default}"

if [ ! -f "$GH_PAT_FILE" ]; then
  echo "ERROR: PAT secret file not found at $GH_PAT_FILE"
  exit 1
fi

GH_PAT="$(cat "$GH_PAT_FILE")"
if [ -z "$GH_PAT" ]; then
  echo "ERROR: PAT is empty"
  exit 1
fi

API_URL="https://api.github.com"
RUNNER_NAME="${GH_RUNNER_NAME_PREFIX}-$(hostname)"

if [ "$GH_SCOPE" = "org" ]; then
  RUNNER_URL="https://github.com/${GH_OWNER}"
  TOKEN_URL="${API_URL}/orgs/${GH_OWNER}/actions/runners/registration-token"
elif [ "$GH_SCOPE" = "repo" ]; then
  : "${GH_REPOSITORY:?repo name required when GH_SCOPE=repo}"
  RUNNER_URL="https://github.com/${GH_OWNER}/${GH_REPOSITORY}"
  TOKEN_URL="${API_URL}/repos/${GH_OWNER}/${GH_REPOSITORY}/actions/runners/registration-token"
else
  echo "ERROR: GH_SCOPE must be 'org' or 'repo'"
  exit 1
fi

echo "Requesting registration token from $TOKEN_URL"
REG_TOKEN="$(curl -sX POST -H "Authorization: token ${GH_PAT}" \
  -H "Accept: application/vnd.github+json" \
  "${TOKEN_URL}" | jq -r '.token')"

if [ -z "$REG_TOKEN" ] || [ "$REG_TOKEN" = "null" ]; then
  echo "ERROR: Failed to obtain registration token"
  exit 1
fi

echo "Configuring runner for ${RUNNER_URL}..."
./config.sh \
  --unattended \
  --url "${RUNNER_URL}" \
  --token "${REG_TOKEN}" \
  --name "${RUNNER_NAME}" \
  --labels "${GH_LABELS}" \
  --runnergroup "${GH_RUNNER_GROUP}" \
  --replace

cleanup() {
  echo "Runner exiting, attempting to remove registration..."
  ./config.sh remove --unattended --token "${REG_TOKEN}" || true
}
trap cleanup EXIT

echo "Starting runner..."
./run.sh
