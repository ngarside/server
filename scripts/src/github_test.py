#!/usr/bin/env python
# This is free and unencumbered software released into the public domain.

import pprint, requests, tag_sanitize

headers = { 'Authorization': f'Bearer {token}'}

def github_get(url):
	response = requests.get(url, headers=headers)
	response.raise_for_status()
	return response.json()

packages = github_get('https://api.github.com/users/ngarside/packages?package_type=container')

branches_full = github_get('https://api.github.com/repos/ngarside/server/branches')
branch_tags = [tag_sanitize.sanitize(branch['name']) for branch in branches_full]
branch_tags = [tag.replace('master', 'latest') for tag in branch_tags]
pprint.pprint(branch_tags)

for package in packages:
	print(package['url'])
	versions = github_get(f'{package['url']}/versions')
	for version in versions:
		print(version['name'])
		tags = version['metadata']['container']['tags']
		if len(tags) == 0:
			print('  untagged - should be deleted')
		elif not any(tag in branch_tags for tag in tags):
			print('  branch tag missing - should be deleted')
	break
