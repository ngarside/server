#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

# Create build directory -------------------------------------------------------

mkdir --parents ./iso/bin

# Pull base image --------------------------------------------------------------

podman pull ghcr.io/ngarside/bootc:latest

# Build ISO --------------------------------------------------------------------

podman run \
	--interactive \
	--privileged \
	--tty \
	--volume ./iso/bin:/output \
	--volume ./iso/src/config.toml:/config.toml:ro \
	--volume /var/lib/containers/storage:/var/lib/containers/storage \
	quay.io/centos-bootc/bootc-image-builder:latest \
	--rootfs btrfs \
	--type iso \
	ghcr.io/ngarside/bootc:latest
