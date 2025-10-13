# This is free and unencumbered software released into the public domain.

# FROM docker.io/gitea/gitea:1.24.6-rootless
# ENV GITEA_I_AM_BEING_UNSAFE_RUNNING_AS_ROOT=true
# # hadolint ignore=DL3002
# USER root

# FROM docker.io/alpine:3.22.2
# RUN apk --no-cache add autoconf build-base git
# RUN git clone https://github.com/git/git
# WORKDIR /git
# RUN git checkout v2.51.0
# RUN make configure


# NO_REGEX=NeedsStartEnd
# RUN ./configure prefix=/bin





FROM docker.io/gitea/gitea:1.24.6-rootless AS gitea

FROM docker.io/alpine/git:2.49.1 AS gitv

FROM docker.io/debian:13.1 AS bash
RUN apt update
RUN apt --yes install bash-static

FROM docker.io/debian:13.1 AS git
# ENV CFLAGS=-static
ENV export NO_OPENSSL=1
ENV export NO_CURL=1
ENV export CFLAGS="${CFLAGS} -static"
ARG export NO_OPENSSL=1
ARG export NO_CURL=1
ARG export CFLAGS="${CFLAGS} -static"
RUN apt update
RUN apt --yes install autoconf build-essential gettext git libcurl4-openssl-dev libexpat1-dev libssl-dev tcl libzstd-dev zlib1g-dev zstd
RUN git clone https://github.com/git/git --branch v2.51.0 --depth 1
WORKDIR /git
RUN make configure
RUN ./configure prefix=/git/out CFLAGS="${CFLAGS} -static"
RUN make
RUN apt --yes install wget
RUN wget -O gitea https://dl.gitea.com/gitea/1.24.6/gitea-1.24.6-linux-amd64
RUN chmod +x gitea

# Pattern is required to copy symbolic links to the new image
# https://stackoverflow.com/a/66823636
RUN mkdir /tmp/cp
# RUN cp -a /usr/bin/exec /tmp/cp/exec
RUN cp -a /usr/bin/git-receive-pack /tmp/cp/git-receive-pack
# RUN cp -a /usr/bin/git-upload-archive /tmp/cp/git-upload-archive
RUN cp -a /usr/bin/git-upload-pack /tmp/cp/git-upload-pack

FROM docker.io/debian:13.1 AS gitd
RUN apt update
RUN apt --yes install git

FROM scratch
ENV GITEA_I_AM_BEING_UNSAFE_RUNNING_AS_ROOT=true
ENV HOME=/root
ENV USER=root
# for ldd for testing
# RUN apk add build-base bash
COPY --from=git /git/git /usr/bin/git
# COPY --from=git /git/git-upload-pack /usr/bin/git-upload-pack
ENTRYPOINT ["/app/gitea/gitea"]
COPY --from=bash /usr/bin/bash-static /usr/bin/bash
COPY --from=git /git/gitea /app/gitea/gitea
COPY --from=git /tmp/cp/ /usr/bin/
COPY --from=gitd /usr/share/git-core/templates/ /usr/share/git-core/templates/
COPY --from=gitd /usr/share/git-core/templates/ /git/out/share/git-core/templates

# make -j "$(nproc)" CFLAGS="-static"
