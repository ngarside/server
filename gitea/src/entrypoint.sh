#!/bin/sh
# This is free and unencumbered software released into the public domain.

echo "Initiating gitea custom entrypoint"

# Load OIDC secret ---------------------------------------------------------------------------------
GITEA_OIDC_SECRET=$(cat /run/secrets/gitea_oidc_secret)
if [ -z "$GITEA_OIDC_SECRET" ]; then
	echo "Secret 'gitea_oidc_secret' has not been set - exiting"
	exit
fi

# Load domain secret -------------------------------------------------------------------------------
MACHINE_DOMAIN_ROOT=$(cat /run/secrets/machine_domain_root)
if [ -z "$MACHINE_DOMAIN_ROOT" ]; then
	echo "Secret 'machine_domain_root' has not been set - exiting"
	exit
fi

/usr/bin/oidc &

gitea admin auth add-oauth \
	--auto-discover-url "https://$MACHINE_DOMAIN_ROOT/application/o/gitea/.well-known/openid-configuration" \
	--key gitea \
	--name Authentik \
	--provider openidConnect \
	--secret "$GITEA_OIDC_SECRET"

echo "Script complete - continuing to built-in entrypoint"
/usr/local/bin/docker-entrypoint.sh "$@"
