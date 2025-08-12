# This is free and unencumbered software released into the public domain.

FROM docker.io/timberio/vector:latest-distroless-static@sha256:3d82ad9269fa3316fbae2a9dd7ad702bc044f46fe24ec58cc6e167cb1f543d0d AS vector

FROM docker.io/library/golang:alpine@sha256:c8c5f95d64aa79b6547f3b626eb84b16a7ce18a139e3e9ca19a8c078b85ba80d AS healthcheck

WORKDIR /go

COPY vector/src/healthcheck.go healthcheck.go

RUN go build -ldflags="-w -s" healthcheck.go
RUN chmod ugo=rx /go/healthcheck

FROM scratch

COPY --from=vector /usr/local/bin/vector /usr/bin/vector
COPY --from=healthcheck /go/healthcheck /usr/bin/healthcheck

ENTRYPOINT ["/usr/bin/vector"]

HEALTHCHECK CMD ["/usr/bin/healthcheck"]

CMD ["--config", "/etc/vector/vector.toml"]
