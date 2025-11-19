@echo off
REM Windows batch script to build Flutter web with production credentials
REM Run this script to rebuild the Flutter web app for production

echo =========================================
echo Building Flutter Web for Production
echo =========================================
echo.

REM Load environment variables from .env.production
FOR /F "tokens=*" %%A IN ('type .env.production ^| findstr /V "^#" ^| findstr /V "^$"') DO (
    SET %%A
)

REM Verify required variables are set
IF "%SUPABASE_URL%"=="" (
    echo ERROR: SUPABASE_URL not found in .env.production
    exit /b 1
)

IF "%SUPABASE_ANON_KEY%"=="" (
    echo ERROR: SUPABASE_ANON_KEY not found in .env.production
    exit /b 1
)

IF "%API_BASE_URL%"=="" (
    echo WARNING: API_BASE_URL not set, using default localhost
    SET API_BASE_URL=http://localhost:8000
)

echo Environment variables loaded:
echo   - SUPABASE_URL: %SUPABASE_URL:~0,30%...
echo   - SUPABASE_ANON_KEY: %SUPABASE_ANON_KEY:~0,20%...
echo   - API_BASE_URL: %API_BASE_URL%
echo.

echo Running Flutter clean...
flutter clean

echo.
echo Running Flutter pub get...
flutter pub get

echo.
echo Building Flutter web with credentials...
flutter build web --release ^
  --dart-define=SUPABASE_URL=%SUPABASE_URL% ^
  --dart-define=SUPABASE_ANON_KEY=%SUPABASE_ANON_KEY% ^
  --dart-define=API_BASE_URL=%API_BASE_URL%

IF %ERRORLEVEL% EQU 0 (
    echo.
    echo =========================================
    echo Build completed successfully!
    echo Output: build/web
    echo.
    echo Next steps:
    echo 1. Test locally: cd build/web ^&^& python -m http.server 8080
    echo 2. Deploy to Railway: git add . ^&^& git commit -m "Rebuild with credentials" ^&^& git push
    echo =========================================
) ELSE (
    echo.
    echo =========================================
    echo Build FAILED!
    echo =========================================
    exit /b 1
)
