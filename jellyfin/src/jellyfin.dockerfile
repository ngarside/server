# This is free and unencumbered software released into the public domain.

FROM ghcr.io/jellyfin/jellyfin:10.11.10@sha256:6497f0245de93fac642926c065b427362ca5e626e659f690516599c8c3817a38
HEALTHCHECK CMD ["/usr/bin/curl", "http://0.0.0.0:8096/health"]
