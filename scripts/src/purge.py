#!/usr/bin/env python
# This is free and unencumbered software released into the public domain.

# Finds and deletes all images from the GitHub container registry which do not:
# - Have a semantic version tag and were created since the cutoff date
# - Have a tag matching the name of an active branch

# Requires a `GITHUB_TOKEN` environment variable containing a GitHub personal
# access token with the permissions:
# - repo
# - delete:packages

# Run with 'python purge.py'

import dataclasses, datetime, dotenv, os, re, requests, slugify

@dataclasses.dataclass
class Container():
	name: str
	repository: str | None
	url: str

@dataclasses.dataclass
class Version:
	hash: str
	id: str
	tags: list[str]
	updated: datetime.datetime

def ensure_success(response):
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
	response = requests.delete(f'https://api.github.com/{url}', headers=headers)
	ensure_success(response)

def github_get(url):
	headers = { 'Authorization': f'Bearer {token}' }
	response = requests.get(f'https://api.github.com/{url}', headers=headers)
	ensure_success(response)
	return response.json()

def is_semantic(tag):
	match = re.match(r'^\d+(\.\d+)*$', tag)
	return match is not None

def to_container(container):
	name = container['name']
	repository = container['repository'].get('full_name') if 'repository' in container else None
	url = container['url'][len("https://api.github.com/"):]
	return Container(name, repository, url)

def to_version(version):
	hash = version['name'].split(':')[1][:7]
	id = version['id']
	tags = version['metadata']['container']['tags']
	updated = datetime.datetime.fromisoformat(version['updated_at'])
	return Version(hash, id, tags, updated)

if __name__ == '__main__':
	print('Initiating purge of GitHub containers')
	cutoff = datetime.datetime.now(datetime.UTC) - datetime.timedelta(days=30)

	print('\tReading environment files')
	dotenv.load_dotenv()

	print('\tReading token from environment')
	token = os.getenv('GITHUB_TOKEN')
	if token is None or len(token) == 0:
		print('\tEnvironment variable GITHUB_TOKEN empty or unset; exiting')
		exit(1)

	print('\tRetrieving data from GitHub')
	branch_full = github_get('repos/ngarside/server/branches')
	branch_tags = [slugify.sanitize(branch['name']) for branch in branch_full]
	containers = [to_container(c) for c in github_get('users/ngarside/packages?package_type=container')]

	print('\nDetected branches:')
	for branch in branch_tags:
		print(f'\t{branch}')

	for container in containers:
		print(f'\nProcessing {container.name}:')
		if container.repository is None:
			print('\tPackage does not belong to any repository; skipping')
			continue
		if container.repository != 'ngarside/server':
			print('\tPackage belongs to another repository; skipping')
			continue
		versions = [to_version(v) for v in github_get(f'{container.url}/versions')]
		if len(versions) == 1:
			print('\tPackage only has one version; skipping')
			continue
		for version in versions:
			print(f'\t{version.hash} | ', end='')
			if any(is_semantic(tag) for tag in version.tags) and version.updated > cutoff:
				print('keep | recent semver ', end='')
			elif any(tag in branch_tags for tag in version.tags):
				print('keep | active branch ', end='')
			else:
				if any(is_semantic(tag) for tag in version.tags):
					print('del  | legacy semver ', end='')
				elif len(version.tags) > 0:
					print('del  | missing branch', end='')
				elif len(version.tags) == 0:
					print('del  | untagged      ', end='')
				github_delete(f'users/ngarside/packages/container/{container.name}/versions/{version.id}')
			print(f' | {version.tags}')

	print('\nPurging completed')
