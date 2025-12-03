# This is free and unencumbered software released into the public domain.

FROM docker.io/traefik/whoami:v1.11.0 AS whoami

FROM docker.io/alpine:3.23.0 AS headcheck
RUN wget https://pixelatedlabs.com/headcheck/releases/latest/linux_x64.zip
RUN unzip /linux_x64.zip

FROM scratch
COPY --from=headcheck /headcheck /usr/bin/headcheck
COPY --from=whoami /whoami /usr/bin/whoami
EXPOSE 80
ENTRYPOINT ["/usr/bin/whoami"]
HEALTHCHECK CMD ["/usr/bin/headcheck", "http://0.0.0.0/health"]
