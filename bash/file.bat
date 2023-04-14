@echo off

set programPath=%1


netsh advfirewall firewall add rule name="File Rover" program=""%programPath%"" service=any dir="in" protocol=tcp security=notrequired action=allow enable=yes profile=any
netsh advfirewall firewall add rule name="File Rover" program=""%programPath%"" service=any dir="out" protocol=tcp security=notrequired action=allow enable=yes profile=any

