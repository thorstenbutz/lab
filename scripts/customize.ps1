#Requires -RunAsAdministrator

function Test-Admin {
    $identity  = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal]::new($identity)
    $principal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

if (!(Test-Admin)) { Write-Warning -Message 'Admin privs required ..'; Read-Host }

## Mouse size
Set-ItemProperty -Path 'HKCU:\Control Panel\Cursors' -Name CursorBaseSize -Value 50
Set-ItemProperty -Path 'Registry::HKEY_USERS\.DEFAULT\Control Panel\Cursors' -Name CursorBaseSize -Value 50

## Presentation Mode
& "C:\git\lab\scripts\PresentationSettingsRegistryBatteryCheck.ps1"

## Profile 
Copy-Item -Path 'C:\git\lab\prefs\profile.ps1' -Destination "$home\Documents"

## $profile.CurrentUserAllHosts
New-Item -ItemType Directory -Path "$home\Documents\WindowsPowerShell\","$home\Documents\PowerShell\"
". $home\Documents\profile.ps1" | Out-File -FilePath "$home\Documents\WindowsPowerShell\profile.ps1"
". $home\Documents\profile.ps1" | Out-File -FilePath "$home\Documents\PowerShell\profile.ps1"

New-Item -ItemType Directory -Path 'c:\depot\tools\bginfo' -Force
. 'C:\git\lab\scripts\SetupSysinternals.ps1'
GetSysinternalSuite -path 'C:\depot\tools\Sysinternals'
AcceptEulaSysinternals 
Copy-Item -Path 'C:\depot\tools\Sysinternals\Bginfo.*' -Destination 'C:\depot\tools\bginfo'
Copy-Item -Path "C:\git\lab\bin\bginfo2.bgi" -Destination 'C:\depot\tools\bginfo'
New-ItemProperty -path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run' -Name 'BGInfo' -Value '"C:\depot\tools\BGInfo\Bginfo.exe" /accepteula /timer:0 c:\depot\tools\BGInfo\bginfo2.bgi'
New-ItemProperty -path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run' -Name 'Presentation' -Value 'C:\Windows\system32\PresentationSettings.exe /start'

