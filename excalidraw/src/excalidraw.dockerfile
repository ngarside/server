# This is free and unencumbered software released into the public domain.
# Excalidraw is rolling release, meaning that it doesn't have versioned images.

FROM docker.io/excalidraw/excalidraw:latest@sha256:799a087c87c11fede93c7f56dd8953e34e6c7979ffa9cfa4716d46cc152f7c29 AS excalidraw

FROM docker.io/caddy:2.10.2 AS caddy
RUN chmod ugo=rx /usr/bin/caddy

FROM docker.io/alpine:3.22.2 AS headcheck
RUN wget https://pixelatedlabs.com/headcheck/releases/latest/linux_x64.zip
RUN unzip /linux_x64.zip

FROM scratch
COPY --from=caddy /usr/bin/caddy /usr/bin/caddy
COPY --from=excalidraw /usr/share/nginx/html /srv
COPY --from=headcheck /headcheck /usr/bin/headcheck
EXPOSE 80
WORKDIR /srv
ENTRYPOINT ["/usr/bin/caddy"]
HEALTHCHECK CMD ["/usr/bin/headcheck", "http://0.0.0.0"]
CMD ["file-server"]
