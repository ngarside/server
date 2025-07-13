#!/usr/bin/env python

# This is free and unencumbered software released into the public domain.

import os, pytest, random, requests, string, subprocess, time

session = requests.Session()
session.mount('http://', requests.adapters.HTTPAdapter(max_retries=10))

@pytest.fixture(autouse=True, scope='session')
def fixture():
	global port
	name = ''.join([random.choice(string.ascii_letters) for _ in range(6)])
	port = random.randrange(1000, 64000)
	dir = os.path.dirname(os.path.realpath(__file__))
	subprocess.run([
		'docker', 'run', '--detach', '--name', name, '--publish', f'{port}:80',
		'--volume', f'{dir}:/etc/caddy:ro', 'ghcr.io/ngarside/caddy'
	])
	time.sleep(0.1)
	yield
	subprocess.run(['docker', 'rm', '--force', name])

def test_respond():
	res = session.get(f'http://localhost:{port}')
	assert res.status_code == 200
