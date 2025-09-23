#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

mkdir --parents /etc/containers/systemd/users/1001
cp /git/vector/ops/privileged.container /etc/containers/systemd/users/1001/vector_privileged.container
cp /git/vector/ops/unprivileged.container /etc/containers/systemd/users/1001/vector_unprivileged.container
cp /git/vector/ops/vector.network /etc/containers/systemd/users/1001/vector.network

mkdir --parents /etc/vector/privileged
cp /git/vector/ops/privileged_journal.toml /etc/vector/privileged/journal.toml

mkdir --parents /etc/vector/unprivileged
cp /git/vector/ops/unprivileged_host.toml /etc/vector/unprivileged/host.toml
cp /git/vector/ops/unprivileged_vector.toml /etc/vector/unprivileged/vector.toml
