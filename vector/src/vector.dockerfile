# This is free and unencumbered software released into the public domain.

FROM docker.io/timberio/vector:latest-distroless-static@sha256:46a0ea09b9c8ad06dc47209361ee622b8ba44af7b897a7419ac387dea7c5d640 AS vector

FROM docker.io/library/golang:alpine@sha256:c8c5f95d64aa79b6547f3b626eb84b16a7ce18a139e3e9ca19a8c078b85ba80d AS healthcheck

WORKDIR /go

COPY vector/src/healthcheck.go healthcheck.go

RUN go build -ldflags="-w -s" healthcheck.go
RUN chmod ugo=rx /go/healthcheck

FROM scratch

COPY --from=vector /usr/local/bin/vector /usr/bin/vector
COPY --from=healthcheck /go/healthcheck /usr/bin/healthcheck

EXPOSE 8686

ENTRYPOINT ["/usr/bin/vector"]

HEALTHCHECK CMD ["/usr/bin/healthcheck"]

CMD ["--config", "/etc/vector/vector.toml"]
