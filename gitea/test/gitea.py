#!/usr/bin/env python
# This is free and unencumbered software released into the public domain.

import os, pytest, random, requests, subprocess, time

name, port = random.sample(range(1025, 65536), 2)

session = requests.Session()
session.mount('http://', requests.adapters.HTTPAdapter(max_retries=10))

@pytest.fixture(autouse=True, scope='session')
def fixture():
	dir = os.path.dirname(os.path.realpath(__file__))
	tag = os.getenv('TAG') or 'latest'
	subprocess.run([
		'podman', 'run', '--detach', '--name', f'{name}', '--publish',
		f'{port}:3000', '--pull', 'never', '--read-only',
		f'ghcr.io/ngarside/gitea:{tag}',
	])
	time.sleep(10)
	yield
	subprocess.run(['podman', 'rm', '--force', f'{name}'])

def test_root():
	response = session.get(f'http://localhost:{port}')
	assert response.status_code == 303
