#!/usr/bin/env python
# This is free and unencumbered software released into the public domain.

# Calculates the tag for a given image definition:
# - If the current ref head or name is 'master', then the tag will be the
#   semantic version (lacking any prefixes or suffixes) of the first base image
#   specified in the provided file
# - Otherwise the tag will be the branch name, sanitized using 'slugify.py'

# Run with 'python tagify.py <path>'

import os, re, sys, slugify

def parse_version(file):
	match = re.search(r'^\s*FROM.*:[^\d]*([\.\d]*).*$', file, re.MULTILINE)
	if match:
		return match.group(1)
	return None

if __name__ == '__main__':
	# Assert CLI argument usage.
	if len(sys.argv) != 2:
		print('Usage: python tagify.py <path>')
		sys.exit(2)

	# Find the name of the currently checked out ref.
	ref = os.getenv('GITHUB_HEAD_REF') or os.getenv('GITHUB_REF_NAME')

	# If the current ref is 'master', then return the semantic version.
	if ref == 'master':
		with open(sys.argv[1], 'r') as file:
			print(parse_version(file))
			sys.exit(0)

	# Otherwise return the ref name, sanitized using 'slugify.py'.
	print(slugify.sanitize(ref))
