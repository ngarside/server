# This is free and unencumbered software released into the public domain.

FROM docker.io/gitea/gitea:1.24.6-rootless
ENV I_AM_BEING_UNSAFE_RUNNING_AS_ROOT=true
USER root
