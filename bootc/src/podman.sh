#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

cp /git/bootc/ops/podman/policy.json /etc/containers/policy.json
cp /git/bootc/ops/podman/prune.service /usr/lib/systemd/system/podman_prune.service
cp /git/bootc/ops/podman/storage.conf /etc/containers/storage.conf

systemctl enable podman_prune
systemctl --machine containers@ --user enable podman.socket
