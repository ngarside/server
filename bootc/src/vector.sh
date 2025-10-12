#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

mkdir --parents /etc/containers/systemd/users/1001
mkdir --parents /etc/vector

cp /git/vector/ops/containers/privileged.container /etc/containers/systemd/users/1001/vector_privileged.container
cp /git/vector/ops/containers/unprivileged.container /etc/containers/systemd/users/1001/vector_unprivileged.container

cp /git/vector/ops/networks/vector.network /etc/containers/systemd/users/1001/vector.network

cp /git/vector/ops/privileged /etc/vector/privileged
cp /git/vector/ops/unprivileged /etc/vector/unprivileged
