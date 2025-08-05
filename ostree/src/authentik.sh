#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

mkdir --parents /usr/etc/containers/systemd/users/1001
mkdir --parents /usr/etc/authentik/blueprints
mkdir --parents /usr/etc/authentik/env
mkdir --parents /usr/etc/authentik/media

cp /tmp/git/authentik/ops/authentik_external.network /usr/etc/containers/systemd/users/1001/authentik_external.network
cp /tmp/git/authentik/ops/authentik_internal.network /usr/etc/containers/systemd/users/1001/authentik_internal.network
cp /tmp/git/authentik/ops/authentik_postgres.container /usr/etc/containers/systemd/users/1001/authentik_postgres.container
cp /tmp/git/authentik/ops/authentik_server.container /usr/etc/containers/systemd/users/1001/authentik_server.container
cp /tmp/git/authentik/ops/authentik_valkey.container /usr/etc/containers/systemd/users/1001/authentik_valkey.container
cp /tmp/git/authentik/ops/authentik_worker.container /usr/etc/containers/systemd/users/1001/authentik_worker.container
cp /tmp/git/authentik/ops/blueprints_memos.yaml /usr/etc/authentik/blueprints/memos.yaml
cp /tmp/git/authentik/ops/blueprints_youtrack.yaml /usr/etc/authentik/blueprints/youtrack.yaml
cp /tmp/git/authentik/ops/blueprints_outline.yaml /usr/etc/authentik/blueprints/outline.yaml
cp /tmp/git/authentik/ops/logo_memos.png /usr/etc/authentik/media/memos.png
cp /tmp/git/authentik/ops/logo_youtrack.png /usr/etc/authentik/media/youtrack.png
cp /tmp/git/authentik/ops/logo_outline.png /usr/etc/authentik/media/outline.png
cp /tmp/git/authentik/ops/worker.env /usr/etc/authentik/env/worker
