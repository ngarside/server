# This is free and unencumbered software released into the public domain.

FROM docker.io/node:24.5.0-alpine AS fossflow

RUN apk --no-cache add git

RUN git clone https://github.com/stan-smith/fossflow fossflow

WORKDIR /fossflow

RUN git checkout d15ad9b8e5be42c6b300650de43aac2590aa81ca

RUN npm ci && npm run build

RUN chmod -R ugo=r build

FROM docker.io/caddy:2.10.0 AS caddy

RUN chmod ugo=rx /usr/bin/caddy

FROM docker.io/library/golang:1.25.0-alpine AS healthcheck

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
