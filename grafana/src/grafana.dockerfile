# This is free and unencumbered software released into the public domain.

FROM docker.io/grafana/grafana:12.2.1 AS grafana

FROM scratch
COPY --from=grafana /usr/share/grafana /usr/share/grafana
ENTRYPOINT ["/usr/share/grafana/bin/grafana"]
CMD ["server", "--homepath", "/usr/share/grafana", "cfg:default.log.mode=console"]
ENV PATH="/usr/share/grafana/bin:$PATH"
EXPOSE 3000
VOLUME /tmp
