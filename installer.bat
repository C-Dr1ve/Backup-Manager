@echo off
setlocal EnableDelayedExpansion
color 0a
title Backup Maker Installer

net session >nul 2>&1
if %errorLevel% neq 0 (
    echo.
    color 0c
    echo This script requires administrator privileges. Restarting as admin...
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit /b
)

set "BIN_FOLDER=%~dp0bin"

if not exist "%BIN_FOLDER%" (
    echo ERROR: "bin" folder not found in the script directory.
    pause
    exit /b
)

powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('NOTE: You have to install the newest version of Python from www.python.org for Backup Manager to work', 'READ ME', 'OK', [System.Windows.Forms.MessageBoxIcon]::Information);}"
cls
echo.
echo === Backup Manager Installer ===
echo.
echo Default install path: C:\Program Files\Backup Manager
set /p USER_PATH=Enter custom install path or press Enter to use default:

if "%USER_PATH%"=="" (
    set "INSTALL_PATH=C:\Program Files\Backup Manager"
) else (
    set "INSTALL_PATH=%USER_PATH%"
)

echo.
echo Creating folder: "%INSTALL_PATH%"
mkdir "%INSTALL_PATH%" >nul 2>&1

echo Copying files from "bin" to "%INSTALL_PATH%"...
xcopy "%BIN_FOLDER%\*" "%INSTALL_PATH%\" /E /I /H /Y >nul

set "MAIN_EXEC=%INSTALL_PATH%\main.exe"
if not exist "%MAIN_EXEC%" (
    echo ERROR: main.exe not found in %INSTALL_PATH%
    pause
    exit /b
)

for /f "tokens=2 delims==" %%I in ('"wmic computersystem get username /value" 2^>nul') do set "USERNAME=%%I"
for %%a in ("%USERNAME%") do set "USERNAME=%%~nxa"

set "STARTMENU_PATH=C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Backup Manager.lnk"
powershell -Command "$s=(New-Object -COM WScript.Shell).CreateShortcut('%STARTMENU_PATH%');$s.TargetPath='%MAIN_EXEC%';$s.WorkingDirectory='%INSTALL_PATH%';$s.Save()"
echo Created Start Menu shortcut.

echo.
set "DESKTOP_PATH=C:\Users\%USERNAME%\Desktop\Backup Manager.lnk"
powershell -Command "$s=(New-Object -COM WScript.Shell).CreateShortcut('%DESKTOP_PATH%');$s.TargetPath='%MAIN_EXEC%';$s.WorkingDirectory='%INSTALL_PATH%';$s.Save()"
echo Desktop shortcut created.

echo.
echo ✅ Backup Manager installed successfully!
pause
pause