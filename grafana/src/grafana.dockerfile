# This is free and unencumbered software released into the public domain.

FROM docker.io/grafana/grafana:12.3.2 AS grafana

FROM docker.io/alpine:3.23.3 AS headcheck
RUN wget https://pixelatedlabs.com/headcheck/releases/latest/linux_x64.zip
RUN unzip /linux_x64.zip

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
