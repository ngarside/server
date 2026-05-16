# This is free and unencumbered software released into the public domain.

FROM docker.io/postgres:18.4-alpine@sha256:96d56f7f57c6aacd1fcb908bc83b345ec5f83231ee486dd66a1baadce274db88
HEALTHCHECK CMD ["pg_isready"]
