#!/usr/bin/env python
# This is free and unencumbered software released into the public domain.

import os, pytest, random, requests, subprocess, tempfile, time

name, port = random.sample(range(1025, 65536), 2)

session = requests.Session()
session.mount('http://', requests.adapters.HTTPAdapter(max_retries=10))

@pytest.fixture(autouse=True, scope='session')
def fixture():
	dir = tempfile.mkdtemp()
	tag = os.getenv('TAG') or 'latest'
	subprocess.run([
		'podman', 'run', '--detach', '--name', f'{name}', '--publish',
		f'{port}:80', '--pull', 'never', '--volume', f'{dir}:/var/lib/memos',
		f'ghcr.io/ngarside/memos:{tag}',
	])
	time.sleep(0.1)
	yield
	subprocess.run(['podman', 'rm', '--force', f'{name}'])

def test_healthcheck():
	status = subprocess.run(['podman', 'healthcheck', 'run', f'{name}'])
	assert status.returncode == 0

def test_root():
	res = session.get(f'http://localhost:{port}')
	assert res.status_code == 200
