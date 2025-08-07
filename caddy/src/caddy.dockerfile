# This is free and unencumbered software released into the public domain.

FROM docker.io/caddy:builder-alpine@sha256:cc6c40aa7cdea02ef9cb99f3c4e4664ecdb6066ae93ae52ed5288afc511e1241 AS build

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
