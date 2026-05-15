# This is free and unencumbered software released into the public domain.

FROM docker.io/postgres:18.4-alpine@sha256:38346350acb3e824c6948e6df7ff4759f48ba09d8ef4cb8d1b6e6db120f56872
HEALTHCHECK CMD ["pg_isready"]
