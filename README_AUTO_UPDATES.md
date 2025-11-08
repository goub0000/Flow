# Automatic University Data Updates

This guide explains how to keep your university data automatically up-to-date with the latest QS Rankings (2026, 2027, etc.) without manual intervention.

## How It Works

The system can:
1. **Auto-detect the latest QS Rankings** by searching Kaggle for datasets from 2027, 2026, 2025, etc.
2. **Download automatically** when new rankings are published
3. **Update your database** with fresh data
4. **Run on a schedule** (daily, weekly, monthly)

---

## Quick Start: Always Get Latest Rankings

### Manual Update (Run Anytime)

```bash
cd "C:\Flow_App (1)\Flow\recommendation_service"

# This will automatically find and download the latest QS Rankings
python import_universities.py --kaggle latest
```

**What happens:**
1. Searches Kaggle for QS Rankings 2027, 2026, 2025, etc.
2. Downloads the most recent available dataset
3. Falls back to QS 2025 if newer versions aren't available yet
4. Imports all universities into your database

### Force Re-download (Update Existing Data)

```bash
# Force download even if you already have the file
python import_universities.py --kaggle latest --force-download
```

---

## Scheduled Automatic Updates

Set up automatic updates to run periodically without manual intervention.

### Option 1: Windows Task Scheduler (Recommended for Windows)

#### Step 1: Create Update Script

Create a file called `update_universities.bat` in `C:\Flow_App (1)\Flow\recommendation_service\`:

```batch
@echo off
cd /d "C:\Flow_App (1)\Flow\recommendation_service"

echo ================================================================================
echo University Data Auto-Update
echo Running at: %date% %time%
echo ================================================================================

REM Activate virtual environment if you're using one
REM call venv\Scripts\activate

REM Download and import latest QS Rankings
python import_universities.py --kaggle latest --force-download

echo ================================================================================
echo Update completed at: %date% %time%
echo ================================================================================

REM Optionally, you can also update US universities
REM python import_universities.py --source collegecard --limit 500

pause
```

#### Step 2: Set Up Task Scheduler

1. **Open Task Scheduler**:
   - Press `Win + R`
   - Type `taskschd.msc`
   - Press Enter

2. **Create New Task**:
   - Click "Create Basic Task"
   - Name: "Update University Data"
   - Description: "Auto-download latest QS Rankings from Kaggle"

3. **Set Trigger** (when to run):
   - **Monthly**: Run on 1st of every month (QS updates annually around June)
   - **Weekly**: Run every Monday
   - **Daily**: Run at 3:00 AM

4. **Set Action**:
   - Action: "Start a program"
   - Program: `C:\Flow_App (1)\Flow\recommendation_service\update_universities.bat`
   - Start in: `C:\Flow_App (1)\Flow\recommendation_service`

5. **Save and Test**:
   - Check "Open Properties dialog"
   - Go to "General" tab
   - Check "Run whether user is logged on or not"
   - Click "OK" and enter your password

**Recommended Schedule**: Monthly on the 1st (since QS releases rankings once per year)

---

### Option 2: Python Scheduler (Cross-Platform)

Create a Python script that runs continuously and checks for updates.

#### Step 1: Install Schedule Library

```bash
pip install schedule
```

#### Step 2: Create `auto_updater.py`

Create `auto_updater.py` in the `recommendation_service` directory:

```python
#!/usr/bin/env python
"""
Automatic University Data Updater
Runs periodically to check for and download latest rankings
"""
import schedule
import time
import logging
from datetime import datetime
import subprocess

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)


def update_universities():
    """Download and import latest QS Rankings"""
    logger.info("=" * 80)
    logger.info("STARTING AUTOMATIC UPDATE")
    logger.info("=" * 80)

    try:
        # Run the import command
        result = subprocess.run(
            ['python', 'import_universities.py', '--kaggle', 'latest', '--force-download'],
            capture_output=True,
            text=True,
            cwd='C:/Flow_App (1)/Flow/recommendation_service'
        )

        logger.info(result.stdout)
        if result.returncode == 0:
            logger.info("✓ Update completed successfully")
        else:
            logger.error(f"✗ Update failed: {result.stderr}")

    except Exception as e:
        logger.error(f"Error during update: {e}")

    logger.info("=" * 80)
    logger.info(f"Next update scheduled for: {schedule.next_run()}")
    logger.info("=" * 80)


# Schedule the update
# Option 1: Run monthly on the 1st at 3:00 AM
schedule.every().month.at("03:00").do(update_universities)

# Option 2: Run weekly on Monday at 3:00 AM
# schedule.every().monday.at("03:00").do(update_universities)

# Option 3: Run daily at 3:00 AM
# schedule.every().day.at("03:00").do(update_universities)

# Option 4: Run every 30 days
# schedule.every(30).days.do(update_universities)


if __name__ == "__main__":
    logger.info("University Data Auto-Updater Started")
    logger.info(f"Next update scheduled for: {schedule.next_run()}")

    # Run immediately on startup (optional)
    # update_universities()

    # Keep running and check for scheduled tasks
    while True:
        schedule.run_pending()
        time.sleep(3600)  # Check every hour
```

#### Step 3: Run the Auto-Updater

```bash
# Run in background (Windows)
python auto_updater.py

# Run as background service (Linux/Mac)
nohup python auto_updater.py &
```

---

### Option 3: Cron Job (Linux/Mac)

#### Step 1: Create Update Script

Create `update_universities.sh`:

```bash
#!/bin/bash
cd /path/to/Flow_App/recommendation_service

echo "================================================================================"
echo "University Data Auto-Update"
echo "Running at: $(date)"
echo "================================================================================"

# Download and import latest QS Rankings
python import_universities.py --kaggle latest --force-download

echo "================================================================================"
echo "Update completed at: $(date)"
echo "================================================================================"
```

Make it executable:
```bash
chmod +x update_universities.sh
```

#### Step 2: Add to Crontab

```bash
crontab -e
```

Add one of these lines:

```cron
# Run monthly on the 1st at 3:00 AM
0 3 1 * * /path/to/update_universities.sh >> /path/to/update.log 2>&1

# Run weekly on Monday at 3:00 AM
0 3 * * 1 /path/to/update_universities.sh >> /path/to/update.log 2>&1

# Run daily at 3:00 AM
0 3 * * * /path/to/update_universities.sh >> /path/to/update.log 2>&1
```

---

## Update Strategies

### Strategy 1: Conservative (Recommended)
- **When**: Monthly on the 1st
- **Why**: QS releases rankings once per year (usually June)
- **Pro**: Minimal bandwidth usage
- **Con**: May miss updates for a few weeks

### Strategy 2: Moderate
- **When**: Weekly on Monday
- **Why**: Catches updates within a week of release
- **Pro**: Reasonably fresh data
- **Con**: More frequent checks than necessary

### Strategy 3: Aggressive
- **When**: Daily
- **Why**: Always have the latest data
- **Pro**: Immediate updates
- **Con**: Unnecessary bandwidth usage (rankings change yearly, not daily)

**Recommendation**: Use **monthly** updates since QS Rankings are published annually.

---

## When Are Rankings Released?

Different ranking organizations release on different schedules:

| Ranking | Release Schedule | Typical Release Month |
|---------|-----------------|----------------------|
| **QS World University Rankings** | Annually | June |
| **Times Higher Education** | Annually | September-October |
| **Academic Ranking of World Universities (ARWU)** | Annually | August |
| **US News & World Report** | Annually | September |

**Optimal Update Schedule**:
- **June**: Check for new QS Rankings
- **September**: Check for THE and US News
- **Annual check** is sufficient for most users

---

## Monitoring Updates

### View Update Logs

**Windows Task Scheduler:**
1. Open Task Scheduler
2. Right-click "Update University Data"
3. Select "Properties" → "History" tab

**Cron Job:**
```bash
tail -f /path/to/update.log
```

### Check What You Have

```bash
# See database statistics
python import_universities.py --stats
```

Output example:
```
================================================================================
DATABASE STATISTICS
================================================================================
Total Universities: 2005
Dataset Version: QS Rankings 2026
Last Updated: 2025-06-15

By Country:
  US: 512
  GB: 90
  DE: 46
  FR: 35
  ...
================================================================================
```

---

## Troubleshooting

### Update Fails: "No newer rankings found"

**Cause**: No newer QS Rankings available on Kaggle yet.

**Solution**: This is normal. The system will use QS 2025 until 2026 is published.

**Workaround**: Nothing needed - it automatically falls back to the latest available.

### Update Fails: "Kaggle authentication failed"

**Cause**: Kaggle credentials not found or expired.

**Solution**: Re-setup Kaggle authentication (see README_KAGGLE_SETUP.md)

### Duplicate Universities

**Cause**: Importing without updating existing records.

**Solution**: The system automatically updates existing universities by default. If you have duplicates, they were created from different sources (e.g., US universities from College Scorecard + global from QS).

**Fix duplicates:**
```bash
# Clear database and re-import
# (Advanced - only if you have issues)
# Backup first!
python -c "from app.database.config import SessionLocal; from app.models.university import University; db = SessionLocal(); db.query(University).delete(); db.commit()"

# Re-import
python import_universities.py --kaggle latest
```

---

## Advanced: Update Notification

Want to be notified when new rankings are available?

### Email Notification (Python)

Add to `auto_updater.py`:

```python
import smtplib
from email.message import EmailMessage

def send_notification(subject, body):
    msg = EmailMessage()
    msg['Subject'] = subject
    msg['From'] = 'your-email@gmail.com'
    msg['To'] = 'your-email@gmail.com'
    msg.set_content(body)

    with smtplib.SMTP_SSL('smtp.gmail.com', 465) as smtp:
        smtp.login('your-email@gmail.com', 'your-app-password')
        smtp.send_message(msg)

def update_universities():
    try:
        # ... existing code ...
        if "Found QS Rankings 202" in result.stdout:
            year = # extract year from output
            send_notification(
                f"New Rankings Available: QS {year}",
                f"Successfully downloaded and imported QS Rankings {year}"
            )
    except Exception as e:
        send_notification("Update Failed", str(e))
```

---

## Summary

| Feature | Command | Frequency |
|---------|---------|-----------|
| Manual latest update | `python import_universities.py --kaggle latest` | As needed |
| Force re-download | `python import_universities.py --kaggle latest --force-download` | As needed |
| Scheduled (Windows) | Task Scheduler → `update_universities.bat` | Monthly recommended |
| Scheduled (Python) | `python auto_updater.py` | Monthly recommended |
| Scheduled (Linux/Mac) | Cron job → `update_universities.sh` | Monthly recommended |

**Recommendation**: Set up a monthly scheduled task to run `python import_universities.py --kaggle latest --force-download` on the 1st of each month.

This ensures you always have the latest rankings without manual intervention!
