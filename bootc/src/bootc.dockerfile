# This is free and unencumbered software released into the public domain.

FROM quay.io/fedora/fedora-bootc:44@sha256:3ec61e9a639d6e336f472987375c03eb476c4bdd68a63ed09a9d5cf8b7e76ba7
SHELL ["/bin/bash", "-c"]
HEALTHCHECK CMD ["/bin/true"]
RUN --mount=target=/git set -euo pipefail && \
	for file in /git/bootc/src/*.sh; do bash "$file" || exit; done && \
	rm --recursive /var/cache/* && \
	rm --recursive /var/log/* && \
	bootc container lint
