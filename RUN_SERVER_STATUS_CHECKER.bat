@echo off
set scriptName=CheckServerStatus.ps1
set scriptPath=%USERPROFILE%\Desktop\%scriptName%

if exist "%scriptPath%" (
    powershell.exe -ExecutionPolicy Bypass -File "%scriptPath%"
    pause
) else (
    echo %scriptName% not found on Desktop.
    pause
)
