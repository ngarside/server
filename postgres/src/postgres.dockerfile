# This is free and unencumbered software released into the public domain.

FROM docker.io/postgres:18.3-alpine@sha256:b73cfacf3ab6dd856b34313193598dc9ff12e835715675bcdcfd3ac8732f5842
HEALTHCHECK CMD ["pg_isready"]
