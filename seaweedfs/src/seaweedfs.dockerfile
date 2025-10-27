# This is free and unencumbered software released into the public domain.

FROM docker.io/chrislusf/seaweedfs:3.99 AS seaweedfs

FROM scratch
COPY --from=seaweedfs /usr/bin/weed /usr/bin/weed
EXPOSE 8333
ENTRYPOINT ["/usr/bin/weed", "-logtostderr=true"]
VOLUME ["/tmp"]
