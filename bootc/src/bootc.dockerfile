# This is free and unencumbered software released into the public domain.

FROM quay.io/fedora/fedora-bootc:44@sha256:f19ac7261bd034679b1431d49c9314df97d84fcd89042c4881e2199a0f092f58
SHELL ["/bin/bash", "-c"]
HEALTHCHECK CMD ["/bin/true"]
RUN --mount=target=/git set -euo pipefail && \
	for file in /git/bootc/src/*.sh; do bash "$file" || exit; done && \
	rm --recursive /var/cache/* && \
	rm --recursive /var/log/* && \
	bootc container lint
