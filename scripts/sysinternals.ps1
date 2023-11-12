###############################################################################
## Sysinternals Suite
## https://learn.microsoft.com/en-us/sysinternals/downloads/sysinternals-suite
###############################################################################

## Optional: Test WebDAV
(Invoke-WebRequest -uri 'https://live.sysinternals.com' -Method Options).Headers.DAV  ## Should display: 1,2,3 

## Map drive
New-PSDrive -Name s -PSProvider FileSystem -Root '\\live.sysinternals.com@SSL\tools'
Get-PSDrive -Name s | Remove-PSDrive

net use s: 'https://live.sysinternals.com/tools' /persistent:Yes
net use s: /del 