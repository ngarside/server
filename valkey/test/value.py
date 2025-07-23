#!/usr/bin/env python

# This is free and unencumbered software released into the public domain.

import pytest, random, string, subprocess, time, valkey

@pytest.fixture(autouse=True, scope='session')
def fixture():
	global port
	name = ''.join([random.choice(string.ascii_letters) for _ in range(6)])
	port = random.randrange(1000, 64000)
	subprocess.run([
		'docker', 'run', '--detach', '--name', name, '--publish',
		f'{port}:6379', '--pull', 'never', 'ghcr.io/ngarside/valkey',
	])
	time.sleep(3)
	yield
	# subprocess.run(['docker', 'rm', '--force', name])

def test_respond():
	r = valkey.Valkey(host='localhost', port=port, db=0)
	r.set('foo', 'bar')
	b = r.get('foo')
	assert b == b'bar'
