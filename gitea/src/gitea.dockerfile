# This is free and unencumbered software released into the public domain.

# This file downloads the Gitea release as it is statically compiled, whereas
# the Docker release is dynamically compiled. The Docker image is still
# referenced to support automated dependency updates.

# Files are sometimes copied to a '/tmp/cp' folder to preserve symlinks
# when copying between stages.
# https://stackoverflow.com/a/66823636

FROM docker.io/gitea/gitea:1.24.6 AS gitea
SHELL ["/bin/ash", "-c"]
RUN gitea --version | grep -o "[0-9.]*" | head -n 1 >> /version
RUN wget -O gitea "https://dl.gitea.com/gitea/$(cat /version)/gitea-$(cat /version)-linux-amd64"
RUN chmod +x gitea

FROM docker.io/debian:13.1 AS bash
RUN apt-get update
RUN apt-get --no-install-recommends --yes install bash-static

FROM docker.io/busybox:1.37.0-musl AS busybox
RUN mkdir /tmp/cp
RUN find /bin ! -name busybox -exec sh -c 'ln -s /usr/bin/busybox "/tmp/cp/$(basename {})"' \;

FROM docker.io/alpine/git:2.49.1 AS git
SHELL ["/bin/ash", "-c"]
RUN git version | grep -o "[0-9.]*" >> /version

FROM docker.io/alpine:3.22.2 AS headcheck
RUN wget https://pixelatedlabs.com/headcheck/releases/latest/linux_x64.zip
RUN unzip /linux_x64.zip

FROM docker.io/alpine:3.22.2 AS local
COPY gitea/src/configuration.sh /usr/bin/configuration
COPY gitea/src/entrypoint.sh /usr/bin/entrypoint
RUN chmod +x /usr/bin/configuration
RUN chmod +x /usr/bin/entrypoint

FROM docker.io/debian:13.1 AS build
COPY --from=git /version /version
ENV NO_OPENSSL=1
RUN apt-get update
RUN apt-get --no-install-recommends --yes install autoconf build-essential ca-certificates gettext git libcurl4-openssl-dev libexpat1-dev libssl-dev tcl libzstd-dev zlib1g-dev zstd
RUN git clone https://github.com/git/git --branch "v$(cat /version)" --depth 1
WORKDIR /git
RUN make configure
RUN ./configure CFLAGS=-static
RUN make
RUN mkdir /tmp/cp
RUN ln --symbolic /usr/bin/git /tmp/cp/git-receive-pack
RUN ln --symbolic /usr/bin/git /tmp/cp/git-upload-archive
RUN ln --symbolic /usr/bin/git /tmp/cp/git-upload-pack

FROM scratch
SHELL ["/usr/bin/bash", "-euo", "pipefail", "-c"]
COPY --from=bash /usr/bin/bash-static /usr/bin/bash
COPY --from=build /git/git /usr/bin/git
COPY --from=build /tmp/cp/ /usr/bin/
COPY --from=busybox /bin/busybox /usr/bin/busybox
COPY --from=busybox /tmp/cp/ /usr/bin/
COPY --from=gitea /gitea /usr/bin/gitea
COPY --from=local /usr/bin/configuration /usr/bin/configuration
COPY --from=local /usr/bin/entrypoint /usr/bin/entrypoint
ENTRYPOINT ["/usr/bin/entrypoint"]
ENV GITEA_I_AM_BEING_UNSAFE_RUNNING_AS_ROOT=true
ENV HOME=/root
ENV USER=root
RUN ln -s /usr/bin /bin
