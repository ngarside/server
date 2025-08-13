# This is free and unencumbered software released into the public domain.

FROM docker.io/timberio/vector:0.49.0-distroless-static AS vector

FROM docker.io/library/golang:1.25.0-alpine AS healthcheck

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
