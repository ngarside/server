# This is free and unencumbered software released into the public domain.

FROM docker.io/adguard/adguardhome:latest@sha256:b9f635f51cec62205dd7bcae0d9bfffe3a33a6d30f3787d9fb7eb531281532d2 AS build

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
