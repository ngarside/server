# This is free and unencumbered software released into the public domain.

# Boots the VM if it is currently powered off.

param (
	[Parameter(Mandatory=$true)][string]$name
)

sudo powershell "Start-VM -Name $name"
