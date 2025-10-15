# This is free and unencumbered software released into the public domain.

FROM docker.io/cloudflare/cloudflared:2025.10.0 AS cloudflared

FROM docker.io/alpine:3.22.1 AS headcheck
RUN wget https://pixelatedlabs.com/headcheck/releases/latest/linux_x64.zip
RUN unzip /linux_x64.zip

FROM scratch
COPY --from=headcheck /headcheck /usr/bin/headcheck
COPY --from=cloudflared /usr/local/bin/cloudflared /usr/bin/cloudflared
ENTRYPOINT ["/usr/bin/cloudflared", "--no-autoupdate"]
EXPOSE 80
HEALTHCHECK CMD ["/usr/bin/headcheck", "http://0.0.0.0"]
