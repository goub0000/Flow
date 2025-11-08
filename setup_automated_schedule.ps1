# PowerShell Script to Setup Automated University Data Updates
# Phase 2 Enhancement - Automated Scheduling
# Run this as Administrator

Write-Host "=================================================="
Write-Host "AUTOMATED UPDATE SCHEDULER SETUP"
Write-Host "=================================================="
Write-Host ""

# Get current directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$PythonExe = "python"

# Check if Python is available
try {
    $pythonVersion = & $PythonExe --version 2>&1
    Write-Host "Found Python: $pythonVersion" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Python not found in PATH" -ForegroundColor Red
    Write-Host "Please install Python and add it to PATH"
    exit 1
}

Write-Host ""
Write-Host "Setting up scheduled tasks..."
Write-Host ""

# ================================================
# DAILY UPDATE - Critical Priority (30 universities/day)
# ================================================
$DailyTaskName = "UniversityData_DailyUpdate"
$DailyScript = Join-Path $ScriptDir "automated_daily_update.py"

Write-Host "1. Creating DAILY update task ($DailyTaskName)..." -ForegroundColor Cyan
Write-Host "   Schedule: Every day at 2:00 AM"
Write-Host "   Target:   Critical priority universities (30/day)"

$DailyAction = New-ScheduledTaskAction -Execute $PythonExe -Argument "`"$DailyScript`"" -WorkingDirectory $ScriptDir

$DailyTrigger = New-ScheduledTaskTrigger -Daily -At "2:00AM"

$DailySettings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -StartWhenAvailable `
    -RunOnlyIfNetworkAvailable `
    -ExecutionTimeLimit (New-TimeSpan -Hours 2)

try {
    # Remove existing task if it exists
    Unregister-ScheduledTask -TaskName $DailyTaskName -Confirm:$false -ErrorAction SilentlyContinue

    # Create new task
    Register-ScheduledTask `
        -TaskName $DailyTaskName `
        -Action $DailyAction `
        -Trigger $DailyTrigger `
        -Settings $DailySettings `
        -Description "Automated daily update for critical priority universities" `
        -RunLevel Limited

    Write-Host "   SUCCESS: Daily task created" -ForegroundColor Green
} catch {
    Write-Host "   ERROR: Failed to create daily task: $_" -ForegroundColor Red
}

Write-Host ""

# ================================================
# WEEKLY UPDATE - High Priority (100 universities/week)
# ================================================
$WeeklyTaskName = "UniversityData_WeeklyUpdate"
$WeeklyScript = Join-Path $ScriptDir "automated_weekly_update.py"

Write-Host "2. Creating WEEKLY update task ($WeeklyTaskName)..." -ForegroundColor Cyan
Write-Host "   Schedule: Every Sunday at 3:00 AM"
Write-Host "   Target:   High priority universities (100/week)"

$WeeklyAction = New-ScheduledTaskAction -Execute $PythonExe -Argument "`"$WeeklyScript`"" -WorkingDirectory $ScriptDir

$WeeklyTrigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Sunday -At "3:00AM"

$WeeklySettings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -StartWhenAvailable `
    -RunOnlyIfNetworkAvailable `
    -ExecutionTimeLimit (New-TimeSpan -Hours 4)

try {
    # Remove existing task if it exists
    Unregister-ScheduledTask -TaskName $WeeklyTaskName -Confirm:$false -ErrorAction SilentlyContinue

    # Create new task
    Register-ScheduledTask `
        -TaskName $WeeklyTaskName `
        -Action $WeeklyAction `
        -Trigger $WeeklyTrigger `
        -Settings $WeeklySettings `
        -Description "Automated weekly update for high priority universities" `
        -RunLevel Limited

    Write-Host "   SUCCESS: Weekly task created" -ForegroundColor Green
} catch {
    Write-Host "   ERROR: Failed to create weekly task: $_" -ForegroundColor Red
}

Write-Host ""

# ================================================
# MONTHLY UPDATE - Medium Priority (300 universities/month)
# ================================================
$MonthlyTaskName = "UniversityData_MonthlyUpdate"
$MonthlyScript = Join-Path $ScriptDir "automated_monthly_update.py"

Write-Host "3. Creating MONTHLY update task ($MonthlyTaskName)..." -ForegroundColor Cyan
Write-Host "   Schedule: 1st day of every month at 4:00 AM"
Write-Host "   Target:   Medium priority universities (300/month)"

$MonthlyAction = New-ScheduledTaskAction -Execute $PythonExe -Argument "`"$MonthlyScript`"" -WorkingDirectory $ScriptDir

# Monthly trigger - 1st day of every month
$MonthlyTrigger = New-ScheduledTaskTrigger -Daily -At "4:00AM"
$MonthlyTrigger.DaysInterval = 1

$MonthlySettings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -StartWhenAvailable `
    -RunOnlyIfNetworkAvailable `
    -ExecutionTimeLimit (New-TimeSpan -Hours 8)

try {
    # Remove existing task if it exists
    Unregister-ScheduledTask -TaskName $MonthlyTaskName -Confirm:$false -ErrorAction SilentlyContinue

    # Create new task
    $MonthlyTask = Register-ScheduledTask `
        -TaskName $MonthlyTaskName `
        -Action $MonthlyAction `
        -Trigger $MonthlyTrigger `
        -Settings $MonthlySettings `
        -Description "Automated monthly update for medium priority universities" `
        -RunLevel Limited

    # Modify trigger to run on 1st day of month only
    $MonthlyTask.Triggers[0].DaysInterval = 0
    $MonthlyTask.Triggers[0].MonthlyDaysOfMonth = 1
    $MonthlyTask | Set-ScheduledTask

    Write-Host "   SUCCESS: Monthly task created" -ForegroundColor Green
} catch {
    Write-Host "   ERROR: Failed to create monthly task: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "=================================================="
Write-Host "SETUP COMPLETE"
Write-Host "=================================================="
Write-Host ""
Write-Host "Created scheduled tasks:" -ForegroundColor Green
Write-Host "  1. $DailyTaskName   - Daily at 2:00 AM"
Write-Host "  2. $WeeklyTaskName  - Sundays at 3:00 AM"
Write-Host "  3. $MonthlyTaskName - 1st of month at 4:00 AM"
Write-Host ""
Write-Host "To manage tasks:"
Write-Host "  - Open Task Scheduler: taskschd.msc"
Write-Host "  - Or use PowerShell:"
Write-Host "    Get-ScheduledTask -TaskName 'UniversityData_*'"
Write-Host ""
Write-Host "To remove tasks:"
Write-Host "    Unregister-ScheduledTask -TaskName 'UniversityData_*' -Confirm:`$false"
Write-Host ""
Write-Host "Logs will be stored in: $ScriptDir\logs\automated"
Write-Host ""
