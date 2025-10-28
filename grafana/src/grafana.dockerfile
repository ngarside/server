# This is free and unencumbered software released into the public domain.

FROM docker.io/grafana/grafana:12.2.1 AS grafana

FROM scratch
COPY --from=grafana /usr/share/grafana/bin/grafana /usr/bin/grafana
COPY --from=grafana /usr/share/grafana/conf /usr/share/grafana/conf
COPY --from=grafana /usr/share/grafana/public /usr/share/grafana/public
ENTRYPOINT ["/usr/bin/grafana"]
CMD ["server", "--homepath", "/usr/share/grafana"]
EXPOSE 3000
VOLUME /tmp
