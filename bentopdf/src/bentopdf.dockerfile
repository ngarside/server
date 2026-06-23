# This is free and unencumbered software released into the public domain.

FROM ghcr.io/alam00000/bentopdf-simple:2.8.5@sha256:268f3e4a1aeed5d7035b58ab1d679da85b7c559ac3d3c08eb2177520c3647e1f AS bentopdf

FROM docker.io/caddy:2.11.4@sha256:1557580dffd3f309e30bd76b23a26aa3970d98bff11313cfa3a63b735ac8d04a AS caddy
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
