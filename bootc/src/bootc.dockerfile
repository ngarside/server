# This is free and unencumbered software released into the public domain.

FROM quay.io/fedora/fedora-bootc:43@\
sha256:9ac597ccef7ba44ac92aefe39abee86b21d8674c23a4aaf6674525e57784a831
SHELL ["/bin/bash", "-c"]
RUN --mount=target=/git set -euo pipefail && \
	for file in /git/bootc/src/*.sh; do bash "$file" || exit; done && \
	bootc container lint
