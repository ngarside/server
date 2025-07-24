# This is free and unencumbered software released into the public domain.

FROM docker.io/caddy:latest@sha256:e23538fceb12f3f8cc97a174844aa99bdea7715023d6e088028850fd0601e2e2 AS caddy

RUN chmod ugo=rx /usr/bin/caddy

FROM docker.io/node:alpine@sha256:820e86612c21d0636580206d802a726f2595366e1b867e564cbc652024151e8a AS fossflow

RUN apk add git

RUN git clone --depth 1 https://github.com/stan-smith/FossFLOW fossflow

WORKDIR /fossflow

RUN npm ci && npm run build

RUN chmod -R ugo=r build

FROM scratch

COPY --from=fossflow /fossflow/build /srv
COPY --from=caddy /usr/bin/caddy /usr/bin/caddy

EXPOSE 80

WORKDIR /srv

ENTRYPOINT ["/usr/bin/caddy"]

CMD ["file-server"]
