#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

mkdir --parents /etc/containers/systemd/users/1001
cp /git/chartdb/ops/chartdb.container /etc/containers/systemd/users/1001/chartdb.container
cp /git/chartdb/ops/chartdb.network /etc/containers/systemd/users/1001/chartdb.network
