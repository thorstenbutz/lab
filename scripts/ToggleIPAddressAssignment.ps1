#######################################################################
## Toggle NIC from DHCPClient/dynamic to static IPv4 address assigment
## v25.02.09
#######################################################################

function Get-IPConfig { 
    param (
        [string] $NIC = 'Ethernet',
        [switch] $TestConnection,
        [string] $IPAddressFamily = 'IPv4'
    )
    process {
        ## Check NIC
        $nicCount = (Get-NetAdapter -Name $NIC -ErrorAction SilentlyContinue | Where-Object Status -EQ 'Up' | Measure-Object).Count
        if ($nicCount -ne 1) { 
            Write-Warning -Message "$NIC not found!" 
            return
        }
        ## Test connectivity
        if ($TestConnection) {
            try { 
                $DNServerTest = (Resolve-DnsName -Name 'dns.google' -ErrorAction Stop) -as [bool]
                $PingTest = Test-Connection -ComputerName 'dns.google' -Count 1 -Quiet
    
            } catch {
                Write-Warning -Message 'Config failed!'
                return
            }
        } else {
            $DNServerTest = $null
            $PingTest = $null
        }
        ## Current config
        [PSCustomObject]@{
            'NIC'             = $NIC
            'IPAddressFamily' = $IPAddressFamily
            'DHCPv4Status'    = (Get-NetIPInterface -InterfaceAlias $NIC -AddressFamily $IPAddressFamily).DHCP
            'IPv4Address'     = (Get-NetIPAddress -InterfaceAlias $nic -AddressFamily $IPAddressFamily).IPAddress
            'PrefixLength'    = (Get-NetIPAddress -InterfaceAlias $nic -AddressFamily $IPAddressFamily).PrefixLength
            'DefaultGateWay'  = (Get-NetRoute -AddressFamily $IPAddressFamily -DestinationPrefix '0.0.0.0/0' -InterfaceAlias $NIC -ErrorAction SilentlyContinue).NextHop
            'DNSServerList'   = (Get-DnsClientServerAddress -InterfaceAlias $nic -AddressFamily $IPAddressFamily).ServerAddresses    
            'DNSServerTest'   = $DNServerTest #-as [bool]
            'PingTest'        = $PingTest 
        }        
    }
}

function Set-IPConfig {
    [CmdletBinding(DefaultParameterSetName = 'Dynamic')]
    param (
        [string] $NIC = 'Ethernet',
        [string] $IPAddressFamily = 'IPv4',

        [Parameter(ParameterSetName = 'Dynamic')]
        [switch] $Dynamic,

        [Parameter(ParameterSetName = 'Static')]
        [switch] $Static,
        
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'Static')]
        [IPAddress] $IPv4Address,
        
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'Static')]
        [int] $PrefixLength,
        
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'Static')]
        [IPAddress] $DefaultGateway,

        [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName = 'Static')]
        [String[]] $DNSServerList # = @('1.1.1.1', '8.8.8.8')
    )
    if ($Dynamic) {
        ## Enable DHCP client 
        'Switching to DHCP client configuration on interface: ' + $nic | Write-Verbose
        Get-NetRoute -DestinationPrefix '0.0.0.0/0' -InterfaceAlias $NIC -ErrorAction SilentlyContinue |
            Remove-NetRoute -Confirm:$false
        Set-NetIPInterface -InterfaceAlias $NIC -Dhcp Enabled
        Set-DnsClientServerAddress -InterfaceAlias $NIC -ResetServerAddresses
        ipconfig.exe /renew $NIC | Out-Null

    } elseif ($Static) {          
        'Switching to Static' | Write-Verbose
        ## Remove config
        ipconfig /release | Out-Null
        Remove-NetIPAddress -InterfaceAlias $NIC -AddressFamily $IPAddressFamily -Confirm:$false -ErrorAction SilentlyContinue
        Remove-NetRoute -Confirm:$false -DestinationPrefix '0.0.0.0/0' -AddressFamily $IPAddressFamily -InterfaceAlias $NIC -ErrorAction SilentlyContinue
        Set-DnsClientServerAddress -InterfaceAlias $NIC -ResetServerAddresses 
        
        ## Set new config
        $tmp = New-NetIPAddress -InterfaceAlias $NIC -IPAddress $IPv4Address -PrefixLength $PrefixLength -DefaultGateway $DefaultGateway      
        Set-DnsClientServerAddress -InterfaceAlias $NIC -ServerAddresses $DNSServerList           
    } else {
        Write-Warning -Message 'Invalid mode: Please choose "Dynamic" or "Static"' 
    }
}

## Action
$currentConfig = Get-IpConfig -NIC 'Wi-Fi' -TestConnection
$currentConfig | Format-Table -AutoSize

## Disable DCHP client 
Set-IPConfig -Dynamic -NIC 'Wi-Fi'

## Enable static IP Address assignment
$setIPConfigSplat = @{
    Static          = $true
    NIC             = 'Wi-Fi'
    IPAddressFamily = 'IPv4'
    IPv4Address     = $currentConfig.IPv4Address
    PrefixLength    = $currentConfig.PrefixLength
    DefaultGateway  = $currentConfig.DefaultGateWay
    DNSServerList   = $currentConfig.DNSServerList
}
Set-IPConfig @setIPConfigSplat

