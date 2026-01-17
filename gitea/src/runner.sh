#!/usr/bin/env sh
# This is free and unencumbered software released into the public domain.

set -emu

# Register the Gitea runner ------------------------------------------------------------------------
echo "[CONFIG] Registering runner"
mkdir --parents /tmp/gitea
runner --config /etc/gitea/gitea.yaml register \
	--instance "$GITEA_INSTANCE_URL" \
	--no-interactive \
	--name runner \
	--token "$(cat "$GITEA_RUNNER_REGISTRATION_TOKEN_FILE")"

# Start the Gitea runner ---------------------------------------------------------------------------
echo "[CONFIG] Starting runner"
runner --config /etc/gitea/gitea.yaml daemon
