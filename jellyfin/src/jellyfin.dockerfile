# This is free and unencumbered software released into the public domain.

FROM ghcr.io/jellyfin/jellyfin:10.11.6
HEALTHCHECK CMD ["/usr/bin/curl", "http://0.0.0.0:8096/health"]
