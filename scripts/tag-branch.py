#!/usr/bin/env python
# This is free and unencumbered software released into the public domain.

# Converts the git branch name, as provided by the GitHub Actions runtime, to a
# container tag using the rules:
# - If the branch name is 'master', then the tag will be 'latest'
# - Otherwise the tag will be the branch name, sanitized using 'tag-sanitize.py'

# Run with 'python tag-branch.py'

import importlib.util, os, sys

if __name__ == '__main__':
	# Assert CLI argument usage.
	if len(sys.argv) != 1:
		print('Usage: python tag-branch.py')
		sys.exit(2)

	# Find the sanitizer module.
	parent = os.path.dirname(os.path.realpath(__file__))
	path = os.path.join(parent, 'tag-sanitize.py')
	spec = importlib.util.spec_from_file_location('sanitize', path)
	module = importlib.util.module_from_spec(spec)

	# Load the sanitizer module.
	try:
		spec.loader.exec_module(module)
	except SystemExit:
		pass

	# Find and transform the branch name.
	refHead = os.getenv('GITHUB_HEAD_REF')
	refName = os.getenv('GITHUB_REF_NAME')
	tag = module.sanitize(refHead or refName)
	print('latest' if tag == 'master' else tag)
