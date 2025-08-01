﻿#!/usr/bin/env python

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
	tag = os.getenv('TAG') or 'latest'
	subprocess.run([
		'podman', 'run', '--detach', '--name', name, '--publish', f'{port}:80',
		'--pull', 'never', '--volume', f'{dir}:/etc/caddy:ro',
		f'ghcr.io/ngarside/caddy:{tag}',
	])
	time.sleep(0.1)
	yield
	subprocess.run(['podman', 'rm', '--force', name])

def test_respond():
	res = session.get(f'http://localhost:{port}')
	assert res.status_code == 200
