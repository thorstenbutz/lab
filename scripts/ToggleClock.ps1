function ToggleSystrayClock { 
    param ( 
        [switch] $RestoreToDefault
    )
   
    $Path = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\'
    $Name = 'ShowSystrayDateTimeValueName'    
    [int] $Value = (Get-ItemProperty -Path $Path -Name $Name).$Name
    
    Set-ItemProperty -Path $Path -Name $Name -Value (($Value + 1) % 2)
}

# ToggleSystrayClock