# This is free and unencumbered software released into the public domain.

FROM docker.io/timberio/vector:0.57.0-distroless-static@sha256:d96454c4e64db59234d9a2b973b02c3b9b09a0674eef685b3955ef7cd03f70a0 AS vector

FROM docker.io/alpine:3.24.1@sha256:28bd5fe8b56d1bd048e5babf5b10710ebe0bae67db86916198a6eec434943f8b AS headcheck
RUN wget https://github.com/pixelatedlabs/headcheck/releases/download/3.0.0/linux-x64.zip
RUN unzip /linux-x64.zip

FROM scratch
COPY --from=vector /usr/local/bin/vector /usr/bin/vector
COPY --from=headcheck /headcheck /usr/bin/headcheck
ENTRYPOINT ["/usr/bin/vector"]
HEALTHCHECK CMD ["/usr/bin/headcheck", "http://0.0.0.0:8686/health"]
CMD ["--config", "/etc/vector/*.toml"]
