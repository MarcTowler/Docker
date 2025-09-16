#!/bin/bash
set -e

# Ensure work dir exists and has correct ownership
mkdir -p /home/runner/actions-runner/_work
chown -R runner:runner /home/runner/actions-runner/_work

# Drop privileges to runner
exec su runner -c "/runner-entry.sh"