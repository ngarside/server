# This is free and unencumbered software released into the public domain.
# Excalidraw is rolling release, meaning that it doesn't have versioned images.

FROM docker.io/excalidraw/excalidraw:latest@sha256:f7ee194addd607bf831d2af0f0a34463dd4225e426cf35199ef0b12a803398e9 AS excalidraw

FROM docker.io/caddy:2.11.4@sha256:cfeb0b281bc44a5a51fecde39e9e577c60d863c0b6196e6bbdf58fd00960887f AS caddy
RUN chmod ugo=rx /usr/bin/caddy

FROM docker.io/alpine:3.23.4@sha256:5b10f432ef3da1b8d4c7eb6c487f2f5a8f096bc91145e68878dd4a5019afde11 AS headcheck
RUN wget https://github.com/pixelatedlabs/headcheck/releases/download/3.0.0/linux-x64.zip
RUN unzip /linux-x64.zip

FROM scratch
COPY --from=caddy /usr/bin/caddy /usr/bin/caddy
COPY --from=excalidraw /usr/share/nginx/html /usr/share/excalidraw
COPY --from=headcheck /headcheck /usr/bin/headcheck
EXPOSE 80
WORKDIR /usr/share/excalidraw
ENTRYPOINT ["/usr/bin/caddy"]
HEALTHCHECK CMD ["/usr/bin/headcheck", "http://0.0.0.0"]
CMD ["file-server"]
