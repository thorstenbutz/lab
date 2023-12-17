####################################
## Taming the unruly:
## From text to object - via RegEx
####################################

(quser.exe) -replace '\s{2,}',',' | ConvertFrom-Csv -Delimiter ','  | Select-Object -Property Username,ID
