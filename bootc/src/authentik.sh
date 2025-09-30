#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

mkdir --parents /etc/authentik
mkdir --parents /etc/containers/systemd/users/1001

cp /git/authentik/ops/blueprints /etc/authentik/blueprints
cp /git/authentik/ops/logos /etc/authentik/media

cp /git/authentik/ops/containers/postgres.container /etc/containers/systemd/users/1001/authentik_postgres.container
cp /git/authentik/ops/containers/server.container /etc/containers/systemd/users/1001/authentik_server.container
cp /git/authentik/ops/containers/valkey.container /etc/containers/systemd/users/1001/authentik_valkey.container
cp /git/authentik/ops/containers/worker.container /etc/containers/systemd/users/1001/authentik_worker.container

cp /git/authentik/ops/networks/external.network /etc/containers/systemd/users/1001/authentik_external.network
cp /git/authentik/ops/networks/internal.network /etc/containers/systemd/users/1001/authentik_internal.network
