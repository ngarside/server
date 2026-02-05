# This is free and unencumbered software released into the public domain.

FROM docker.io/victoriametrics/victoria-logs:v1.45.0 AS victorialogs

FROM scratch
COPY --from=victorialogs /victoria-logs-prod /usr/bin/victorialogs
ENTRYPOINT ["/usr/bin/victorialogs", "-storageDataPath", "/var/lib/victorialogs"]
EXPOSE 9428
VOLUME /var/lib/victorialogs
