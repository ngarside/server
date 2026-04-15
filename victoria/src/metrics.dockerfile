# This is free and unencumbered software released into the public domain.

FROM docker.io/victoriametrics/victoria-metrics:v1.140.0@sha256:5ea06e3a567249f8a23181208755f36dabd3b515f7023e9eb570fd4ae6c29203 AS victoriametrics

FROM docker.io/alpine:3.23.4@sha256:c7989ac7a27b473e1795973c98d714f62b4dd0b134594d36880505ce0bfd716b AS headcheck
RUN wget https://pixelatedlabs.com/headcheck/releases/latest/linux-x64.zip
RUN unzip /linux-x64.zip

FROM scratch
COPY --from=headcheck /headcheck /usr/bin/headcheck
COPY --from=victoriametrics /victoria-metrics-prod /usr/bin/victoriametrics
ENTRYPOINT ["/usr/bin/victoriametrics", "-storageDataPath", "/var/lib/victoriametrics"]
EXPOSE 8428
HEALTHCHECK CMD ["/usr/bin/headcheck", "http://0.0.0.0:8428/health"]
VOLUME /var/lib/victoriametrics
