# This is free and unencumbered software released into the public domain.

FROM docker.io/caddy:builder-alpine@sha256:1df07ddece81440960d630985847d6e50df8851766222ad8c1168324ef790457 AS build

RUN xcaddy build --with github.com/caddy-dns/cloudflare

RUN chmod ugo=rx /usr/bin/caddy

FROM scratch

COPY --from=build /usr/bin/caddy /usr/bin/caddy

EXPOSE 80

WORKDIR /opt/caddy

ENTRYPOINT ["/usr/bin/caddy"]

CMD [ \
	"run", \
	"--adapter", "caddyfile", \
	"--config", "/etc/caddy/caddyfile" \
]
