# This is free and unencumbered software released into the public domain.

FROM docker.io/gitea/act_runner:0.6.1@sha256:b5c35d6bdbb9bb25e531230bfc7cc663cb751406cbec90a2a891b85fea54de86 AS runner

FROM docker.io/alpine:3.24.1@sha256:28bd5fe8b56d1bd048e5babf5b10710ebe0bae67db86916198a6eec434943f8b AS busybox
SHELL ["/bin/ash", "-euo", "pipefail", "-c"]
RUN apk --no-cache add alpine-sdk grep linux-headers
RUN busybox | { head -n 1; cat >/dev/null; } | grep -oP '(?<=v)[\d\.]+' | sed 's/\./_/g' > /version
RUN git clone https://git.busybox.net/busybox --branch "$(cat /version)" --depth 1
WORKDIR /busybox
RUN make defconfig
RUN sed -i 's/^CONFIG_BASH_IS_NONE=y$/# CONFIG_BASH_IS_NONE is not set/' .config
RUN sed -i 's/^CONFIG_FEATURE_TC_INGRESS=y/# CONFIG_FEATURE_TC_INGRESS is not set/' .config
RUN sed -i 's/^CONFIG_TC=y$/# CONFIG_TC is not set/' .config
RUN sed -i 's/^# CONFIG_BASH_IS_ASH is not set.*$/CONFIG_BASH_IS_ASH=y/' .config
RUN sed -i 's/^# CONFIG_STATIC is not set.*$/CONFIG_STATIC=y/' .config
RUN make -j "$(nproc)"
RUN mkdir /tmp/cp
RUN cp /busybox/busybox /usr/bin/busybox
RUN /usr/bin/busybox --install -s /tmp/cp

FROM docker.io/alpine:3.24.1@sha256:28bd5fe8b56d1bd048e5babf5b10710ebe0bae67db86916198a6eec434943f8b AS local
COPY gitea/src/runner.sh /usr/bin/entrypoint
RUN chmod +x /usr/bin/entrypoint

FROM scratch
COPY --from=busybox /usr/bin/busybox /usr/bin/busybox
COPY --from=busybox /tmp/cp/ /usr/bin/
COPY --from=local /usr/bin/entrypoint /usr/bin/entrypoint
COPY --from=runner /usr/local/bin/act_runner /usr/bin/runner
ENTRYPOINT ["/usr/bin/entrypoint"]
