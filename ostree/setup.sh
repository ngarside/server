#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

podman build --file ostree/src/ostree.dockerfile --format docker --tag ghcr.io/ngarside/server:feature_bootc .

podman run --volume ./output:/output --privileged --volume /var/lib/containers/storage:/var/lib/containers/storage -it quay.io/centos-bootc/bootc-image-builder:latest --rootfs btrfs --type iso ghcr.io/ngarside/server:feature_bootc
