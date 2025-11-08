@echo off
REM Update All Universities - QS Rankings + College Scorecard
REM This script updates both global (QS) and USA (College Scorecard) university data

echo ================================================================================
echo UPDATING ALL UNIVERSITY DATA
echo ================================================================================
echo.

REM Change to the recommendation service directory
cd /d "%~dp0"

echo [1/2] Updating QS World University Rankings...
echo.
python import_to_supabase.py

echo.
echo.
echo [2/2] Updating USA Universities from College Scorecard...
echo.
python import_college_scorecard_to_supabase.py

echo.
echo ================================================================================
echo ALL UPDATES COMPLETE
echo ================================================================================
echo.
echo Both datasets have been updated:
echo   - QS World University Rankings (Global)
echo   - College Scorecard (USA Universities)
echo.
echo Check the output above for any errors.
echo.

pause
