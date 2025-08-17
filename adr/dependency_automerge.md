<!-- This is free and unencumbered software released into the public domain -->

# <p align=center>Dependency Automerge

Documenting the rationale for which dependencies are automatically merged.

# <p align=center>Containers (Post Version 1)

> Always automerge minor updates.

```json
{
	"automerge": true,
	"automergeStrategy": "squash",
	"matchCurrentVersion": "!/^0/",
	"matchFileNames": [
		"**/*.container",
		"!**/authentik_server.container",
		"!**/authentik_worker.container",
		"!**/cloudflared.container",
		"!**/youtrack.container"
	],
	"matchUpdateTypes": ["minor", "patch", "pin", "digest"]
}
```

The semantic versioning specification dictates that minor upgrades for stable
versions (`>= 1.0.0`) are always backwards compatible. It should therefore be
safe to automerge all minor updates for container files (`*.container`).

Note that this rule is overridden for certain container files (see sections
below).

# <p align=center>Containers (Pre Version 1)

> Always automerge patch updates.

```json
{
	"automerge": true,
	"automergeStrategy": "squash",
	"matchCurrentVersion": "/^0/",
	"matchFileNames": ["**/*.container"],
	"matchUpdateTypes": ["patch", "pin", "digest"]
}
```

The semantic versioning specification allows any unstable versions (`< 1.0.0`)
to contain backwards incompatible changes. However, in practice, backwards
incompatible changes are always limited to minor versions. It should therefore
be safe to automerge all patch updates for container files (`*.container`) with
versions `< 1.0.0`.

# <p align=center>Containers (Calender Versioning)

> Always automerge patch updates.

```json
{
	"automerge": true,
	"automergeStrategy": "squash",
	"matchFileNames": [
		"**/authentik_server.container",
		"**/authentik_worker.container",
		"**/cloudflared.container",
		"**/youtrack.container"
	],
	"matchUpdateTypes": ["patch", "pin", "digest"]
}
```

The calendar versioning specification does not have strict requirements on when
breaking changes are allowed, but in practice all projects utilising it only
allow breaking changes in major and minor versions. It should therefore be safe
to automerge all patch updates for container files (`*.container`) which utilise
calendar versioning.

# <p align=center>Images

> Always automerge all updates.

```json
{
	"automerge": true,
	"automergeStrategy": "squash",
	"matchFileNames": [
		"**/*.dockerfile",
		"!**/ostree.dockerfile"
	]
}
```

Published container images (`*.dockerfile`) are not automatically used anywhere.
Rather, the decision of whether or not to upgrade to a new image is done in the
`*.container` files. Holding back an image upgrade would prevent `*.container`
files from upgrading to that version (both automatically and manually).
Therefore, the images should always be updated so that the `*.container` files
have the option of upgrading to them.

# <p align=center>Images (Fedora)

> Always automerge minor updates.

```json
{
	"automerge": true,
	"automergeStrategy": "squash",
	"matchFileNames": ["**/ostree.dockerfile"],
	"matchUpdateTypes": ["minor", "patch", "pin", "digest"]
}
```

Fedora base images are consumed directly by the base system (using automatic
upgrades within the OS), which differentiates them from the other images which
are only consumed indirectly. As Fedora utilises semantic versioning it is
therefore safe to automerge minor updates for images based on Fedora.

```json
{
	"enabled": false,
	"matchFileNames": ["**/ostree.dockerfile"],
	"matchUpdateTypes": ["major"]
}
```

While Fedora iteself utilises semantic versioning, the Fedora base images do not
follow it correctly, in the sense that unstable major versions do not have any
suffixes. This makes them indistinguishable from stable versions. Upgrading
through major versions therefore needs to be explicitly disabled.

# <p align=center>Python

> Always automerge all updates.

```json
{
	"automerge": true,
	"automergeStrategy": "squash",
	"matchFileNames": ["pyproject.toml"]
}
```

Python scripts are well tested and are exclusively used in CI/CD pipelines.
There is therefore little risk of an incompatible update getting through, and
even if one did the consequences would be minimal.

# <p align=center>Workflows

> Always automerge all updates.

```json
{
	"automerge": true,
	"automergeStrategy": "squash",
	"matchFileNames": [".github/workflows/*.yml"]
}
```

Workflow dependencies are simple and automatically tested simply by being run.
They are also (obviously) exclusively used in CI/CD. There is therefore little
risk of an incompatible update getting through, and even if one did the
consequences would be minimal.

# References

- [calver.org](https://calver.org)
- [quay.io/organization/fedora](https://quay.io/organization/fedora)
- [semver.org](https://semver.org)
