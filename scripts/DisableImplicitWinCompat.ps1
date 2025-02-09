####################################################################################################################################################################################
## Managing implicit module loading: "DisableImplicitWinCompat"
## https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_windows_powershell_compatibility?view=powershell-7.5#managing-implicit-module-loading
####################################################################################################################################################################################

#Requires -Version 7.0

## Create backup file
Copy-Item -Path "$PSHOME\powershell.config.json" -Destination "$PSHOME\powershell.config.json.bak"

## Display content
Get-Content -Path "$PSHOME\powershell.config.json"

## Update Content
Get-Content -Path "$PSHOME\powershell.config.json" | 
  ConvertFrom-Json | 
  Add-Member -MemberType NoteProperty -Name DisableImplicitWinCompat -Value $true -PassThru | 
  ConvertTo-Json |
  Set-Content -Path  "$PSHOME\powershell.config.json"

## Restore backup
Copy-Item -Path "$PSHOME\powershell.config.json.bak" -Destination "$PSHOME\powershell.config.json"