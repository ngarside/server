# This is free and unencumbered software released into the public domain.

FROM docker.io/caddy:2.10.2-builder-alpine AS caddy
RUN xcaddy build --with github.com/caddy-dns/cloudflare
RUN chmod ugo=rx /usr/bin/caddy

FROM docker.io/library/alpine:latest AS headcheck
RUN wget --progress=dot:giga https://pixelatedlabs.com/headcheck/releases/latest/linux_x64.zip
RUN unzip /linux_x64.zip

FROM scratch
COPY --from=caddy /usr/bin/caddy /usr/bin/caddy
COPY --from=headcheck /headcheck /usr/bin/headcheck
EXPOSE 80
WORKDIR /opt/caddy
ENTRYPOINT ["/usr/bin/caddy"]
HEALTHCHECK CMD ["/usr/bin/headcheck"]
CMD [ \
	"run", \
	"--adapter", "caddyfile", \
	"--config", "/etc/caddy/caddyfile" \
]
