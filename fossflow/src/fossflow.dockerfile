# This is free and unencumbered software released into the public domain.

FROM docker.io/stnsmith/fossflow:latest@sha256:d1a64070f11d44dafb3bbc6f37316230b6b4f350f35266926da85dadfb74e5d3 AS fossflow

FROM docker.io/caddy:2.10.2 AS caddy
RUN chmod ugo=rx /usr/bin/caddy

FROM docker.io/alpine:3.22.2 AS headcheck
RUN wget https://pixelatedlabs.com/headcheck/releases/latest/linux_x64.zip
RUN unzip /linux_x64.zip

FROM scratch
COPY --from=caddy /usr/bin/caddy /usr/bin/caddy
COPY --from=fossflow /usr/share/nginx/html /usr/share/fossflow
COPY --from=headcheck /headcheck /usr/bin/headcheck
EXPOSE 80
WORKDIR /usr/share/fossflow
ENTRYPOINT ["/usr/bin/caddy"]
HEALTHCHECK CMD ["/usr/bin/headcheck", "http://0.0.0.0"]
CMD ["file-server"]
