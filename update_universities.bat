@echo off
REM ================================================================================
REM Automatic University Data Update Script
REM This script downloads and imports the latest QS World University Rankings
REM ================================================================================

cd /d "C:\Flow_App (1)\Flow\recommendation_service"

echo ================================================================================
echo University Data Auto-Update
echo Running at: %date% %time%
echo ================================================================================
echo.

REM Check if Python is available
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Python is not found in PATH
    echo Please ensure Python is installed and added to PATH
    pause
    exit /b 1
)

echo [1/3] Checking for latest QS World University Rankings...
echo.

REM Download and import latest QS Rankings
python import_universities.py --kaggle latest --force-download

if %errorlevel% equ 0 (
    echo.
    echo ================================================================================
    echo SUCCESS: Update completed successfully at: %date% %time%
    echo ================================================================================
) else (
    echo.
    echo ================================================================================
    echo ERROR: Update failed at: %date% %time%
    echo Check the error messages above for details
    echo ================================================================================
)

echo.
echo [2/3] Displaying database statistics...
echo.

REM Show statistics
python import_universities.py --stats

echo.
echo ================================================================================
echo [3/3] Update process finished
echo Next scheduled update: Check Task Scheduler
echo ================================================================================
echo.

REM Uncomment the line below if you want to see the output when running manually
REM pause
