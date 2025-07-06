##########################################################################################################
# Silent setup PwSh builds:
# Sources:    https://raw.githubusercontent.com/PowerShell/PowerShell/master/tools/install-powershell.ps1
# Short uris: aka.ms/install-powershell.ps1
############################################################################################################ 
 
## Quick'n dirty
iex "& { $(irm https://aka.ms/install-powershell.ps1) } -UseMSI -Preview"
iex "& { $(irm https://aka.ms/install-powershell.ps1) } -UseMSI -Quiet -AddExplorerContextMenu -EnablePSRemoting -Preview"

## Setup PwSh 
 Invoke-RestMethod -uri 'https://aka.ms/install-powershell.ps1' -UseBasicParsing -OutFile 'install-powershell.ps1'
.\install-powershell.ps1 -Quiet -UseMSI -AddExplorerContextMenu -EnablePSRemoting

## Single line
## Invoke-Expression -Command "& { $(Invoke-RestMethod -uri 'https://aka.ms/install-powershell.ps1' -UseBasicParsing) } -UseMSI -Quiet -AddExplorerContextMenu -EnablePSRemoting"

## "Portable" setup - no admin rights required
.\install-powershell.ps1 -Preview -Destination 'c:\ps\ps7preview'

## Uninstall (not recommended, just a demo)
## Get-CimInstance -ClassName Win32_Product -Filter 'name like "PowerShell%"' | Invoke-CimMethod -MethodName Uninstall
