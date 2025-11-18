# Scheduled Reports Cron Setup Guide

Complete guide to deploying the automated scheduled reports system.

## 📋 Overview

This cron service automatically processes scheduled reports and sends them via email on a regular schedule (hourly by default).

## 🔧 Setup Instructions

### Step 1: Install Dependencies

```bash
cd recommendation_service
pip install -r requirements_scheduled_reports.txt
```

This installs:
- `APScheduler` - For cron scheduling
- `sendgrid` - For email delivery

### Step 2: Configure Environment Variables

Add these to your `.env` file in the `recommendation_service` directory:

```bash
# Supabase Configuration (you should already have these)
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_SERVICE_KEY=your_service_role_key_here  # Important: Use SERVICE ROLE key, not anon key!

# SendGrid Email Configuration
SENDGRID_API_KEY=SG.your_sendgrid_api_key_here
REPORT_FROM_EMAIL=reports@yourcompany.com

# Cron Schedule (optional - defaults to every hour)
CRON_SCHEDULE="0 * * * *"  # Runs every hour at minute 0

# Run on Startup (optional - defaults to false)
RUN_ON_STARTUP=true  # Set to true to process reports immediately when cron starts

# Environment
ENVIRONMENT=production
```

### Step 3: Get SendGrid API Key

1. **Sign up for SendGrid** (free tier available):
   - Go to https://sendgrid.com/
   - Sign up for free (allows 100 emails/day)

2. **Create API Key**:
   - Log into SendGrid dashboard
   - Go to Settings → API Keys
   - Click "Create API Key"
   - Choose "Restricted Access"
   - Enable "Mail Send" permission
   - Copy the API key and add to `.env`

3. **Verify Sender Email**:
   - Go to Settings → Sender Authentication
   - Click "Verify a Single Sender"
   - Add the email address you'll use (e.g., reports@yourcompany.com)
   - Check your email and click verification link

### Step 4: Get Supabase Service Role Key

⚠️ **Important**: You need the SERVICE ROLE key, not the anon key!

1. Go to your Supabase Dashboard
2. Navigate to Project Settings → API
3. Find the "service_role" key (keep it secret!)
4. Add it to your `.env` file

## 🚀 Running the Cron Service

### Option A: Development/Testing (Local)

Run directly with Python:

```bash
cd recommendation_service
python scheduled_reports_cron.py
```

You should see:
```
🚀 Starting Scheduled Reports Cron Service
Environment: production
Supabase URL: https://...
SendGrid configured: Yes
📅 Scheduled to run: 0 * * * *
✅ Scheduler started successfully!
Press Ctrl+C to stop
```

### Option B: Production (Background Process)

#### Using systemd (Linux):

1. Create service file:

```bash
sudo nano /etc/systemd/system/scheduled-reports.service
```

2. Add this content:

```ini
[Unit]
Description=Flow Scheduled Reports Cron Service
After=network.target

[Service]
Type=simple
User=your_username
WorkingDirectory=/path/to/Flow/recommendation_service
Environment="PATH=/path/to/your/venv/bin"
ExecStart=/path/to/your/venv/bin/python scheduled_reports_cron.py
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

3. Enable and start:

```bash
sudo systemctl enable scheduled-reports
sudo systemctl start scheduled-reports
sudo systemctl status scheduled-reports
```

4. View logs:

```bash
sudo journalctl -u scheduled-reports -f
```

#### Using PM2 (Cross-platform):

```bash
# Install PM2
npm install -g pm2

# Start the service
pm2 start scheduled_reports_cron.py --name scheduled-reports --interpreter python3

# View logs
pm2 logs scheduled-reports

# Make it start on boot
pm2 startup
pm2 save
```

#### Using Docker:

Create `Dockerfile.cron`:

```dockerfile
FROM python:3.11-slim

WORKDIR /app

# Copy requirements
COPY requirements.txt requirements_scheduled_reports.txt ./

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt -r requirements_scheduled_reports.txt

# Copy application code
COPY . .

# Run cron service
CMD ["python", "scheduled_reports_cron.py"]
```

Build and run:

```bash
docker build -f Dockerfile.cron -t flow-scheduled-reports .
docker run -d --name flow-reports --env-file .env flow-scheduled-reports
```

### Option C: Railway Deployment

1. **Add as a new service** in your Railway project:
   - Click "New" → "Empty Service"
   - Name it "Scheduled Reports Cron"

2. **Configure**:
   - Set the start command: `python scheduled_reports_cron.py`
   - Add all environment variables from Step 2

3. **Deploy**:
   - Push your code to GitHub
   - Railway will automatically deploy

## 🔍 Testing

### Test Manually

Run a single report processing cycle:

```bash
cd recommendation_service
python -c "
import asyncio
from app.services.scheduled_reports_service import get_scheduled_reports_service

async def test():
    service = get_scheduled_reports_service()
    stats = await service.process_due_reports()
    print('Stats:', stats)

asyncio.run(test())
"
```

### Create a Test Schedule

1. Log into your app as an admin
2. Go to Admin Dashboard → Reports → Scheduled Reports
3. Click "New Schedule"
4. Configure:
   - **Title**: "Test Report"
   - **Frequency**: Daily
   - **Recipients**: Your email address
   - **Metrics**: Select any 2-3 metrics
   - **Next Run**: Set to NOW (manually edit in database if needed)
5. Save

Then run the cron manually to process it.

### Check Database

View scheduled reports:
```sql
SELECT * FROM scheduled_reports;
```

View execution history:
```sql
SELECT
    sr.title,
    sre.status,
    sre.started_at,
    sre.completed_at,
    sre.error_message
FROM scheduled_report_executions sre
JOIN scheduled_reports sr ON sr.id = sre.scheduled_report_id
ORDER BY sre.created_at DESC
LIMIT 10;
```

## 📅 Cron Schedule Examples

Modify the `CRON_SCHEDULE` environment variable:

```bash
# Every hour
CRON_SCHEDULE="0 * * * *"

# Every 30 minutes
CRON_SCHEDULE="*/30 * * * *"

# Every 6 hours
CRON_SCHEDULE="0 */6 * * *"

# Every day at 9 AM
CRON_SCHEDULE="0 9 * * *"

# Every Monday at 9 AM
CRON_SCHEDULE="0 9 * * 1"

# First day of month at midnight
CRON_SCHEDULE="0 0 1 * *"
```

Format: `minute hour day month day_of_week`

## 📧 Email Template

Reports are sent with a professional HTML email that includes:
- Report title and description
- Generation timestamp
- Attached report file (PDF/CSV/JSON)
- Branding and footer

Example email:

![Email Example](https://via.placeholder.com/600x400?text=Professional+Email+Template)

## 🐛 Troubleshooting

### Reports Not Being Sent

1. **Check if cron is running**:
   ```bash
   # For systemd
   sudo systemctl status scheduled-reports

   # For PM2
   pm2 status
   ```

2. **Check logs**:
   ```bash
   # File log
   tail -f recommendation_service/scheduled_reports.log

   # PM2 logs
   pm2 logs scheduled-reports

   # systemd logs
   sudo journalctl -u scheduled-reports -f
   ```

3. **Verify environment variables**:
   ```bash
   # Check if variables are loaded
   python -c "import os; from dotenv import load_dotenv; load_dotenv(); print('SENDGRID_API_KEY:', 'SET' if os.getenv('SENDGRID_API_KEY') else 'NOT SET')"
   ```

### SendGrid Issues

1. **Verify API key**: Try sending a test email using SendGrid dashboard
2. **Check sender verification**: Make sure your from_email is verified
3. **Review SendGrid activity**: Check SendGrid dashboard for delivery logs
4. **Check spam folder**: Test emails might go to spam initially

### Database Connection Issues

1. **Verify Supabase credentials**: Make sure you're using the SERVICE ROLE key
2. **Check network**: Ensure the server can reach Supabase
3. **Test connection**:
   ```bash
   python -c "from supabase import create_client; import os; from dotenv import load_dotenv; load_dotenv(); client = create_client(os.getenv('SUPABASE_URL'), os.getenv('SUPABASE_SERVICE_KEY')); print('Connected:', client.table('scheduled_reports').select('*').limit(1).execute())"
   ```

### No Reports Due

If no reports are being processed:

1. Check `next_run_at` timestamps:
   ```sql
   SELECT title, next_run_at, is_active
   FROM scheduled_reports
   WHERE is_active = true
   ORDER BY next_run_at;
   ```

2. Update a report to run now:
   ```sql
   UPDATE scheduled_reports
   SET next_run_at = NOW()
   WHERE title = 'Your Report Title';
   ```

## 📊 Monitoring

### Health Check Endpoint

Add this to your main FastAPI app:

```python
@app.get("/health/scheduled-reports")
async def scheduled_reports_health():
    """Check scheduled reports service health"""
    try:
        # Check last execution
        response = supabase.table("scheduled_report_executions") \
            .select("*") \
            .order("created_at", desc=True) \
            .limit(1) \
            .execute()

        if response.data:
            last_run = response.data[0]
            return {
                "status": "healthy",
                "last_execution": last_run["created_at"],
                "last_status": last_run["status"]
            }
        else:
            return {
                "status": "warning",
                "message": "No executions found"
            }
    except Exception as e:
        return {
            "status": "unhealthy",
            "error": str(e)
        }
```

### Monitoring Queries

```sql
-- Check recent activity
SELECT
    sr.title,
    sr.frequency,
    sr.is_active,
    sr.next_run_at,
    sr.last_run_at,
    COUNT(sre.id) as execution_count,
    SUM(CASE WHEN sre.status = 'failed' THEN 1 ELSE 0 END) as failed_count
FROM scheduled_reports sr
LEFT JOIN scheduled_report_executions sre ON sre.scheduled_report_id = sr.id
    AND sre.created_at > NOW() - INTERVAL '7 days'
GROUP BY sr.id, sr.title, sr.frequency, sr.is_active, sr.next_run_at, sr.last_run_at
ORDER BY sr.next_run_at;

-- Check for failures
SELECT
    sr.title,
    sre.error_message,
    sre.created_at
FROM scheduled_report_executions sre
JOIN scheduled_reports sr ON sr.id = sre.scheduled_report_id
WHERE sre.status = 'failed'
ORDER BY sre.created_at DESC
LIMIT 20;
```

## 🔒 Security Best Practices

1. **Never commit `.env` file** - Add to `.gitignore`
2. **Use service role key only on backend** - Never expose in frontend
3. **Restrict SendGrid API key** - Use restricted access with only Mail Send permission
4. **Validate recipient emails** - Prevent spam/abuse
5. **Rate limit report generation** - Prevent resource abuse
6. **Monitor execution logs** - Watch for suspicious activity

## 📈 Performance Tips

1. **Batch processing**: Process multiple reports in parallel (already implemented)
2. **Database indexes**: Already created in migration
3. **Limit report frequency**: Don't allow reports more frequent than hourly
4. **Archive old executions**: Delete execution records older than 90 days
5. **Cache metric data**: Cache frequently requested metrics

## 🆘 Support

For issues:
- Check logs: `scheduled_reports.log`
- Review execution history in database
- Test email delivery via SendGrid dashboard
- Verify all environment variables are set

---

**Last Updated**: 2025-11-18
**Version**: 1.0.0
