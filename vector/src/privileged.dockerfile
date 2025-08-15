# This is free and unencumbered software released into the public domain.

# The upstream reference is duplicated as it both:
# - Needs to appear first to be detected as the upstream tag
# - Needs to appear last to be inherited from

FROM docker.io/timberio/vector:0.49.0-debian

FROM docker.io/library/golang:1.25.0-alpine AS healthcheck

WORKDIR /go

COPY vector/src/healthcheck.go healthcheck.go

RUN go build -ldflags="-w -s" healthcheck.go
RUN chmod ugo=rx /go/healthcheck

FROM docker.io/timberio/vector:0.49.0-debian

COPY --from=healthcheck /go/healthcheck /usr/bin/healthcheck

ENTRYPOINT ["/usr/bin/vector"]

HEALTHCHECK CMD ["/usr/bin/healthcheck"]

CMD ["--config", "/etc/vector/*.toml"]
