# This is free and unencumbered software released into the public domain.

FROM docker.io/postgres:18.4-alpine@sha256:ecafd34249b5c248f3cb6ebe339584ee6448b36fad3f0a827ae5e8efbae6afda
HEALTHCHECK CMD ["pg_isready"]
