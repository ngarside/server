# This is free and unencumbered software released into the public domain.

FROM quay.io/fedora/fedora-bootc:43@sha256:49415a5a0bb48f858e22884b16e79c6b93a4ee8ff644c41a8d52b786f9aa0299
SHELL ["/bin/bash", "-c"]
RUN --mount=target=/git set -euo pipefail && \
	for file in /git/bootc/src/*.sh; do bash "$file" || exit; done && \
	rm --recursive /var/cache/* && \
	rm --recursive /var/log/* && \
	bootc container lint
