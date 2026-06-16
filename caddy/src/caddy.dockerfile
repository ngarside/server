# This is free and unencumbered software released into the public domain.

FROM docker.io/caddy:2.11.4-builder-alpine@sha256:0ff10d4b83af453e5526b1c3cd7ae43396832aa8a2a55311d624f6812b33767d AS caddy
RUN xcaddy build \
	--with github.com/caddy-dns/cloudflare \
	--with github.com/hslatman/caddy-crowdsec-bouncer/http
RUN chmod ugo=rx /usr/bin/caddy

FROM docker.io/alpine:3.24.1@sha256:bec4ccd3817e7c824eb0388971a0b83fab111d586285511ba0266b77e8dc65a9 AS headcheck
RUN wget https://github.com/pixelatedlabs/headcheck/releases/download/3.0.0/linux-x64.zip
RUN unzip /linux-x64.zip

FROM scratch
COPY --from=caddy /usr/bin/caddy /usr/bin/caddy
COPY --from=headcheck /headcheck /usr/bin/headcheck
EXPOSE 80
WORKDIR /opt/caddy
ENTRYPOINT ["/usr/bin/caddy"]
ENV HOME=/var/lib/caddy
HEALTHCHECK CMD ["/usr/bin/headcheck", "http://0.0.0.0/reverse_proxy/upstreams"]
CMD [ \
	"run", \
	"--adapter", "caddyfile", \
	"--config", "/etc/caddy/caddyfile" \
]
