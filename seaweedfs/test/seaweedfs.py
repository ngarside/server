#!/usr/bin/env python
# This is free and unencumbered software released into the public domain.

import contextlib, os, psycopg, pytest, random, string, subprocess, time, io, boto3

# @pytest.fixture(autouse=True, scope='session')
# def fixture():
# 	global session
# 	name = ''.join([random.choice(string.ascii_letters) for _ in range(6)])
# 	port = random.randrange(1025, 65536)
# 	tag = os.getenv('TAG') or 'latest'
# 	subprocess.run([
# 		'podman', 'run', '--detach', '--env', 'POSTGRES_DB=postgres', '--env',
# 		'POSTGRES_PASSWORD=postgres', '--env', 'POSTGRES_USER=postgres',
# 		'--name', name, '--publish', f'{port}:5432', '--pull',
# 		'never', f'ghcr.io/ngarside/seaweedfs:{tag}', 'server', '-s3',
# 	])
# 	for _ in range(100):
# 		try:
# 			session = psycopg.connect(
# 				host='localhost',
# 				port=port,
# 				user='postgres',
# 				password='postgres',
# 			)
# 		except:
# 			time.sleep(0.1)
# 	yield
# 	subprocess.run(['podman', 'rm', '--force', name])

# def test_select():
# 	with contextlib.closing(session) as conn:
# 		with conn.cursor() as cur:
# 			cur.execute('select 1')
# 			assert cur.fetchone()[0] == 1

BUCKET_NAME = "your-bucket-name"
OBJECT_KEY = "example/test_file.bin"

# def upload_bytes(data: bytes):
# 	s3 = boto3.client("s3")
# 	file_obj = io.BytesIO(data)
# 	s3.upload_fileobj(file_obj, BUCKET_NAME, OBJECT_KEY)
# 	print(f"Uploaded {len(data)} bytes to s3://{BUCKET_NAME}/{OBJECT_KEY}")

ENDPOINT_URL = "http://localhost:8333"  # SeaweedFS S3 API endpoint
ACCESS_KEY = "your-access-key"           # configured in SeaweedFS (default: usually empty)
SECRET_KEY = "your-secret-key"           # configured in SeaweedFS (default: usually empty)
BUCKET_NAME = "my-bucket"
OBJECT_KEY = "example/in_memory_test.bin"

if __name__ == "__main__":
	s3_client = boto3.client(
		"s3",
		endpoint_url=ENDPOINT_URL,
		aws_access_key_id=ACCESS_KEY,
		aws_secret_access_key=SECRET_KEY,
	)
	paginator = s3_client.get_paginator("list_buckets")
	response_iterator = paginator.paginate(
		PaginationConfig={
			"PageSize": 50,  # Adjust PageSize as needed.
			"StartingToken": None,
		}
	)

	buckets_found = False
	for page in response_iterator:
		if "Buckets" in page and page["Buckets"]:
			buckets_found = True
			for bucket in page["Buckets"]:
				print(f"\t{bucket['Name']}")

	if not buckets_found:
		print("No buckets found!")

	# Example byte array
	# example_data = b"Hello, S3 in-memory upload and download!"

	# upload_bytes(example_data)

	# # downloaded_data = download_bytes()
	# # print("Downloaded content:", downloaded_data.decode())
