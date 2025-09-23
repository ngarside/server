# This is free and unencumbered software released into the public domain.

if [[ "$USER" != "root" ]]; then
	echo "Script must be run as superuser; exiting"
	exit 1
fi

qemu-img create -f qcow2 /var/lib/libvirt/images/server-root.qcow2 64G
qemu-img create -f qcow2 /var/lib/libvirt/images/server-data.qcow2 512G

XML="$(dirname $BASH_SOURCE[0])/config.xml"
virsh define "$XML"
