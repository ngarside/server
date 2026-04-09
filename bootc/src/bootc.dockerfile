# This is free and unencumbered software released into the public domain.

FROM quay.io/fedora/fedora-bootc:43@sha256:48cdcca3dd6be39e1f077e714dc5a82d1f32af35bb63886b4895af87880f8e87
SHELL ["/bin/bash", "-c"]
HEALTHCHECK CMD ["/bin/true"]
RUN --mount=target=/git set -euo pipefail && \
	for file in /git/bootc/src/*.sh; do bash "$file" || exit; done && \
	rm --recursive /var/cache/* && \
	rm --recursive /var/log/* && \
	bootc container lint
