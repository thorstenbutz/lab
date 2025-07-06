#############################################
## System.Management.Automation.PSCredential
#############################################

## A
$credA = Get-Credential
$credA.GetType().FullName
$credA.UserName
$credA.Password

## B
$username = 'contoso\Administrator'
$password = Read-Host -AsSecureString 
## $credB = New-Object -TypeName 'System.Management.Automation.PSCredential' -ArgumentList $username,$password
$credB = [System.Management.Automation.PSCredential]::new($username,$password)
$credB.UserName
$credB.Password


## C
$username = 'contoso\Administrator'
$password = ConvertTo-SecureString -AsPlainText -Force -String 'Pa$$w0rd'
$credC = [PSCredential]::new($username,$password)
$credC.UserName
$credC.Password

####################
## Decrypt password
####################

## D
$net = [System.Net.NetworkCredential]::new($null,$password)
$net.Password

## E
$bString = [Runtime.interopservices.Marshal]::SecureStringToBSTR($password)
[Runtime.interopservices.Marshal]::PtrToStringAuto($bString)

######################################
## Save PW to file, read PW from file
######################################

## F: Convert to encrypted standard string, save to file
$password | ConvertFrom-SecureString | Out-File -FilePath 'vault.txt'

## G: Read from file
$password = Get-Content -Path 'vault.txt' | ConvertTo-SecureString
 

