#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

# Load environment variables
# shellcheck source=./restic.env
source /etc/restic/restic.env

# Delete dangling snapshot if it wasn't cleaned up correctly
btrfs subvolume delete /var/data/@backup || true

# Create a new snapshot
btrfs subvolume snapshot -r /var/data /var/data/@backup

# Backup using restic
restic backup /var/data/@backup

# Delete snapshot once backup has completed
btrfs subvolume delete /var/data/@backup
