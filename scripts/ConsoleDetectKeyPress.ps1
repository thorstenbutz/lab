################################################################
## Read more: Detect key press
## https://powershell.one/tricks/input-devices/detect-key-press
################################################################

do { 
    '. '
    Start-Sleep -Milliseconds 500
}
while (
     [Console]::KeyAvailable -eq $false
)
