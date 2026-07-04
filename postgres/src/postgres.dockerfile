# This is free and unencumbered software released into the public domain.

FROM docker.io/postgres:18.4-alpine@sha256:1b1689b20d16a014a3d195653381cf2caa75a41a92d93b255a9d6ea29fd353aa
HEALTHCHECK CMD ["pg_isready"]
