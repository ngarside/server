#!/usr/bin/env python
# This is free and unencumbered software released into the public domain.

import os, pytest, random, subprocess

name = random.randrange(1025, 65536)

@pytest.fixture(autouse=True, scope='session')
def fixture():
	tag = os.getenv('TAG') or 'latest'
	subprocess.run([
		'podman', 'run', '--detach', '--name', f'{name}', '--pull', 'never',
		'--read-only', f'ghcr.io/ngarside/alpine:{tag}', 'sleep', '10s',
	])
	yield
	subprocess.run(['podman', 'rm', '--force', f'{name}'])

def test_healthcheck():
	status = subprocess.run(['podman', 'healthcheck', 'run', f'{name}'])
	assert status.returncode == 0

def test_whoami():
	result = subprocess.run(['podman', 'exec', f'{name}', 'whoami'], capture_output=True, text=True)
	assert result.stdout == 'root\n'
