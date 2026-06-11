# This is free and unencumbered software released into the public domain.

FROM docker.io/grafana/grafana:13.0.2@sha256:5dad0df181cb644a14e13617b913b261a54f7d4fd4510721dba420929f35bea2 AS grafana

FROM docker.io/alpine:3.24.0@sha256:a2d49ea686c2adfe3c992e47dc3b5e7fa6e6b5055609400dc2acaeb241c829f4 AS headcheck
RUN wget https://github.com/pixelatedlabs/headcheck/releases/download/3.0.0/linux-x64.zip
RUN unzip /linux-x64.zip

FROM scratch
COPY --from=grafana /usr/share/grafana/bin/grafana /usr/bin/grafana
COPY --from=grafana /usr/share/grafana/conf /usr/share/grafana/conf
COPY --from=grafana /usr/share/grafana/public /usr/share/grafana/public
COPY --from=headcheck /headcheck /usr/bin/headcheck
ENTRYPOINT ["/usr/bin/grafana"]
ENV GF_PATHS_DATA=/var/lib/grafana
ENV GF_PATHS_PLUGINS=/var/lib/grafana/plugins
ENV GF_SERVER_HTTP_PORT=80
CMD ["server", "--config", "/etc/grafana/grafana.ini", "--homepath", "/usr/share/grafana"]
HEALTHCHECK CMD ["/usr/bin/headcheck", "http://0.0.0.0/api/health"]
EXPOSE 80
VOLUME ["/etc/grafana", "/tmp", "/var/lib/grafana"]
