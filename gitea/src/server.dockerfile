# This is free and unencumbered software released into the public domain.

# This file downloads the Gitea release as it is statically compiled, whereas
# the Docker release is dynamically compiled. The Docker image is still
# referenced to support automated dependency updates.

# Files are sometimes copied to a '/tmp/cp' folder to preserve symlinks
# when copying between stages.
# https://stackoverflow.com/a/66823636

FROM docker.io/gitea/gitea:1.26.2@sha256:7d13848af12645600a5f9d93ee2560daa9c6fa6b5b859b7bff3a5e1c0b661031 AS gitea
SHELL ["/bin/ash", "-euo", "pipefail", "-c"]
RUN gitea --version | grep -o "[0-9.]*" | { head -n 1; cat >/dev/null; } > /version

FROM golang:1.26.4-alpine@sha256:3ad57304ad93bbec8548a0437ad9e06a455660655d9af011d58b993f6f615648 as gitea-build
COPY --from=gitea /version /version
RUN apk --no-cache add build-base git pnpm
RUN git clone https://github.com/go-gitea/gitea --branch "v$(cat /version)" --depth 1
WORKDIR /go/gitea
COPY /gitea/src/server.patch /tmp/server.patch
RUN patch modules/setting/server.go < /tmp/server.patch
RUN LDFLAGS='-extldflags -static' TAGS='bindata sqlite sqlite_unlock_notify' make build -j "$(nproc)"
RUN strip /go/gitea/gitea

FROM docker.io/alpine:3.24.1@sha256:28bd5fe8b56d1bd048e5babf5b10710ebe0bae67db86916198a6eec434943f8b AS busybox
SHELL ["/bin/ash", "-euo", "pipefail", "-c"]
RUN apk --no-cache add alpine-sdk grep linux-headers
RUN busybox | { head -n 1; cat >/dev/null; } | grep -oP '(?<=v)[\d\.]+' | sed 's/\./_/g' > /version
RUN git clone https://git.busybox.net/busybox --branch "$(cat /version)" --depth 1
WORKDIR /busybox
RUN make defconfig
RUN sed -i 's/^CONFIG_BASH_IS_NONE=y$/# CONFIG_BASH_IS_NONE is not set/' .config
RUN sed -i 's/^CONFIG_FEATURE_TC_INGRESS=y/# CONFIG_FEATURE_TC_INGRESS is not set/' .config
RUN sed -i 's/^CONFIG_TC=y$/# CONFIG_TC is not set/' .config
RUN sed -i 's/^# CONFIG_BASH_IS_ASH is not set.*$/CONFIG_BASH_IS_ASH=y/' .config
RUN sed -i 's/^# CONFIG_STATIC is not set.*$/CONFIG_STATIC=y/' .config
RUN make -j "$(nproc)"
RUN mkdir /tmp/cp
RUN cp /busybox/busybox /usr/bin/busybox
RUN /usr/bin/busybox --install -s /tmp/cp

FROM docker.io/alpine/git:v2.54.0@sha256:113d99116e236f93f0b1f53cd46dbda662cf1136d20dc9ae2834962226654d9f AS git
SHELL ["/bin/ash", "-euo", "pipefail", "-c"]
RUN git version | grep -o "[0-9.]*" > /version

FROM docker.io/alpine:3.24.1@sha256:28bd5fe8b56d1bd048e5babf5b10710ebe0bae67db86916198a6eec434943f8b AS headcheck
RUN wget https://github.com/pixelatedlabs/headcheck/releases/download/3.0.0/linux-x64.zip
RUN unzip /linux-x64.zip

FROM docker.io/alpine:3.24.1@sha256:28bd5fe8b56d1bd048e5babf5b10710ebe0bae67db86916198a6eec434943f8b AS local
COPY gitea/src/server.sh /usr/bin/entrypoint
COPY gitea/src/server.ini /etc/gitea/gitea.ini
RUN chmod +x /usr/bin/entrypoint

FROM docker.io/alpine:3.24.1@sha256:28bd5fe8b56d1bd048e5babf5b10710ebe0bae67db86916198a6eec434943f8b AS git-build
COPY --from=git /version /version
RUN apk --no-cache add alpine-sdk autoconf tcl-dev zlib-dev zlib-static
RUN git clone https://github.com/git/git --branch "v$(cat /version)" --depth 1
WORKDIR /git
RUN make configure
RUN ./configure CFLAGS=-static
RUN MAKEFLAGS="-j $(nproc)" make
RUN mkdir /tmp/cp
RUN ln -s /usr/bin/git /tmp/cp/git-receive-pack
RUN ln -s /usr/bin/git /tmp/cp/git-upload-archive
RUN ln -s /usr/bin/git /tmp/cp/git-upload-pack

FROM scratch
SHELL ["/usr/bin/bash", "-euo", "pipefail", "-c"]
COPY --from=git-build /git/git /usr/bin/git
COPY --from=git-build /tmp/cp/ /usr/bin/
COPY --from=headcheck /headcheck /usr/bin/headcheck
COPY --from=busybox /usr/bin/busybox /usr/bin/busybox
COPY --from=busybox /tmp/cp/ /usr/bin/
COPY --from=gitea-build /go/gitea/gitea /usr/bin/gitea
COPY --from=local /usr/bin/entrypoint /usr/bin/entrypoint
COPY --from=local /etc/gitea/gitea.ini /etc/gitea/gitea.ini
ENTRYPOINT ["/usr/bin/entrypoint"]
ENV GITEA_CUSTOM=/var/lib/gitea/custom
ENV GITEA_I_AM_BEING_UNSAFE_RUNNING_AS_ROOT=true
ENV GITEA_TEMP=/tmp/gitea
ENV GITEA_WORK_DIR=/var/lib/gitea
ENV HOME=/var/lib/gitea/git
ENV TMPDIR=/tmp/gitea
ENV USER=root
HEALTHCHECK CMD ["/usr/bin/headcheck", "http://0.0.0.0/api/healthz"]
RUN ln -s /usr/bin /bin
