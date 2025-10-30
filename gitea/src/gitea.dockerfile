# This is free and unencumbered software released into the public domain.

# This file downloads the Gitea release as it is statically compiled, whereas
# the Docker release is dynamically compiled. The Docker image is still
# referenced to support automated dependency updates.

# Files are sometimes copied to a '/tmp/cp' folder to preserve symlinks
# when copying between stages.
# https://stackoverflow.com/a/66823636

FROM docker.io/gitea/gitea:1.25.0 AS gitea
SHELL ["/bin/ash", "-euo", "pipefail", "-c"]
RUN gitea --version | grep -o "[0-9.]*" | { head -n 1; cat >/dev/null; } >> /version
RUN wget -O gitea "https://dl.gitea.com/gitea/$(cat /version)/gitea-$(cat /version)-linux-amd64"
RUN chmod +x gitea

FROM docker.io/alpine:3.22.2 AS busybox2
RUN apk --no-cache add alpine-sdk linux-headers
RUN wget -O busybox.tar.gz https://github.com/mirror/busybox/archive/refs/tags/1_36_1.tar.gz
RUN tar -xvzf busybox.tar.gz
WORKDIR /busybox-1_36_1
RUN make defconfig
RUN sed -i 's/^CONFIG_BASH_IS_NONE=y$/# CONFIG_BASH_IS_NONE is not set/' .config
RUN sed -i 's/^CONFIG_FEATURE_TC_INGRESS=y/# CONFIG_FEATURE_TC_INGRESS is not set/' .config
RUN sed -i 's/^CONFIG_TC=y$/# CONFIG_TC is not set/' .config
RUN sed -i 's/^# CONFIG_BASH_IS_ASH is not set.*$/CONFIG_BASH_IS_ASH=y/' .config
RUN sed -i 's/^# CONFIG_STATIC is not set.*$/CONFIG_STATIC=y/' .config
RUN make -j "$(nproc)"

FROM docker.io/busybox:1.37.0-musl AS busybox
RUN mkdir /tmp/cp
RUN find /bin ! -name busybox -exec sh -c 'ln -s /usr/bin/busybox "/tmp/cp/$(basename $1)"' shell {} \;
RUN ln -s /usr/bin/busybox /tmp/cp/bash

FROM docker.io/alpine/git:2.49.1 AS git
SHELL ["/bin/ash", "-euo", "pipefail", "-c"]
RUN git version | grep -o "[0-9.]*" >> /version

FROM docker.io/alpine:3.22.2 AS headcheck
RUN wget https://pixelatedlabs.com/headcheck/releases/latest/linux_x64.zip
RUN unzip /linux_x64.zip

FROM docker.io/alpine:3.22.2 AS local
COPY gitea/src/configuration.sh /usr/bin/configuration
COPY gitea/src/entrypoint.sh /usr/bin/entrypoint
RUN chmod +x /usr/bin/configuration
RUN chmod +x /usr/bin/entrypoint

# FROM docker.io/debian:13.1 AS build
# COPY --from=git /version /version
# ENV NO_OPENSSL=1
# RUN apt-get update
# RUN apt-get --no-install-recommends --yes install autoconf build-essential ca-certificates gettext \
# 	git libcurl4-openssl-dev libexpat1-dev libssl-dev tcl libzstd-dev zlib1g-dev zstd
# RUN git clone https://github.com/git/git --branch "v$(cat /version)" --depth 1
# WORKDIR /git
# RUN make configure
# RUN ./configure CFLAGS=-static
# RUN make
# RUN mkdir /tmp/cp
# RUN ln --symbolic /usr/bin/git /tmp/cp/git-receive-pack
# RUN ln --symbolic /usr/bin/git /tmp/cp/git-upload-archive
# RUN ln --symbolic /usr/bin/git /tmp/cp/git-upload-pack

FROM scratch
SHELL ["/usr/bin/bash", "-euo", "pipefail", "-c"]
# COPY --from=build /git/git /usr/bin/git
# COPY --from=build /tmp/cp/ /usr/bin/
COPY --from=busybox2 /busybox-1_36_1/busybox /usr/bin/busybox
COPY --from=busybox /tmp/cp/ /usr/bin/
COPY --from=gitea /gitea /usr/bin/gitea
COPY --from=local /usr/bin/configuration /usr/bin/configuration
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
