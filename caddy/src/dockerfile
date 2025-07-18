# This is free and unencumbered software released into the public domain.

FROM docker.io/caddy:latest@sha256:e23538fceb12f3f8cc97a174844aa99bdea7715023d6e088028850fd0601e2e2 AS build

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
