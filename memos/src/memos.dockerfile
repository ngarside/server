# This is free and unencumbered software released into the public domain.

FROM docker.io/neosmemo/memos:stable@sha256:e278981311adb91712328cdd81d2f7bcf132f055b051338bbfaecf0538ba69fe AS memos

RUN chmod ugo=rx /usr/local/memos/memos

FROM docker.io/library/golang:alpine@sha256:c8c5f95d64aa79b6547f3b626eb84b16a7ce18a139e3e9ca19a8c078b85ba80d AS healthcheck

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
