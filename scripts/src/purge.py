#!/usr/bin/env python
# This is free and unencumbered software released into the public domain.

# Finds and deletes all images from the GitHub container registry which do not
# have any tags corresponding to branches in this repository.

# Finds and deletes all images from the GitHub container registry which do not:
# - Have a semantic version tag
# - Have a tag matching the name of an active branch

# Requires a `GITHUB_TOKEN` environment variable containing a GitHub personal
# access token with the permissions:
# - repo
# - delete:packages

# Run with 'python purge.py'

import datetime, os, re, requests, slugify

def ensure_sucecss(response):
	if response.status_code < 300:
		return
	print('\nExiting due to response error:')
	print(f'\tAddress: {response.url}')
	print(f'\tMethod: {response.request.method}')
	print(f'\tResponse: {response.text}')
	print(f'\tStatus: {response.status_code}')
	exit(1)

def github_delete(url):
	headers = { 'Authorization': f'Bearer {token}' }
	response = requests.delete(url, headers=headers)
	ensure_sucecss(response)

def github_get(url):
	headers = { 'Authorization': f'Bearer {token}' }
	response = requests.get(url, headers=headers)
	ensure_sucecss(response)
	return response.json()

print('Initiating purge of GitHub containers')
cutoff = datetime.datetime.now(datetime.UTC) - datetime.timedelta(days=7)

print('\tReading token from environment')
token = os.getenv('GITHUB_TOKEN')

print('\tRetrieving data from GitHub')
branch_full = github_get('https://api.github.com/repos/ngarside/server/branches')
branch_tags = [slugify.sanitize(branch['name']) for branch in branch_full]
containers = github_get('https://api.github.com/users/ngarside/packages?package_type=container')

print('\nDetected branches:')
for branch in branch_tags:
	print(f'\t{branch}')

for container in containers:
	print(f'\nProcessing {container['name']}:')
	versions = github_get(f'{container['url']}/versions')
	for version in versions:
		sha = version['name'].split(':')[1][:7]
		print(f'\t{sha} | ', end='')
		updated = datetime.datetime.fromisoformat(version['updated_at'])
		tags = version['metadata']['container']['tags']
		if 'latest' in tags:
			print('keep | default branch          ', end='')
		elif any(tag in branch_tags for tag in tags):
			print('keep | active branch ')
		elif len(tags) > 0:
			print('del  | missing branch          ', end='')
			github_delete(f'https://api.github.com/users/ngarside/packages/container/{container['name']}/versions/{version['id']}')
		elif updated > cutoff:
			print('keep | untagged (after cutoff) ', end='')
		else:
			print('del  | untagged (before cutoff)', end='')
			github_delete(f'https://api.github.com/users/ngarside/packages/container/{container['name']}/versions/{version['id']}')
		print(f' | {tags}')

print('\nPurging completed')
