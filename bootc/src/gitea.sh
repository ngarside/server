#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

mkdir --parents /etc/containers/systemd/users/1001
cp /git/gitea/ops/server.container /etc/containers/systemd/users/1001/gitea_server.container
cp /git/gitea/ops/server.network /etc/containers/systemd/users/1001/gitea_server.network

mkdir --parents /etc/gitea/server
cp /git/gitea/ops/server.ini /etc/gitea/server/gitea.ini
