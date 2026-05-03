# This is free and unencumbered software released into the public domain.

FROM docker.io/vaultwarden/server:1.36.0-alpine@sha256:d3531610b486905943706b235e97159331801c6856e1367a93a5905e2b40f204 AS vaultwarden
RUN chmod ugo=rx /vaultwarden

FROM docker.io/alpine:3.23.4@sha256:5b10f432ef3da1b8d4c7eb6c487f2f5a8f096bc91145e68878dd4a5019afde11 AS headcheck
RUN wget https://github.com/pixelatedlabs/headcheck/releases/download/3.0.0/linux-x64.zip
RUN unzip /linux-x64.zip

FROM scratch
COPY --from=headcheck /headcheck /usr/bin/headcheck
COPY --from=vaultwarden /vaultwarden /usr/bin/vaultwarden
COPY --from=vaultwarden /web-vault /usr/share/vaultwarden
ENTRYPOINT ["/usr/bin/vaultwarden"]
ENV ROCKET_ADDRESS=0.0.0.0
ENV ROCKET_PORT=80
ENV ROCKET_PROFILE="release"
ENV WEB_VAULT_FOLDER=/usr/share/vaultwarden
EXPOSE 80
HEALTHCHECK CMD ["/usr/bin/headcheck", "http://0.0.0.0/alive"]
