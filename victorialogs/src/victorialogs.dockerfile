# This is free and unencumbered software released into the public domain.

FROM docker.io/victoriametrics/victoria-logs:v1.36.1-scratch AS victorialogs

FROM scratch
COPY --from=victorialogs /victoria-logs-prod /usr/bin/victorialogs
ENTRYPOINT ["/usr/bin/victorialogs"]
EXPOSE 9428
