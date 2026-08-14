# This is free and unencumbered software released into the public domain.

FROM docker.io/postgres:18.6-alpine@sha256:432b3b824c0769275ec9b0947736ef8b376d6997bcaa9de29818f613819c2feb
HEALTHCHECK CMD ["pg_isready"]
