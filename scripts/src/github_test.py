#!/usr/bin/env python
# This is free and unencumbered software released into the public domain.

# Finds and deletes all images from the GitHub container registry which do not
# have any tags corresponding to branches in this repository.

import requests, slugify


def github_get(url):
	headers = { 'Authorization': f'Bearer {token}' }
	response = requests.get(url, headers=headers)
	response.raise_for_status()
	return response.json()

print('Initiating purge of GitHub containers')

branches_full = github_get('https://api.github.com/repos/ngarside/server/branches')
branch_tags = [slugify.sanitize(branch['name']) for branch in branches_full]

print(f'\nDetected branches:')
for branch in branch_tags:
	print(f'\t{branch}')

containers = github_get('https://api.github.com/users/ngarside/packages?package_type=container')

for container in containers:
	print(f'\nProcessing {container["name"]}:')
	versions = github_get(f'{container['url']}/versions')
	for version in versions:
		sha = version['name'].split(':')[1][:7]
		print(f'\t{sha} | ', end='')
		tags = version['metadata']['container']['tags']
		if 'latest' in tags:
			print('keep | default branch')
		elif any(tag in branch_tags for tag in tags):
			print('keep | active branch')
		elif len(tags) > 0:
			print('del  | missing branch')
		else:
			print('del  | untagged')
	break

print('\nPurging completed')
