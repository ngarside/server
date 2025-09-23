# This is free and unencumbered software released into the public domain.

FROM docker.io/node:24.8.0-alpine AS fossflow

RUN apk --no-cache add git

RUN git clone https://github.com/stan-smith/fossflow fossflow

WORKDIR /fossflow

RUN git checkout 1405f285a816bc5c56beee8365e08bfbdf69b0e9

RUN npm ci && npm run docker:build

RUN chmod -R ugo=r dist

FROM docker.io/caddy:2.10.2 AS caddy

RUN chmod ugo=rx /usr/bin/caddy

FROM docker.io/library/golang:1.25.1-alpine AS healthcheck

WORKDIR /go

COPY fossflow/src/healthcheck.go healthcheck.go

RUN go build -ldflags="-w -s" healthcheck.go
RUN chmod ugo=rx /go/healthcheck

FROM scratch

COPY --from=caddy /usr/bin/caddy /usr/bin/caddy
COPY --from=fossflow /fossflow/dist /srv
COPY --from=healthcheck /go/healthcheck /usr/bin/healthcheck

EXPOSE 80

WORKDIR /srv

ENTRYPOINT ["/usr/bin/caddy"]

HEALTHCHECK CMD ["/usr/bin/healthcheck"]

CMD ["file-server"]
