#!/bin/bash
set -e

# Required env vars:
#   GITHUB_URL
#   GH_PAT
#
# Optional:
#   RUNNER_GROUP  (default: "Default")
#   RUNNER_LABELS (default: "self-hosted,Linux,X64")

if [[ -z "${GITHUB_URL}" || -z "${GH_PAT}" ]]; then
  echo "ERROR: GITHUB_URL and GH_PAT must be set"
  exit 1
fi

RUNNER_GROUP=${RUNNER_GROUP:-"Default"}
RUNNER_LABELS=${RUNNER_LABELS:-"self-hosted,Linux,X64"}

cd /home/runner/actions-runner || exit 1

# Strip trailing slash
URL_CLEAN="${GITHUB_URL%/}"

# Detect repo vs org for API
if [[ "$URL_CLEAN" =~ github.com/([^/]+)/([^/]+)$ ]]; then
  OWNER="${BASH_REMATCH[1]}"
  REPO="${BASH_REMATCH[2]}"
  API_URL="https://api.github.com/repos/${OWNER}/${REPO}/actions/runners/registration-token"
  GROUPS_API="https://api.github.com/repos/${OWNER}/${REPO}/actions/runner-groups"
elif [[ "$URL_CLEAN" =~ github.com/([^/]+)$ ]]; then
  ORG="${BASH_REMATCH[1]}"
  API_URL="https://api.github.com/orgs/${ORG}/actions/runners/registration-token"
  GROUPS_API="htt_
