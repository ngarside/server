# This is free and unencumbered software released into the public domain.

FROM docker.io/caddy:2.11.3-builder-alpine@sha256:7d2315853f99b425d0daa6bcad826e8b0d65b4af1f70fcaeb6b152157d81771d AS caddy
RUN xcaddy build --with github.com/hslatman/caddy-crowdsec-bouncer/http
RUN chmod ugo=rx /usr/bin/caddy

FROM docker.io/alpine:3.23.4@sha256:5b10f432ef3da1b8d4c7eb6c487f2f5a8f096bc91145e68878dd4a5019afde11 AS headcheck
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
