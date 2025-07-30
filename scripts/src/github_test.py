#!/usr/bin/env python
# This is free and unencumbered software released into the public domain.

# Finds and deletes all images from the GitHub container registry which do not
# have any tags corresponding to branches in this repository.

import datetime, os, requests, slugify

def github_get(url):
	headers = { 'Authorization': f'Bearer {token}' }
	response = requests.get(url, headers=headers)
	response.raise_for_status()
	return response.json()

print('Initiating purge of GitHub containers')
cutoff = datetime.datetime.now(datetime.UTC) - datetime.timedelta(days=7)

print('\tReading token from environment')
token = os.getenv('GITHUB_TOKEN')

print('\tRetrieving data from GitHub')
branch_full = github_get('https://api.github.com/repos/ngarside/server/branches')
branch_tags = [slugify.sanitize(branch['name']) for branch in branch_full]
containers = github_get('https://api.github.com/user/packages?package_type=container')

print(f'\nDetected branches:')
for branch in branch_tags:
	print(f'\t{branch}')

for container in containers:
	print(f'\nProcessing {container["name"]}:')
	versions = github_get(f'{container['url']}/versions')
	for version in versions:
		sha = version['name'].split(':')[1][:7]
		print(f'\t{sha} | ', end='')
		updated = datetime.datetime.fromisoformat(version['updated_at'])
		tags = version['metadata']['container']['tags']
		if 'latest' in tags:
			print('keep | default branch')
		elif any(tag in branch_tags for tag in tags):
			print('keep | active branch')
		elif len(tags) > 0:
			print('del  | missing branch')
		elif updated > cutoff:
			print('keep | untagged (after cutoff)')
		else:
			print('del  | untagged (before cutoff)')

print('\nPurging completed')
