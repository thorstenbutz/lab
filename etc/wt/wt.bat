whoami 
hostname
echo '------------'
copy  \\sea-dc1\training\wt\wt_settings.json  %userprofile%\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json
reg import  \\sea-dc1\training\wt\wt_DefaultTerminalApplication.reg
ping localhost -n 5 > NUL
start wt.exe