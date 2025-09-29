# This is free and unencumbered software released into the public domain.

FROM docker.io/neosmemo/memos:0.25.1 AS memos
RUN chmod ugo=rx /usr/local/memos/memos

FROM docker.io/alpine:3.22.1 AS headcheck
RUN wget https://pixelatedlabs.com/headcheck/releases/latest/linux_x64.zip
RUN unzip /linux_x64.zip

FROM scratch
COPY --from=memos /usr/local/memos/memos /usr/bin/memos
COPY --from=headcheck /headcheck /usr/bin/headcheck
ENTRYPOINT ["/usr/bin/memos"]
HEALTHCHECK CMD ["/usr/bin/headcheck", "http://0.0.0.0"]
CMD ["--data", "/opt/memos", "--mode", "prod", "--port", "80"]
