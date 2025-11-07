#!/usr/bin/env python
# This is free and unencumbered software released into the public domain.

# Calculates the path of the test file for the given image path.

# Run with 'python testify.py <path>'

import pathlib, sys

def assemble(path):
	# Parse the provided path.
	path = pathlib.Path(path)
	image = path.stem
	service = path.parts[0]

	# Build the test file path.
	return f'{service}/test/{image}.py'

if __name__ == '__main__':
	# Assert CLI argument usage.
	if len(sys.argv) != 2:
		print('Usage: python testify.py <path>')
		sys.exit(2)

	# Build and print the path.
	path = assemble(sys.argv[1])
	print(path)
