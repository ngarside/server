# This is free and unencumbered software released into the public domain.

FROM docker.io/victoriametrics/victoria-metrics:v1.150.0@sha256:54467c7764a3e6579199af1914bb779f01ce32265cd552eb5ae0d4f8a2b80a97 AS victoriametrics

FROM docker.io/alpine:3.24.1@sha256:28bd5fe8b56d1bd048e5babf5b10710ebe0bae67db86916198a6eec434943f8b AS headcheck
RUN wget https://github.com/pixelatedlabs/headcheck/releases/download/3.0.0/linux-x64.zip
RUN unzip /linux-x64.zip

FROM scratch
COPY --from=headcheck /headcheck /usr/bin/headcheck
COPY --from=victoriametrics /victoria-metrics-prod /usr/bin/victoriametrics
ENTRYPOINT ["/usr/bin/victoriametrics", "-storageDataPath", "/var/lib/victoriametrics"]
EXPOSE 8428
HEALTHCHECK CMD ["/usr/bin/headcheck", "http://0.0.0.0:8428/health"]
VOLUME /var/lib/victoriametrics
