#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

mkdir --parents /usr/etc/containers/systemd/users/1001
cp /tmp/git/gitea/ops/gitea.container /usr/etc/containers/systemd/users/1001/gitea.container
cp /tmp/git/gitea/ops/gitea.network /usr/etc/containers/systemd/users/1001/gitea.network
