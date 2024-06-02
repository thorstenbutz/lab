##################################################################################################
# Silent setup of current VSCode builds:
# Sources: https://github.com/PowerShell/vscode-powershell/blob/master/scripts/Install-VSCode.ps1
##################################################################################################

## A: Simple Download/Setup 
Install-Script -name 'Install-VSCode' -Scope AllUsers
## Set-Location -path "$($env:ProgramFiles)\WindowsPowerShell\Scripts\"
Install-VSCode.ps1 -Architecture '64-bit' -BuildEdition Stable-System -EnableContextMenus -AdditionalExtensions 'ms-vscode.powershell' ,'ms-vscode-remote.remote-wsl','ms-vscode.azure-account','ms-vsliveshare.vsliveshare','mechatroner.rainbow-csv','cweijan.vscode-office'

## B: Splattting
$params = @{
    BuildEdition = 'Stable-System'
    Architecture = '64-bit'
    LaunchWhenDone = $true
    EnableContextMenus = $true
    AdditionalExtensions = 'ms-vscode.powershell' ,'ms-vscode-remote.remote-wsl','ms-vscode.azure-account','ms-vsliveshare.vsliveshare','mechatroner.rainbow-csv','cweijan.vscode-office'
}

Install-VSCode.ps1 @params

## C: Manual setup
Function Get-RedirectedURI {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory,ValueFromPipelineByPropertyName,ValueFromPipeline)]
        [String]$URI
    )
    process {
        $request = [System.Net.WebRequest]::Create($URI)
        $request.AllowAutoRedirect=$false
        $response=$request.GetResponse()

        If ($response.StatusCode -eq 'Found') {
            $response.GetResponseHeader('Location')
        }
        else {
            Write-Warning -Message 'No location header found in response.'
        }
    }
}

$uri = Get-RedirectedURI -URI 'https://update.code.visualstudio.com/latest/win32-x64/stable'
Invoke-WebRequest -UseBasicParsing -Uri $uri -OutFile $uri.Split('/')[-1] 

# Setup main program
$setupFile = (Get-Item -Path $uri.Split('/')[-1]).Fullname # Get the full path .. 
Start-Process -FilePath  $setupFile -ArgumentList '/verysilent /tasks=addcontextmenufiles,addcontextmenufolders,addtopath' -Wait

# Manage extensions
$code = 'C:\Program Files\Microsoft VS Code\bin\code.cmd'
& $code --install-extension 'ms-vscode.powershell' --force 
& $code --install-extension 'ms-vscode-remote.remote-wsl' --force
& $code --install-extension 'ms-vscode.azure-account' --force
& $code --install-extension 'mechatroner.rainbow-csv' --force
& $code --install-extension 'cweijan.vscode-office' --force
& $code --list-extensions
& $code --uninstall-extension 'ms-vscode.powershell' --force
