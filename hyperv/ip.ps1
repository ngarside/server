# This is free and unencumbered software released into the public domain.

# Prints the IP address of the VM.

sudo powershell "(Get-VM -Name Server).NetworkAdapters.IPAddresses[0]"
