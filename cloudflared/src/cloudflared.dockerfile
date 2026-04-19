# This is free and unencumbered software released into the public domain.

FROM docker.io/cloudflare/cloudflared:2026.3.0@sha256:6b599ca3e974349ead3286d178da61d291961182ec3fe9c505e1dd02c8ac31b0 AS cloudflared

FROM scratch
COPY --chown=0 --from=cloudflared /usr/local/bin/cloudflared /usr/bin/cloudflared
ENTRYPOINT ["/usr/bin/cloudflared", "--no-autoupdate"]
