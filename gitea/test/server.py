#!/usr/bin/env python
# This is free and unencumbered software released into the public domain.

import os, pytest, random, requests, subprocess, tempfile, time

etc = tempfile.TemporaryDirectory()
name, port = random.sample(range(1025, 65536), 2)

session = requests.Session()
session.mount('http://', requests.adapters.HTTPAdapter(max_retries=10))

@pytest.fixture(autouse=True, scope='session')
def fixture():
	open(os.path.join(etc.name, 'gitea.tmpl'), 'w').close()
	tag = os.getenv('TAG') or 'latest'
	subprocess.run([
		'podman', 'run', '--detach', '--name', f'{name}', '--publish',
		f'{port}:3000', '--pull', 'never', '--read-only', '--volume',
		f'{etc.name}:/etc/gitea', f'ghcr.io/ngarside/gitea-server:{tag}',
	])
	time.sleep(10)
	yield
	subprocess.run(['podman', 'rm', '--force', f'{name}'])

def test_root():
	response = session.get(f'http://localhost:{port}')
	assert response.status_code == 200
