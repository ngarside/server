# This is free and unencumbered software released into the public domain.

FROM docker.io/timberio/vector:0.55.0-distroless-static@sha256:d0e9bcff73d38c408b553683bd230cbc6a204eca399267b40af79f0cd9afc15e AS vector

FROM docker.io/alpine:3.23.4@sha256:5b10f432ef3da1b8d4c7eb6c487f2f5a8f096bc91145e68878dd4a5019afde11 AS headcheck
RUN wget https://pixelatedlabs.com/headcheck/releases/latest/linux-x64.zip
RUN unzip /linux-x64.zip

FROM scratch
COPY --from=vector /usr/local/bin/vector /usr/bin/vector
COPY --from=headcheck /headcheck /usr/bin/headcheck
ENTRYPOINT ["/usr/bin/vector"]
HEALTHCHECK CMD ["/usr/bin/headcheck", "http://0.0.0.0:8686/health"]
CMD ["--config", "/etc/vector/*.toml"]
