#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

mkdir --parents /etc/caddy
mkdir --parents /etc/containers/systemd/users/1001

cp /tmp/git/caddy/ops/caddyfile /etc/caddy/caddyfile
cp /tmp/git/caddy/ops/caddy.container /etc/containers/systemd/users/1001/caddy.container
