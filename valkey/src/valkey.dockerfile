# This is free and unencumbered software released into the public domain.

FROM docker.io/alpine:latest@sha256:4bcff63911fcb4448bd4fdacec207030997caf25e9bea4045fa6c8c44de311d1 AS build

RUN apk add ca-certificates git build-base pkgconf

RUN git clone https://github.com/valkey-io/valkey

WORKDIR /valkey

RUN git checkout $(git tag | tail -1)

RUN sed -i "s|\(protected_mode.*\)1|\10|g" /valkey/src/config.c

RUN make -j "$(nproc)" LDFLAGS="-s -w -static" CFLAGS="-static" USE_SYSTEMD=no BUILD_TLS=no

FROM scratch

COPY --from=build /valkey/src/valkey-cli /usr/bin/valkey-cli
COPY --from=build /valkey/src/valkey-server /usr/bin/valkey-server

EXPOSE 6379

ENTRYPOINT ["/usr/bin/valkey-server"]
