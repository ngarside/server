# This is free and unencumbered software released into the public domain.

# This file downloads the Gitea release as it is statically compiled, whereas
# the Docker release is dynamically compiled. The Docker image is still
# referenced to support automated dependency updates.

# Files are sometimes copied to a '/tmp/cp' folder to preserve symlinks
# when copying between stages.
# https://stackoverflow.com/a/66823636

FROM docker.io/gitea/gitea:1.25.5@sha256:f846d26a4fc389c5806a580a765e00bfdd1fd181e6f2060da98ea2669d914472 AS gitea
SHELL ["/bin/ash", "-euo", "pipefail", "-c"]
RUN gitea --version | grep -o "[0-9.]*" | { head -n 1; cat >/dev/null; } > /version

FROM golang:1.26.2-alpine@sha256:27f829349da645e287cb195a9921c106fc224eeebbdc33aeb0f4fca2382befa6 as gitea-build
COPY --from=gitea /version /version
RUN apk --no-cache add build-base git pnpm
RUN git clone https://github.com/go-gitea/gitea --branch "v$(cat /version)" --depth 1
WORKDIR /go/gitea
COPY /gitea/src/server.patch /tmp/server.patch
RUN patch modules/setting/server.go < /tmp/server.patch
RUN LDFLAGS='-extldflags -static' TAGS='bindata sqlite sqlite_unlock_notify' make build -j "$(nproc)"
RUN strip /go/gitea/gitea

FROM docker.io/alpine:3.23.4@sha256:5b10f432ef3da1b8d4c7eb6c487f2f5a8f096bc91145e68878dd4a5019afde11 AS busybox
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

FROM docker.io/alpine/git:2.52.0@sha256:d453f54c83320412aa89c391b076930bd8569bc1012285e8c68ce2d4435826a3 AS git
SHELL ["/bin/ash", "-euo", "pipefail", "-c"]
RUN git version | grep -o "[0-9.]*" > /version

FROM docker.io/alpine:3.23.4@sha256:5b10f432ef3da1b8d4c7eb6c487f2f5a8f096bc91145e68878dd4a5019afde11 AS headcheck
RUN wget https://pixelatedlabs.com/headcheck/releases/latest/linux-x64.zip
RUN unzip /linux-x64.zip

FROM docker.io/alpine:3.23.4@sha256:5b10f432ef3da1b8d4c7eb6c487f2f5a8f096bc91145e68878dd4a5019afde11 AS local
COPY gitea/src/server.sh /usr/bin/entrypoint
RUN chmod +x /usr/bin/entrypoint

FROM docker.io/alpine:3.23.4@sha256:5b10f432ef3da1b8d4c7eb6c487f2f5a8f096bc91145e68878dd4a5019afde11 AS git-build
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
COPY --from=busybox /usr/bin/busybox /usr/bin/busybox
COPY --from=busybox /tmp/cp/ /usr/bin/
COPY --from=gitea-build /go/gitea/gitea /usr/bin/gitea
COPY --from=local /usr/bin/entrypoint /usr/bin/entrypoint
ENTRYPOINT ["/usr/bin/entrypoint"]
ENV GITEA_CUSTOM=/var/lib/gitea/custom
ENV GITEA_I_AM_BEING_UNSAFE_RUNNING_AS_ROOT=true
ENV GITEA_TEMP=/tmp/gitea
ENV GITEA_WORK_DIR=/var/lib/gitea
ENV HOME=/var/lib/gitea/git
ENV TMPDIR=/tmp/gitea
ENV USER=root
RUN ln -s /usr/bin /bin
