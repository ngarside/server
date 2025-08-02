#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

# This script configures YouTrack to use the 'youtrack.usani.uk' base URL.
# It needs to be run manually once when creating a new server instance.

set -euo pipefail

# Ensure that we're running as the 'containers' user.
USER=$(id --name --user)
if [ "$USER" != "containers" ]; then
	echo "Script must be run as the 'containers' user"
	exit 1
fi

# Find the latest YouTrack image.
IMAGE=$(podman image list --format json |
	jq '.[] | select(.Dangling!=true) | .Names | first' |
	jq 'select(. | startswith("docker.io/jetbrains/youtrack:"))' |
	jq --null-input --raw-output '[inputs] | sort_by(.) | last')

# Configure YouTrack to use the public base URL.
podman run \
	--interactive \
	--rm \
	--tty \
	--volume /var/data/youtrack/config:/opt/youtrack/conf:U,Z \
	"$IMAGE" \
	configure --base-url https://youtrack.usani.uk
