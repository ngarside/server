# This is free and unencumbered software released into the public domain.

FROM docker.io/chrislusf/seaweedfs:3.99 AS seaweedfs

FROM docker.io/alpine:3.22.2 AS headcheck
RUN wget https://pixelatedlabs.com/headcheck/releases/latest/linux_x64.zip
RUN unzip /linux_x64.zip

FROM scratch
COPY --from=headcheck /headcheck /usr/bin/headcheck
COPY --from=seaweedfs /usr/bin/weed /usr/bin/weed
EXPOSE 80
ENTRYPOINT ["/usr/bin/weed", "-logtostderr=true"]
HEALTHCHECK CMD ["/usr/bin/headcheck", "http://0.0.0.0/status"]
VOLUME ["/tmp"]
