# This is free and unencumbered software released into the public domain.

FROM docker.io/caddy:2.11.2-builder-alpine@sha256:ff7dd52d7a2b46429367617bbde8812b5e7c567139a0d713607e6122d9dc62c4 AS caddy
RUN xcaddy build \
	--with github.com/caddy-dns/cloudflare \
	--with github.com/hslatman/caddy-crowdsec-bouncer/http
RUN chmod ugo=rx /usr/bin/caddy

FROM docker.io/alpine:3.23.3@sha256:25109184c71bdad752c8312a8623239686a9a2071e8825f20acb8f2198c3f659 AS headcheck
RUN wget https://pixelatedlabs.com/headcheck/releases/latest/linux-x64.zip
RUN unzip /linux-x64.zip

FROM scratch
COPY --from=caddy /usr/bin/caddy /usr/bin/caddy
COPY --from=headcheck /headcheck /usr/bin/headcheck
EXPOSE 80
WORKDIR /opt/caddy
ENTRYPOINT ["/usr/bin/caddy"]
HEALTHCHECK CMD ["/usr/bin/headcheck", "http://0.0.0.0/reverse_proxy/upstreams"]
CMD [ \
	"run", \
	"--adapter", "caddyfile", \
	"--config", "/etc/caddy/caddyfile" \
]
