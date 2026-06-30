# This is free and unencumbered software released into the public domain.

FROM quay.io/fedora/fedora-bootc:44@sha256:614ed760484d8e7e58207d49f63843e60eb038f8b60595f087534056ae7c8802
SHELL ["/bin/bash", "-c"]
HEALTHCHECK CMD ["/bin/true"]
RUN --mount=target=/git set -euo pipefail && \
	for file in /git/bootc/src/*.sh; do bash "$file" || exit; done && \
	rm --recursive /var/cache/* && \
	rm --recursive /var/log/* && \
	bootc container lint
