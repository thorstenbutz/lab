####################
## Implict Remoting
####################

## Create Credentials object
$cred = [System.Management.Automation.PSCredential]::new('adminstrator@contoso.com', (ConvertTo-SecureString -AsPlainText -Force -String 'Pa$$w0rd'))
Test-WSMan -ComputerName 'sea-dc1' -Credential $cred -Authentication Kerberos

## Active Directory
$psSession1 = New-PSSession -ComputerName 'sea-dc1' -Credential $cred
Invoke-Command -Session $psSession1 -ScriptBlock { Get-ADDomain }

## "Proxy" 
$ProxyModule1 = Import-PSSession -Session $psSession1 -Module ActiveDirectory 
Get-ADDomain

## Exchange 
$PSSession2 = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri 'http://sea-mx1.contoso.com/PowerShell/' -Credential $cred -Authentication Kerberos
$ProxyModule2 = Import-PSSession $PSSession2
Get-Mailbox

## Clean up
Remove-Module -Name $ProxyModule1,$ProxyModule2
Remove-PSSession -Session $psSession1, $psSession2