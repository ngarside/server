#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

mkdir --parents /home/containers/.config/systemd/user
cp /git/bootc/ops/podman/prune.service /home/containers/.config/systemd/user/podman_prune.service

cp /git/bootc/ops/podman/policy.json /etc/containers/policy.json
cp /git/bootc/ops/podman/storage.conf /etc/containers/storage.conf
