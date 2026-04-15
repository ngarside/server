# This is free and unencumbered software released into the public domain.

FROM docker.io/postgres:18.3-alpine@sha256:4da1a4828be12604092fa55311276f08f9224a74a62dcb4708bd7439e2a03911
HEALTHCHECK CMD ["pg_isready"]
