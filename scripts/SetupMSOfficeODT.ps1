##################################################################
## Office Deployment Tool
## https://www.microsoft.com/en-us/download/details.aspx?id=49117
## Last change: 2023-11-25
##################################################################

## Get installer file 
$uri ='https://download.microsoft.com/download/2/7/A/27AF1BE6-DD20-4CB4-B154-EBAB8A7D4A7E/officedeploymenttool_16731-20398.exe'       
$installerFile = $env:TEMP + '\' + $uri.Split('/')[-1]
Invoke-RestMethod -UseBasicParsing -Uri $uri -OutFile $installerFile

## Setup ODT
Start-Process -FilePath   $installerFile -Wait -ArgumentList '/quiet /passive /extract:"C:\Program Files\OfficeDeploymentTool"'
Remove-Item -Path $installerFile  # Test-Path -Path $installerFile

## Setup Microsoft Office
# & 'C:\Program Files\OfficeDeploymentTool\setup.exe' /configure 'C:\Program Files\OfficeDeploymentTool\configuration-Office2019Enterprise.xml'
Start-Process -Wait -FilePath 'C:\Program Files\OfficeDeploymentTool\setup.exe' -ArgumentList '/configure "C:\Program Files\OfficeDeploymentTool\configuration-Office2019Enterprise.xml"'
