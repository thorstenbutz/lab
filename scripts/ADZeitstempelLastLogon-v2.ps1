##########################################
## Active Directory-Zeitstempel umrechnen
## https://www.epochconverter.com/ldap
##########################################
$result = Get-ADDomainController -Filter * | ForEach-Object -Process {
    $dc = $_.name
    Get-ADUser -Filter { lastlogon -gt 0 } -Properties 'LastlogonDate','lastLogon','lastLogonTimestamp' -Server $dc | 
    Select-Object -Property 'Name','LastlogonDate','lastLogon','lastLogonTimestamp',@{
            l = 'lastLogon(hr)'
            e = { [System.DateTime]::FromFileTime($_.lastlogon) }
        },
        @{
            l = 'lastLogonTimestamp(hr)'
            e = { [System.DateTime]::FromFileTime($_.lastLogonTimestamp) }
        },@{
            l = 'DC'
            e = { $dc }
        } | Sort-Object -Property LastlogonDate -Descending 
} 

$result | Group-Object -Property Name | ForEach-Object -Process { 
    $_.Group | Sort-Object -Property LastLogon -Descending | Select-Object -First 1    
} | Out-GridView