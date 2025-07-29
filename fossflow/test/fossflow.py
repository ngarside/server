#!/usr/bin/env python

# This is free and unencumbered software released into the public domain.

import pytest, random, requests, string, subprocess

session = requests.Session()
session.mount('http://', requests.adapters.HTTPAdapter(max_retries=10))

@pytest.fixture(autouse=True, scope='session')
def fixture():
	global port
	name = ''.join([random.choice(string.ascii_letters) for _ in range(6)])
	port = random.randrange(1000, 64000)
	subprocess.run([
		'podman', 'run', '--detach', '--name', name, '--publish', f'{port}:80',
		'--pull', 'never', 'ghcr.io/ngarside/fossflow'
	])
	yield
	subprocess.run(['podman', 'rm', '--force', name])

def test_root():
	res = session.get(f'http://localhost:{port}')
	assert res.status_code == 200
