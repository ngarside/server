# This is free and unencumbered software released into the public domain.

FROM docker.io/caddy:latest@sha256:e23538fceb12f3f8cc97a174844aa99bdea7715023d6e088028850fd0601e2e2 AS caddy

RUN chmod ugo=rx /usr/bin/caddy

FROM docker.io/node:alpine@sha256:e8e882c692a08878d55ec8ff6c5a4a71b3edca25eda0af4406e2a160d8a93cf2 AS fossflow

RUN apk add git

RUN git clone --depth 1 https://github.com/stan-smith/fossflow fossflow

WORKDIR /fossflow

RUN npm ci && npm run build

RUN chmod -R ugo=r build

FROM docker.io/library/golang:alpine@sha256:c8c5f95d64aa79b6547f3b626eb84b16a7ce18a139e3e9ca19a8c078b85ba80d AS healthcheck

WORKDIR /go

COPY fossflow/src/healthcheck.go healthcheck.go

RUN go build -ldflags="-w -s" healthcheck.go
RUN chmod ugo=rx /go/healthcheck

FROM scratch

COPY --from=caddy /usr/bin/caddy /usr/bin/caddy
COPY --from=fossflow /fossflow/build /srv
COPY --from=healthcheck /go/healthcheck /usr/bin/healthcheck

EXPOSE 80

WORKDIR /srv

ENTRYPOINT ["/usr/bin/caddy"]

HEALTHCHECK CMD ["/usr/bin/healthcheck"]

CMD ["file-server"]
