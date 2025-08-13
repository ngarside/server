# This is free and unencumbered software released into the public domain.

FROM docker.io/neosmemo/memos:0.25.0 AS memos

RUN chmod ugo=rx /usr/local/memos/memos

FROM docker.io/library/golang:1.24.6-alpine AS healthcheck

WORKDIR /go

COPY memos/src/healthcheck.go healthcheck.go

RUN go build -ldflags="-w -s" healthcheck.go
RUN chmod ugo=rx /go/healthcheck

FROM scratch

COPY --from=memos /usr/local/memos/memos /usr/bin/memos
COPY --from=healthcheck /go/healthcheck /usr/bin/healthcheck

ENTRYPOINT ["/usr/bin/memos"]

HEALTHCHECK CMD ["/usr/bin/healthcheck"]

CMD ["--data", "/opt/memos", "--mode", "prod", "--port", "80"]
