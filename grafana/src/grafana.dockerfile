# This is free and unencumbered software released into the public domain.

FROM docker.io/grafana/grafana:13.1.0@sha256:121a7a9ece6dc10b969f1f96eed64b4f07dfac0d0b8abc070f7cb83bbde86f63 AS grafana

FROM docker.io/alpine:3.24.1@sha256:28bd5fe8b56d1bd048e5babf5b10710ebe0bae67db86916198a6eec434943f8b AS headcheck
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
