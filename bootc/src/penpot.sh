#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

mkdir --parents /etc/containers/systemd/users/1001
cp /tmp/git/penpot/ops/backend.container /etc/containers/systemd/users/1001/penpot_backend.container
cp /tmp/git/penpot/ops/exporter.container /etc/containers/systemd/users/1001/penpot_exporter.container
cp /tmp/git/penpot/ops/frontend.container /etc/containers/systemd/users/1001/penpot_frontend.container
cp /tmp/git/penpot/ops/postgres.container /etc/containers/systemd/users/1001/penpot_postgres.container
cp /tmp/git/penpot/ops/valkey.container /etc/containers/systemd/users/1001/penpot_valkey.container
cp /tmp/git/penpot/ops/penpot_backend.network /etc/containers/systemd/users/1001/penpot_backend.network
cp /tmp/git/penpot/ops/penpot_frontend.network /etc/containers/systemd/users/1001/penpot_frontend.network
