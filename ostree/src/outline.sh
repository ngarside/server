#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

mkdir --parents /usr/etc/containers/systemd/users/1001
mkdir --parents /usr/etc/outline
cp /tmp/git/outline/ops/outline.container /usr/etc/containers/systemd/users/1001/outline.container
cp /tmp/git/outline/ops/outline.env /usr/etc/outline/outline.env
cp /tmp/git/outline/ops/outline.network /usr/etc/containers/systemd/users/1001/outline.network
cp /tmp/git/outline/ops/postgres.container /usr/etc/containers/systemd/users/1001/outline_postgres.container
cp /tmp/git/outline/ops/valkey.container /usr/etc/containers/systemd/users/1001/outline_valkey.container
