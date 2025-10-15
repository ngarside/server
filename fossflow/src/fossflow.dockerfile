# This is free and unencumbered software released into the public domain.

FROM docker.io/stnsmith/fossflow:latest@sha256:1797c358ed45c07f4df7e98f5753fa53c17bfa0d7d1c9fbc1c296710f4ee2589 AS fossflow

FROM docker.io/caddy:2.10.2 AS caddy
RUN chmod ugo=rx /usr/bin/caddy

FROM docker.io/alpine:3.22.2 AS headcheck
RUN wget https://pixelatedlabs.com/headcheck/releases/latest/linux_x64.zip
RUN unzip /linux_x64.zip

FROM scratch
COPY --from=caddy /usr/bin/caddy /usr/bin/caddy
COPY --from=fossflow /usr/share/nginx/html /srv
COPY --from=headcheck /headcheck /usr/bin/headcheck
EXPOSE 80
WORKDIR /srv
ENTRYPOINT ["/usr/bin/caddy"]
HEALTHCHECK CMD ["/usr/bin/headcheck", "http://0.0.0.0"]
CMD ["file-server"]
