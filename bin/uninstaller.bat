@echo off
color 0a
title Backup Manager Uninstaller

net session >nul 2>&1
if %errorLevel% neq 0 (
    echo.
    color 0c
    echo This script requires administrator privileges. Restarting as admin...
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit /b
)

color 0a
echo Press any key to continue with the uninstallation
pause >nul
echo Uninstalling Backup Manager...

set "INSTALL_PATH=C:\Program Files\Backup Manager"
set "STARTMENU_PATH=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Backup Manager.lnk"
set "DESKTOP_PATH=%USERPROFILE%\Desktop\Backup Manager.lnk"
set "UNINSTALLER=%INSTALL_PATH%\uninstall.bat"

timeout /t 1 >nul
del "%STARTMENU_PATH%"
del "%DESKTOP_PATH%"
rmdir /s /q "%INSTALL_PATH%"
echo Backup Manager has been uninstalled.
pause