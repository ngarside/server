# This is free and unencumbered software released into the public domain.

FROM docker.io/postgres:18.3-alpine@sha256:52098013b4b64a746626437d38afc03cabff6cdeb4d3d92e2342aa95f0ce56ea
HEALTHCHECK CMD ["pg_isready"]
