# This is free and unencumbered software released into the public domain.

# Deletes the VM if it exists.

sudo powershell @"
	Remove-VM -Name Server -Force

	Remove-VMSwitch "Server Switch"

	Remove-Item -Force -Path F:\Server -Recurse
"@
