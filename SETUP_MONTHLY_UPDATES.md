# Monthly Automatic Updates Setup Guide

This guide will help you set up automatic monthly updates for both QS Rankings and College Scorecard data.

## What Gets Updated

Your system now has **two automated update options**:

### 1. QS World University Rankings (Annual - Global)
- **Data**: Top 1,500+ universities worldwide
- **Update Frequency**: Annually (new rankings released each year)
- **Script**: `update_universities.bat`
- **Recommended Schedule**: Monthly (to catch new releases)

### 2. College Scorecard (Annual - USA Only)
- **Data**: 1,800+ USA universities with detailed stats
- **Update Frequency**: 1-2 times per year
- **Script**: `update_college_scorecard.bat`
- **Recommended Schedule**: Monthly on the 15th

### 3. Update Everything (Recommended)
- **Script**: `update_all_universities.bat`
- **Updates both QS Rankings AND College Scorecard**
- **One-click solution for complete updates**

---

## Quick Setup (Run as Administrator)

### Step 1: Open PowerShell as Administrator

1. Press `Windows Key`
2. Type "PowerShell"
3. Right-click on "Windows PowerShell"
4. Select "Run as administrator"
5. Click "Yes" on the User Account Control prompt

### Step 2: Navigate to the Folder

```powershell
cd "C:\Flow_App (1)\Flow\recommendation_service"
```

### Step 3: Set Up College Scorecard Monthly Updates

```powershell
.\setup_college_scorecard_schedule.ps1
```

This will create a scheduled task that runs **monthly on the 15th at 3:00 AM**.

---

## What the Scheduled Task Does

When the task runs on the 15th of each month, it will:

1. ✅ Connect to the College Scorecard API
2. ✅ Fetch the latest USA university data
3. ✅ Update your Supabase database automatically
4. ✅ Log the results (check Task Scheduler for history)

---

## Managing Your Scheduled Tasks

### View Scheduled Tasks

1. Press `Windows Key + R`
2. Type `taskschd.msc` and press Enter
3. Look for "Update College Scorecard Universities"

### Test the Task Manually

1. Open Task Scheduler (see above)
2. Find "Update College Scorecard Universities"
3. Right-click → "Run"
4. Check the "Last Run Result" column

### Modify the Schedule

1. Open Task Scheduler
2. Find your task
3. Right-click → "Properties"
4. Go to "Triggers" tab
5. Edit the schedule (e.g., change from 15th to 1st of month)

### Disable Automatic Updates

1. Open Task Scheduler
2. Find your task
3. Right-click → "Disable"

---

## Manual Updates (Without Scheduled Tasks)

If you prefer to run updates manually instead:

### Update QS Rankings Only
```bash
cd "C:\Flow_App (1)\Flow\recommendation_service"
python import_to_supabase.py
```

### Update College Scorecard Only
```bash
cd "C:\Flow_App (1)\Flow\recommendation_service"
python import_college_scorecard_to_supabase.py
```

### Update Everything
```bash
cd "C:\Flow_App (1)\Flow\recommendation_service"
update_all_universities.bat
```

---

## Current Database Status

After completing the initial setup, your Supabase database contains:

- **Total Universities**: 3,295
  - QS World Rankings: ~1,503 universities (global)
  - College Scorecard: ~1,804 universities (USA)
  - Some overlap exists (USA universities appear in both datasets)

---

## Update Schedule Recommendations

### Best Practice: Monthly Updates

Run both updates monthly to ensure you catch:
- New QS Rankings releases (typically August-September)
- College Scorecard updates (typically late summer/fall)
- Any data corrections or additions

### Suggested Schedule

**Option 1: Staggered Updates**
- Day 1 of month: QS Rankings
- Day 15 of month: College Scorecard

**Option 2: Single Monthly Update**
- Day 1 of month: Update everything (`update_all_universities.bat`)

---

## Troubleshooting

### Task Doesn't Run

**Check Task Status:**
1. Open Task Scheduler
2. Find your task
3. Check "Last Run Result" column
4. If it says error, right-click → "Properties" → "History" tab

**Common Issues:**
- Computer was off/asleep at scheduled time
  - Solution: Enable "Run task as soon as possible after a scheduled start is missed" in task settings
- Network connection required
  - Solution: Task already configured to require network
- Python not in PATH
  - Solution: Task uses full path to Python in batch file

### Import Fails

**Check API Keys:**
```bash
cd "C:\Flow_App (1)\Flow\recommendation_service"
type .env
```

Make sure these are set:
- `COLLEGE_SCORECARD_API_KEY`
- `KAGGLE_USERNAME`
- `KAGGLE_KEY`
- `SUPABASE_URL`
- `SUPABASE_SERVICE_KEY`

**Check Internet Connection:**
- College Scorecard API requires internet
- Kaggle API requires internet
- Supabase requires internet

---

## Files Created

### Batch Scripts
- `update_universities.bat` - Update QS Rankings
- `update_college_scorecard.bat` - Update College Scorecard
- `update_all_universities.bat` - Update everything

### PowerShell Setup Scripts
- `setup_scheduled_task.ps1` - Set up QS Rankings monthly task
- `setup_college_scorecard_schedule.ps1` - Set up College Scorecard monthly task

### Python Import Scripts
- `import_to_supabase.py` - Import QS Rankings to Supabase
- `import_college_scorecard_to_supabase.py` - Import College Scorecard to Supabase

---

## Next Steps

After setting up automatic updates:

1. ✅ Test the scheduled task manually (see "Test the Task Manually" above)
2. ✅ Verify data in Supabase dashboard
3. ✅ Connect your Flutter app to Supabase
4. ✅ Build your recommendation algorithm

---

## Support

If you encounter any issues:

1. Check the batch file output for error messages
2. Verify API keys in `.env` file
3. Test manual imports first before troubleshooting scheduled tasks
4. Check Task Scheduler history for task execution details

---

## Summary

You now have a fully automated system that will:

- ✅ Update global university rankings monthly
- ✅ Update USA university details monthly
- ✅ Keep your database current automatically
- ✅ Work even when you're not at your computer

Your university recommendation system is production-ready! 🎉
