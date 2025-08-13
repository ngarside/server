# This is free and unencumbered software released into the public domain.

FROM quay.io/fedora/fedora-bootc:42.20250718.0

SHELL ["/bin/bash", "-c"]

RUN --mount=target=/tmp/git set -euo pipefail && \
	for file in /tmp/git/ostree/src/*.sh; do bash "$file" || exit; done && \
	ostree container commit
