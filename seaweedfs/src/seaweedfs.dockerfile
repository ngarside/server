# This is free and unencumbered software released into the public domain.

# This file was adapted under the MIT license:
# - https://github.com/moparisthebest/static-curl/blob/master/build.sh
# - https://github.com/moparisthebest/static-curl/blob/master/LICENSE.txt

FROM docker.io/chrislusf/seaweedfs:4.31@sha256:e14ad400e28c811fe8426dc08abf248ec722b9f017713290a9b84a54557f45c2 AS seaweedfs
SHELL ["/bin/ash", "-euo", "pipefail", "-c"]
USER root
RUN weed version 2>&1 | awk 'NR==1{print $3}' > /version

FROM golang:1.26.3-alpine@sha256:91eda9776261207ea25fd06b5b7fed8d397dd2c0a283e77f2ab6e91bfa71079d as build
COPY --from=seaweedfs /version /version
RUN apk --no-cache add build-base git
RUN git clone https://github.com/seaweedfs/seaweedfs --branch "$(cat /version)" --depth 1
WORKDIR /go/seaweedfs/weed
COPY /seaweedfs/src/credentials.patch /tmp/credentials.patch
RUN patch s3api/auth_credentials.go < /tmp/credentials.patch
RUN go install -ldflags '-linkmode external -extldflags -static'
RUN strip /go/bin/weed

FROM docker.io/curlimages/curl:8.20.0@sha256:b3f1fb2a51d923260350d21b8654bbc607164a987e2f7c84a0ac199a67df812a AS curl
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
