#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

# On first boot, this script must be modified to include the appropriate secret
# data and then run as the 'containers' user.

set -euo pipefail

# Cloudflare.
echo -n 'SECRETDATA' | podman secret create cloudflare_api_token -
echo -n 'SECRETDATA' | podman secret create cloudflare_tunnel_token -

# Open Cloud.
echo -n 'SECRETDATA' | podman secret create opencloud_public_uri -

# Outline.
echo -n 'SECRETDATA' | podman secret create outline_oidc_uri -
echo -n 'SECRETDATA' | podman secret create outline_public_uri -

# Penpot.
echo -n 'SECRETDATA' | podman secret create penpot_oidc_uri -
echo -n 'SECRETDATA' | podman secret create penpot_public_uri -

# Physical / Virtual Machine.
echo -n 'SECRETDATA' | podman secret create machine_domain_root -
