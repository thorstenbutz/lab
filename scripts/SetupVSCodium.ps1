##############################
## Automated setup: VSCodium
## https://vscodium.com/
## Last cahange: 2024-10-17
##############################

## Get asset
$account = 'VSCodium'
$repo = 'VSCodium'
$latest = "https://api.github.com/repos/$account/$repo/releases/latest"
[string] $msiDownloadUri = ((Invoke-RestMethod -Uri $latest).assets.browser_download_url -like '*.msi') -notlike '*update*'
[string] $msiChecksum = ((Invoke-RestMethod -Uri $latest).assets.browser_download_url -like '*.msi.sha256') -notlike '*update*'

## Download
$installerFile = $env:TEMP + '\' + $msiDownloadUri.split('/')[-1]
$checksumFile =  $env:TEMP + '\' + $msiChecksum.split('/')[-1]

Invoke-RestMethod -Uri $msiDownloadUri -OutFile $installerFile 
Invoke-RestMethod -Uri $msiChecksum -OutFile $checksumFile

## Check downloads
# Test-Path -Path $installerFile
# Test-Path -Path $checksumFile

$checksumA = (Get-Content -Path $checksumFile).split(' ')[0]
$checksumB = (Get-FileHash -Algorithm SHA256 -Path $installerFile).Hash

if ($checksumA -ne $checksumB) { 
    Write-Warning -Message 'Checksum verification failed!'
    return
}

## Setup VSCodium
$arguments = '/passive'
Start-Process -FilePath $installerFile  -ArgumentList $arguments -Wait

## Install PowerShell extension
$codium = 'C:\Program Files\VSCodium\bin\codium.cmd'
& $codium   --install-extension 'ms-vscode.powershell' --force
& $codium --list-extensions --show-versions

