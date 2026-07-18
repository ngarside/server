# This is free and unencumbered software released into the public domain.

FROM docker.io/adguard/adguardhome:v0.107.78@sha256:1ea34eafe5dc691007946e8eaab7bf46b0de9412f39213d8c06e48b53bf9a6c5 AS adguardhome
RUN chmod ugo=rx /opt/adguardhome/AdGuardHome

FROM docker.io/alpine:3.24.1@sha256:28bd5fe8b56d1bd048e5babf5b10710ebe0bae67db86916198a6eec434943f8b AS headcheck
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
