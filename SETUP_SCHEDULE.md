# Quick Setup: Scheduled Automatic Updates

Follow these steps to set up automatic monthly updates for university data.

---

## Option 1: Automatic Setup (EASIEST) ⭐

### Step 1: Run the Setup Script

1. **Open PowerShell as Administrator**:
   - Press `Win + X`
   - Click "Windows PowerShell (Admin)" or "Terminal (Admin)"

2. **Navigate to the folder**:
   ```powershell
   cd "C:\Flow_App (1)\Flow\recommendation_service"
   ```

3. **Run the setup script**:
   ```powershell
   powershell -ExecutionPolicy Bypass -File setup_scheduled_task.ps1
   ```

4. **Choose your schedule**:
   - Option 1: Monthly (1st of each month at 3:00 AM) ← **RECOMMENDED**
   - Option 2: Weekly (Every Monday at 3:00 AM)
   - Option 3: Daily (Every day at 3:00 AM)
   - Option 4: Custom (set manually later)

5. **Done!** The script will:
   - Create the scheduled task
   - Set it to run automatically
   - Offer to test it immediately

### That's it! Your updates are now scheduled! 🎉

---

## Option 2: Manual Setup (Step-by-step)

If the automatic script doesn't work, follow these manual steps:

### Step 1: Open Task Scheduler

1. Press `Win + R`
2. Type: `taskschd.msc`
3. Press Enter

### Step 2: Create Basic Task

1. Click **"Create Basic Task"** in the right panel
2. **Name**: `Update University Data`
3. **Description**: `Automatically downloads latest QS Rankings from Kaggle`
4. Click **Next**

### Step 3: Set Trigger (When to Run)

1. Select: **Monthly**
2. Click **Next**
3. **Months**: Select "All months" (check all boxes)
4. **Days**: Select "1" (first day of month)
5. **Start**: Today's date
6. **Time**: 3:00 AM
7. Click **Next**

### Step 4: Set Action (What to Run)

1. Select: **Start a program**
2. Click **Next**
3. **Program/script**: Click **Browse**
   - Navigate to: `C:\Flow_App (1)\Flow\recommendation_service`
   - Select: `update_universities.bat`
4. **Start in**: `C:\Flow_App (1)\Flow\recommendation_service`
5. Click **Next**

### Step 5: Finish and Configure

1. Check **"Open the Properties dialog for this task when I click Finish"**
2. Click **Finish**

### Step 6: Advanced Settings

In the Properties dialog that opens:

**General Tab:**
- ✅ Check: "Run whether user is logged on or not"
- ✅ Check: "Run with highest privileges"

**Triggers Tab:**
- Verify: Monthly, Day 1, 3:00 AM

**Conditions Tab:**
- ✅ Uncheck: "Stop if the computer switches to battery power" (if laptop)
- ✅ Check: "Wake the computer to run this task"

**Settings Tab:**
- ✅ Check: "Allow task to be run on demand"
- ✅ Check: "If the task fails, restart every: 1 minute" (try 3 times)

**Click OK to Save**

---

## Verify the Schedule

### Check if Task is Created:

1. Open Task Scheduler: `Win + R` → `taskschd.msc`
2. In the left panel, click "Task Scheduler Library"
3. Find "Update University Data" in the list
4. Double-click to see details

### Test the Task Manually:

**Option A: Run the batch file directly**
```batch
cd "C:\Flow_App (1)\Flow\recommendation_service"
update_universities.bat
```

**Option B: Run from Task Scheduler**
1. Open Task Scheduler
2. Right-click "Update University Data"
3. Click "Run"
4. Watch the command window for progress

---

## What the Schedule Does

**Monthly on the 1st at 3:00 AM:**
1. Searches Kaggle for latest QS Rankings (2027, 2026, 2025...)
2. Downloads the most recent available dataset
3. Imports all universities into your database
4. Shows statistics
5. Logs results

**You'll always have the latest university data without doing anything!**

---

## View Update History

1. Open Task Scheduler
2. Find "Update University Data"
3. Click the "History" tab (bottom panel)
4. See all past runs and results

---

## Modify the Schedule

### Change Frequency:

**From Monthly to Weekly:**
1. Open Task Scheduler
2. Right-click "Update University Data" → Properties
3. Go to "Triggers" tab
4. Double-click the trigger
5. Change to "Weekly" and select day(s)
6. Click OK

**From Monthly to Daily:**
1. Same steps as above
2. Change to "Daily"

### Change Time:

1. Open the trigger (same steps as above)
2. Change the time
3. Click OK

---

## Disable/Enable the Schedule

**Temporarily Disable:**
1. Open Task Scheduler
2. Right-click "Update University Data"
3. Click "Disable"

**Re-enable:**
1. Right-click the task
2. Click "Enable"

**Delete Completely:**
1. Right-click the task
2. Click "Delete"
3. Confirm

---

## Troubleshooting

### Task shows "The task is currently running" but nothing happens

**Solution**: The task might be stuck.
1. Right-click → "End"
2. Wait 1 minute
3. Right-click → "Run" to test again

### Task failed with error code

**Common errors:**

| Error Code | Meaning | Solution |
|------------|---------|----------|
| 0x0 | Success | No action needed |
| 0x1 | General error | Check if Python is in PATH, check Kaggle credentials |
| 0xFF | Task terminated | Check if script path is correct |

**Check logs:**
1. Open the History tab in Task Scheduler
2. Look for error messages
3. See what went wrong

### Updates aren't happening

**Check:**
1. ✅ Kaggle credentials are set up (see README_KAGGLE_SETUP.md)
2. ✅ Python is in PATH
3. ✅ Script path is correct
4. ✅ Task is enabled (not disabled)
5. ✅ Computer was on at 3:00 AM (or "Wake computer" is checked)

---

## Recommended Schedule

**For most users:**
- **Monthly** on the 1st at 3:00 AM

**Why?**
- QS Rankings update once per year (usually June)
- Monthly checks ensure you get updates within a month of release
- Minimal resource usage

**Alternatives:**
- **Weekly** if you want faster updates (within a week)
- **Daily** if resources aren't a concern (overkill for annual rankings)

---

## Files Created

After setup, you'll have:

1. **update_universities.bat** - The update script
2. **setup_scheduled_task.ps1** - Automated setup script
3. **Scheduled Task** in Task Scheduler
4. **Log files** (created automatically when tasks run)

---

## Next Steps

1. ✅ **Set up Kaggle credentials** (see README_KAGGLE_SETUP.md)
2. ✅ **Test the update script** manually first
3. ✅ **Verify scheduled task** is created
4. ✅ **Wait for first scheduled run** or run manually

**You're all set! Your university data will stay up-to-date automatically!** 🎉
