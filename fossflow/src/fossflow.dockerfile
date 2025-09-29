# This is free and unencumbered software released into the public domain.

FROM docker.io/node:24.8.0-alpine AS fossflow
RUN apk --no-cache add git
RUN git clone https://github.com/stan-smith/fossflow fossflow
WORKDIR /fossflow
RUN git checkout 1405f285a816bc5c56beee8365e08bfbdf69b0e9
RUN npm ci && npm run docker:build
RUN chmod -R ugo=r dist

FROM docker.io/caddy:2.10.2 AS caddy
RUN chmod ugo=rx /usr/bin/caddy

FROM docker.io/library/alpine:latest AS headcheck
RUN wget --progress=dot:giga https://pixelatedlabs.com/headcheck/releases/latest/linux_x64.zip
RUN unzip /linux_x64.zip

FROM scratch
COPY --from=caddy /usr/bin/caddy /usr/bin/caddy
COPY --from=fossflow /fossflow/dist /srv
COPY --from=headcheck /headcheck /usr/bin/headcheck
EXPOSE 80
WORKDIR /srv
ENTRYPOINT ["/usr/bin/caddy"]
HEALTHCHECK CMD ["/usr/bin/headcheck", "http://0.0.0.0"]
CMD ["file-server"]
