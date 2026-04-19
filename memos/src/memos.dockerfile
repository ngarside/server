# This is free and unencumbered software released into the public domain.

FROM docker.io/neosmemo/memos:0.27.1@sha256:3c8313d93a46890557b0ad36c805bed444da7d7006269dc54c4f1c4fce35b91c AS memos
RUN chmod ugo=rx /usr/local/memos/memos

FROM docker.io/alpine:3.23.4@sha256:5b10f432ef3da1b8d4c7eb6c487f2f5a8f096bc91145e68878dd4a5019afde11 AS headcheck
RUN wget https://pixelatedlabs.com/headcheck/releases/latest/linux-x64.zip
RUN unzip /linux-x64.zip

FROM scratch
COPY --from=memos /usr/local/memos/memos /usr/bin/memos
COPY --from=headcheck /headcheck /usr/bin/headcheck
ENTRYPOINT ["/usr/bin/memos"]
HEALTHCHECK CMD ["/usr/bin/headcheck", "http://0.0.0.0"]
CMD ["--data", "/var/lib/memos", "--port", "80"]
