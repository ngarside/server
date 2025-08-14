<!-- This is free and unencumbered software released into the public domain -->

# <p align=center>Server

The GitOps codebase for my home server.

# <p align=center>Secret Setup

This script must be run manually on first boot, as the `containers` user, to
configure the container secrets:

```sh
# Cloudflare
echo -n 'SECRETDATA' | podman secret create cloudflare_api_token -
echo -n 'SECRETDATA' | podman secret create cloudflare_tunnel_token -

# Grafana Cloud - Loki
echo -n 'SECRETDATA' | podman secret create grafana_loki_password -
echo -n 'SECRETDATA' | podman secret create grafana_loki_uri -
echo -n 'SECRETDATA' | podman secret create grafana_loki_username -

# Grafana Cloud - Prometheus
echo -n 'SECRETDATA' | podman secret create grafana_prometheus_password -
echo -n 'SECRETDATA' | podman secret create grafana_prometheus_uri -
echo -n 'SECRETDATA' | podman secret create grafana_prometheus_username -

# Mailjet
echo -n 'SECRETDATA' | podman secret create mailjet_smtp_password -
echo -n 'SECRETDATA' | podman secret create mailjet_smtp_username -
```

# <p align=center>Security

The various containers are reasonably well hardened, however this hardening is
split between the container files and the systemd services. Therefore, it is not
recommended to run the containers in other environments, as they will only be
partially hardened.

# <p align=center>License

This is free and unencumbered software released into the public domain.
