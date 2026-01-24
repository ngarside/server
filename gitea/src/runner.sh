#!/usr/bin/env sh
# This is free and unencumbered software released into the public domain.

set -emu

# Read domain secret -------------------------------------------------------------------------------
echo "[CONFIG] Reading 'machine_domain_root' secret"
if [ -f /run/secrets/machine_domain_root ]; then
	MACHINE_DOMAIN_ROOT=$(cat /run/secrets/machine_domain_root)
else
	MACHINE_DOMAIN_ROOT=""
fi

if [ -z "$MACHINE_DOMAIN_ROOT" ]; then
	echo "[CONFIG] Secret 'machine_domain_root' has not been set - exiting"
	exit 1
fi
echo "[CONFIG] Secret 'machine_domain_root' read successfully"

# Register the Gitea runner ------------------------------------------------------------------------
echo "[CONFIG] Registering runner"
mkdir --parents /tmp/gitea
runner --config /etc/gitea/gitea.yaml register \
	--instance "https://gitea.$MACHINE_DOMAIN_ROOT" \
	--no-interactive \
	--name runner \
	--token "$(cat "$GITEA_RUNNER_REGISTRATION_TOKEN_FILE")"

# Start the Gitea runner ---------------------------------------------------------------------------
echo "[CONFIG] Starting runner"
runner --config /etc/gitea/gitea.yaml daemon
