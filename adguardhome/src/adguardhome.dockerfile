# This is free and unencumbered software released into the public domain.

FROM docker.io/adguard/adguardhome:v0.107.66 AS adguardhome

RUN chmod ugo=rx /opt/adguardhome/AdGuardHome

FROM docker.io/library/golang:1.25.1-alpine AS healthcheck

WORKDIR /go

COPY adguardhome/src/healthcheck.go healthcheck.go

RUN go build -ldflags="-w -s" healthcheck.go
RUN chmod ugo=rx /go/healthcheck

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
