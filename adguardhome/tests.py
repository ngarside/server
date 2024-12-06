#!/usr/bin/env python

# This is free and unencumbered software released into the public domain.

import dns.resolver, os, pytest, random, requests, string, subprocess, time

@pytest.fixture(autouse=True, scope='session')
def fixture():
	global port_admin, port_dns
	name = ''.join([random.choice(string.ascii_letters) for _ in range(6)])
	port_admin = random.randrange(1000, 64000)
	port_dns = random.randrange(1000, 64000)
	dir = os.path.dirname(os.path.realpath(__file__))
	subprocess.run([
		'docker', 'run', '--detach', '--name', name, '--publish', f'{port_admin}:80',
		'--publish', f'{port_dns}:53', '--volume', f'{dir}/etc:/etc/adguardhome',
		'ghcr.io/ngarside/adguardhome'
	])
	time.sleep(0.1)
	yield
	subprocess.run(['docker', 'rm', '--force', name])

def test_admin_home():
	res = requests.get(f'http://localhost:{port_admin}')
	assert res.status_code == 200

def test_dns_tcp():
	request = dns.message.make_query(qname='example.com', rdtype=dns.rdatatype.ANY)
	dns.query.tcp(q=request, where='127.0.0.1', port=port_dns, timeout=10)
