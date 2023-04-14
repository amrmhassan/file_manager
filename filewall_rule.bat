@echo off

set programPath=%1

set ruleName="File Rover"

echo %date% %time%: Starting script with arguments %* >>C:\log.log

netsh advfirewall firewall show rule name=%ruleName% >nul
if %errorlevel%==0 (
  echo Rule "%ruleName%" already exists. Exiting...
  echo %date% %time%: Rule "%ruleName%" already exists. Exiting... >>C:\log.log
  exit /b
)

echo Rule "%ruleName%" not found. Adding...
echo %date% %time%: Rule "%ruleName%" not found. Adding... >>C:\log.log

netsh advfirewall firewall add rule name=%ruleName% action=allow enable=yes dir=in profile=domain,private,public localip=any remoteip=any protocol=any program=%programPath%
netsh advfirewall firewall add rule name=%ruleName% action=allow enable=yes dir=out profile=domain,private,public localip=any remoteip=any protocol=any program=%programPath%

echo Rule "%ruleName%" added successfully.
echo %date% %time%: Rule "%ruleName%" added successfully. >>C:\log.log

exit /b

