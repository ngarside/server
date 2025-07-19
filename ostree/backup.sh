#!/usr/bin/env bash

set -euo pipefail

# Load environment variables
source backup.env

# Delete dangling snapshot if it wasn't cleaned up correctly
btrfs subvolume delete /var/data/@backup || true

# Create a new snapshot
btrfs subvolume snapshot -r /var/data /var/data/@backup

# Backup using restic
restic --insecure-no-password --repo /tmp/restic-repo backup /var/data/@backup

# Delete snapshot once backup has completed
btrfs subvolume delete /var/data/@backup
