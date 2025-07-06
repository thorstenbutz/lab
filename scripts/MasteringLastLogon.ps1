#######################################
## Mastering the "lastLogon" challenge
#######################################

## A: Get users from a specific OU (without RSAT)
$ou = [ADSI]'LDAP://ou=Seattle,dc=contoso,dc=com'
$Domain = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
$Searcher = [System.DirectoryServices.DirectorySearcher]::new()
$Searcher.Searchroot = $Ou 
$Searcher.Filter = "(ObjectCategory=User)"
$Results = $Searcher.FindAll()
$Results

## B: Query example user
$user = [ADSI]'LDAP://CN=Bill Gates,ou=Seattle,dc=contoso,dc=com'
$lastlogon = $user.ConvertLargeIntegerToInt64($user.lastLogon.Value)
$lastlogonTimestamp = $user.ConvertLargeIntegerToInt64($user.lastLogonTimestamp.Value)
$lastlogon, $lastlogonTimestamp

## C: Test the offset: DateTime (ISO 8601/common era) vs. Win32Epoch
$win32Epoch = [System.DateTime]::new(1601,1,1,0,0,0,[DateTimeKind]::UTC)
$ceEpoch = [System.DateTime]::MinValue
$win32Epoch -eq $ceEpoch.AddYears(1600) 


## D: Create DateTime objects

## YOU SHOULD AVOID USING Get-Date HERE. IT WILL CREATE "Unspecified" DATETIME OBJECTS THAT MAY LEAD TO CONFUSION !
# $objLastlogon = (Get-Date -Date $lastlogon).AddYears(1600)  ## is UTC!
# $objLastlogonTimeStamp = (Get-Date -Date $lastlogonTimestamp).AddYears(1600)   ## is UTC!
# $objLastlogon, $objLastlogonTimeStamp | Select-Object -Property Kind,DateTime

## That is the better way:
$objLastlogon = ([System.DateTime]::new($lastlogon,'UTC')).AddYears(1600)
$objLastlogonTimeStamp = ([System.DateTime]::new($lastlogonTimestamp,'UTC')).AddYears(1600)
$objLastlogon, $objLastlogonTimeStamp | Select-Object -Property Kind,DateTime

## E: Display results for example user
[PSCustomObject]@{
    'TimeZone'       = (Get-TimeZone).ID
    'lastLogon' = $Lastlogon    
    'lastLogonUTC' = $objLastlogon    
    'lastLogonLocal' = $objLastlogon.ToLocalTime()
    
    'lastLogonTimeStamp' = $lastlogonTimestamp
    'LastLogonTimeStampUTC'   = $objLastlogonTimeStamp # UTC    
    'lastLogonTimeStampLocal' = $objLastlogonTimeStamp.ToLocalTime()    
}
