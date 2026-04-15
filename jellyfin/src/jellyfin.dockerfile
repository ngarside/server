# This is free and unencumbered software released into the public domain.

FROM ghcr.io/jellyfin/jellyfin:10.11.8@sha256:93227545077893cc9516f28b3adb733b67bc4691f41b6167428a2a0e3220b81c
HEALTHCHECK CMD ["/usr/bin/curl", "http://0.0.0.0:8096/health"]
