# This is free and unencumbered software released into the public domain.

FROM ghcr.io/alam00000/bentopdf-simple:2.8.4@sha256:2bae644d27351a4d01bbbbcce7a9948fcc66da053ec7a37fff168c3788de9096 AS bentopdf

FROM docker.io/caddy:2.11.3@sha256:68d335223f05fadcc55ec3677521a2e61488949d30b5c7beeb3d0b2309efca1d AS caddy
RUN chmod ugo=rx /usr/bin/caddy

FROM docker.io/alpine:3.23.4@sha256:5b10f432ef3da1b8d4c7eb6c487f2f5a8f096bc91145e68878dd4a5019afde11 AS headcheck
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
