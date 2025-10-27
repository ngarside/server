# This is free and unencumbered software released into the public domain.

FROM docker.io/chrislusf/seaweedfs:3.99 AS seaweedfs

FROM docker.io/curlimages/curl:8.16.0 AS curl
USER root
RUN apk add grep
RUN curl --version | grep -oP '(?<=curl )\S+' >> /version

FROM docker.io/alpine:3.22.2 AS healthcheck
COPY --from=curl /version /version
RUN apk add build-base
RUN wget https://curl.se/download/curl-$(cat /version).tar.gz
RUN mkdir curl
RUN tar xzf curl-$(cat /version).tar.gz --directory /curl --strip-components 1
WORKDIR /curl
RUN LDFLAGS="-static" ./configure --enable-static --without-libpsl --without-ssl
RUN make -j $(nproc) LDFLAGS="-static -all-static"
RUN strip src/curl

FROM scratch
COPY --from=healthcheck /curl/src/curl /usr/bin/curl
COPY --from=seaweedfs /usr/bin/weed /usr/bin/weed
EXPOSE 80
ENTRYPOINT ["/usr/bin/weed", "-logtostderr=true"]
HEALTHCHECK CMD ["/usr/bin/curl", "--silent", "http://0.0.0.0/healthz"]
VOLUME ["/tmp"]
