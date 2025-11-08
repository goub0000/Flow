# ================================================================================
# Windows Task Scheduler Setup Script
# Creates a scheduled task to automatically update university data monthly
# ================================================================================

# Requires Administrator privileges
#Requires -RunAsAdministrator

Write-Host "================================================================================" -ForegroundColor Cyan
Write-Host "University Data Auto-Update - Task Scheduler Setup" -ForegroundColor Cyan
Write-Host "================================================================================" -ForegroundColor Cyan
Write-Host ""

# Configuration
$TaskName = "Update University Data"
$TaskDescription = "Automatically downloads and imports the latest QS World University Rankings from Kaggle"
$ScriptPath = "C:\Flow_App (1)\Flow\recommendation_service\update_universities.bat"
$WorkingDirectory = "C:\Flow_App (1)\Flow\recommendation_service"

# Check if script exists
if (-not (Test-Path $ScriptPath)) {
    Write-Host "ERROR: Update script not found at: $ScriptPath" -ForegroundColor Red
    Write-Host "Please ensure the update_universities.bat file exists" -ForegroundColor Red
    pause
    exit 1
}

Write-Host "Configuration:" -ForegroundColor Yellow
Write-Host "  Task Name: $TaskName"
Write-Host "  Script: $ScriptPath"
Write-Host "  Working Directory: $WorkingDirectory"
Write-Host ""

# Ask user for schedule preference
Write-Host "Choose update frequency:" -ForegroundColor Yellow
Write-Host "  1. Monthly (1st of each month at 3:00 AM) [RECOMMENDED]"
Write-Host "  2. Weekly (Every Monday at 3:00 AM)"
Write-Host "  3. Daily (Every day at 3:00 AM)"
Write-Host "  4. Custom (you'll set it manually later)"
Write-Host ""

$choice = Read-Host "Enter your choice (1-4)"

# Delete existing task if it exists
$existingTask = Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue
if ($existingTask) {
    Write-Host ""
    Write-Host "Removing existing scheduled task..." -ForegroundColor Yellow
    Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false
    Write-Host "Existing task removed." -ForegroundColor Green
}

# Create the action
$Action = New-ScheduledTaskAction -Execute $ScriptPath -WorkingDirectory $WorkingDirectory

# Create the trigger based on user choice
switch ($choice) {
    "1" {
        # Monthly on the 1st at 3:00 AM
        $Trigger = New-ScheduledTaskTrigger -Daily -At 3am
        # Note: We'll modify this to monthly after creation
        $scheduleType = "Monthly (1st at 3:00 AM)"
        $isMonthly = $true
    }
    "2" {
        # Weekly on Monday at 3:00 AM
        $Trigger = New-ScheduledTaskTrigger -Weekly -WeeksInterval 1 -DaysOfWeek Monday -At 3am
        $scheduleType = "Weekly (Monday at 3:00 AM)"
        $isMonthly = $false
    }
    "3" {
        # Daily at 3:00 AM
        $Trigger = New-ScheduledTaskTrigger -Daily -At 3am
        $scheduleType = "Daily (3:00 AM)"
        $isMonthly = $false
    }
    "4" {
        # Custom - create basic trigger, user will customize
        $Trigger = New-ScheduledTaskTrigger -Daily -At 3am
        $scheduleType = "Custom (you'll set it in Task Scheduler)"
        $isMonthly = $false
    }
    default {
        Write-Host "Invalid choice. Using default: Monthly" -ForegroundColor Yellow
        $Trigger = New-ScheduledTaskTrigger -Daily -At 3am
        $scheduleType = "Monthly (1st at 3:00 AM)"
        $isMonthly = $true
    }
}

# Create the principal (run whether user is logged on or not)
$Principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest

# Create the settings
$Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable

# Register the task
Write-Host ""
Write-Host "Creating scheduled task..." -ForegroundColor Yellow

try {
    Register-ScheduledTask -TaskName $TaskName -Action $Action -Trigger $Trigger -Principal $Principal -Settings $Settings -Description $TaskDescription -Force | Out-Null

    # If monthly, modify the trigger to run on day 1 of every month
    if ($isMonthly) {
        $task = Get-ScheduledTask -TaskName $TaskName
        $task.Triggers[0].DaysOfMonth = 1
        $task | Set-ScheduledTask | Out-Null
    }

    Write-Host "✓ Scheduled task created successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "================================================================================" -ForegroundColor Cyan
    Write-Host "SETUP COMPLETE" -ForegroundColor Green
    Write-Host "================================================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Task Details:" -ForegroundColor Yellow
    Write-Host "  Name: $TaskName"
    Write-Host "  Schedule: $scheduleType"
    Write-Host "  Status: Ready"
    Write-Host "  Runs as: SYSTEM (no login required)"
    Write-Host ""
    Write-Host "Next Steps:" -ForegroundColor Yellow
    Write-Host "  1. Set up Kaggle credentials (see README_KAGGLE_SETUP.md)"
    Write-Host "  2. Test the task by running: update_universities.bat"
    Write-Host "  3. View task in Task Scheduler: Win+R -> taskschd.msc"
    Write-Host ""
    Write-Host "To run the update manually right now:" -ForegroundColor Yellow
    Write-Host "  cd `"C:\Flow_App (1)\Flow\recommendation_service`""
    Write-Host "  update_universities.bat"
    Write-Host ""

    # Offer to run now
    $runNow = Read-Host "Would you like to test the update now? (y/n)"
    if ($runNow -eq "y" -or $runNow -eq "Y") {
        Write-Host ""
        Write-Host "Starting update..." -ForegroundColor Yellow
        Start-Process -FilePath $ScriptPath -WorkingDirectory $WorkingDirectory -Wait -NoNewWindow
    }

} catch {
    Write-Host "✗ Failed to create scheduled task" -ForegroundColor Red
    Write-Host "Error: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "Try running this script as Administrator" -ForegroundColor Yellow
    pause
    exit 1
}

Write-Host ""
Write-Host "================================================================================" -ForegroundColor Cyan
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
