# This is free and unencumbered software released into the public domain.

FROM quay.io/fedora/fedora-bootc:44@sha256:1a17d180491130098b6881300ff3bbe74d37cc40968af4fbf3d5945a9779bb73
SHELL ["/bin/bash", "-c"]
HEALTHCHECK CMD ["/bin/true"]
RUN --mount=target=/git set -euo pipefail && \
	for file in /git/bootc/src/*.sh; do bash "$file" || exit; done && \
	rm --recursive /var/cache/* && \
	rm --recursive /var/log/* && \
	bootc container lint
