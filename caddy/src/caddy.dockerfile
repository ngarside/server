# This is free and unencumbered software released into the public domain.

FROM docker.io/caddy:2.10.0-builder-alpine AS caddy

RUN xcaddy build --with github.com/caddy-dns/cloudflare

RUN chmod ugo=rx /usr/bin/caddy

FROM docker.io/library/golang:1.25.0-alpine AS healthcheck

WORKDIR /go

COPY caddy/src/healthcheck.go healthcheck.go

RUN go build -ldflags="-w -s" healthcheck.go
RUN chmod ugo=rx /go/healthcheck

FROM scratch

COPY --from=caddy /usr/bin/caddy /usr/bin/caddy
COPY --from=healthcheck /go/healthcheck /usr/bin/healthcheck

EXPOSE 80

WORKDIR /opt/caddy

ENTRYPOINT ["/usr/bin/caddy"]

HEALTHCHECK CMD ["/usr/bin/healthcheck"]

CMD [ \
	"run", \
	"--adapter", "caddyfile", \
	"--config", "/etc/caddy/caddyfile" \
]
