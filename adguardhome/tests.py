#!/usr/bin/env python

# This is free and unencumbered software released into the public domain.

import pytest, random, requests, string, subprocess

@pytest.fixture(autouse=True)
def fixture():
	global port
	name = ''.join([random.choice(string.ascii_letters) for _ in range(6)])
	port = random.randrange(1000, 64000)
	subprocess.run([
		'docker', 'run', '--detach', '--name', name,
		'--publish', f'{port}:80', 'ghcr.io/ngarside/adguardhome'
	])
	yield
	subprocess.run(['docker', 'rm', '--force', name])

def test_admin_home():
	res = requests.get(f'http://localhost:{port}')
	assert res.status_code == 200
