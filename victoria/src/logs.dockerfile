# This is free and unencumbered software released into the public domain.

FROM docker.io/victoriametrics/victoria-logs:v1.50.0@sha256:ae9bea8d8a3b0fc47c7f0058bcca410e79c84b4a0acd12d4dac71b9302526590 AS victorialogs

FROM docker.io/alpine:3.24.1@sha256:28bd5fe8b56d1bd048e5babf5b10710ebe0bae67db86916198a6eec434943f8b AS headcheck
RUN wget https://github.com/pixelatedlabs/headcheck/releases/download/3.0.0/linux-x64.zip
RUN unzip /linux-x64.zip

FROM scratch
COPY --from=headcheck /headcheck /usr/bin/headcheck
COPY --from=victorialogs /victoria-logs-prod /usr/bin/victorialogs
ENTRYPOINT ["/usr/bin/victorialogs", "-storageDataPath", "/var/lib/victorialogs"]
EXPOSE 9428
HEALTHCHECK CMD ["/usr/bin/headcheck", "http://0.0.0.0:9428/health"]
VOLUME /var/lib/victorialogs
