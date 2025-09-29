#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

mkdir --parents /etc/containers/systemd/users/1001
mkdir --parents /etc/authentik/blueprints
mkdir --parents /etc/authentik/media

cp /git/authentik/ops/blueprints/adguardhome.yaml /etc/authentik/blueprints/adguardhome.yaml
cp /git/authentik/ops/blueprints/chartdb.yaml /etc/authentik/blueprints/chartdb.yaml
cp /git/authentik/ops/blueprints/excalidraw.yaml /etc/authentik/blueprints/excalidraw.yaml
cp /git/authentik/ops/blueprints/fossflow.yaml /etc/authentik/blueprints/fossflow.yaml
cp /git/authentik/ops/blueprints/gitea.yaml /etc/authentik/blueprints/gitea.yaml
cp /git/authentik/ops/blueprints/memos.yaml /etc/authentik/blueprints/memos.yaml
cp /git/authentik/ops/blueprints/opencloud.yaml /etc/authentik/blueprints/opencloud.yaml
cp /git/authentik/ops/blueprints/outline.yaml /etc/authentik/blueprints/outline.yaml
cp /git/authentik/ops/blueprints/outpost.yaml /etc/authentik/blueprints/outpost.yaml
cp /git/authentik/ops/blueprints/penpot.yaml /etc/authentik/blueprints/penpot.yaml
cp /git/authentik/ops/blueprints/vaultwarden.yaml /etc/authentik/blueprints/vaultwarden.yaml
cp /git/authentik/ops/blueprints/youtrack.yaml /etc/authentik/blueprints/youtrack.yaml

cp /git/authentik/ops/containers/postgres.container /etc/containers/systemd/users/1001/authentik_postgres.container
cp /git/authentik/ops/containers/server.container /etc/containers/systemd/users/1001/authentik_server.container
cp /git/authentik/ops/containers/valkey.container /etc/containers/systemd/users/1001/authentik_valkey.container
cp /git/authentik/ops/containers/worker.container /etc/containers/systemd/users/1001/authentik_worker.container

cp /git/authentik/ops/logos/adguardhome.png /etc/authentik/media/adguardhome.png
cp /git/authentik/ops/logos/chartdb.png /etc/authentik/media/chartdb.png
cp /git/authentik/ops/logos/excalidraw.png /etc/authentik/media/excalidraw.png
cp /git/authentik/ops/logos/fossflow.png /etc/authentik/media/fossflow.png
cp /git/authentik/ops/logos/gitea.png /etc/authentik/media/gitea.png
cp /git/authentik/ops/logos/jellyfin.png /etc/authentik/media/jellyfin.png
cp /git/authentik/ops/logos/memos.png /etc/authentik/media/memos.png
cp /git/authentik/ops/logos/opencloud.png /etc/authentik/media/opencloud.png
cp /git/authentik/ops/logos/outline.png /etc/authentik/media/outline.png
cp /git/authentik/ops/logos/penpot.png /etc/authentik/media/penpot.png
cp /git/authentik/ops/logos/vaultwarden.png /etc/authentik/media/vaultwarden.png
cp /git/authentik/ops/logos/youtrack.png /etc/authentik/media/youtrack.png

cp /git/authentik/ops/networks/external.network /etc/containers/systemd/users/1001/authentik_external.network
cp /git/authentik/ops/networks/internal.network /etc/containers/systemd/users/1001/authentik_internal.network
