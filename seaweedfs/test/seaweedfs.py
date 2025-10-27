#!/usr/bin/env python
# This is free and unencumbered software released into the public domain.

import boto3, os, pytest, random, subprocess, time

BUCKET_NAME = 'my-bucket'

name, port = random.sample(range(1025, 65536), 2)
port = 8333

@pytest.fixture(autouse=True, scope='session')
def fixture():
	global client
	tag = os.getenv('TAG') or 'latest'
	subprocess.run([
		'podman', 'run', '--detach', '--name', f'{name}', '--publish',
		f'{port}:8333', '--pull', 'never', f'ghcr.io/ngarside/seaweedfs:{tag}',
		'server', '-s3',
	])
	for _ in range(10):
		try:
			client = boto3.client(
				's3',
				aws_access_key_id='',
				aws_secret_access_key='',
				endpoint_url=f'http://localhost:{port}',
			)
			client.create_bucket(Bucket=BUCKET_NAME)
			break
		except:
			time.sleep(1)
	yield
	subprocess.run(['podman', 'rm', '--force', f'{name}'])

def test_bucket_list():
	bucket = client.list_buckets()['Buckets'][0]
	assert bucket['Name'] == BUCKET_NAME
