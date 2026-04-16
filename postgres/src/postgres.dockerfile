# This is free and unencumbered software released into the public domain.

FROM docker.io/postgres:18.3-alpine@sha256:c48f944df2efbcece2dc4ea6725554f97d430fc0a4fbcfbeb31803b22dc33331
HEALTHCHECK CMD ["pg_isready"]
