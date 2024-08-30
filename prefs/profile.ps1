function countdown {
    [CmdletBinding()]
    [Alias('☕')]
    param (
      [int] $minutes,
      [int] $seconds = 10 ,
      [int] $halign = 1120
    )
        if ($MyInvocation.InvocationName -like 'Kaffeepause*' -or $MyInvocation.InvocationName -like '☕*') {
          $message = '☕'
          $halign -= 160
        } 
        else {
          $message = ''
        }  
    try {
        Import-Module -Name PSTimers -ErrorAction Stop
    } 
    catch {
        Set-PackageSource -Name PSGallery -Trusted 
        if (!(Get-PackageProvider -Name nuget -Force | ? Version -ge 2.8.5.201)) {            
            Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force | Out-Null            
        }
        Find-Module -Name PSTimers | Install-Module -Force -scope CurrentUser
    }
    finally {
        Stop-PSCountdownTimer -WarningAction SilentlyContinue -Confirm:$false
        if ($minutes) { $seconds = $minutes * 60 }
        Start-PSCountdownTimer  -Message $message -Seconds $seconds -OnTop -FontFamily 'Cascadia Light' -Position $halign,140 -FontSize 99 -Color red
        if ($MyInvocation.InvocationName -like 'Kaffeepause*' -or $MyInvocation.InvocationName -like '☕*') { "Eo☕" }
    }
}
New-Alias -Name 'Kaffeepause' -Value 'countdown' # ☕
return

# if ((Get-Module -Name PSReadLine).Version -ge 2.2.6) { Set-PSReadLineOption -PredictionSource None }
& { Set-PSReadLineOption -PredictionSource None } 2> $NUL
Set-Location -path c:\
Clear-Host