# This is free and unencumbered software released into the public domain.

FROM docker.io/adguard/adguardhome as build

FROM scratch

COPY --from=build /opt/adguardhome/AdGuardHome /usr/bin/adguardhome

EXPOSE 53/tcp 53/udp 80/tcp

WORKDIR /opt/adguardhome/work

ENTRYPOINT ["/usr/bin/adguardhome"]

CMD [ \
	"--no-check-update", \
	"-c", "/opt/adguardhome/conf/adguardhome.yml", \
	"-w", "/opt/adguardhome/work", \
	"--web-addr", "0.0.0.0:80" \
]
