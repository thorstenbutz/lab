Get-NetConnectionProfile | Set-NetConnectionProfile -NetworkCategory Private
New-Item -Path c:\ps\training -Force -ItemType Directory
New-SmbShare -Path c:\ps\training -Name training -ReadAccess everyone -ChangeAccess interactive
