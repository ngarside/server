#!/usr/bin/env python
# This is free and unencumbered software released into the public domain.

# Calculates the name of the given image description:
# - Images are always placed at 'ghcr.io/ngarside/<name>'
# - If the file and root folder have the same name then the image name will be '<file-name>'
# - Otherwise the image name will be '<root-name>-<file-name>'

# Run with 'python namify.py <path>'

import pathlib, sys

def assemble(path):
	# Parse the provided path.
	path = pathlib.Path(path)
	image = path.stem
	service = path.parts[0]

	# If the image and service match then use the short syntax.
	if image == service:
		return image

	# Otherwise use the full syntax.
	return f'{service}-{image}'

if __name__ == '__main__':
	# Assert CLI argument usage.
	if len(sys.argv) != 2:
		print('Usage: python tagify.py <path>')
		sys.exit(2)

	# Build and print the path.
	name = assemble(sys.argv[1])
	print(name)
