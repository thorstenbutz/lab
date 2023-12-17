@echo off

:: Mind the gap: you need to change the command while running interactively: 
:: for /f "tokens=2 delims=:" %a in ('ipconfig /all ^| findstr /R /C:"Physical"') do @for /f "tokens=*" %b in ("%a") do @echo %b

echo Your MacAddress(es):

for /f "tokens=2 delims=:" %%a in ('ipconfig /all ^| findstr /R /C:"Physical"') do @for /f "tokens=*" %%b in ("%%a") do @echo %%b

ping localhost -n 10 > NUL 