# This is free and unencumbered software released into the public domain.

FROM quay.io/fedora/fedora-bootc:43@sha256:3a163c8ecd865539769d6c784a9dc482350a2397f47a26bab5f2cedbc4afb0b4
SHELL ["/bin/bash", "-c"]
RUN --mount=target=/git set -euo pipefail && \
	for file in /git/bootc/src/*.sh; do bash "$file" || exit; done && \
	rm --recursive /var/cache/* && \
	rm --recursive /var/log/* && \
	bootc container lint
