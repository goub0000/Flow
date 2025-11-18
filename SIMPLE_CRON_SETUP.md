# Simple Cron Setup (GitHub Actions Only)

Use your existing GitHub + Railway + Supabase setup. **No new tools needed!**

## ✅ Option 1: GitHub Actions (Recommended - FREE)

GitHub will run your scheduled reports automatically every hour.

### Setup (2 minutes):

1. **Add secrets to GitHub**:
   - Go to your GitHub repo → Settings → Secrets and variables → Actions
   - Click "New repository secret"
   - Add these two secrets:
     - `SUPABASE_URL` = Your Supabase URL (from Supabase dashboard)
     - `SUPABASE_SERVICE_KEY` = Your service role key (from Supabase Settings → API)

2. **Commit and push** the workflow file (already created):
   ```bash
   git add .github/workflows/scheduled-reports.yml
   git commit -m "Add GitHub Actions scheduled reports"
   git push
   ```

3. **Done!** GitHub will now run this every hour automatically.

### Test it manually:
- Go to GitHub → Actions → "Scheduled Reports" → Run workflow

### View logs:
- GitHub → Actions → Click on any run to see logs

---

## 📧 Email Options (Optional)

For now, reports are just tracked in the database. To send emails:

### A. Use Gmail SMTP (FREE)
Add to GitHub secrets:
```
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_USER=your-email@gmail.com
EMAIL_PASSWORD=your-app-password  # Get from Google Account settings
```

### B. Use Railway Email Service
Railway supports SMTP email sending through environment variables.

### C. Store in Supabase Storage
Instead of email, save reports to Supabase Storage and notify users in-app.

---

## 🚀 Option 2: Railway Cron Service

If you prefer Railway over GitHub Actions:

1. **Add new service** in Railway:
   - Click "New" → "Empty Service"
   - Name: "Scheduled Reports Cron"

2. **Set start command**:
   ```bash
   python recommendation_service/scheduled_reports_cron.py
   ```

3. **Add environment variables**:
   - `SUPABASE_URL`
   - `SUPABASE_SERVICE_KEY`
   - `CRON_SCHEDULE=0 * * * *`

4. **Deploy** - Railway will keep it running 24/7

Cost: ~$5/month on Railway (vs FREE on GitHub Actions)

---

## 📊 What Happens

Every hour:
1. ✅ Checks `scheduled_reports` table for due reports
2. ✅ Marks them as executed
3. ✅ Updates `next_run_at` automatically
4. ✅ Creates execution record in `scheduled_report_executions`
5. ✅ Logs everything for debugging

---

## 🎯 For Email Delivery (Later)

When you want to actually send emails:

### Simple Python Script:
```python
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

def send_report_email(to, subject, body, attachment):
    msg = MIMEMultipart()
    msg['From'] = 'reports@yourapp.com'
    msg['To'] = to
    msg['Subject'] = subject
    msg.attach(MIMEText(body, 'html'))

    # Add attachment
    # msg.attach(attachment)

    # Send via Gmail
    with smtplib.SMTP('smtp.gmail.com', 587) as server:
        server.starttls()
        server.login('your-email', 'app-password')
        server.send_message(msg)
```

---

## 💡 Recommended Approach

**Start with GitHub Actions** (free, easy, no new tools):
1. Commit the workflow file ✅ (already created)
2. Add GitHub secrets (2 minutes)
3. Push to GitHub
4. Done!

**Later**, when you need emails:
- Add Gmail SMTP (free, 500 emails/day)
- Or use Supabase Storage to save reports and notify in-app

---

## 📝 Status

- ✅ Database schema deployed
- ✅ GitHub Actions workflow created
- ⏳ Waiting for: GitHub secrets setup
- ⏳ Waiting for: Git push

**Next step**: Add the two secrets to GitHub, then push!
