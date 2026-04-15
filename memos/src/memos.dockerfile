# This is free and unencumbered software released into the public domain.

FROM docker.io/neosmemo/memos:0.26.2@sha256:3eefcc231141369accbd2f42bdc1a4c1e3b291fb6e288ff0deb60afa1b5d4727 AS memos
RUN chmod ugo=rx /usr/local/memos/memos

FROM docker.io/alpine:3.23.4@sha256:c7989ac7a27b473e1795973c98d714f62b4dd0b134594d36880505ce0bfd716b AS headcheck
RUN wget https://pixelatedlabs.com/headcheck/releases/latest/linux-x64.zip
RUN unzip /linux-x64.zip

FROM scratch
COPY --from=memos /usr/local/memos/memos /usr/bin/memos
COPY --from=headcheck /headcheck /usr/bin/headcheck
ENTRYPOINT ["/usr/bin/memos"]
HEALTHCHECK CMD ["/usr/bin/headcheck", "http://0.0.0.0"]
CMD ["--data", "/var/lib/memos", "--port", "80"]
