<!-- This is free and unencumbered software released into the public domain -->

# <p align=center>Server

The GitOps codebase for my home server.

# <p align=center>Secret Setup

These commands must be manually run on first boot to configure the container
secrets:

```sh
sudo machinectl --quiet shell containers@.host

# Grafana Cloud
echo "<SECRETDATA>" | podman secret create grafana_cloud_password -
echo "<SECRETDATA>" | podman secret create grafana_cloud_uri -
echo "<SECRETDATA>" | podman secret create grafana_cloud_username -
```

# <p align=center>Security

The various containers are reasonably well hardened, however this hardening is
split between the container files and the systemd services. Therefore, it is not
recommended to run the containers in other environments, as they will only be
partially hardened.

# <p align=center>License

This is free and unencumbered software released into the public domain.
