# This is free and unencumbered software released into the public domain.

# This file downloads the Gitea release as it is statically compiled, whereas
# the Docker release is dynamically compiled. The Docker image is still
# referenced to support automated dependency updates.
# https://github.com/opencloud-eu/opencloud/tree/main/services/thumbnails

FROM docker.io/gitea/gitea:1.24.6-rootless AS gitea
RUN gitea --version | grep -o "[0-9.]*" | head -n 1 >> /version
RUN wget -O gitea "https://dl.gitea.com/gitea/$(cat /version)/gitea-$(cat /version)-linux-amd64"
RUN chmod +x gitea

FROM docker.io/debian:13.1 AS bash
RUN apt update
RUN apt --yes install bash-static

FROM docker.io/alpine/git:2.49.1 AS git
RUN git version | grep -o "[0-9.]*" >> /version

FROM docker.io/alpine:3.22.2 AS headcheck
RUN wget https://pixelatedlabs.com/headcheck/releases/latest/linux_x64.zip
RUN unzip /linux_x64.zip

FROM docker.io/debian:13.1 AS build
COPY --from=git /version /version
ENV export NO_OPENSSL=1
ENV export NO_CURL=1
ENV export CFLAGS="${CFLAGS} -static"
RUN apt update
RUN apt --yes install autoconf build-essential gettext git libcurl4-openssl-dev libexpat1-dev libssl-dev tcl libzstd-dev zlib1g-dev zstd
RUN git clone https://github.com/git/git --branch "v$(cat /version)" --depth 1
WORKDIR /git
RUN make configure
RUN ./configure prefix=/git/out CFLAGS="${CFLAGS} -static"
RUN make

# Pattern is required to copy symbolic links to the new image
# https://stackoverflow.com/a/66823636
RUN mkdir /tmp/cp
# RUN cp -a /usr/bin/exec /tmp/cp/exec
RUN cp -a /usr/bin/git-receive-pack /tmp/cp/git-receive-pack
# RUN cp -a /usr/bin/git-upload-archive /tmp/cp/git-upload-archive
RUN cp -a /usr/bin/git-upload-pack /tmp/cp/git-upload-pack

FROM scratch
ENV GITEA_I_AM_BEING_UNSAFE_RUNNING_AS_ROOT=true
ENV HOME=/root
ENV USER=root
COPY --from=build /git/git /usr/bin/git
ENTRYPOINT ["/app/gitea/gitea"]
COPY --from=bash /usr/bin/bash-static /usr/bin/bash
COPY --from=build /git/gitea /app/gitea/gitea
COPY --from=build /tmp/cp/ /usr/bin/
COPY --from=git /usr/share/git-core/templates/ /usr/share/git-core/templates/
COPY --from=git /usr/share/git-core/templates/ /git/out/share/git-core/templates
