#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

mkdir --parents /etc/containers/systemd/users/1001

cp /git/penpot/ops/containers/backend.container /etc/containers/systemd/users/1001/penpot_backend.container
cp /git/penpot/ops/containers/exporter.container /etc/containers/systemd/users/1001/penpot_exporter.container
cp /git/penpot/ops/containers/frontend.container /etc/containers/systemd/users/1001/penpot_frontend.container
cp /git/penpot/ops/containers/postgres.container /etc/containers/systemd/users/1001/penpot_postgres.container
cp /git/penpot/ops/containers/valkey.container /etc/containers/systemd/users/1001/penpot_valkey.container

cp /git/penpot/ops/networks/internal.network /etc/containers/systemd/users/1001/penpot_internal.network
cp /git/penpot/ops/networks/external.network /etc/containers/systemd/users/1001/penpot_external.network
