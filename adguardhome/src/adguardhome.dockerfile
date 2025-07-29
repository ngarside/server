# This is free and unencumbered software released into the public domain.

FROM docker.io/adguard/adguardhome:latest@sha256:23243d0004d9398cf9c83bdfce3dd92005df72aef010f537e7325a021f31a6f5 AS build

RUN chmod ugo=rx /opt/adguardhome/AdGuardHome

FROM scratch

COPY --from=build /opt/adguardhome/AdGuardHome /usr/bin/adguardhome

EXPOSE 53/tcp 53/udp 80/tcp

WORKDIR /opt/adguardhome

ENTRYPOINT ["/usr/bin/adguardhome"]

CMD [ \
	"--config", "/etc/adguardhome/config.yml", \
	"--no-check-update", \
	"--web-addr", "0.0.0.0:80", \
	"--work-dir", "/opt/adguardhome" \
]
