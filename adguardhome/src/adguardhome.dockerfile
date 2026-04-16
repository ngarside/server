# This is free and unencumbered software released into the public domain.

FROM docker.io/adguard/adguardhome:v0.107.73@sha256:7fbf01d73ecb7a32d2d9e6cef8bf88e64bd787889ca80a1e8bce30cd4c084442 AS adguardhome
RUN chmod ugo=rx /opt/adguardhome/AdGuardHome

FROM docker.io/alpine:3.23.4@sha256:5b10f432ef3da1b8d4c7eb6c487f2f5a8f096bc91145e68878dd4a5019afde11 AS headcheck
RUN wget https://pixelatedlabs.com/headcheck/releases/latest/linux-x64.zip
RUN unzip /linux-x64.zip

FROM scratch
COPY --from=adguardhome /opt/adguardhome/AdGuardHome /usr/bin/adguardhome
COPY --from=headcheck /headcheck /usr/bin/headcheck
EXPOSE 53/tcp 53/udp 80/tcp
WORKDIR /opt/adguardhome
ENTRYPOINT ["/usr/bin/adguardhome"]
HEALTHCHECK CMD ["/usr/bin/headcheck", "http://0.0.0.0"]
CMD [ \
	"--config", "/etc/adguardhome/adguardhome.yaml", \
	"--no-check-update", \
	"--web-addr", "0.0.0.0:80", \
	"--work-dir", "/var/lib/adguardhome" \
]
