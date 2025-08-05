#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

mkdir --parents /usr/etc/containers/systemd/users/1001
cp /tmp/git/jellyfin/ops/jellyfin.container /usr/etc/containers/systemd/users/1001/jellyfin.container
cp /tmp/git/jellyfin/ops/jellyfin.network /usr/etc/containers/systemd/users/1001/jellyfin.network
