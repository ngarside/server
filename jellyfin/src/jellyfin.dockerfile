# This is free and unencumbered software released into the public domain.

FROM ghcr.io/jellyfin/jellyfin:10.11.9@sha256:ef4d95143a5475d1ba4d9a6983342cac300044d676a30648b7d0e0688961712a
HEALTHCHECK CMD ["/usr/bin/curl", "http://0.0.0.0:8096/health"]
