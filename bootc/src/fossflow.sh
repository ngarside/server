#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

mkdir --parents /etc/containers/systemd/users/1001
cp /tmp/git/fossflow/ops/fossflow.container /etc/containers/systemd/users/1001/fossflow.container
cp /tmp/git/fossflow/ops/fossflow.network /etc/containers/systemd/users/1001/fossflow.network
