@echo off
REM Update USA Universities from College Scorecard - Monthly Update Script
REM This script fetches the latest USA university data from College Scorecard API

echo ================================================================================
echo UPDATING USA UNIVERSITIES FROM COLLEGE SCORECARD
echo ================================================================================
echo.

REM Change to the recommendation service directory
cd /d "%~dp0"

REM Run the College Scorecard import
python import_college_scorecard_to_supabase.py

echo.
echo ================================================================================
echo UPDATE COMPLETE
echo ================================================================================
echo.
echo Check the output above for any errors.
echo.

pause
