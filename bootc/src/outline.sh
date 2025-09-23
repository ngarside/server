#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

mkdir --parents /etc/containers/systemd/users/1001
mkdir --parents /etc/outline
cp /git/outline/ops/outline.container /etc/containers/systemd/users/1001/outline.container
cp /git/outline/ops/outline.env /etc/outline/outline.env
cp /git/outline/ops/outline.network /etc/containers/systemd/users/1001/outline.network
cp /git/outline/ops/postgres.container /etc/containers/systemd/users/1001/outline_postgres.container
cp /git/outline/ops/valkey.container /etc/containers/systemd/users/1001/outline_valkey.container
