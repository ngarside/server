# This is free and unencumbered software released into the public domain.

FROM docker.io/alpine:latest@sha256:4bcff63911fcb4448bd4fdacec207030997caf25e9bea4045fa6c8c44de311d1 AS build

RUN apk add execline git

# gitea --version | grep -oE [0-9]+.[0-9]+.[0-9]+
RUN wget -O gitea https://dl.gitea.com/gitea/1.24.3/gitea-1.24.3-linux-amd64
RUN chmod +x gitea

RUN echo "gitea:x:100:101::/usr/bin/data/home:/sbin/nologin" >> /tmp/passwd

# Pattern is required to copy symbolic links to the new image
# https://stackoverflow.com/a/66823636
RUN mkdir /tmp/cp
RUN cp -a /usr/bin/exec /tmp/cp/exec
RUN cp -a /usr/bin/git-receive-pack /tmp/cp/git-receive-pack
RUN cp -a /usr/bin/git-receive-pack /tmp/cp/git-upload-archive
RUN cp -a /usr/bin/git-receive-pack /tmp/cp/git-upload-pack

FROM scratch

COPY --from=build /usr/share/git-core/templates/ /usr/share/git-core/templates/

COPY --from=build /gitea /usr/bin/gitea

COPY --from=build /usr/bin/execline /usr/bin/execline

COPY --from=build /usr/bin/git /usr/bin/git

COPY --from=build /lib/ld-musl-x86_64.so.1 /lib/ld-musl-x86_64.so.1

COPY --from=build /usr/lib/libpcre2-8.so.0 /usr/lib/libpcre2-8.so.0

COPY --from=build /usr/lib/libz.so.1 /usr/lib/libz.so.1

COPY --from=build /usr/lib/libexecline.so.2.9.7.0 /usr/lib/libexecline.so.2.9

COPY --from=build /usr/lib/libskarnet.so.2.14.4.0 /usr/lib/libskarnet.so.2.14

COPY --from=build /lib/ld-musl-x86_64.so.1 /lib/ld-musl-x86_64.so.1

COPY --from=build /tmp/passwd /etc/passwd

COPY --from=build /tmp/cp/ /usr/bin/

USER gitea

EXPOSE 80

ENTRYPOINT ["/usr/bin/gitea"]

CMD ["web", "--config", "/usr/bin/data/etc/gitea.ini", "--port", "80"]
