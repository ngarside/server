#!/usr/bin/env python
# This is free and unencumbered software released into the public domain.

# The host port is hardcoded to 9200 as this is required by OpenCloud.
# https://github.com/search?q=repo%3Aopencloud-eu%2Fopencloud%209200&type=code

import os, pytest, random, requests, subprocess, tempfile, time

etc = tempfile.TemporaryDirectory()
name = random.randrange(1025, 65536)

session = requests.Session()
session.mount('http://', requests.adapters.HTTPAdapter(max_retries=10))

@pytest.fixture(autouse=True, scope='session')
def fixture():
	tag = os.getenv('TAG') or 'latest'
	subprocess.run([
		'podman', 'run', '--pull', 'never', '--rm', '--volume', f'{etc.name}:/etc/opencloud',
		f'ghcr.io/ngarside/opencloud:{tag}', 'init', '--insecure', 'no',
	])
	subprocess.run([
		'podman', 'run', '--detach', '--env', 'PROXY_TLS=false', '--name', f'{name}',
		'--publish', '9200:9200', '--pull', 'never', '--volume', f'{etc.name}:/etc/opencloud',
		f'ghcr.io/ngarside/opencloud:{tag}',
	])
	time.sleep(10)
	yield
	subprocess.run(['podman', 'rm', '--force', f'{name}'])

def test_healthcheck():
	status = subprocess.run(['podman', 'healthcheck', 'run', f'{name}'])
	assert status.returncode == 0

def test_home():
	response = session.get('http://localhost:9200', timeout=10)
	assert response.status_code == 200
