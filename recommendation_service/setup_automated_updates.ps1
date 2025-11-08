# PowerShell Script to Set Up Automated University Database Updates
# This script creates Windows Task Scheduler tasks for regular database updates

# Requires Administrator privileges
#Requires -RunAsAdministrator

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$PythonScript = Join-Path $ScriptDir "update_all_university_data.py"
$LogDir = Join-Path $ScriptDir "logs"

# Ensure log directory exists
if (!(Test-Path $LogDir)) {
    New-Item -ItemType Directory -Path $LogDir | Out-Null
}

Write-Host "========================================================================"
Write-Host "SETTING UP AUTOMATED UNIVERSITY DATABASE UPDATES"
Write-Host "========================================================================"
Write-Host ""

# Find Python executable
$PythonExe = (Get-Command python).Source
if (!$PythonExe) {
    Write-Host "ERROR: Python not found in PATH" -ForegroundColor Red
    exit 1
}

Write-Host "Python executable: $PythonExe"
Write-Host "Update script: $PythonScript"
Write-Host "Log directory: $LogDir"
Write-Host ""

# Task 1: Daily Wikipedia Updates
Write-Host "[1/3] Creating daily Wikipedia update task..."

$TaskName1 = "FlowApp-UniversityDB-DailyWikipedia"
$Action1 = New-ScheduledTaskAction -Execute $PythonExe -Argument """$ScriptDir\import_wikipedia_universities.py"""
$Trigger1 = New-ScheduledTaskTrigger -Daily -At "02:00AM"  # Run at 2 AM daily
$Principal1 = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount
$Settings1 = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable

# Remove existing task if it exists
Unregister-ScheduledTask -TaskName $TaskName1 -Confirm:$false -ErrorAction SilentlyContinue

# Register new task
Register-ScheduledTask -TaskName $TaskName1 -Action $Action1 -Trigger $Trigger1 -Principal $Principal1 -Settings $Settings1 -Description "Daily Wikipedia scraping for non-ranked universities" | Out-Null

Write-Host "  ✓ Created: $TaskName1 (Daily at 2:00 AM)"

# Task 2: Weekly Comprehensive Update
Write-Host "[2/3] Creating weekly comprehensive update task..."

$TaskName2 = "FlowApp-UniversityDB-WeeklyFull"
$Action2 = New-ScheduledTaskAction -Execute $PythonExe -Argument """$PythonScript"""
$Trigger2 = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Sunday -At "03:00AM"  # Run Sundays at 3 AM
$Principal2 = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount
$Settings2 = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable

# Remove existing task if it exists
Unregister-ScheduledTask -TaskName $TaskName2 -Confirm:$false -ErrorAction SilentlyContinue

# Register new task
Register-ScheduledTask -TaskName $TaskName2 -Action $Action2 -Trigger $Trigger2 -Principal $Principal2 -Settings $Settings2 -Description "Weekly comprehensive database update (all sources)" | Out-Null

Write-Host "  ✓ Created: $TaskName2 (Weekly on Sundays at 3:00 AM)"

# Task 3: Monthly College Scorecard Update
Write-Host "[3/3] Creating monthly College Scorecard update task..."

$TaskName3 = "FlowApp-UniversityDB-MonthlyScorecard"
$Action3 = New-ScheduledTaskAction -Execute $PythonExe -Argument """$ScriptDir\import_college_scorecard_to_supabase.py"""
$Trigger3 = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Monday -At "04:00AM" -WeeksInterval 4  # First Monday of month at 4 AM
$Principal3 = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount
$Settings3 = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable

# Remove existing task if it exists
Unregister-ScheduledTask -TaskName $TaskName3 -Confirm:$false -ErrorAction SilentlyContinue

# Register new task
Register-ScheduledTask -TaskName $TaskName3 -Action $Action3 -Trigger $Trigger3 -Principal $Principal3 -Settings $Settings3 -Description "Monthly College Scorecard data update" | Out-Null

Write-Host "  ✓ Created: $TaskName3 (Monthly - First Monday at 4:00 AM)"

Write-Host ""
Write-Host "========================================================================"
Write-Host "SETUP COMPLETE!"
Write-Host "========================================================================"
Write-Host ""
Write-Host "Scheduled Tasks Created:"
Write-Host "  1. $TaskName1"
Write-Host "     - Frequency: Daily at 2:00 AM"
Write-Host "     - Purpose: Wikipedia scraping for new universities"
Write-Host ""
Write-Host "  2. $TaskName2"
Write-Host "     - Frequency: Weekly on Sundays at 3:00 AM"
Write-Host "     - Purpose: Full database update (all sources)"
Write-Host ""
Write-Host "  3. $TaskName3"
Write-Host "     - Frequency: Monthly - First Monday at 4:00 AM"
Write-Host "     - Purpose: US College Scorecard updates"
Write-Host ""
Write-Host "To view tasks in Task Scheduler:"
Write-Host "  taskschd.msc"
Write-Host ""
Write-Host "To manually run the comprehensive update now:"
Write-Host "  python ""$PythonScript"""
Write-Host ""
Write-Host "Logs will be saved to:"
Write-Host "  $LogDir"
Write-Host ""
Write-Host "========================================================================"

# Test one task to ensure it works
Write-Host ""
Write-Host "Testing task execution..."
try {
    Start-ScheduledTask -TaskName $TaskName1
    Write-Host "✓ Task execution started successfully" -ForegroundColor Green
    Write-Host "  Check Task Scheduler for execution status"
} catch {
    Write-Host "✗ Failed to start task: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "Setup completed successfully!" -ForegroundColor Green
