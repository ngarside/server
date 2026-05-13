# This is free and unencumbered software released into the public domain.

FROM docker.io/stnsmith/fossflow:latest@sha256:9709d727bf15c96b32860744ddeef3be693362bbea136574dc7685b61744298b AS fossflow

FROM docker.io/caddy:2.11.3@sha256:68d335223f05fadcc55ec3677521a2e61488949d30b5c7beeb3d0b2309efca1d AS caddy
RUN chmod ugo=rx /usr/bin/caddy

FROM docker.io/alpine:3.23.4@sha256:5b10f432ef3da1b8d4c7eb6c487f2f5a8f096bc91145e68878dd4a5019afde11 AS headcheck
RUN wget https://github.com/pixelatedlabs/headcheck/releases/download/3.0.0/linux-x64.zip
RUN unzip /linux-x64.zip

FROM scratch
COPY --from=caddy /usr/bin/caddy /usr/bin/caddy
COPY --from=fossflow /usr/share/nginx/html /usr/share/fossflow
COPY --from=headcheck /headcheck /usr/bin/headcheck
EXPOSE 80
WORKDIR /usr/share/fossflow
ENTRYPOINT ["/usr/bin/caddy"]
HEALTHCHECK CMD ["/usr/bin/headcheck", "http://0.0.0.0"]
CMD ["file-server"]
