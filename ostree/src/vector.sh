#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

mkdir --parents /usr/etc/containers/systemd/users/1001
cp /tmp/git/vector/ops/vector.container /usr/etc/containers/systemd/users/1001/vector.container
cp /tmp/git/vector/ops/vector.network /usr/etc/containers/systemd/users/1001/vector.network

mkdir --parents /usr/etc/vector
cp /tmp/git/vector/ops/vector.env /usr/etc/vector/vector.env
cp /tmp/git/vector/ops/vector.toml /usr/etc/vector/vector.toml
