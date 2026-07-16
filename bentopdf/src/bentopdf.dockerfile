# This is free and unencumbered software released into the public domain.

FROM ghcr.io/alam00000/bentopdf-simple:2.8.6@sha256:1a947a9d4ae515be27b381a2a1f8565d5fa33087c32abc2bb7a6754f83e95f4c AS bentopdf

FROM docker.io/caddy:2.11.4@sha256:58483504a1c605edfd9e948ee67524f5dd6cc5734aa315ec68b88b99c8433952 AS caddy
RUN chmod ugo=rx /usr/bin/caddy

FROM docker.io/alpine:3.24.1@sha256:28bd5fe8b56d1bd048e5babf5b10710ebe0bae67db86916198a6eec434943f8b AS headcheck
RUN wget https://github.com/pixelatedlabs/headcheck/releases/download/3.0.0/linux-x64.zip
RUN unzip /linux-x64.zip

FROM scratch
COPY --from=caddy /usr/bin/caddy /usr/bin/caddy
COPY --from=bentopdf /usr/share/nginx/html /usr/share/bentopdf
COPY --from=headcheck /headcheck /usr/bin/headcheck
EXPOSE 80
WORKDIR /usr/share/bentopdf
ENTRYPOINT ["/usr/bin/caddy"]
HEALTHCHECK CMD ["/usr/bin/headcheck", "http://0.0.0.0"]
CMD ["file-server"]
