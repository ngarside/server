#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

mkdir --parents /etc/containers/systemd/users/1001
cp /tmp/git/cloudflared/ops/cloudflared.container /etc/containers/systemd/users/1001/cloudflared.container
cp /tmp/git/cloudflared/ops/cloudflared.network /etc/containers/systemd/users/1001/cloudflared.network
