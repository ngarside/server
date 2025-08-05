#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

mkdir --parents /usr/etc/containers/systemd/users/1001
cp /tmp/git/vaultwarden/ops/vaultwarden.container /usr/etc/containers/systemd/users/1001/vaultwarden.container
cp /tmp/git/vaultwarden/ops/vaultwarden.network /usr/etc/containers/systemd/users/1001/vaultwarden.network
