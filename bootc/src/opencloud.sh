#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

mkdir --parents /etc/containers/systemd/users/1001
cp /git/opencloud/ops/opencloud.container /etc/containers/systemd/users/1001/opencloud.container
cp /git/opencloud/ops/opencloud.network /etc/containers/systemd/users/1001/opencloud.network
