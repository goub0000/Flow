# GitHub Actions Setup - Quick Checklist

Your cloud-based automated update system is ready! Follow these steps to complete the setup.

## Current Status

✅ **Completed:**
- Supabase database setup with 3,295 universities
- GitHub Actions workflow file created
- Import scripts tested and working
- .gitignore configured to protect sensitive data
- All dependencies listed in requirements.txt

## What You Need to Do

### Step 1: Create GitHub Repository (5 minutes)

1. Go to [GitHub](https://github.com)
2. Click "New repository" (green button)
3. Repository name: `university-data-updater` (or any name you prefer)
4. Choose **Private** (recommended) or Public
5. **DO NOT** initialize with README, .gitignore, or license
6. Click "Create repository"

### Step 2: Push Your Code to GitHub (5 minutes)

```bash
cd "C:\Flow_App (1)\Flow\recommendation_service"

# Initialize git repository
git init

# Add all files
git add .

# Commit
git commit -m "Initial commit - University data updater with GitHub Actions"

# Add GitHub remote (replace YOUR-USERNAME with your GitHub username)
git remote add origin https://github.com/YOUR-USERNAME/university-data-updater.git

# Push to GitHub
git branch -M main
git push -u origin main
```

If prompted for credentials, use your GitHub username and a Personal Access Token (not your password).
- Generate token at: https://github.com/settings/tokens
- Select "repo" scope

### Step 3: Add Secrets to GitHub (10 minutes)

1. Go to your GitHub repository
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Add each secret below (one at a time):

| Secret Name | Value | Where to Find |
|-------------|-------|---------------|
| `SUPABASE_URL` | `https://wmuarotbdjhqbyjyslqg.supabase.co` | Your `.env` file |
| `SUPABASE_SERVICE_KEY` | Your service key | Your `.env` file |
| `KAGGLE_USERNAME` | `ogouba` | Your `.env` file |
| `KAGGLE_KEY` | Your Kaggle API key | Your `.env` file |
| `COLLEGE_SCORECARD_API_KEY` | Your College Scorecard key | Your `.env` file |

**For each secret:**
1. Click "New repository secret"
2. Enter the **Name** (exactly as shown above - case sensitive!)
3. Paste the **Value** from your `.env` file
4. Click "Add secret"

**Important:** Get the actual values from your `.env` file:
```bash
type .env
```

### Step 4: Enable and Test GitHub Actions (5 minutes)

1. Go to your repository
2. Click the **Actions** tab
3. If prompted, click "I understand my workflows, go ahead and enable them"
4. Click **Update Universities Data** workflow (left sidebar)
5. Click **Run workflow** button (right side)
6. Click the green **Run workflow** button in the dropdown
7. Wait 5-10 minutes for completion
8. Check for green checkmark ✅ (success) or red X ❌ (failed)

### Step 5: Verify Data in Supabase (2 minutes)

1. Go to your Supabase dashboard: https://supabase.com/dashboard
2. Click on your project
3. Click **Table Editor** → **universities** table
4. Verify you see university records
5. Check the `updated_at` timestamp to confirm recent update

## What Happens Next

### Automatic Updates
- Every month on the 15th at 3:00 AM UTC
- Updates both QS Rankings and College Scorecard
- Completely automatic - no action needed from you
- Email notifications if workflow fails

### Manual Updates (Anytime)
1. Go to **Actions** tab in your repository
2. Click **Update Universities Data**
3. Click **Run workflow** → **Run workflow**
4. Updates start immediately

### Monitoring
- View all past runs in the **Actions** tab
- Click any run to see detailed logs
- Check for success/failure status
- Expand steps to see what happened

## Cost

**Total: $0/month** 🎉

- GitHub Actions: 2,000 minutes/month free (private repos)
- Your usage: ~10 minutes/month (well within free tier)
- Supabase: Free tier (500 MB database)
- College Scorecard API: Free (government API)
- Kaggle API: Free

## Files in Your Repository

**Core Scripts:**
- `import_to_supabase.py` - Import QS Rankings
- `import_college_scorecard_to_supabase.py` - Import College Scorecard
- `requirements.txt` - Python dependencies

**GitHub Actions:**
- `.github/workflows/update-universities.yml` - Workflow configuration

**Python Application:**
- `app/` - Complete application code
- `app/database/supabase_client.py` - Database connection
- `app/data_fetchers/` - Data fetching and parsing

**Documentation:**
- `GITHUB_ACTIONS_SETUP.md` - Comprehensive guide (400+ lines)
- `GITHUB_SETUP_CHECKLIST.md` - This checklist
- `SUPABASE_SETUP.md` - Database setup guide
- `SETUP_MONTHLY_UPDATES.md` - Local scheduling (superseded)

**Configuration:**
- `.env` - **NOT committed** (protected by .gitignore)
- `.gitignore` - Protects sensitive data
- `requirements.txt` - Dependencies

## Troubleshooting

### Workflow Fails

**Check Logs:**
1. Go to **Actions** tab
2. Click the failed workflow run
3. Click on the failed job (red X)
4. Expand steps to see error messages

**Common Issues:**

**"Invalid API key" / "Authentication failed"**
- Check that all 5 secrets are added in GitHub
- Verify secret names match exactly (case-sensitive)
- Ensure values are correct (no extra spaces)

**"Module not found"**
- Check that `requirements.txt` is in the repository
- Verify all dependencies are listed

**"Permission denied"**
- Verify `SUPABASE_SERVICE_KEY` is used (not anon key)
- Check Supabase service key has full permissions

**"Rate limit exceeded"**
- Wait a few hours and try again
- This is rare with monthly updates

### Need Help?

Refer to the comprehensive guide:
```bash
type GITHUB_ACTIONS_SETUP.md
```

Or open the file in your editor for full details.

## Summary

You've built a **production-ready, cloud-based university data system** that:

- ✅ Automatically updates monthly (no computer needed)
- ✅ Runs in the cloud (GitHub's infrastructure)
- ✅ Completely free (within generous free tiers)
- ✅ Reliable and monitored (email notifications)
- ✅ Secure (encrypted secrets, private repo)
- ✅ Contains 3,295 universities (QS + College Scorecard)
- ✅ Can be triggered manually anytime

**Time to complete setup: ~25 minutes**

**Next steps after GitHub setup:**
1. Connect your Flutter app to Supabase
2. Build your recommendation algorithm
3. Deploy your app

Your system is ready for production! 🚀
