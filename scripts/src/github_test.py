#!/usr/bin/env python
# This is free and unencumbered software released into the public domain.

# Finds and deletes all images from the GitHub container registry which do not
# have any tags corresponding to branches in this repository.

import pprint, requests, slugify

headers = { 'Authorization': f'Bearer {token}'}

def github_get(url):
	response = requests.get(url, headers=headers)
	response.raise_for_status()
	return response.json()

packages = github_get('https://api.github.com/users/ngarside/packages?package_type=container')

branches_full = github_get('https://api.github.com/repos/ngarside/server/branches')
branch_tags = [slugify.sanitize(branch['name']) for branch in branches_full]
branch_tags = [tag.replace('master', 'latest') for tag in branch_tags]
pprint.pprint(branch_tags)

for package in packages:
	print(package['url'])
	versions = github_get(f'{package['url']}/versions')
	for version in versions:
		print(version['name'])
		tags = version['metadata']['container']['tags']
		print(tags)
		if 'latest' in tags:
			print('  keep - master')
		elif any(tag in branch_tags for tag in tags):
			print('  keep - active branch')
		elif len(tags) > 0:
			print('  branch tag missing - should be deleted')
		else:
			print('  untagged - should be deleted')
	break
