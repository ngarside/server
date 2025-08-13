<!-- This is free and unencumbered software released into the public domain -->

# <p align=center>Dependency Automerge

Documenting the rationale for which dependencies are automatically merged.

# <p align=center>Containers (Post Version 1)

> Always automerge minor updates.

The semantic versioning specification dictates that minor upgrades for stable
versions (`>= 1.0.0`) are always backwards compatible. It should therefore be
safe to automerge all minor updates for container files (`*.container`).

Note that this rule is overridden for certain container files (see sections
below).

# <p align=center>Containers (Pre Version 1)

> Always automerge patch updates.

The semantic versioning specification allows any unstable versions (`< 1.0.0`)
to contain backwards incompatible changes. However, in practice, backwards
incompatible changes are always limited to minor versions. It should therefore
be safe to automerge all patch updates for container files (`*.container`) with
versions `< 1.0.0`.

# <p align=center>Containers (Calender Versioning)

> Always automerge patch updates.

The calendar versioning specification does not have strict requirements on when
breaking changes are allowed, but in practice all projects utilising it only
allow breaking changes in major and minor versions. It should therefore be safe
to automerge all patch updates for container files (`*.container`) which utilise
calendar versioning.

# <p align=center>Images

> Always automerge all updates.

Published container images (`*.dockerfile`) are not automatically used anywhere.
Rather, the decision of whether or not to upgrade to a new image is done in the
`*.container` files. Holding back an image upgrade would prevent `*.container`
files from upgrading to that version (both automatically and manually).
Therefore, the images should always be updated so that the `*.container` files
have the option of upgrading to them.

# <p align=center>Images (Fedora)

> Always automerge minor updates.

The Fedora base images do not follow semver, in the sense that unstable major
versions do not have any suffixes, and are therefore indistinguishable from
stable versions. Fedora base images are also consumed directly by the base
system (using automatic upgrades within the OS), which differentiates them from
the other images which are only consumed indirectly. Therefore it is only safe
to automerge minor updates for images based on Fedora.

# <p align=center>Python

> Always automerge all updates.

Python scripts are well tested and are exclusively used in CI/CD pipelines.
There is therefore little risk of an incompatible update getting through, and
even if one did the consequences would be minimal.

# <p align=center>Workflows

> Always automerge all updates.

Workflow dependencies are simple and automatically tested simply by being run.
They are also (obviously) exclusively used in CI/CD. There is therefore little
risk of an incompatible update getting through, and even if one did the
consequences would be minimal.

# References

- [calver.org](https://calver.org)
- [quay.io/organization/fedora](https://quay.io/organization/fedora)
- [semver.org](https://semver.org)
