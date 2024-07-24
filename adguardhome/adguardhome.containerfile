# This is free and unencumbered software released into the public domain.

FROM docker.io/adguard/adguardhome as build

RUN chmod ugo=rx /opt/adguardhome/AdGuardHome

FROM scratch

COPY --from=build /opt/adguardhome/AdGuardHome /usr/bin/adguardhome

EXPOSE 53/tcp 53/udp 80/tcp

WORKDIR /opt/adguardhome/work

ENTRYPOINT ["/usr/bin/adguardhome"]

CMD [ \
	"--config", "/opt/adguardhome/conf/adguardhome.yml", \
	"--no-check-update", \
	"--web-addr", "0.0.0.0:80" \
	"--work-dir", "/opt/adguardhome/work", \
]
