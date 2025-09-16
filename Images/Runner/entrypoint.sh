#!/bin/bash
set -e

mkdir -p /home/runner/actions-runner/_work
mkdir -p /home/runner/actions-runner/_tool
chown -R runner:docker /home/runner/actions-runner

# Drop to non-root user (runner)
exec su - runner -c "/runner-entry.sh"