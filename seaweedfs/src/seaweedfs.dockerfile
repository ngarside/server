# This is free and unencumbered software released into the public domain.

# This file was adapted under the MIT license:
# - https://github.com/moparisthebest/static-curl/blob/master/build.sh
# - https://github.com/moparisthebest/static-curl/blob/master/LICENSE.txt

FROM docker.io/chrislusf/seaweedfs:4.21@sha256:e0b528145ea514040ab00d03ff0833f56acb1f0e07aeab232e20485af9278fd8 AS seaweedfs
SHELL ["/bin/ash", "-euo", "pipefail", "-c"]
USER root
RUN weed version 2>&1 | awk 'NR==1{print $3}' > /version

FROM golang:1.26.2-alpine@sha256:f85330846cde1e57ca9ec309382da3b8e6ae3ab943d2739500e08c86393a21b1 as build
COPY --from=seaweedfs /version /version
RUN apk --no-cache add build-base git
RUN git clone https://github.com/seaweedfs/seaweedfs --branch "$(cat /version)" --depth 1
WORKDIR /go/seaweedfs/weed
COPY /seaweedfs/src/credentials.patch /tmp/credentials.patch
RUN patch s3api/auth_credentials.go < /tmp/credentials.patch
RUN go install -ldflags '-linkmode external -extldflags -static'
RUN strip /go/bin/weed

FROM docker.io/curlimages/curl:8.19.0@sha256:c03110c736db81bbe1be0296f1f1608c81b954b01626bdfb0a8f84e5bd00ff3c AS curl
SHELL ["/bin/ash", "-euo", "pipefail", "-c"]
USER root
RUN apk --no-cache add grep
RUN curl --version | grep -oP '(?<=curl )\S+' > /version

FROM docker.io/alpine:3.23.4@sha256:5b10f432ef3da1b8d4c7eb6c487f2f5a8f096bc91145e68878dd4a5019afde11 AS healthcheck
COPY --from=curl /version /version
RUN apk --no-cache add build-base curl
RUN curl --remote-name "https://curl.se/download/curl-$(cat /version).tar.gz"
RUN mkdir curl
RUN tar xzf "curl-$(cat /version).tar.gz" --directory /curl --strip-components 1
WORKDIR /curl
RUN LDFLAGS="-static" ./configure --enable-static --without-libpsl --without-ssl
RUN make -j "$(nproc)" LDFLAGS="-static -all-static"
RUN strip src/curl

FROM scratch
COPY --from=build /go/bin/weed /usr/bin/weed
COPY --from=healthcheck /curl/src/curl /usr/bin/curl
EXPOSE 80
ENTRYPOINT ["/usr/bin/weed", "-logtostderr=true"]
HEALTHCHECK CMD ["/usr/bin/curl", "--silent", "http://0.0.0.0/healthz"]
VOLUME ["/tmp"]
