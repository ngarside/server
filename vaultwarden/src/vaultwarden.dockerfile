# This is free and unencumbered software released into the public domain.

FROM docker.io/vaultwarden/server:1.34.3-alpine AS vaultwarden
RUN chmod ugo=rx /vaultwarden

FROM docker.io/alpine:3.22.1 AS headcheck
RUN wget https://pixelatedlabs.com/headcheck/releases/latest/linux_x64.zip
RUN unzip /linux_x64.zip

FROM scratch
COPY --from=vaultwarden /vaultwarden /usr/bin/vaultwarden
COPY --from=headcheck /headcheck /usr/bin/headcheck
ENTRYPOINT ["/usr/bin/vaultwarden"]
HEALTHCHECK CMD ["/usr/bin/headcheck", "http://0.0.0.0/alive"]
