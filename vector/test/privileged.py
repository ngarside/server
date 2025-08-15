#!/usr/bin/env python

# This is free and unencumbered software released into the public domain.

import os, pytest, random, requests, subprocess

name, port = random.sample(range(1025, 65536), 2)

dir = os.path.dirname(os.path.realpath(__file__))
tag = os.getenv('TAG') or 'latest'
image = f'ghcr.io/ngarside/vector-privileged:{tag}'

session = requests.Session()
session.mount('http://', requests.adapters.HTTPAdapter(max_retries=10))

has_image = subprocess.run(['podman', 'image', 'inspect', image]).returncode
pytestmark = pytest.mark.skipif(has_image != 0, reason=f'Image not found')

@pytest.fixture(autouse=True, scope='session')
def fixture():
	subprocess.run([
		'podman', 'run', '--detach', '--name', f'{name}', '--pull', 'never',
		'--read-only', '--volume',
		f'{dir}/vector.toml:/etc/vector/vector.toml:ro', image, '--config',
		'/etc/vector/vector.toml',
	])
	yield
	subprocess.run(['podman', 'rm', '--force', f'{name}'])

def test_healthcheck():
	status = subprocess.run(['podman', 'healthcheck', 'run', f'{name}'])
	assert status.returncode == 0
