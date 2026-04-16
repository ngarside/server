# This is free and unencumbered software released into the public domain.

FROM docker.io/stnsmith/fossflow:latest@sha256:4f75ded25a7f45d2da25e0971be1ecb0db627df89fb406e4f27be6bef99ee142 AS fossflow

FROM docker.io/caddy:2.11.2@sha256:22e1d921a7dd98ea722ebd6819de785fd71abdab7f7fed8a2378e96d29bb923a AS caddy
RUN chmod ugo=rx /usr/bin/caddy

FROM docker.io/alpine:3.23.4@sha256:5b10f432ef3da1b8d4c7eb6c487f2f5a8f096bc91145e68878dd4a5019afde11 AS headcheck
RUN wget https://pixelatedlabs.com/headcheck/releases/latest/linux-x64.zip
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
