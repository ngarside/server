#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

mkdir --parents /etc/containers/systemd/users/1001
mkdir --parents /etc/authentik/blueprints
mkdir --parents /etc/authentik/media

cp /git/authentik/ops/authentik_external.network /etc/containers/systemd/users/1001/authentik_external.network
cp /git/authentik/ops/authentik_internal.network /etc/containers/systemd/users/1001/authentik_internal.network
cp /git/authentik/ops/authentik_postgres.container /etc/containers/systemd/users/1001/authentik_postgres.container
cp /git/authentik/ops/authentik_server.container /etc/containers/systemd/users/1001/authentik_server.container
cp /git/authentik/ops/authentik_valkey.container /etc/containers/systemd/users/1001/authentik_valkey.container
cp /git/authentik/ops/authentik_worker.container /etc/containers/systemd/users/1001/authentik_worker.container
cp /git/authentik/ops/blueprints_memos.yaml /etc/authentik/blueprints/memos.yaml
cp /git/authentik/ops/blueprints_youtrack.yaml /etc/authentik/blueprints/youtrack.yaml
cp /git/authentik/ops/blueprints_outline.yaml /etc/authentik/blueprints/outline.yaml
cp /git/authentik/ops/logo_memos.png /etc/authentik/media/memos.png
cp /git/authentik/ops/logo_youtrack.png /etc/authentik/media/youtrack.png
cp /git/authentik/ops/logo_outline.png /etc/authentik/media/outline.png
