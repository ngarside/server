# This is free and unencumbered software released into the public domain.

FROM quay.io/fedora/fedora-coreos:stable@sha256:67c9125048afe7168a7da7353ee4c15bca8bd1220bfcde4a54bfaf086badba35

SHELL ["/bin/bash", "-c"]

RUN --mount=target=/tmp/git for file in /tmp/git/ostree/src/*.sh; do bash "$file"; done && \
	ostree container commit
