# PowerShell Script to Set Up Monthly College Scorecard Update Task
# Run this script as Administrator

Write-Host "=================================================================================" -ForegroundColor Cyan
Write-Host "SETTING UP MONTHLY COLLEGE SCORECARD UPDATE TASK" -ForegroundColor Cyan
Write-Host "=================================================================================" -ForegroundColor Cyan
Write-Host ""

# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "ERROR: This script must be run as Administrator!" -ForegroundColor Red
    Write-Host ""
    Write-Host "To run as Administrator:" -ForegroundColor Yellow
    Write-Host "1. Right-click on PowerShell" -ForegroundColor Yellow
    Write-Host "2. Select 'Run as Administrator'" -ForegroundColor Yellow
    Write-Host "3. Run this script again" -ForegroundColor Yellow
    Write-Host ""
    pause
    exit 1
}

# Get the current directory where the script is located
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$batchFile = Join-Path $scriptDir "update_college_scorecard.bat"

# Check if batch file exists
if (-not (Test-Path $batchFile)) {
    Write-Host "ERROR: update_college_scorecard.bat not found!" -ForegroundColor Red
    Write-Host "Expected location: $batchFile" -ForegroundColor Yellow
    Write-Host ""
    pause
    exit 1
}

Write-Host "Batch file found: $batchFile" -ForegroundColor Green
Write-Host ""

# Task details
$taskName = "Update College Scorecard Universities"
$taskDescription = "Monthly update of USA university data from College Scorecard API to Supabase"

# Delete existing task if it exists
$existingTask = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
if ($existingTask) {
    Write-Host "Removing existing scheduled task..." -ForegroundColor Yellow
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
    Write-Host "Existing task removed." -ForegroundColor Green
    Write-Host ""
}

# Create task action
$action = New-ScheduledTaskAction -Execute $batchFile

# Create trigger - Monthly on the 15th at 3:00 AM
$trigger = New-ScheduledTaskTrigger -Monthly -DaysOfMonth 15 -At 3:00AM

# Create principal (run whether user is logged on or not)
$principal = New-ScheduledTaskPrincipal -UserId "$env:USERDOMAIN\$env:USERNAME" -LogonType S4U -RunLevel Limited

# Create settings
$settings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -StartWhenAvailable `
    -RunOnlyIfNetworkAvailable `
    -MultipleInstances IgnoreNew

# Register the task
Write-Host "Creating scheduled task..." -ForegroundColor Cyan
$task = Register-ScheduledTask `
    -TaskName $taskName `
    -Description $taskDescription `
    -Action $action `
    -Trigger $trigger `
    -Principal $principal `
    -Settings $settings

if ($task) {
    Write-Host ""
    Write-Host "=================================================================================" -ForegroundColor Green
    Write-Host "SCHEDULED TASK CREATED SUCCESSFULLY!" -ForegroundColor Green
    Write-Host "=================================================================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Task Details:" -ForegroundColor Cyan
    Write-Host "  Name: $taskName" -ForegroundColor White
    Write-Host "  Schedule: Monthly on the 15th at 3:00 AM" -ForegroundColor White
    Write-Host "  Script: $batchFile" -ForegroundColor White
    Write-Host ""
    Write-Host "The task will:" -ForegroundColor Cyan
    Write-Host "  - Fetch the latest USA university data from College Scorecard API" -ForegroundColor White
    Write-Host "  - Update your Supabase database with new/updated information" -ForegroundColor White
    Write-Host "  - Run automatically every month on the 15th" -ForegroundColor White
    Write-Host ""
    Write-Host "To manage this task:" -ForegroundColor Yellow
    Write-Host "  - Open Task Scheduler (taskschd.msc)" -ForegroundColor White
    Write-Host "  - Look for: $taskName" -ForegroundColor White
    Write-Host "  - You can run it manually, disable it, or modify the schedule" -ForegroundColor White
    Write-Host ""
    Write-Host "To test the task now:" -ForegroundColor Yellow
    Write-Host "  1. Open Task Scheduler" -ForegroundColor White
    Write-Host "  2. Find '$taskName'" -ForegroundColor White
    Write-Host "  3. Right-click and select 'Run'" -ForegroundColor White
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "ERROR: Failed to create scheduled task!" -ForegroundColor Red
    Write-Host ""
}

Write-Host "Press any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
