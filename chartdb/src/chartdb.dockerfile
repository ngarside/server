# This is free and unencumbered software released into the public domain.

FROM ghcr.io/chartdb/chartdb:1.20.1@sha256:9385f1a72174a2cdba27036127a98474a0c941c3c795dcc15149884c09834460 AS chartdb

FROM docker.io/caddy:2.11.4@sha256:cfeb0b281bc44a5a51fecde39e9e577c60d863c0b6196e6bbdf58fd00960887f AS caddy
RUN chmod ugo=rx /usr/bin/caddy

FROM docker.io/alpine:3.24.1@sha256:bec4ccd3817e7c824eb0388971a0b83fab111d586285511ba0266b77e8dc65a9 AS headcheck
RUN wget https://github.com/pixelatedlabs/headcheck/releases/download/3.0.0/linux-x64.zip
RUN unzip /linux-x64.zip

FROM scratch
COPY --from=caddy /usr/bin/caddy /usr/bin/caddy
COPY --from=chartdb /usr/share/nginx/html /usr/share/chartdb
COPY --from=headcheck /headcheck /usr/bin/headcheck
COPY /chartdb/src/config.js /usr/share/chartdb/config.js
EXPOSE 80
WORKDIR /usr/share/chartdb
ENTRYPOINT ["/usr/bin/caddy"]
HEALTHCHECK CMD ["/usr/bin/headcheck", "http://0.0.0.0"]
CMD ["file-server"]
