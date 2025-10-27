# This is free and unencumbered software released into the public domain.

FROM docker.io/chrislusf/seaweedfs:3.99 AS seaweedfs

FROM docker.io/alpine:3.22.2 AS curl
RUN apk add build-base
RUN wget https://curl.se/download/curl-8.16.0.tar.gz
RUN tar xzf curl-8.16.0.tar.gz
WORKDIR /curl-8.16.0
RUN LDFLAGS="-static" ./configure --enable-static --without-libpsl --without-ssl
RUN make -j $(nproc) LDFLAGS="-static -all-static"
RUN cp /curl-8.16.0/src/curl /curl

FROM scratch
COPY --from=curl /curl /usr/bin/curl
COPY --from=seaweedfs /usr/bin/weed /usr/bin/weed
EXPOSE 80
ENTRYPOINT ["/usr/bin/weed", "-logtostderr=true"]
HEALTHCHECK CMD ["/usr/bin/curl", "http://0.0.0.0/status"]
VOLUME ["/tmp"]
