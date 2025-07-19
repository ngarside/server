#!/usr/bin/env bash

set -euo pipefail

# Delete dangling snapshot if it wasn't cleaned up correctly
btrfs subvolume delete /var/data/@backup || true

# Initialize restic repository if it doesn't already exist
restic --insecure-no-password --repo /tmp/restic-repo init || true

# Backup using restic
restic --insecure-no-password --repo /tmp/restic-repo backup /var/data/@backup

# Create a new snapshot
btrfs subvolume snapshot -r /var/data /var/data/@backup
