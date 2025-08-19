# This is free and unencumbered software released into the public domain.

# Shuts down the VM if it is currently running.

param (
	[Parameter(Mandatory=$true)][string]$name
)

sudo powershell "Stop-VM -Name $name"
