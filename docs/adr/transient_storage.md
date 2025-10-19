<!-- This is free and unencumbered software released into the public domain -->

# <p align=center>Using Transient Storage For Containers

Containers are run using transient storage for their metadata.

```toml
# /etc/containers/storage.conf

[storage]
transient_store = true
```

# <p align=center>The Problem

As the system reboots fairly often to install updates, it's important that services come
back online quickly. However, by default, Podman will save-then-load the metadata for
previously running containers when restarting the system. This process gets very IO
intensive when running many containers, which significantly slows the time it takes for
the system to boot into a useable state.

# <p align=center>The Solution

As containers are run fully declaratively (via Quadlet) and use read-only root
filesystems, there is no benefit to persisting them across reboots. Therefore, making them
transient - so they are completely forgotten about on shutdown and recreated on bootup -
significantly reduces IO operations and improves startup performance.

# <p align=center>Pitfalls

Using transient storage means that Podman is unable to correctly track previously created
layers across reboots, which can result in these layers become orphaned.

To overcome this is it necessary to run a prune command on every reboot:

```sh
podman system prune --external
```

# <p align=center>References

- [docs.podman.io/en/stable/markdown/podman.1.html#transient-store](
    https://docs.podman.io/en/stable/markdown/podman.1.html#transient-store)
- [docs.podman.io/en/stable/markdown/podman-system-prune.1.html#external](
    https://docs.podman.io/en/stable/markdown/podman-system-prune.1.html#external)
- [redhat.com/en/blog/speed-containers-podman-raspberry-pi](
    https://redhat.com/en/blog/speed-containers-podman-raspberry-pi)
