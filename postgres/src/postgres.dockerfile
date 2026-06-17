# This is free and unencumbered software released into the public domain.

FROM docker.io/postgres:18.4-alpine@sha256:d3e64d36360a9f40c30fbbc5dd2dde799fe35f8537500c8b067551a6497f50f4
HEALTHCHECK CMD ["pg_isready"]
