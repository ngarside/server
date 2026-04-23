# This is free and unencumbered software released into the public domain.

FROM docker.io/grafana/grafana:13.0.1@sha256:0f86bada30d65ef9d0183b90c1e2682ac92d53d95da8bed322b984ea78a4a73a AS grafana

FROM docker.io/alpine:3.23.4@sha256:5b10f432ef3da1b8d4c7eb6c487f2f5a8f096bc91145e68878dd4a5019afde11 AS headcheck
RUN wget https://github.com/pixelatedlabs/headcheck/releases/download/2.1.0/linux-x64.zip
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
