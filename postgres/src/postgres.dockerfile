# This is free and unencumbered software released into the public domain.

FROM docker.io/postgres:18.4-alpine@sha256:2591af411ef9fdc73eac387e85cf37cee5feff417abc773624f0037402390c77
HEALTHCHECK CMD ["pg_isready"]
