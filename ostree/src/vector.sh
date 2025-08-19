#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

mkdir --parents /etc/containers/systemd/users/1001
cp /tmp/git/vector/ops/privileged.container /etc/containers/systemd/users/1001/vector_privileged.container
cp /tmp/git/vector/ops/unprivileged.container /etc/containers/systemd/users/1001/vector_unprivileged.container
cp /tmp/git/vector/ops/vector.network /etc/containers/systemd/users/1001/vector.network

mkdir --parents /etc/vector/privileged
cp /tmp/git/vector/ops/privileged_journal.toml /etc/vector/privileged/journal.toml

mkdir --parents /etc/vector/unprivileged
cp /tmp/git/vector/ops/unprivileged_host.toml /etc/vector/unprivileged/host.toml
cp /tmp/git/vector/ops/unprivileged_vector.toml /etc/vector/unprivileged/vector.toml
