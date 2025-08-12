<!-- This is free and unencumbered software released into the public domain -->

# <p align=center>Mounting Certificates In Containers

Some containers mount the host's certificate store.

```sh
# Quadlet '*.container' file.
# ...

Volume=/etc/pki/ca-trust/extracted/pem:/etc/pki/ca-trust/extracted/pem:ro
```

# <p align=center>The Problem

Containers inheriting from `scratch` do not contain any `ca-certificates` (or
similar) package. This means that they cannot verify TLS certificates, which in
turn prevents them from calling out to any HTTPS addresses.

# <p align=center>The Solution

Mounting the host's certificate store allows containers to use the host's
certificates for TLS. This bypasses the need for `ca-certificates` to be
installed inside the container.

This requires enabling the `container_read_certs` SELinux boolean to allow
containers to read files labelled as `cert_t`.

# <p align=center>Discounted Alternatives

Baking certificates into the containers would bloat their size and require
updates whenever certificates are added or removed.

Installing `ca-certificates` into the container would require switching to an
`alpine` base image and making the root filesystem read-write. This would
significantly bloat their size and increase their attack surface.

Disabling HTTPS is a security risk and in some cases would require patching
applications which do not support HTTP.

# <p align=center>References

- [github.com/alexcrichton/openssl-probe/blob/main/src/lib.rs](
    https://github.com/alexcrichton/openssl-probe/blob/main/src/lib.rs)
- [github.com/containers/podman/discussions/18703#discussioncomment-6013076](
    https://github.com/containers/podman/discussions/18703#discussioncomment-6013076)
- [go.dev/src/crypto/x509/root_linux.go](https://go.dev/src/crypto/x509/root_linux.go)
