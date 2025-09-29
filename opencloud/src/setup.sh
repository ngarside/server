#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

# This script runs the OpenCloud 'init' command.
# It needs to be run manually once when creating a new server instance.

set -euo pipefail

# Ensure that we're running as the 'containers' user.
USER=$(id --name --user)
if [ "$USER" != "containers" ]; then
	echo "Script must be run as the 'containers' user"
	exit 1
fi

# Find the latest OpenCloud image.
IMAGE=$(podman image list --format json |
	jq '.[] | select(.Dangling!=true) | .Names | first' |
	jq 'select(. | startswith("docker.io/opencloudeu/opencloud:"))' |
	jq --null-input --raw-output '[inputs] | sort_by(.) | last')

# Run the 'init' command.
podman run \
	--rm \
	--volume /var/data/opencloud/config:/etc/opencloud:U,Z \
	--volume /var/data/opencloud/data:/var/lib/opencloud:U,Z \
	"$IMAGE" \
	init --insecure no
