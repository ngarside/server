#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

mkdir --parents /usr/etc/containers/systemd/users/1001
cp /tmp/git/penpot/ops/backend.container /usr/etc/containers/systemd/users/1001/penpot_backend.container
cp /tmp/git/penpot/ops/exporter.container /usr/etc/containers/systemd/users/1001/penpot_exporter.container
cp /tmp/git/penpot/ops/frontend.container /usr/etc/containers/systemd/users/1001/penpot_frontend.container
cp /tmp/git/penpot/ops/postgres.container /usr/etc/containers/systemd/users/1001/penpot_postgres.container
cp /tmp/git/penpot/ops/valkey.container /usr/etc/containers/systemd/users/1001/penpot_valkey.container
cp /tmp/git/penpot/ops/penpot_backend.network /usr/etc/containers/systemd/users/1001/penpot_backend.network
cp /tmp/git/penpot/ops/penpot_frontend.network /usr/etc/containers/systemd/users/1001/penpot_frontend.network
