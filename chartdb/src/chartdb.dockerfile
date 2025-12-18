# This is free and unencumbered software released into the public domain.

FROM ghcr.io/chartdb/chartdb:1.19.0 AS chartdb

FROM docker.io/caddy:2.10.2 AS caddy
RUN chmod ugo=rx /usr/bin/caddy

FROM docker.io/alpine:3.23.2 AS headcheck
RUN wget https://pixelatedlabs.com/headcheck/releases/latest/linux_x64.zip
RUN unzip /linux_x64.zip

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
