#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

mkdir --parents /etc/containers/systemd/users/1001
cp /git/jellyfin/ops/jellyfin.container /etc/containers/systemd/users/1001/jellyfin.container
cp /git/jellyfin/ops/jellyfin.network /etc/containers/systemd/users/1001/jellyfin.network
