#!/usr/bin/env python
# This is free and unencumbered software released into the public domain.

# Calculates the tag for a given image definition:
# - If the current ref head or name is 'master', then the tag will be the
#   semantic version (lacking any prefixes or suffixes) of the first base image
#   specified in the provided file, suffixed by the current workflow run number (if set)
# - If the first base image does not use semantic versioning (for example if it is a
#   rolling release image) then the version will default to '0.0.0'
# - Otherwise the tag will be the branch name, sanitized using 'slugify.py'

# Run with 'python tagify.py <path>'

import os, re, sys, slugify

def version(file):
	match = re.search(r'^\s*FROM.*?:[a-z]*([^:\-@\s]*).*$', file, re.MULTILINE)
	if match:
		return match.group(1)
	return '0.0.0'

if __name__ == '__main__':
	# Assert CLI argument usage.
	if len(sys.argv) != 2:
		print('Usage: python tagify.py <path>')
		sys.exit(2)

	# Find the name of the currently checked out ref.
	ref = os.getenv('GITHUB_HEAD_REF') or os.getenv('GITHUB_REF_NAME') or 'master'

	# If the current branch is not the default branch, then return
	# the ref name, sanitized using 'slugify.py'.
	if ref != 'master':
		print(slugify.sanitize(ref))
		sys.exit(0)

	# Otherwise return the semantic version.
	with open(sys.argv[1], 'r') as file:
		tag = version(file.read())
		run = os.getenv('GITHUB_RUN_NUMBER')
		if run is not None:
			tag += f'.{run}'
		print(tag)
