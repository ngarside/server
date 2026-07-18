# This is free and unencumbered software released into the public domain.

FROM ghcr.io/jellyfin/jellyfin:10.11.11@sha256:45f648c382a0c8b552582fcea40e95cb17c5d475473a891cba0eb7523fb92112
HEALTHCHECK CMD ["/usr/bin/curl", "http://0.0.0.0:8096/health"]
