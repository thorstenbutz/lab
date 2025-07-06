######################################################################################################
## PSReadline and the mystery of the "hidden" PreRelease flag 
## https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/export-formatdata
######################################################################################################

## Standard output lists: ModuleType,Version,PreRelease,Name,PSEdition,ExportedCommands
Get-Module -Name PSReadLine -ListAvailable  

## Lets focus on some properties
Get-Module -Name PSReadLine -ListAvailable  | Select-Object -Property ModuleType,Version,PreRelease,Name ## PSEdition,ExportedCommands

## What about "Prerelease"? 
Get-Module -Name PSReadLine -ListAvailable | Select-Object -Property Name,PreRelease 
Get-Module -Name PSReadLine -ListAvailable | Select-Object -Property Name,ModuleType,Version,{$_.PrivateData.PSData.PreRelease}

## Where are the modules located? 
Get-Module -Name PSReadLine -ListAvailable | Format-List -Property Version,Path,{$_.PrivateData.PSData.PreRelease}

## How do I investigate this? 
Get-FormatData -TypeName  System.Management.Automation.PSModuleInfo | 
   Export-FormatData -Path  System.Management.Automation.PSModuleInfo.ps1xml -IncludeScriptBlock

## Edit the xml file and search for "PreRelease"
psedit  System.Management.Automation.PSModuleInfo.ps1xml   