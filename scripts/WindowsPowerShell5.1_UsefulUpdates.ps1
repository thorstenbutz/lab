#################################
## Windows PowerShell 5.1
## Useful updates as of May 2024
#################################

## Update help files in the background
Start-Job -ScriptBlock { Update-Help -UICulture en-US -Force }
## Get-Job | Wait-Job | Receive-Job # -Keep

## Add NuGet to package providers
Get-PackageProvider  ## MSI,MSU,powerShellGet,Programs
Install-PackageProvider -Name NuGet -Force

## Trust the PSGallery 
Set-PackageSource -Name PSGallery -Trusted

## Update PowerShellGet
Get-Module -Name PowerShellGet -ListAvailable   # v1.0.0.1 
Install-Module PowerShellGet -AllowClobber -Force # v.2.2.5

## Update PSReadline 
Get-Module -Name PSReadLine -ListAvailable # 2.0.0
Get-Module -Name PSReadLine -ListAvailable | Select-Object -Property ModuleType, Version, Name, Modulebase  
Find-Module -Name PSReadline  ## v.2.3.5
Install-Module -Name PSReadline -Scope AllUsers -Force

## PwSh 7 provides a new parameter "AllowPrerelease"
## Find-Module -Name PSReadline -AllowPrerelease

## Configure (updated) PSReadline options
Get-PSReadLineOption | Select-Object -Property Prediction*,History*
Set-PSReadLineOption -PredictionSource History  ## Does not work in ISE
Set-PSReadLineOption -PredictionSource None

