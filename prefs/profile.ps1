function countdown {
    [CmdletBinding()]
    [Alias('☕')]
    param (
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
        Find-Module -Name PSTimers | Install-Module -Force
    }
    finally {
        Stop-PSCountdownTimer -WarningAction SilentlyContinue -Confirm:$false
        Start-PSCountdownTimer  -Message $message -Seconds $seconds -OnTop -FontFamily 'Cascadia Light' -Position $halign,140 -FontSize 99 -Color red
        if ($MyInvocation.InvocationName -like 'Kaffeepause*' -or $MyInvocation.InvocationName -like '☕*') { "Eo☕" }
    }
}
New-Alias -Name 'Kaffeepause' -Value 'countdown' # ☕

# if ((Get-Module -Name PSReadLine).Version -ge 2.2.6) { Set-PSReadLineOption -PredictionSource None }
& { Set-PSReadLineOption -PredictionSource None } 2> $NUL
Set-Location -path c:\
Clear-Host