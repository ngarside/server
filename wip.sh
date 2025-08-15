podman run --name vectortest --replace --rm --security-opt no-new-privileges --security-opt label=disable --read-only --userns auto:size=8 --volume /etc/pki/ca-trust/extracted/pem:/etc/pki/ca-trust/extracted/pem:ro --volume /home/containers/vectortest:/etc/vector:ro --volume /proc:/proc:ro --volume /sys:/sys:ro --secret grafana_loki_password,type=env,target=GRAFANA_LOKI_PASSWORD --secret grafana_loki_uri,type=env,target=GRAFANA_LOKI_URI --secret grafana_loki_username,type=env,target=GRAFANA_LOKI_USERNAME --secret grafana_prometheus_password,type=env,target=GRAFANA_PROMETHEUS_PASSWORD --secret grafana_prometheus_uri,type=env,target=GRAFANA_PROMETHEUS_URI --secret grafana_prometheus_username,type=env,target=GRAFANA_PROMETHEUS_USERNAME --volume /var/log/journal:/var/log/journal:ro --volume /home/containers/vectortest/data:/var/lib/vector:U,Z ghcr.io/ngarside/vector:0.49.0.63





podman run --name vectortest --replace --rm --security-opt label=disable --volume /home/containers/vectortest:/etc/vector:ro --volume /var/log/journal:/var/log/journal:ro --volume /home/containers/vectortest/data:/var/lib/vector:U,Z --privileged --entrypoint /usr/bin/journalctl timberio/vector:0.49.0-debian




podman run --name vectortest --replace --rm --security-opt label=disable --volume /home/containers/vectortest:/etc/vector:ro --volume /var/log/journal:/var/log/journal:ro --volume /home/containers/vectortest/data:/var/lib/vector:U,Z --privileged --entrypoint /bin/bash --group-add keep-groups -it timberio/vector:0.49.0-debian




podman run --name vectortest --replace --rm --security-opt label=disable --volume /home/containers/vectortest:/etc/vector:ro --volume /var/log/journal:/var/log/journal:ro --volume /home/containers/vectortest/data:/var/lib/vector:U,Z --entrypoint /bin/bash --group-add keep-groups -it timberio/vector:0.49.0-debian
