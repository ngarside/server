podman run \
	--publish 9200:9200 \
	--rm \
	--volume ${PWD}/config:/etc/opencloud:U,Z \
	--volume ${PWD}/data:/var/lib/opencloud:U,Z \
	docker.io/opencloudeu/opencloud:2.0.4

	# --read-only \
	# --security-opt no-new-privileges \
	# --userns auto:size=8 \
	# docker.io/opencloudeu/opencloud:2.0.4 init --insecure yes
