# This is free and unencumbered software released into the public domain.

FROM docker.io/neosmemo/memos:stable@sha256:e278981311adb91712328cdd81d2f7bcf132f055b051338bbfaecf0538ba69fe AS build

RUN chmod ugo=rx /usr/local/memos/memos

FROM scratch

COPY --from=build /usr/local/memos/memos /usr/bin/memos

ENTRYPOINT ["/usr/bin/memos"]

CMD ["--data", "/opt/memos", "--mode", "prod", "--port", "80"]
