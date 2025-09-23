#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

mkdir --parents /etc/containers/systemd/users/1001
cp /tmp/git/youtrack/ops/youtrack.container /etc/containers/systemd/users/1001/youtrack.container
cp /tmp/git/youtrack/ops/youtrack.network /etc/containers/systemd/users/1001/youtrack.network
