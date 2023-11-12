###########################################
## create a random password (a simple way) 
###########################################

## What characters will be used? 
$pool = @()
$pool += 65..90  | % { [char]$_ }   # upper case letters
$pool += 97..122 | % { [char]$_ }   # lower case letters
$pool += 0..9 
$pool += '!','?','#','ü','ä'

## Create the password
$random = $pool | Get-Random -Count 10

## Create a string
$stringPassword = [string]::Join('',$random) 
$stringPassword

## You can also query a web service (if you trust them) 
Invoke-RestMethod -UseBasicParsing -Uri 'https://www.passwordrandom.com/query?command=password'