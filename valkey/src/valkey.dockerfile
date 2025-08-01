# This is free and unencumbered software released into the public domain.

# This file was adapted under the LGPL-3.0 license
# https://github.com/ZoeyVid/valkey-static/blob/latest/Dockerfile
# https://github.com/ZoeyVid/valkey-static/blob/latest/COPYING

FROM docker.io/alpine:latest@sha256:4bcff63911fcb4448bd4fdacec207030997caf25e9bea4045fa6c8c44de311d1 AS build

RUN apk add ca-certificates git build-base pkgconf

RUN git clone https://github.com/valkey-io/valkey

WORKDIR /valkey

RUN git checkout $(git tag | tail -1)

RUN make -j "$(nproc)" LDFLAGS="-s -w -static" CFLAGS="-static" USE_SYSTEMD=no BUILD_TLS=no

RUN chmod ugo=rx /valkey/src/valkey-server

FROM scratch

COPY --from=build /valkey/src/valkey-server /usr/bin/valkey-server

EXPOSE 6379

ENTRYPOINT ["/usr/bin/valkey-server"]

CMD ["--protected-mode", "no", "--save"]
