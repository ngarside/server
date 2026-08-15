# This is free and unencumbered software released into the public domain.

FROM docker.io/stnsmith/fossflow:latest@sha256:186429cd981362913be571f60c97a38ab8812519551d74a0473e0a903b1bd90a AS fossflow

FROM docker.io/caddy:2.11.4@sha256:df7f1c2fb114453b951de51a98efc010db1655a92c2e86be6706714e2417a78d AS caddy
RUN chmod ugo=rx /usr/bin/caddy

FROM docker.io/alpine:3.24.1@sha256:28bd5fe8b56d1bd048e5babf5b10710ebe0bae67db86916198a6eec434943f8b AS headcheck
RUN wget https://github.com/pixelatedlabs/headcheck/releases/download/3.0.0/linux-x64.zip
RUN unzip /linux-x64.zip

FROM scratch
COPY --from=caddy /usr/bin/caddy /usr/bin/caddy
COPY --from=fossflow /usr/share/nginx/html /usr/share/fossflow
COPY --from=headcheck /headcheck /usr/bin/headcheck
EXPOSE 80
WORKDIR /usr/share/fossflow
ENTRYPOINT ["/usr/bin/caddy"]
HEALTHCHECK CMD ["/usr/bin/headcheck", "http://0.0.0.0"]
CMD ["file-server"]
