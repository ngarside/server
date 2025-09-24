#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

# Load environment variables
export AWS_ACCESS_KEY_ID=$(podman secret inspect restic_repository_key --showsecret | jq --raw-output ".[].SecretData")
export RESTIC_PASSWORD=$(podman secret inspect restic_repository_password --showsecret | jq --raw-output ".[].SecretData")
export AWS_SECRET_ACCESS_KEY=$(podman secret inspect restic_repository_secret --showsecret | jq --raw-output ".[].SecretData")
export RESTIC_REPOSITORY=$(podman secret inspect restic_repository_uri --showsecret | jq --raw-output ".[].SecretData")
export RESTIC_REPOSITORY="s3:$RESTIC_REPOSITORY"

# Delete dangling snapshot if it wasn't cleaned up correctly
btrfs subvolume delete /var/data/@backup || true

# Create a new snapshot
btrfs subvolume snapshot -r /var/data /var/data/@backup

# Backup using restic
restic backup /var/data/@backup

# Delete snapshot once backup has completed
btrfs subvolume delete /var/data/@backup
