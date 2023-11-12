#################################################
## HOWTO: Display classic context menu in Win 11
#################################################
 
<# 
    CMD style
    reg.exe add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve

    /ve = Add empty value
    /d  = data 
    /f  = force

    taskkill /f /im explorer.exe
#>


## GET
$baseFolder = 'HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}'
$path = 'HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32'

Get-Item -Path $basefolder
Get-Item -Path $path

## Add/Set
New-Item -Path $path -Force -Value ''

## Restart Explorer
Get-Process -Name explorer | Stop-Process
Get-Command -Noun *process