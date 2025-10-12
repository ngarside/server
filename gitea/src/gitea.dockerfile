# This is free and unencumbered software released into the public domain.

FROM docker.io/gitea/gitea:1.24.6-rootless
ENV GITEA_I_AM_BEING_UNSAFE_RUNNING_AS_ROOT=true
# hadolint ignore=DL3002
USER root
COPY gitea/src/entrypoint.sh /usr/bin/entrypoint
RUN chmod +x /usr/bin/entrypoint
ENTRYPOINT ["/usr/bin/dumb-init", "--", "/usr/bin/entrypoint"]
