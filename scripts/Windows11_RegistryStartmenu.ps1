####################################
## Die Registry "manipulieren"
## Hintergrund: PowerShell-Provider
####################################

Get-PSProvider
Get-PSDrive -PSProvider FileSystem
Get-PSDrive -PSProvider Registry

Get-Item -Path 'c:\ps'
Get-ChildItem -Path 'c:\ps' -File

Get-Item -Path 'HKCU:\Software'
Get-ChildItem -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
Get-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
Get-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'TaskbarAl'

# Linksbündiges Startmenü
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'TaskbarAl' -Value 0

# Zentriertes Startmenü
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'TaskbarAl' -Value 1

# Falls der Wert (noch) nicht existiert
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'TaskbarAl' -Value 0 -PropertyType DWORD

# Löschen des Wertes
Remove-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'TaskbarAl' 