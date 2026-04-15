# This is free and unencumbered software released into the public domain.

FROM docker.io/traefik/whoami:v1.11.0@sha256:200689790a0a0ea48ca45992e0450bc26ccab5307375b41c84dfc4f2475937ab AS whoami

FROM docker.io/alpine:3.23.3@sha256:25109184c71bdad752c8312a8623239686a9a2071e8825f20acb8f2198c3f659 AS headcheck
RUN wget https://pixelatedlabs.com/headcheck/releases/latest/linux-x64.zip
RUN unzip /linux-x64.zip

FROM scratch
COPY --from=headcheck /headcheck /usr/bin/headcheck
COPY --from=whoami /whoami /usr/bin/whoami
EXPOSE 80
ENTRYPOINT ["/usr/bin/whoami"]
HEALTHCHECK CMD ["/usr/bin/headcheck", "http://0.0.0.0/health"]
