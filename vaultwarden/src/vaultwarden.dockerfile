# This is free and unencumbered software released into the public domain.

FROM docker.io/vaultwarden/server:1.35.7-alpine@sha256:9a54dad95452412afb959664dc5d6c3c3ca7c4131116ca7667888b0376320b03 AS vaultwarden
RUN chmod ugo=rx /vaultwarden

FROM docker.io/alpine:3.23.3@sha256:25109184c71bdad752c8312a8623239686a9a2071e8825f20acb8f2198c3f659 AS headcheck
RUN wget https://pixelatedlabs.com/headcheck/releases/latest/linux-x64.zip
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
