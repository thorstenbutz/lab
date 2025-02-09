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
& "$PSScriptRoot\PresentationSettingsRegistryBatteryCheck.ps1"

## Profile 
Copy-Item -Path "$PSScriptRoot\..\prefs\profile.ps1" -Destination "$home\Documents"

## $profile.CurrentUserAllHosts
New-Item -ItemType Directory -Path "$home\Documents\WindowsPowerShell\","$home\Documents\PowerShell\"
". $home\Documents\profile.ps1" | Out-File -FilePath "$home\Documents\WindowsPowerShell\profile.ps1"
". $home\Documents\profile.ps1" | Out-File -FilePath "$home\Documents\PowerShell\profile.ps1"

New-Item -ItemType Directory -Path 'c:\depot\tools\bginfo' -Force
# . "$PSScriptRoot\SetupSysinternals.ps1"
. "$PSScriptRoot\SysinternalsSetup.ps1"
GetSysinternalSuite -path 'C:\depot\tools\Sysinternals'

## Sysinternals live ##
$testWebDAV = (Invoke-WebRequest -uri 'https://live.sysinternals.com' -Method Options).Headers.DAV  ## Should display: 1,2,3 
if ($testWebDAV -and !(Test-Path -Path s:)) {
    net use s: 'https://live.sysinternals.com/tools' /persistent:Yes
    New-Item -ItemType Directory -Path c:\depot\tools\Sysinternals -Force -ErrorAction SilentlyContinue
    New-Item -ItemType Directory -Path C:\depot\tools\Bginfo\ -ErrorAction SilentlyContinue
    Get-ChildItem -Path s: -Filter bginfo* | Copy-Item -Destination C:\depot\tools\Bginfo\
    Get-ChildItem -Path s: -Filter zoomit* | Copy-Item -Destination C:\depot\tools\Sysinternals
}
##

AcceptEulaSysinternals 
Copy-Item -Path 'C:\depot\tools\Sysinternals\Bginfo.*' -Destination 'C:\depot\tools\bginfo'
Copy-Item -Path "C:\git\lab\etc\bginfo2.bgi" -Destination 'C:\depot\tools\bginfo'
New-ItemProperty -path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run' -Name 'BGInfo' -Value '"C:\depot\tools\BGInfo\Bginfo.exe" /accepteula /timer:0 c:\depot\tools\BGInfo\bginfo2.bgi'
New-ItemProperty -path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Run' -Name 'Presentation' -Value 'C:\Windows\system32\PresentationSettings.exe /start'
# New-ItemProperty -path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run' -Name 'Presentation' -Value 'C:\Windows\system32\PresentationSettings.exe /start'

if (Test-Path 'c:\git\lab\scripts\Update-InboxApp.ps1') { 
    c:\git\lab\scripts\Update-InboxApp.ps1 -PackageFamilyName 'Microsoft.WindowsTerminal_8wekyb3d8bbwe'
    c:\git\lab\scripts\Update-InboxApp.ps1 -PackageFamilyName 'Microsoft.DesktopAppInstaller_8wekyb3d8bbwe'    
    Copy-Item 'c:\git\lab\etc\wt\wt_settings.json' $env:userprofile\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json
    reg import 'c:\git\lab\etc\wt\wt_DefaultTerminalApplication.reg'
}


New-Item -Path 'c:\ps\training' -Force -ItemType Directory
New-SmbShare -Name 'Training' -Path 'c:\ps\training' -ChangeAccess 'Everyone' -FullAccess 'Interactive'
New-PSDrive -Name T -PSProvider FileSystem -Root "\\$($env:COMPUTERNAME)\training" -Persist

if ((Test-Path c:\al\bginfo.bgi) -and (Test-Path 'C:\git\lab\etc\bginfo2.bgi')) { 
    Copy-Item -Path 'C:\git\lab\etc\bginfo2.bgi' -Destination 'c:\al\bginfo.bgi' -Force
}

c:\git\lab\scripts\SetupMSOffice.ps1

HOSTNAME.EXE
whoami 

