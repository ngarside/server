# This is free and unencumbered software released into the public domain.

FROM docker.io/gitea/gitea:1.24.6-rootless
USER root
COPY gitea/src/configuration.sh /usr/bin/configuration
COPY gitea/src/entrypoint.sh /usr/bin/entrypoint
ENTRYPOINT ["/usr/bin/dumb-init", "--", "/usr/bin/entrypoint"]
ENV GITEA_I_AM_BEING_UNSAFE_RUNNING_AS_ROOT=true
RUN chmod +x /usr/bin/configuration
RUN chmod +x /usr/bin/entrypoint
