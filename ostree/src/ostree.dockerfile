# This is free and unencumbered software released into the public domain.

FROM quay.io/fedora/fedora-bootc:stable@sha256:c70df617b90492358a8d0d62bd110c2bcb9cbc6115c253d53741b23102d7edcb

RUN --mount=target=/tmp/git for file in /tmp/git/ostree/src/*.sh; do bash "$file"; done && \
	ostree container commit
