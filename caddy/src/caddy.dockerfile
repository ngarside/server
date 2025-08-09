# This is free and unencumbered software released into the public domain.

FROM docker.io/caddy:builder-alpine@sha256:cc6c40aa7cdea02ef9cb99f3c4e4664ecdb6066ae93ae52ed5288afc511e1241 AS caddy

RUN xcaddy build --with github.com/caddy-dns/cloudflare

RUN chmod ugo=rx /usr/bin/caddy

FROM docker.io/library/golang:alpine@sha256:c8c5f95d64aa79b6547f3b626eb84b16a7ce18a139e3e9ca19a8c078b85ba80d AS healthcheck

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
