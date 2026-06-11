# This is free and unencumbered software released into the public domain.

FROM docker.io/victoriametrics/victoria-logs:v1.50.0@sha256:ae9bea8d8a3b0fc47c7f0058bcca410e79c84b4a0acd12d4dac71b9302526590 AS victorialogs

FROM docker.io/alpine:3.24.0@sha256:a2d49ea686c2adfe3c992e47dc3b5e7fa6e6b5055609400dc2acaeb241c829f4 AS headcheck
RUN wget https://github.com/pixelatedlabs/headcheck/releases/download/3.0.0/linux-x64.zip
RUN unzip /linux-x64.zip

FROM scratch
COPY --from=headcheck /headcheck /usr/bin/headcheck
COPY --from=victorialogs /victoria-logs-prod /usr/bin/victorialogs
ENTRYPOINT ["/usr/bin/victorialogs", "-storageDataPath", "/var/lib/victorialogs"]
EXPOSE 9428
HEALTHCHECK CMD ["/usr/bin/headcheck", "http://0.0.0.0:9428/health"]
VOLUME /var/lib/victorialogs
