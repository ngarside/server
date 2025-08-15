#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

mkdir --parents /usr/etc/containers/systemd/users/1001
cp /tmp/git/vector/ops/unprivileged.container /usr/etc/containers/systemd/users/1001/vector_unprivileged.container
cp /tmp/git/vector/ops/vector.network /usr/etc/containers/systemd/users/1001/vector.network

mkdir --parents /usr/etc/vector/unprivileged
cp /tmp/git/vector/ops/journal.toml /usr/etc/vector/unprivileged/journal.toml
cp /tmp/git/vector/ops/unprivileged_host.toml /usr/etc/vector/unprivileged/host.toml
cp /tmp/git/vector/ops/unprivileged_vector.toml /usr/etc/vector/unprivileged/vector.toml
