# This is free and unencumbered software released into the public domain.

FROM docker.io/adguard/adguardhome:latest@sha256:23243d0004d9398cf9c83bdfce3dd92005df72aef010f537e7325a021f31a6f5 AS adguardhome

RUN chmod ugo=rx /opt/adguardhome/AdGuardHome

FROM docker.io/library/golang:alpine@sha256:c8c5f95d64aa79b6547f3b626eb84b16a7ce18a139e3e9ca19a8c078b85ba80d AS healthcheck

COPY healthcheck.go healthcheck.go

RUN go build -ldflags="-w -s" healthcheck.go

FROM scratch

COPY --from=adguardhome /opt/adguardhome/AdGuardHome /usr/bin/adguardhome
COPY --from=healthcheck /go/healthcheck /usr/bin/healthcheck

EXPOSE 53/tcp 53/udp 80/tcp

WORKDIR /opt/adguardhome

ENTRYPOINT ["/usr/bin/adguardhome"]

HEALTHCHECK CMD ["/usr/bin/healthcheck"]

CMD [ \
	"--config", "/etc/adguardhome/config.yml", \
	"--no-check-update", \
	"--web-addr", "0.0.0.0:80", \
	"--work-dir", "/opt/adguardhome" \
]
