#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

mkdir --parents /usr/etc/containers/systemd/users/1001
cp /tmp/git/cloudflared/ops/cloudflared.container /usr/etc/containers/systemd/users/1001/cloudflared.container
cp /tmp/git/cloudflared/ops/cloudflared.network /usr/etc/containers/systemd/users/1001/cloudflared.network
