# This is free and unencumbered software released into the public domain.

FROM ghcr.io/alam00000/bentopdf-simple:2.8.2@sha256:d59a3812cb98c4887672ea73425722ee3dd7010969736c974c6b4ce7ba32c4fb AS bentopdf

FROM docker.io/caddy:2.11.2@sha256:2acb10cebb92eea91a40b76691aff73adde9151416facbeab630bbc66d0969ab AS caddy
RUN chmod ugo=rx /usr/bin/caddy

FROM docker.io/alpine:3.23.4@sha256:5b10f432ef3da1b8d4c7eb6c487f2f5a8f096bc91145e68878dd4a5019afde11 AS headcheck
RUN wget https://pixelatedlabs.com/headcheck/releases/latest/linux-x64.zip
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
