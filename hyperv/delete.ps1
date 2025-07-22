# This is free and unencumbered software released into the public domain.

sudo run powershell @"
	Remove-VM -Name Server -Force

	Remove-Item -Force -Path F:\Server -Recurse
"@

