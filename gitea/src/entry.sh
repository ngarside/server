#!/bin/sh
# This is free and unencumbered software released into the public domain.

gitea admin auth add-oauth \
	--auto-discover-url https://$MACHINE_DOMAIN_ROOT/application/o/gitea/.well-known/openid-configuration \
	--key gitea \
	--name Authentik \
	--provider openidConnect\
	--secret "$GITEA_CLIENT_SECRET"

/usr/local/bin/docker-entrypoint.sh "$@"
