<!-- This is free and unencumbered software released into the public domain -->

# <p align=center>Using Transient Storage For Containers

Containers are run using transient storage for their root volumes.

```sh
# /etc/containers/storage.conf

[storage]
transient_store = true
```

# <p align=center>The Problem

As the system reboots fairly often to install updates, it's important that services come back online quickly. However, by default, Podman will save then load previously running containers when restarting the system. This process gets very IO intensive when running many containers, which significantly slows down the time it takes for the system to boot into a useable state.

# <p align=center>The Solution

As containers are always run using read-only root filesystems, there is no reason to persist storage across reboots. Therefore, making the storage transient - so it is never reloaded on boot - significantly reduces IO operations on startup.

# <p align=center>Pitfalls

Using transient storage means that Podman is unable to correctly track previously created layers across reboots, which can result in these layers become orphaned.

To overcome this is it necessary to run a prune command on every reboot.

```sh
podman system prune --external
```

# <p align=center>References

- [redhat.com/en/blog/speed-containers-podman-raspberry-pi](
    https://redhat.com/en/blog/speed-containers-podman-raspberry-pi)
- [docs.podman.io/en/stable/markdown/podman.1.html#transient-store](
    https://docs.podman.io/en/stable/markdown/podman.1.html#transient-store)
- [docs.podman.io/en/stable/markdown/podman-system-prune.1.html#external](
    https://docs.podman.io/en/stable/markdown/podman-system-prune.1.html#external)
