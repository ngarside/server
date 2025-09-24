# This is free and unencumbered software released into the public domain.

FROM quay.io/fedora/fedora-bootc:43

SHELL ["/bin/bash", "-c"]

RUN --mount=target=/git set -euo pipefail && \
	for file in /git/bootc/src/*.sh; do bash "$file" || exit; done

RUN bootc container lint
