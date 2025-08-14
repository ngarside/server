#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

mkdir --parents /usr/etc/caddy
mkdir --parents /usr/etc/containers/systemd/users/1001

cp /tmp/git/caddy/ops/caddyfile /usr/etc/caddy/caddyfile
cp /tmp/git/caddy/ops/caddy.container /usr/etc/containers/systemd/users/1001/caddy.container
