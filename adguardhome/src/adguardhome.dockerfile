# This is free and unencumbered software released into the public domain.

FROM docker.io/adguard/adguardhome:v0.107.66 AS adguardhome
RUN chmod ugo=rx /opt/adguardhome/AdGuardHome

FROM docker.io/alpine:3.22.1 AS headcheck
RUN wget https://pixelatedlabs.com/headcheck/releases/latest/linux_x64.zip
RUN unzip /linux_x64.zip

FROM scratch
COPY --from=adguardhome /opt/adguardhome/AdGuardHome /usr/bin/adguardhome
COPY --from=headcheck /headcheck /usr/bin/headcheck
EXPOSE 53/tcp 53/udp 80/tcp
WORKDIR /opt/adguardhome
ENTRYPOINT ["/usr/bin/adguardhome"]
HEALTHCHECK CMD ["/usr/bin/headcheck", "http://0.0.0.0"]
CMD [ \
	"--config", "/etc/adguardhome/config.yml", \
	"--no-check-update", \
	"--web-addr", "0.0.0.0:80", \
	"--work-dir", "/opt/adguardhome" \
]
