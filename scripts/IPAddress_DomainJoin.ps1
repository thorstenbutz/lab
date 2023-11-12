## Set IP addresses
$ip4 = '192.168.42.101'
$ip6 = 'fd42:a:b:b:a::101'
$defgw4 = '192.168.42.254'$dns = '192.168.42.1','fd42:a:b:b:a::1'
$domain = 'contoso.com'

Get-NetAdapter -Name Ethernet | New-NetIPAddress -IPAddress $ip4 -DefaultGateway $defgw4 -AddressFamily IPv4 -PrefixLength $pl
Get-NetAdapter -Name Ethernet | New-NetIPAddress -IPAddress $ip6 -AddressFamily IPv6 -PrefixLength 64
Get-NetAdapter -Name Ethernet | Set-DnsClientServerAddress -ServerAddresses $dns


# A
# $cred = Get-Credential

# B
$username = 'administrator@contoso.com'
$password = ConvertTo-SecureString -AsPlainText -Force -String 'Pa$$w0rd'
$cred = [System.Management.Automation.PSCredential]::new($username, $password)
Add-Computer -DomainName 'contoso.com' -Credential $cred 