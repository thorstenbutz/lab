##################################################################
## Office Deployment Tool
## https://www.microsoft.com/en-us/download/details.aspx?id=49117
## Last change: 2024-11-01
##################################################################

## A: Get ODT via AppInstallerCLI/WinGet
## winget install --id Microsoft.OfficeDeploymentTool

## B: Get ODT manually (URI may require an update)
## (Try to) Get direct download URI
$iwrData = Invoke-WebRequest -UseBasicParsing -Uri 'https://www.microsoft.com/en-us/download/details.aspx?id=49117'
$uri = $iwrData.Links.where({ $_.href -like 'https://download.microsoft.com/download*officedeploymenttool*.exe' }).href
$uri | Write-Host -ForegroundColor Yellow

## EXMAPLE URI
## $uri = 'https://download.microsoft.com/download/2/7/A/27AF1BE6-DD20-4CB4-B154-EBAB8A7D4A7E/officedeploymenttool_18129-20030.exe'
$installerFile = $env:TEMP + '\' + $uri.Split('/')[-1]
Invoke-RestMethod -UseBasicParsing -Uri $uri -OutFile $installerFile

## Setup ODT
Start-Process -FilePath $installerFile -Wait -ArgumentList '/quiet /passive /extract:"C:\Program Files\OfficeDeploymentTool"'
Remove-Item -Path $installerFile  # Test-Path -Path $installerFile

## C: Run ODT
## Setup Microsoft Office
# & 'C:\Program Files\OfficeDeploymentTool\setup.exe' /configure 'C:\Program Files\OfficeDeploymentTool\configuration-Office2021Enterprise.xml'
# Start-Process -Wait -FilePath 'C:\Program Files\OfficeDeploymentTool\setup.exe' -ArgumentList '/configure "C:\Program Files\OfficeDeploymentTool\configuration-Office2021Enterprise.xml"'
# $configFile = "$PSScriptRoot\configuration-Office2021Enterprise.xml"
$configFile = "$PSScriptRoot\configuration-Office2024Enterprise.xml"

if (Test-Path -Path $configFile) { 
    Start-Process -Wait -FilePath 'C:\Program Files\OfficeDeploymentTool\setup.exe' -ArgumentList "/configure $configFile"
} else { 
    Write-Warning -Message "MS Office config file not found: $configFile"
}