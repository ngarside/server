#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

mkdir --parents /etc/containers/systemd/users/1001
cp /git/vaultwarden/ops/vaultwarden.container /etc/containers/systemd/users/1001/vaultwarden.container
cp /git/vaultwarden/ops/vaultwarden.network /etc/containers/systemd/users/1001/vaultwarden.network
