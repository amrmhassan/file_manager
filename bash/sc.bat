@REM @echo off

@REM set programPath=%1

@REM set ruleName="File Rover"

@REM netsh advfirewall firewall show rule name=%ruleName% >nul
@REM if %errorlevel%==0 (
@REM   echo Rule "%ruleName%" already exists. Exiting...
@REM   exit /b
@REM )

@REM echo Rule "%ruleName%" not found. Adding...

@REM netsh advfirewall firewall add rule name=%ruleName% program=""%programPath%"" service=any dir="in" protocol=tcp security=notrequired action=allow enable=yes profile=any
@REM netsh advfirewall firewall add rule name=%ruleName% program=""%programPath%"" service=any dir="out" protocol=tcp security=notrequired action=allow enable=yes profile=any



@REM echo Rule "%ruleName%" added successfully.


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


netsh advfirewall firewall add rule name=%ruleName% action=allow enable=yes dir=in profile=domain,private,public localip=any remoteip=any protocol=any