# This is free and unencumbered software released into the public domain.

FROM docker.io/adguard/adguardhome:v0.107.77@sha256:e6f2b8bcda06064ab055b44933a4f0e983c35558b9cdb8d2e7ab1efcee36d890 AS adguardhome
RUN chmod ugo=rx /opt/adguardhome/AdGuardHome

FROM docker.io/alpine:3.24.0@sha256:a2d49ea686c2adfe3c992e47dc3b5e7fa6e6b5055609400dc2acaeb241c829f4 AS headcheck
RUN wget https://github.com/pixelatedlabs/headcheck/releases/download/3.0.0/linux-x64.zip
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
