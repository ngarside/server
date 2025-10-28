# This is free and unencumbered software released into the public domain.

FROM docker.io/grafana/grafana:12.2.1 AS grafana
# ENV PATH="/usr/share/grafana/bin"

FROM scratch
COPY --from=grafana /usr/share/grafana /usr/share/grafana
ENTRYPOINT ["/usr/share/grafana/bin/grafana"]
CMD ["server", "--homepath", "/usr/share/grafana", "cfg:default.log.mode=console"]
ENV PATH="/usr/share/grafana/bin:$PATH"
ENV GF_PATHS_CONFIG=/etc/grafana/grafana.ini
ENV GF_PATHS_DATA=/var/lib/grafana
ENV GF_PATHS_HOME=/usr/share/grafana
ENV GF_PATHS_LOGS=/var/log/grafana
ENV GF_PATHS_PLUGINS=/var/lib/grafana/plugins
ENV GF_PATHS_PROVISIONING=/etc/grafana/provisioning
EXPOSE 3000
VOLUME /tmp

# FROM scratch
# COPY --from=grafana /usr/share/grafana/bin/grafana /usr/bin/grafana
# COPY --from=grafana /usr/share/grafana/public /srv
# ENTRYPOINT [ \
# 	"/usr/bin/grafana", \
# 	"--homepath", "/srv", \
# ]
# ENV GF_PATHS_CONFIG=/etc/grafana/grafana.ini
# ENV GF_PATHS_DATA=/var/lib/grafana
# ENV GF_PATHS_HOME=/usr/share/grafana
# ENV GF_PATHS_LOGS=/var/log/grafana
# ENV GF_PATHS_PLUGINS=/var/lib/grafana/plugins
# ENV GF_PATHS_PROVISIONING=/etc/grafana/provisioning
# EXPOSE 3000
