# This is free and unencumbered software released into the public domain.

FROM quay.io/fedora/fedora-bootc:43@sha256:f271f7181c45316ee54dcb1eb761e94783b607a7f39f8b33fe6f4d4bf9819291
SHELL ["/bin/bash", "-c"]
RUN --mount=target=/git set -euo pipefail && \
	for file in /git/bootc/src/*.sh; do bash "$file" || exit; done && \
	rm --recursive /var/cache/* && \
	rm --recursive /var/log/* && \
	bootc container lint
