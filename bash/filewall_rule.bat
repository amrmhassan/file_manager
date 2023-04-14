@echo off

set programPath=%1

set ruleName="File Rover"

netsh advfirewall firewall show rule name=%ruleName% >nul
if %errorlevel%==0 (
  echo Rule "%ruleName%" already exists. Exiting...
  exit /b
)

echo Rule "%ruleName%" not found. Adding...

netsh advfirewall firewall add rule name=%ruleName% program=""%programPath%"" service=any dir="in" protocol=tcp security=notrequired action=allow enable=yes profile=any
netsh advfirewall firewall add rule name=%ruleName% program=""%programPath%"" service=any dir="out" protocol=tcp security=notrequired action=allow enable=yes profile=any



echo Rule "%ruleName%" added successfully.
