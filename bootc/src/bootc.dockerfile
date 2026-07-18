# This is free and unencumbered software released into the public domain.

FROM quay.io/fedora/fedora-bootc:44@sha256:451ab491a197c41ba07277bad6a72f6d8458d4dd9fb189b242419031aa9ea840
SHELL ["/bin/bash", "-c"]
HEALTHCHECK CMD ["/bin/true"]
RUN --mount=target=/git set -euo pipefail && \
	for file in /git/bootc/src/*.sh; do bash "$file" || exit; done && \
	rm --recursive /var/cache/* && \
	rm --recursive /var/log/* && \
	bootc container lint
