######################
## Updating (Win)PS 5 
######################

## Prerequisites
Install-PackageProvider -Name NuGet -Force
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

## Update PSReadline (Windows PowerShell 5.1)
Install-Module -Name PSReadline -Scope AllUsers -Force

## Update PowershellGet (Windows PowerShell 5.1)
Install-Module PowerShellGet -AllowClobber -Force

## PSReadline: Toggle "ListView" and "InlineView": F2
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -PredictionSource None ## Default: History

## PSReadline: Get command history 
$PSReadlineOptions = Get-PSReadLineOption
Get-Content -Path $PSReadlineOptions.HistorySavePath 