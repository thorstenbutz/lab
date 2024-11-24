whoami > $NUL ; [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 # Check enconding 


[cultureinfo]::CurrentUICulture = 'en-US'
[cultureinfo]::CurrentCulture = 'en-US'

######################
## Argument completer
###################### 

## AppInstaller/Wnget: https://github.com/microsoft/winget-cli/blob/master/doc/Completion.md
Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
  param($wordToComplete, $commandAst, $cursorPosition)
  [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
  $Local:word = $wordToComplete.Replace('"', '""')
  $Local:ast = $commandAst.ToString().Replace('"', '""')
  winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
    [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
  }
}

Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
  param($wordToComplete, $commandAst, $cursorPosition)
  dotnet complete --position $cursorPosition $commandAst.ToString() | ForEach-Object {
    [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
  }
}

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
          $message = ' '
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