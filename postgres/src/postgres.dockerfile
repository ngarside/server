# This is free and unencumbered software released into the public domain.

FROM docker.io/postgres:18.3-alpine@sha256:d164db0c6b4fc00e438f160b4480f207f3f837cf60f781c61670af4ef71a8062
HEALTHCHECK CMD ["pg_isready"]
