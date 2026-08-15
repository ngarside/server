# This is free and unencumbered software released into the public domain.

FROM docker.io/postgres:18.6-alpine@sha256:d3e1620b530c944afa6e887d22eb899824da68e19c52024bf98f5220c88a65b2
HEALTHCHECK CMD ["pg_isready"]
