#!/usr/bin/env python

# This is free and unencumbered software released into the public domain.

import os, pytest, random, requests, string, subprocess

name, port = random.sample(range(1000, 64000), 2)

session = requests.Session()
session.mount('http://', requests.adapters.HTTPAdapter(max_retries=10))

@pytest.fixture(autouse=True, scope='session')
def fixture():
	dir = os.path.dirname(os.path.realpath(__file__))
	tag = os.getenv('TAG') or 'latest'
	subprocess.run([
		'podman', 'run', '--detach', '--name', f'{name}', '--publish',
		f'{port}:8686', '--pull', 'never', '--read-only', '--volume',
		f'{dir}/vector.toml:/etc/vector/vector.toml:ro',
		f'ghcr.io/ngarside/vector:{tag}', '--config', '/etc/vector/vector.toml'
	])
	yield
	subprocess.run(['podman', 'rm', '--force', f'{name}'])

def test_api():
	res = session.get(f'http://localhost:{port}/health')
	assert res.status_code == 200

def test_healthcheck():
	status = subprocess.run(['podman', 'healthcheck', 'run', f'{name}'])
	assert status.returncode == 0
