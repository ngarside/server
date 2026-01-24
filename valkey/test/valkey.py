#!/usr/bin/env python
# This is free and unencumbered software released into the public domain.

# This uses the Redis package, as opposed to the Valkey package, to ensure
# compatibility as most applications are currently developed against Redis, not
# Valkey.

import os, pytest, random, redis, string, subprocess, time

name = ''.join([random.choice(string.ascii_letters) for _ in range(6)])

@pytest.fixture(autouse=True, scope='session')
def fixture():
	global port
	port = random.randrange(1025, 65536)
	tag = os.getenv('TAG') or 'latest'
	subprocess.run([
		'podman', 'run', '--detach', '--name', name, '--publish',
		f'{port}:6379', '--pull', 'never', f'ghcr.io/ngarside/valkey:{tag}',
	])
	time.sleep(0.1)
	yield
	subprocess.run(['podman', 'rm', '--force', name])

def test_bytes():
	session = redis.Redis(port=port)
	session.set('foo', 'bar')
	actual = session.get('foo')
	assert actual == b'bar'

def test_healthcheck():
	status = subprocess.run(['podman', 'healthcheck', 'run', name])
	assert status.returncode == 0
