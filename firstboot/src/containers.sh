#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

# On first boot, this script must be modified to include the appropriate secret
# data and then run as the 'containers' user.

set -euo pipefail

# Cloudflare.
echo -n 'SECRETDATA' | podman secret create cloudflare_api_token -
echo -n 'SECRETDATA' | podman secret create cloudflare_tunnel_token -

# Grafana Cloud - Loki.
echo -n 'SECRETDATA' | podman secret create grafana_loki_password -
echo -n 'SECRETDATA' | podman secret create grafana_loki_uri -
echo -n 'SECRETDATA' | podman secret create grafana_loki_username -

# Grafana Cloud - Prometheus.
echo -n 'SECRETDATA' | podman secret create grafana_prometheus_password -
echo -n 'SECRETDATA' | podman secret create grafana_prometheus_uri -
echo -n 'SECRETDATA' | podman secret create grafana_prometheus_username -

# Mailjet.
echo -n 'SECRETDATA' | podman secret create mailjet_smtp_password -
echo -n 'SECRETDATA' | podman secret create mailjet_smtp_username -

# Physical / Virtual Machine.
echo -n 'SECRETDATA' | podman secret create machine_domain_root -
