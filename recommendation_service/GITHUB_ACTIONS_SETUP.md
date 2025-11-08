# GitHub Actions Setup - Cloud-Based Automatic Updates

This guide sets up **completely automated, cloud-based** monthly updates that run without any computer.

## Why GitHub Actions?

### ❌ Problems with Local Scheduling
- Computer must be on 24/7
- Fails if computer is off, broken, or unavailable
- Requires electricity and maintenance
- Not suitable for production apps

### ✅ Benefits of GitHub Actions
- **Always Available**: Runs in GitHub's cloud infrastructure
- **No Computer Needed**: Completely serverless
- **Free**: 2,000 minutes/month for private repos, unlimited for public
- **Reliable**: GitHub's enterprise-grade infrastructure
- **Easy to Monitor**: View run history and logs in GitHub
- **Manual Trigger**: Run updates on-demand anytime

---

## Setup Instructions

### Step 1: Create a GitHub Repository

1. Go to [GitHub](https://github.com)
2. Click "New repository"
3. Name it: `university-data-updater` (or any name you prefer)
4. Choose **Private** (recommended) or Public
5. Click "Create repository"

### Step 2: Upload Your Code to GitHub

#### Option A: Using Git (Recommended)

```bash
cd "C:\Flow_App (1)\Flow\recommendation_service"

# Initialize git repository
git init

# Add all files
git add .

# Commit
git commit -m "Initial commit - University data updater"

# Add GitHub remote (replace YOUR-USERNAME with your GitHub username)
git remote add origin https://github.com/YOUR-USERNAME/university-data-updater.git

# Push to GitHub
git branch -M main
git push -u origin main
```

#### Option B: Using GitHub Web Interface

1. Go to your repository on GitHub
2. Click "uploading an existing file"
3. Drag and drop these files:
   - `.github/workflows/update-universities.yml`
   - `import_to_supabase.py`
   - `import_college_scorecard_to_supabase.py`
   - `requirements.txt`
   - All files from `app/` directory
4. Click "Commit changes"

### Step 3: Add Secrets to GitHub

GitHub Actions needs your API keys to work. Add them as encrypted secrets:

1. Go to your GitHub repository
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Add each secret:

| Secret Name | Value | Where to Find |
|-------------|-------|---------------|
| `SUPABASE_URL` | `https://wmuarotbdjhqbyjyslqg.supabase.co` | Your `.env` file |
| `SUPABASE_SERVICE_KEY` | Your service key | Your `.env` file |
| `KAGGLE_USERNAME` | `ogouba` | Your `.env` file |
| `KAGGLE_KEY` | Your Kaggle API key | Your `.env` file |
| `COLLEGE_SCORECARD_API_KEY` | Your College Scorecard key | Your `.env` file |

**For each secret:**
1. Click "New repository secret"
2. Enter the **Name** (exactly as shown above)
3. Paste the **Value** from your `.env` file
4. Click "Add secret"

### Step 4: Enable GitHub Actions

1. Go to your repository
2. Click the **Actions** tab
3. If prompted, click "I understand my workflows, go ahead and enable them"

---

## How It Works

### Automatic Monthly Updates

The workflow automatically runs:
- **Every month on the 15th at 3:00 AM UTC**
- Updates both QS Rankings AND College Scorecard
- Completely automatic - no action needed

### Manual Updates (On-Demand)

You can trigger updates anytime:

1. Go to your GitHub repository
2. Click **Actions** tab
3. Click **Update Universities Data** workflow
4. Click **Run workflow** button
5. Click the green **Run workflow** button

The update will start immediately!

---

## Monitoring Updates

### View Run History

1. Go to **Actions** tab in your repository
2. See all past runs with status (✅ Success or ❌ Failed)
3. Click any run to see detailed logs

### View Logs

1. Click on a workflow run
2. Click on "Update QS Rankings" or "Update College Scorecard"
3. Expand sections to see detailed output
4. Check for errors or success messages

### Get Notifications

GitHub automatically sends email notifications if a workflow fails.

To customize notifications:
1. Go to GitHub **Settings** → **Notifications**
2. Enable "Actions" notifications

---

## Testing the Setup

### Test Immediately After Setup

1. Go to **Actions** tab
2. Click **Update Universities Data**
3. Click **Run workflow** → **Run workflow**
4. Wait 5-10 minutes for completion
5. Check Supabase to verify data was updated

### Expected Behavior

**Successful Run:**
- ✅ Green checkmark next to workflow
- QS Rankings: Updated ~1,500 universities
- College Scorecard: Updated ~1,800 universities
- Total run time: 5-10 minutes

**Failed Run:**
- ❌ Red X next to workflow
- Check logs for error messages
- Common issues:
  - Missing secrets
  - API rate limits
  - Network issues (GitHub will auto-retry)

---

## Schedule Customization

The workflow is currently set to run **monthly on the 15th at 3:00 AM UTC**.

To change the schedule, edit `.github/workflows/update-universities.yml`:

```yaml
on:
  schedule:
    # Examples:
    - cron: '0 3 1 * *'    # 1st of every month at 3:00 AM
    - cron: '0 0 15 * *'   # 15th at midnight
    - cron: '0 12 1,15 * *' # 1st and 15th at noon
    - cron: '0 3 * * 0'    # Every Sunday at 3:00 AM
```

**Cron Syntax**: `minute hour day month day-of-week`

Use [crontab.guru](https://crontab.guru) to generate cron expressions.

---

## Cost Analysis

### GitHub Actions Pricing

**Public Repositories:**
- ✅ Completely FREE (unlimited minutes)

**Private Repositories:**
- ✅ 2,000 minutes/month FREE
- Each update takes ~5-10 minutes
- You can run updates **200+ times per month** for free
- Additional minutes: $0.008 per minute (only if you exceed 2,000)

**Your Monthly Usage:**
- 1 automatic run per month: ~10 minutes
- Occasional manual runs: ~50 minutes
- **Total: ~60 minutes/month (well within free tier)**

### Other Services (Free Tier)

- ✅ Supabase: 500 MB database (enough for millions of records)
- ✅ College Scorecard API: Unlimited (free government API)
- ✅ Kaggle API: Unlimited downloads

**Total Cost: $0/month** 🎉

---

## Alternative Cloud Solutions

If you prefer not to use GitHub Actions:

### 1. Vercel Cron Jobs
- Free on Hobby plan
- Requires deploying as serverless function
- [Documentation](https://vercel.com/docs/cron-jobs)

### 2. Railway.app
- Free tier includes cron jobs
- Deploy Python app
- [Documentation](https://docs.railway.app/reference/cron-jobs)

### 3. Supabase Edge Functions + External Cron
- Deploy functions to Supabase
- Trigger with external cron service (cron-job.org)
- More complex setup

### 4. AWS Lambda + EventBridge
- Free tier: 1 million requests/month
- More complex setup
- Requires AWS account

**Recommendation**: Start with GitHub Actions (simplest and most reliable)

---

## Troubleshooting

### Workflow Not Running

**Check GitHub Actions is Enabled:**
1. Repository → **Settings** → **Actions** → **General**
2. Ensure "Allow all actions and reusable workflows" is selected

**Check Branch Name:**
- Workflow must be on `main` or `master` branch
- Check your default branch name in repository settings

### Import Fails

**Check Secrets:**
1. Go to **Settings** → **Secrets and variables** → **Actions**
2. Verify all 5 secrets are added
3. Secret names must match exactly (case-sensitive)

**Check Logs:**
1. Go to **Actions** tab
2. Click failed workflow
3. Expand steps to see error messages

**Common Errors:**
- "Invalid API key" → Check secrets are correct
- "Rate limit exceeded" → Wait and retry (rare)
- "Connection timeout" → GitHub will auto-retry

### Testing Secrets Locally

Before pushing to GitHub, test your scripts work:

```bash
cd "C:\Flow_App (1)\Flow\recommendation_service"
python import_to_supabase.py
python import_college_scorecard_to_supabase.py
```

If these work locally, they'll work on GitHub Actions.

---

## Security Best Practices

### ✅ Do's
- Store API keys as GitHub Secrets (encrypted)
- Use private repository for extra security
- Never commit `.env` file to Git
- Regularly rotate API keys

### ❌ Don'ts
- Never hardcode API keys in code
- Never share your repository publicly with secrets in code
- Don't commit `.env` file

### `.gitignore` (Already Configured)

Make sure your `.gitignore` includes:

```
.env
.env.local
*.db
__pycache__/
*.py[cod]
data/
```

---

## Next Steps

After setting up GitHub Actions:

1. ✅ Push your code to GitHub
2. ✅ Add all secrets
3. ✅ Test with manual workflow run
4. ✅ Verify data in Supabase
5. ✅ Connect your Flutter app to Supabase
6. ✅ Build your recommendation algorithm

Your system is now **production-ready** and runs completely in the cloud! 🚀

---

## Summary

### What You Get

- ✅ **Automatic monthly updates** (no computer needed)
- ✅ **Cloud-based** (GitHub's infrastructure)
- ✅ **Free** (within generous free tier)
- ✅ **Reliable** (enterprise-grade uptime)
- ✅ **Monitored** (email notifications on failure)
- ✅ **Manual control** (trigger updates anytime)
- ✅ **Secure** (encrypted secrets)

### Comparison

| Feature | Local Task Scheduler | GitHub Actions |
|---------|---------------------|----------------|
| Computer Required | ✅ Yes (always on) | ❌ No |
| Cost | Electricity costs | Free |
| Reliability | Poor (if computer off) | Excellent |
| Monitoring | None | Built-in logs |
| Notifications | None | Email alerts |
| Manual Trigger | Difficult | One click |
| Production Ready | ❌ No | ✅ Yes |

**GitHub Actions is the clear winner for production apps!** 🎯
