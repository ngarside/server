#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

mkdir --parents /usr/etc/containers/systemd/users/1001
cp /tmp/git/memos/ops/memos.container /usr/etc/containers/systemd/users/1001/memos.container
cp /tmp/git/memos/ops/memos.network /usr/etc/containers/systemd/users/1001/memos.network
