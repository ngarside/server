#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

mkdir --parents /etc/containers/systemd/users/1001
cp /git/gitea/ops/gitea.container /etc/containers/systemd/users/1001/gitea.container
cp /git/gitea/ops/gitea.network /etc/containers/systemd/users/1001/gitea.network
