# This is free and unencumbered software released into the public domain.

FROM docker.io/adguard/adguardhome:latest@sha256:558437c3b656a20a23192d3db0f0334770b4c2f391223fa051591ba9202b0322 AS build

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
