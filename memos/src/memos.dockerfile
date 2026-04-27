# This is free and unencumbered software released into the public domain.

FROM docker.io/neosmemo/memos:0.28.0@sha256:06066de94333c091ee67c2ad5dec5f15bf5f35b31498c90092f9915dd05e9f92 AS memos
RUN chmod ugo=rx /usr/local/memos/memos

FROM docker.io/alpine:3.23.4@sha256:5b10f432ef3da1b8d4c7eb6c487f2f5a8f096bc91145e68878dd4a5019afde11 AS headcheck
RUN wget https://github.com/pixelatedlabs/headcheck/releases/download/3.0.0/linux-x64.zip
RUN unzip /linux-x64.zip

FROM scratch
COPY --from=memos /usr/local/memos/memos /usr/bin/memos
COPY --from=headcheck /headcheck /usr/bin/headcheck
ENTRYPOINT ["/usr/bin/memos"]
HEALTHCHECK CMD ["/usr/bin/headcheck", "http://0.0.0.0"]
CMD ["--data", "/var/lib/memos", "--port", "80"]
