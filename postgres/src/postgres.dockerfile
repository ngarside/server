# This is free and unencumbered software released into the public domain.

FROM docker.io/postgres:18.2-alpine
HEALTHCHECK CMD ["pg_isready"]
