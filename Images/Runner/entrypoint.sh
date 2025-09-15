#!/bin/bash
set -e

# Fix ownership of the work directory volume
mkdir -p /home/runner/actions-runner/_work
chown -R runner:runner /home/runner/actions-runner/_work

# Drop privileges to runner user
exec su runner -c "/runner-entry.sh"
