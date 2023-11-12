###############################################
# Enable Presentation Settings on a Desktop PC
###############################################

# New-Item -path 'Registry::HKEY_CURRENT_USER\Software\Microsoft\MobilePC\MobilityCenter\'
# Set-ItemProperty -Path 'Registry::HKEY_CURRENT_USER\Software\Microsoft\MobilePC\MobilityCenter\' -Name 'RunOnDesktop' -Value 1 -type 'DWORD'
Set-ItemProperty -Path 'Registry::HKEY_CURRENT_USER\Software\Microsoft\MobilePC\AdaptableSettings\' -Name 'SkipBatteryCheck' -Value 1 -type 'DWORD'

PresentationSettings.exe /start
# PresentationSettings.exe /stop
# PresentationSettings.exe 

