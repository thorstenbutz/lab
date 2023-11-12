$newName = 'cl1'
$newDNSServer = '10.29.111.200'
$p = ConvertTo-SecureString -AsPlainText -Force -String 'Pa$$w0rd'
$c = [System.Management.Automation.PSCredential]::new('Administrator',$p)

## Remove from domain
ipconfig /release
ipconfig /flushdns 
Remove-Computer -WorkgroupName Workgroup -Force

## Join new domain
Start-Sleep -Seconds 5
ipconfig /renew
Set-DnsClientServerAddress -InterfaceAlias Ethernet -ServerAddresses $newDNSServer

if (Test-Connection -ComputerName contoso.com. -Quiet) {
    Add-Computer -DomainName contoso.com -Credential $c -NewName $newName
    Start-Sleep -Seconds 10
    Restart-Computer
}