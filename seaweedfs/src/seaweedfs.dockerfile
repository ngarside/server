# This is free and unencumbered software released into the public domain.

# This file was adapted under the MIT license:
# - https://github.com/moparisthebest/static-curl/blob/master/build.sh
# - https://github.com/moparisthebest/static-curl/blob/master/LICENSE.txt

FROM docker.io/chrislusf/seaweedfs:4.37@sha256:f898c91e42d7da5f4bb13f1efd424ff03ba85b420312eb929708a384e8a8b03d AS seaweedfs
SHELL ["/bin/ash", "-euo", "pipefail", "-c"]
USER root
RUN weed version 2>&1 | awk 'NR==1{print $3}' > /version

FROM golang:1.26.4-alpine@sha256:3ad57304ad93bbec8548a0437ad9e06a455660655d9af011d58b993f6f615648 as build
COPY --from=seaweedfs /version /version
RUN apk --no-cache add build-base git
RUN git clone https://github.com/seaweedfs/seaweedfs --branch "$(cat /version)" --depth 1
WORKDIR /go/seaweedfs/weed
COPY /seaweedfs/src/credentials.patch /tmp/credentials.patch
RUN patch s3api/auth_credentials.go < /tmp/credentials.patch
RUN go install -ldflags '-linkmode external -extldflags -static'
RUN strip /go/bin/weed

FROM docker.io/curlimages/curl:8.21.0@sha256:7c12af72ceb38b7432ab85e1a265cff6ae58e06f95539d539b654f2cfa64bb13 AS curl
SHELL ["/bin/ash", "-euo", "pipefail", "-c"]
USER root
RUN apk --no-cache add grep
RUN curl --version | grep -oP '(?<=curl )\S+' > /version

FROM docker.io/alpine:3.24.1@sha256:28bd5fe8b56d1bd048e5babf5b10710ebe0bae67db86916198a6eec434943f8b AS healthcheck
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
