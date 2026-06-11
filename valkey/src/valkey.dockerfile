# This is free and unencumbered software released into the public domain.

# This file was adapted under the LGPL-3.0 license
# https://github.com/ZoeyVid/valkey-static/blob/latest/Dockerfile
# https://github.com/ZoeyVid/valkey-static/blob/latest/COPYING

FROM docker.io/valkey/valkey:9.0.4@sha256:8436e10bc65c94886a91d4415b6a6dfa9cb5a306fb3b996e5bb67cd2b4854193 AS valkey
SHELL ["/bin/bash", "-euo", "pipefail", "-c"]
RUN valkey-server --version | grep --only-matching --perl-regexp '(?<=v=)\S*' > /version

FROM docker.io/alpine:3.24.0@sha256:a2d49ea686c2adfe3c992e47dc3b5e7fa6e6b5055609400dc2acaeb241c829f4 AS build
RUN apk --no-cache add ca-certificates git build-base pkgconf
RUN git clone https://github.com/valkey-io/valkey
WORKDIR /valkey
COPY --from=valkey /version /version
RUN git checkout "$(cat /version)"
RUN make -j "$(nproc)" LDFLAGS="-s -w -static" CFLAGS="-static" USE_SYSTEMD=no BUILD_TLS=no
RUN chmod ugo=rx /valkey/src/valkey-cli
RUN chmod ugo=rx /valkey/src/valkey-server

FROM scratch
COPY --from=build /valkey/src/valkey-cli /usr/bin/valkey-cli
COPY --from=build /valkey/src/valkey-server /usr/bin/valkey-server
EXPOSE 6379
ENTRYPOINT ["/usr/bin/valkey-server"]
HEALTHCHECK CMD ["valkey-cli", "ping"]
CMD ["--protected-mode", "no", "--save"]
