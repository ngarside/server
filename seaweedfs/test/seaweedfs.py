#!/usr/bin/env python
# This is free and unencumbered software released into the public domain.

import boto3, os, pytest, random, subprocess, time

name, port = random.sample(range(1025, 65536), 2)
client = boto3.client(
	's3', aws_access_key_id='abc123', aws_secret_access_key='def456',
	endpoint_url=f'http://localhost:{port}',
)

@pytest.fixture(autouse=True, scope='session')
def fixture():
	dir = os.path.dirname(os.path.realpath(__file__))
	tag = os.getenv('TAG') or 'latest'
	subprocess.run([
		'podman', 'run', '--detach', '--name', f'{name}', '--publish',
		f'{port}:80', '--pull', 'never', '--read-only', '--volume',
		f'{dir}:/etc/seaweedfs:ro', f'ghcr.io/ngarside/seaweedfs:{tag}',
		'server', '-s3', '-s3.config=/etc/seaweedfs/seaweedfs.json',
		'-s3.port=80',
	])
	for _ in range(10):
		try:
			client.create_bucket(Bucket='test')
			break
		except:
			time.sleep(1)
	yield
	subprocess.run(['podman', 'rm', '--force', f'{name}'])

def test_file_touch():
	client.put_object(
		Body=b'',
		Bucket='test',
		Key='empty.txt',
	)

def test_healthcheck():
	status = subprocess.run(['podman', 'healthcheck', 'run', f'{name}'])
	assert status.returncode == 0
