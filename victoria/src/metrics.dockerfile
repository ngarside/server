# This is free and unencumbered software released into the public domain.

FROM docker.io/victoriametrics/victoria-metrics:v1.149.0@sha256:13b8951e35bb3589626816538483127785a9d8b53f9f5123769db0fcab1d961f AS victoriametrics

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
