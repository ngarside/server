#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

# Wait for Gitea server to initialise ----------------------------------------------------
echo "[CONFIG] Waiting for Gitea server to initialise"
RETRIES_MAX=60
RETRIES_CURRENT=1
while (( RETRIES_CURRENT <= RETRIES_MAX )); do
	echo "[CONFIG] Sending HTTP request (attempt $RETRIES_CURRENT of $RETRIES_MAX)"
	STATUS=$(wget -qSO /dev/null 0.0.0.0 2>&1 | awk '/^  HTTP/{print $2}')
	echo "[CONFIG] Received $STATUS status code"
	if (( STATUS >= 200 && STATUS < 400 )); then
		echo "[CONFIG] Code is successful, exiting loop"
		break
	else
		echo "[CONFIG] Code is unsuccessful, delaying before retry"
		sleep 1
	fi
	(( RETRIES_CURRENT++ ))
done
if (( RETRIES_CURRENT > RETRIES_MAX )); then
	echo "[CONFIG] Exceeded maximum retry count, aborting script"
	exit 1
fi
echo "[CONFIG] Finished waiting for initialisation"

# Read OIDC secret -----------------------------------------------------------------------
echo "[CONFIG] Reading 'gitea_oidc_secret' secret"
GITEA_OIDC_SECRET=$(cat /run/secrets/gitea_oidc_secret)
if [ -z "$GITEA_OIDC_SECRET" ]; then
	echo "[CONFIG] Secret 'gitea_oidc_secret' has not been set - exiting"
	exit
fi
echo "[CONFIG] Secret 'gitea_oidc_secret' read successfully"

# Read domain secret ---------------------------------------------------------------------
echo "[CONFIG] Reading 'machine_domain_root' secret"
MACHINE_DOMAIN_ROOT=$(cat /run/secrets/machine_domain_root)
if [ -z "$MACHINE_DOMAIN_ROOT" ]; then
	echo "[CONFIG] Secret 'machine_domain_root' has not been set - exiting"
	exit
fi
echo "[CONFIG] Secret 'machine_domain_root' read successfully"

# Configure Authentik OIDC ---------------------------------------------------------------
echo "[CONFIG] Adding OIDC configuration for Gitea/Authentik"
gitea admin auth add-oauth \
	--auto-discover-url \
	"https://$MACHINE_DOMAIN_ROOT/application/o/gitea/.well-known/openid-configuration" \
	--key gitea \
	--name Authentik \
	--provider openidConnect \
	--secret "$GITEA_OIDC_SECRET"
echo "[CONFIG] OIDC command completed, see above for output"
