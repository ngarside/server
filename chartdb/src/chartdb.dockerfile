# This is free and unencumbered software released into the public domain.

FROM ghcr.io/chartdb/chartdb:1.20.1@sha256:9385f1a72174a2cdba27036127a98474a0c941c3c795dcc15149884c09834460 AS chartdb

FROM docker.io/caddy:2.11.2@sha256:25cdc846626b62d05f6b633b9b40c2c9f6ef89b515dc76133cefd920f7dbe562 AS caddy
RUN chmod ugo=rx /usr/bin/caddy

FROM docker.io/alpine:3.23.4@sha256:5b10f432ef3da1b8d4c7eb6c487f2f5a8f096bc91145e68878dd4a5019afde11 AS headcheck
RUN wget https://github.com/pixelatedlabs/headcheck/releases/download/2.0.0/linux-x64.zip
RUN unzip /linux-x64.zip

FROM scratch
COPY --from=caddy /usr/bin/caddy /usr/bin/caddy
COPY --from=chartdb /usr/share/nginx/html /usr/share/chartdb
COPY --from=headcheck /headcheck /usr/bin/headcheck
COPY /chartdb/src/config.js /usr/share/chartdb/config.js
EXPOSE 80
WORKDIR /usr/share/chartdb
ENTRYPOINT ["/usr/bin/caddy"]
HEALTHCHECK CMD ["/usr/bin/headcheck", "http://0.0.0.0"]
CMD ["file-server"]
