#!/usr/bin/env python
# This is free and unencumbered software released into the public domain.

import os, pytest, random, requests, subprocess

name, port = random.sample(range(1025, 65536), 2)

session = requests.Session()
session.mount('http://', requests.adapters.HTTPAdapter(max_retries=10))

@pytest.fixture(autouse=True, scope='session')
def fixture():
	tag = os.getenv('TAG') or 'latest'
	subprocess.run([
		'podman', 'run', '--detach', '--name', f'{name}', '--publish', f'{port}:80',
		'--pull', 'never', f'ghcr.io/ngarside/fossflow:{tag}',
	])
	yield
	subprocess.run(['podman', 'rm', '--force', f'{name}'])

def test_healthcheck():
	status = subprocess.run(['podman', 'healthcheck', 'run', f'{name}'])
	assert status.returncode == 0

def test_root():
	res = session.get(f'http://localhost:{port}')
	assert res.status_code == 200
