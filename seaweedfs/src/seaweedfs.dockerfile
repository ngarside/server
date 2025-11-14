# This is free and unencumbered software released into the public domain.

# This file was adapted under the MIT license:
# - https://github.com/moparisthebest/static-curl/blob/master/build.sh
# - https://github.com/moparisthebest/static-curl/blob/master/LICENSE.txt

FROM docker.io/chrislusf/seaweedfs:4.00 AS seaweedfs
USER root
RUN weed version 2>&1 | awk 'NR==1{print $3}' > /version

FROM golang:1.24-alpine as build
COPY --from=seaweedfs /version /version
RUN apk add git g++ fuse
RUN mkdir -p /go/src/github.com/seaweedfs/
RUN git clone https://github.com/seaweedfs/seaweedfs /seaweedfs \
  --branch "$(cat /version)" --depth 1
WORKDIR /seaweedfs/weed
RUN CGO_ENABLED=0 go install -ldflags "-extldflags -static ${LDFLAGS}"

# FROM docker.io/curlimages/curl:8.17.0 AS curl
# SHELL ["/bin/ash", "-euo", "pipefail", "-c"]
# USER root
# RUN apk --no-cache add grep
# RUN curl --version | grep -oP '(?<=curl )\S+' > /version

# FROM docker.io/alpine:3.22.2 AS healthcheck
# COPY --from=curl /version /version
# RUN apk --no-cache add build-base
# RUN wget "https://curl.se/download/curl-$(cat /version).tar.gz"
# RUN mkdir curl
# RUN tar xzf "curl-$(cat /version).tar.gz" --directory /curl --strip-components 1
# WORKDIR /curl
# RUN LDFLAGS="-static" ./configure --enable-static --without-libpsl --without-ssl
# RUN make -j "$(nproc)" LDFLAGS="-static -all-static"
# RUN strip src/curl

# FROM scratch
# COPY --from=build /go/bin/weed /usr/bin/weed
# COPY --from=healthcheck /curl/src/curl /usr/bin/curl
# EXPOSE 80
# ENTRYPOINT ["/usr/bin/weed", "-logtostderr=true"]
# HEALTHCHECK CMD ["/usr/bin/curl", "--silent", "http://0.0.0.0/healthz"]
# VOLUME ["/tmp"]
