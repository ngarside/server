# This is free and unencumbered software released into the public domain.
# Excalidraw is rolling release, meaning that it doesn't have versioned images.

FROM docker.io/excalidraw/excalidraw:latest@sha256:95d528cb4f8d18e0fbdc42ae3d09b5c4a899bfbd6bb89eeaf94b904330d79714 AS excalidraw

FROM docker.io/caddy:2.10.2 AS caddy
RUN chmod ugo=rx /usr/bin/caddy

FROM docker.io/alpine:3.23.0 AS headcheck
RUN wget https://pixelatedlabs.com/headcheck/releases/latest/linux_x64.zip
RUN unzip /linux_x64.zip

FROM scratch
COPY --from=caddy /usr/bin/caddy /usr/bin/caddy
COPY --from=excalidraw /usr/share/nginx/html /usr/share/excalidraw
COPY --from=headcheck /headcheck /usr/bin/headcheck
EXPOSE 80
WORKDIR /usr/share/excalidraw
ENTRYPOINT ["/usr/bin/caddy"]
HEALTHCHECK CMD ["/usr/bin/headcheck", "http://0.0.0.0"]
CMD ["file-server"]
