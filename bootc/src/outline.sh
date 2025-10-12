#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

mkdir --parents /etc/containers/systemd/users/1001
cp /git/outline/ops/containers/outline.container /etc/containers/systemd/users/1001/outline.container
cp /git/outline/ops/networks/outline.network /etc/containers/systemd/users/1001/outline.network
cp /git/outline/ops/containers/postgres.container /etc/containers/systemd/users/1001/outline_postgres.container
cp /git/outline/ops/containers/valkey.container /etc/containers/systemd/users/1001/outline_valkey.container
