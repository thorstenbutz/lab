######################
## Sysinternals Suite
######################

<#  TESTING
    ## Registry
    Get-ChildItem -Path 'HKCU:\SOFTWARE\Sysinternals' | Where-Object -FilterScript { $_.Property -contains 'EulaAccepted' }  | ForEach-Object -Process {"'" +  $_.PSChildName + "'" } 

    ## Start every app to check EULA dialog
    Get-ChildItem -Path '.\Sysinternals' -Filter '*.exe' | ForEach-Object -Process { Start-Process -FilePath $_.Fullname # -Wait }
#>

function GetSysinternalSuite {
    param (
        [string] $path = '.\Sysinternals'
    )

    ## Create folder 
    if (!(Test-Path -Path $path)) { 
        New-Item -ItemType Directory -Path $path | Out-Null
    }

    ## Download suite
    $uri = 'https://download.sysinternals.com/files/SysinternalsSuite.zip'
    Invoke-RestMethod -UseBasicParsing -Uri $uri -OutFile $uri.split('/')[-1] 
    Expand-Archive -Path $uri.split('/')[-1] -DestinationPath $path -Force
    Remove-Item -Path  $uri.split('/')[-1] 
    
    ## Set path variable
    if ([Environment]::GetEnvironmentVariable('Path','User') -like "*$path*") {
        """$path"" already in PATH variable. No change needed."
    } else {            
        [Environment]::SetEnvironmentVariable(
          'Path',
          [Environment]::GetEnvironmentVariable('Path', [EnvironmentVariableTarget]::User) + ';' + (Get-Item -Path $path).Fullname,
          [EnvironmentVariableTarget]::User        # System wide:   [EnvironmentVariableTarget]::Machine
        )
    }
}

## Accept EULA
function AcceptEulaSysinternals {
    $toolsAlt = @(
        'AccessChk'
        'AccessEnum'
        'AdExplorer'
        'AdInsight'
        'AdRestore'
        'Autologon'
        'Autoruns'
        'BgInfo'
        'BlueScreen'
        'CacheSet'
        'ClockRes'
        'Contig'
        'Coreinfo'
        'Ctrl2cap'
        'DebugView'
        'Desktops'
        'Disk Usage'
        'Disk2vhd'
        'DiskExt'
        'Diskmon'
        'DiskView'
        'EFSDump'
        'Handle'
        'Hex2dec'
        'Junction'
        'LDMDump'
        'ListDLLs'
        'LiveKd'
        'LoadOrder'
        'LogonSessions'
        'MoveFile'
        'NTFSInfo'
        'PageDefrag'
        'PendMoves'
        'PipeList'
        'PortMon'
        'ProcDump'
        'Process Explorer'
        'Process Monitor'
        'ProcFeatures'
        'PsExec'
        'PsFile'
        'PsGetSid'
        'PsInfo'
        'PsKill'
        'PsList'
        'PsLoggedOn'
        'PsLogList'
        'PsPasswd'
        'PsService'
        'PsShutdown'
        'PsSuspend'
        'PsTools'
        'RAMMap'
        'RegDelNull'
        'RegJump'
        'RootkitRevealer'
        'SDelete'
        'ShareEnum'
        'ShellRunas'
        'Sigcheck'
        'Streams'
        'Strings'
        'Sync'
        'TCPView'
        'VMMap'
        'VolumeId'
        'Whois'
        'WinObj'
        'ZoomIt'
        'Active Directory Explorer'
    )

    $tools = @(
        'AccessChk'
        'Active Directory Explorer'
        'ADInsight'
        'AdRestore'
        'Autologon'
        'AutoRuns'
        'BGInfo'
        'CacheSet'
        'ClockRes'
        'Contig'
        'Coreinfo'
        'CPUSTRES'
        'Ctrl2cap'
        'DbgView'
        'Desktops'
        'Disk2Vhd'
        'DiskExt'
        'Diskmon'
        'DiskView'
        'EFSDump'
        'FindLinks'
        'Handle'
        'Hex2Dec'
        'Junction'
        'LdmDump'
        'ListDLLs'
        'LiveKd'
        'LoadOrder'
        'LogonSessions'
        'Movefile'
        'NotMyFault'
        'NTFSInfo'
        'PageDefrag'
        'PendMove'
        'PipeList'
        'Portmon'
        'ProcDump'
        'Process Explorer'
        'Process Monitor'
        'PsExec'
        'PsFile'
        'PsGetSid'
        'PsInfo'
        'PsKill'
        'PsList'
        'PsLoggedon'
        'PsLoglist'
        'PsPasswd'
        'PsPing'
        'PsService'
        'PsShutdown'
        'PsSuspend'
        'RamMap'
        'RegDelNull'
        'Regjump'
        'Regsize'
        'SDelete'
        'Share Enum'
        'ShellRunas - Sysinternals: www.sysinternals.com'
        'sigcheck'
        'Streams'
        'Strings'
        'Sync'
        'TCPView'
        'VMMap'
        'VolumeID'
        'Whois'
        'ZoomIt'   
)

    foreach ($tool in $tools) {
        Write-Verbose -Message $tool
        ## Best effort: trying to set the key ignoring/discarding any output
        & {
            reg.exe ADD "HKCU\Software\Sysinternals\$tool" /v EulaAccepted /t REG_DWORD /d 1 /f 
            reg.exe ADD "HKU\.DEFAULT\Software\Sysinternals\$tool" /v EulaAccepted /t REG_DWORD /d 1 /f 
        } *> $null
        
    }
}

## Do it!
# GetSysinternalSuite 
# AcceptEulaSysinternals 

## Start toools
# .\Sysinternals\procexp.exe -t 
# .\Sysinternals\ZoomIt.exe /? 