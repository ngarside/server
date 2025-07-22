# This is free and unencumbered software released into the public domain.

# Opens the VM's homepage in the default browser.

$IP = sudo powershell "(Get-VM -Name Server).NetworkAdapters.IPAddresses[0]"

Start-Process "http://$IP/adguardhome"
