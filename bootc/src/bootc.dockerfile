# This is free and unencumbered software released into the public domain.

FROM quay.io/fedora/fedora-bootc:43@sha256:7a3e3a86a9855b98eda7f9c905ee569d9087b95c6ae782dfb95ad6af9e6f800b
SHELL ["/bin/bash", "-c"]
RUN --mount=target=/git set -euo pipefail && \
	for file in /git/bootc/src/*.sh; do bash "$file" || exit; done && \
	rm --recursive /var/cache/* && \
	rm --recursive /var/log/* && \
	bootc container lint
