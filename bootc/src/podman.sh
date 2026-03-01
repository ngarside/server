#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

cp /git/bootc/ops/podman/policy.json /etc/containers/policy.json
cp /git/bootc/ops/podman/prune_images.service /usr/lib/systemd/system/prune_images.service
cp /git/bootc/ops/podman/prune_images.timer /usr/lib/systemd/system/prune_images.timer
cp /git/bootc/ops/podman/prune_system.service /usr/lib/systemd/system/prune_system.service
cp /git/bootc/ops/podman/storage.conf /etc/containers/storage.conf

systemctl enable prune_images.timer
systemctl enable prune_system
