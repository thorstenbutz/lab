########################################################################################################
## Trouble with Win32_Product
## https://xkln.net/blog/please-stop-using-win32product-to-find-installed-software-alternatives-inside/
########################################################################################################

## A: Check event log records
$xmlfilter = @'
<QueryList>
  <Query Id="0" Path="Application">
    <Select Path="Application">*[System[Provider[@Name='MsiInstaller'] and TimeCreated[timediff(@SystemTime) &lt;= 3600000]]]</Select>
  </Query>
</QueryList>
'@

$records = Get-WinEvent -FilterXml $xmlfilter
$records | Format-List -Property TimeCreated,Id,Logname,Message 
"Number of records: " + $records.count

## B: Query Win32_Product
$wmiData = Get-CimInstance -ClassName Win32_Product
$wmiData


