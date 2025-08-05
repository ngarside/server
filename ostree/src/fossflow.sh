#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

mkdir --parents /usr/etc/containers/systemd/users/1001
cp /tmp/git/fossflow/ops/fossflow.container /usr/etc/containers/systemd/users/1001/fossflow.container
cp /tmp/git/fossflow/ops/fossflow.network /usr/etc/containers/systemd/users/1001/fossflow.network
