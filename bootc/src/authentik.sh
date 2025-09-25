#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

mkdir --parents /etc/containers/systemd/users/1001
mkdir --parents /etc/authentik/blueprints
mkdir --parents /etc/authentik/media

cp /git/authentik/ops/external.network /etc/containers/systemd/users/1001/external.network
cp /git/authentik/ops/internal.network /etc/containers/systemd/users/1001/internal.network
cp /git/authentik/ops/postgres.container /etc/containers/systemd/users/1001/postgres.container
cp /git/authentik/ops/server.container /etc/containers/systemd/users/1001/server.container
cp /git/authentik/ops/valkey.container /etc/containers/systemd/users/1001/valkey.container
cp /git/authentik/ops/worker.container /etc/containers/systemd/users/1001/worker.container
cp /git/authentik/ops/memos.yaml /etc/authentik/blueprints/memos.yaml
cp /git/authentik/ops/youtrack.yaml /etc/authentik/blueprints/youtrack.yaml
cp /git/authentik/ops/outline.yaml /etc/authentik/blueprints/outline.yaml
cp /git/authentik/ops/memos.png /etc/authentik/media/memos.png
cp /git/authentik/ops/youtrack.png /etc/authentik/media/youtrack.png
cp /git/authentik/ops/outline.png /etc/authentik/media/outline.png
