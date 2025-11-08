@echo off
echo ========================================================================
echo SETUP AUTOMATED UNIVERSITY DATABASE UPDATES
echo ========================================================================
echo.
echo This script will create 3 scheduled tasks for automated database updates:
echo   1. Daily Wikipedia Updates (2:00 AM)
echo   2. Weekly Comprehensive Update (Sundays 3:00 AM)
echo   3. Monthly College Scorecard (First Monday 4:00 AM)
echo.
echo NOTE: You must run this as Administrator!
echo.
pause

REM Check for admin rights
net session >nul 2>&1
if %errorLevel% == 0 (
    echo Running with Administrator privileges...
    echo.
    powershell -ExecutionPolicy Bypass -File "%~dp0setup_automated_updates.ps1"
    echo.
    pause
) else (
    echo ERROR: This script must be run as Administrator!
    echo.
    echo Please:
    echo   1. Right-click this file
    echo   2. Select "Run as administrator"
    echo   3. Click "Yes" on the UAC prompt
    echo.
    pause
    exit /b 1
)
