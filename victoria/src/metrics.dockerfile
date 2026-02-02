# This is free and unencumbered software released into the public domain.

FROM docker.io/victoriametrics/victoria-metrics:v1.135.0 AS victoriametrics

FROM scratch
COPY --from=victoriametrics /victoria-metrics-prod /usr/bin/victoriametrics
ENTRYPOINT ["/usr/bin/victoriametrics", "-storageDataPath", "/var/lib/victoriametrics"]
EXPOSE 8428
VOLUME /var/lib/victoriametrics
