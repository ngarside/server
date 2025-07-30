#!/usr/bin/env python
# This is free and unencumbered software released into the public domain.

# Sanitizes container tags by echoing the first CLI argument with alterations:
# - Replaces invalid characters with underscores
# - Trims boundary underscores
# - Merges consecutive underscores
# - Defaults to a single underscore if the tag contains no valid characters

# Run with 'python slugify.py <tag>'

import re, sys

def sanitize(tag):
	# Replace invalid characters with underscores.
	tag = re.sub(r'[^a-zA-Z0-9_.-]+', '_', tag)

	# Trim boundary underscores.
	tag = re.sub(r'^[_]+(?=[^_])', '', tag)
	tag = re.sub(r'(?<=[^_])[_]+$', '', tag)

	# Ensure the result is not empty.
	return tag if tag else '_'

if __name__ == '__main__':
	if len(sys.argv) != 2:
		print('Usage: python slugify.py <tag>')
		sys.exit(2)
	print(sanitize(sys.argv[1]))
	sys.exit(0)
