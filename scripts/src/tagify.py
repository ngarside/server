#!/usr/bin/env python
# This is free and unencumbered software released into the public domain.

# Converts the git branch name, as provided by the GitHub Actions runtime, to a
# container tag using the rules:
# - If the branch name is 'master', then the tag will be 'latest'
# - Otherwise the tag will be the branch name, sanitized using 'slugify.py'

# Run with 'python tagify.py'

import os, sys, slugify
import re


def parse_version(file):
	match = re.search(r'^FROM.*:[^\d]*([\.\d]*).*$', file)
	if match:
		return match.group(1)
		if line.startswith('ARG VERSION='):
			return line.split('=')[1].strip()

if __name__ == '__main__':
	# Assert CLI argument usage.
	if len(sys.argv) != 1:
		print('Usage: python tagify.py')
		sys.exit(2)

	# Find and transform the branch name.
	refHead = os.getenv('GITHUB_HEAD_REF')
	refName = os.getenv('GITHUB_REF_NAME')
	tag = slugify.sanitize(refHead or refName)
	print('latest' if tag == 'master' else tag)
