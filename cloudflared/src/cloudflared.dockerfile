# This is free and unencumbered software released into the public domain.

FROM docker.io/cloudflare/cloudflared:2026.1.1 AS cloudflared

FROM scratch
COPY --chown=0 --from=cloudflared /usr/local/bin/cloudflared /usr/bin/cloudflared
ENTRYPOINT ["/usr/bin/cloudflared", "--no-autoupdate"]
