# Mounting Certificates In Containers

Some containers mount the host's certificate store.

```sh
# Quadlet '*.container' file.
# ...

Volume=/etc/pki/ca-trust/extracted/pem:/etc/pki/ca-trust/extracted/pem:O
```

# The Problem

Containers inheriting from `scratch` do not contain any `ca-certificates` (or
similar) package. This means that they cannot verify TLS certificates, which in
turn prevents them from calling out to any HTTPS addresses.

# The Solution

Mounting the host's certificate store allows containers to use the host's
certificates for TLS. This bypasses the need for `ca-certificates` to be
installed inside the container.

# Discounted Alternatives

Baking certificates into the containers would bloat their size and require
updates whenever certificates are added or removed.

Installing `ca-certificates` into the container would require switching to an
`alpine` base image and making the root filesystem read-write. This would
significantly bloat their size and increase their attack surface.

Disabling HTTPS is a security risk and in some cases would require patching
applications which do not support HTTP.

# Using OverlayFS

The `O` flag mounts the folder as an overlay filesystem. This is necessary to
work around the fact that the `/etc/pki` directory is labelled as `cert_t`, and
therefore can't be read by rootless containers.

However, this means that the volume overlay is writeable, as OverlayFS doesn't
have a read-only mode.

This also means that the entire `/etc/pki/ca-trust/extracted/pem` directory
needs to be mounted, rather than just the required
`/etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem` file, as OverlayFS only
works with directories.

This also means the `/etc/pki/ca-trust/extracted/pem` directory must be mounted,
rather than the `/etc/pki/tls/certs` directory, as files in the latter are
symlinks to files in the former, and therefore can't be read if the former
directory isn't mounted.

# References

- [go.dev/src/crypto/x509/root_linux.go](https://go.dev/src/crypto/x509/root_linux.go)
