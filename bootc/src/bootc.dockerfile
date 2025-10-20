# This is free and unencumbered software released into the public domain.

FROM quay.io/fedora/fedora-bootc:43@\
sha256:a810702c9a16e5eb493d173d2a534963c73e4a58595cc9b29d1d035739cc8211 AS bootc
SHELL ["/bin/bash", "-c"]
RUN --mount=target=/git set -euo pipefail && \
	for file in /git/bootc/src/*.sh; do bash "$file" || exit; done && \
	bootc container lint
