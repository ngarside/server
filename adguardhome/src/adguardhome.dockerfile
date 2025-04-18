# This is free and unencumbered software released into the public domain.

FROM docker.io/adguard/adguardhome:latest@sha256:f793df60142d249f2b869e95da4516acb96104aaa799bc3efb090622964242bd AS build

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
