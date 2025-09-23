#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

mkdir --parents /etc/containers/systemd/users/1001
cp /git/memos/ops/memos.container /etc/containers/systemd/users/1001/memos.container
cp /git/memos/ops/memos.network /etc/containers/systemd/users/1001/memos.network
