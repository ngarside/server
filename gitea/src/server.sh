#!/usr/bin/env sh
# This is free and unencumbered software released into the public domain.

set -emu

# Run Gitea server in background -------------------------------------------------------------------
echo "[CONFIG] Starting Gitea server in background"
/usr/bin/gitea --config /etc/gitea/gitea.ini "$@" &
GITEA_JOB=%1

# Wait for Gitea server to initialise --------------------------------------------------------------
echo "[CONFIG] Waiting for Gitea server to initialise"
RETRIES_MAX=60
RETRIES_CURRENT=1
while [ "$RETRIES_CURRENT" -le "$RETRIES_MAX" ]; do
	echo "[CONFIG] Sending HTTP request (attempt $RETRIES_CURRENT of $RETRIES_MAX)"
	STATUS=$(wget -qSO /dev/null 0.0.0.0 2>&1 | awk '/^  HTTP/{print $2; exit}' | tr -d '\n')
	echo "[CONFIG] Received $STATUS status code"
	case "$STATUS" in
		2*|3*)
			echo "[CONFIG] Code is successful, exiting loop"
			break
			;;
		*)
			echo "[CONFIG] Code is unsuccessful, delaying before retry"
			sleep 1
			;;
	esac
	RETRIES_CURRENT=$((RETRIES_CURRENT + 1))
done

if [ "$RETRIES_CURRENT" -gt "$RETRIES_MAX" ]; then
	echo "[CONFIG] Exceeded maximum retry count, bringing Gitea server to foreground"
	fg $GITEA_JOB
fi

echo "[CONFIG] Finished waiting for initialisation"

# Read OIDC secret ---------------------------------------------------------------------------------
echo "[CONFIG] Reading 'gitea_oidc_secret' secret"
if [ -f /run/secrets/gitea_oidc_secret ]; then
	GITEA_OIDC_SECRET=$(cat /run/secrets/gitea_oidc_secret)
else
	GITEA_OIDC_SECRET=""
fi

if [ -z "$GITEA_OIDC_SECRET" ]; then
	echo "[CONFIG] Secret 'gitea_oidc_secret' has not been set - exiting"
	exit 1
fi
echo "[CONFIG] Secret 'gitea_oidc_secret' read successfully"

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

# Configure Authentik OIDC -------------------------------------------------------------------------
echo "[CONFIG] Adding OIDC configuration for Gitea/Authentik"
gitea \
	--config /tmp/gitea.ini \
	admin auth add-oauth \
	--auto-discover-url \
	"https://$MACHINE_DOMAIN_ROOT/application/o/gitea/.well-known/openid-configuration" \
	--key gitea \
	--name Authentik \
	--provider openidConnect \
	--secret "$GITEA_OIDC_SECRET"
echo "[CONFIG] OIDC command completed, see above for output"

# Bring Gitea server process to the foreground -----------------------------------------------------
echo "[CONFIG] Bringing Gitea server to foreground"
fg $GITEA_JOB
