#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

mkdir --parents /etc/containers/systemd/users/1001
cp /git/excalidraw/ops/excalidraw.container /etc/containers/systemd/users/1001/excalidraw.container
cp /git/excalidraw/ops/excalidraw.network /etc/containers/systemd/users/1001/excalidraw.network
