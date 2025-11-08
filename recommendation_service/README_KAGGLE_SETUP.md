# Kaggle API Setup Guide

This guide explains how to set up Kaggle API authentication to automatically download datasets like QS World University Rankings.

## Why Kaggle?

Kaggle hosts thousands of datasets including:
- **QS World University Rankings 2025** (1,500+ universities globally)
- **Times Higher Education Rankings**
- And many more educational datasets

With the Kaggle API, you can download these datasets automatically instead of manual downloads.

---

## Quick Start (Recommended Method)

### Step 1: Get Your Kaggle API Credentials

1. **Create a Kaggle account** (if you don't have one):
   - Go to https://www.kaggle.com
   - Sign up for a free account

2. **Generate API Token**:
   - Log in to Kaggle
   - Go to your account settings: https://www.kaggle.com/account
   - Scroll down to the "API" section
   - Click **"Create New API Token"**
   - This will download a file called `kaggle.json`

### Step 2: Place the Kaggle Credentials File

**Windows:**
```bash
# Create the .kaggle directory in your user folder
mkdir C:\Users\<YourUsername>\.kaggle

# Move the downloaded kaggle.json file to this location
move Downloads\kaggle.json C:\Users\<YourUsername>\.kaggle\
```

**Mac/Linux:**
```bash
# Create the .kaggle directory in your home folder
mkdir ~/.kaggle

# Move the downloaded kaggle.json file
mv ~/Downloads/kaggle.json ~/.kaggle/

# Set permissions (Mac/Linux only)
chmod 600 ~/.kaggle/kaggle.json
```

### Step 3: Test the Setup

```bash
cd "C:\Flow_App (1)\Flow\recommendation_service"

# Test by downloading QS Rankings 2025
python import_universities.py --kaggle qs-2025 --limit 100
```

If this works, you're all set! 🎉

---

## Alternative Method: Using Environment Variables

If you prefer not to place the `kaggle.json` file in your user directory, you can use environment variables instead.

### Step 1: Extract Credentials from kaggle.json

Open the downloaded `kaggle.json` file in a text editor. It looks like:
```json
{
  "username": "your_username",
  "key": "your_api_key_here"
}
```

### Step 2: Add to .env File

Add these lines to your `.env` file in the `recommendation_service` directory:

```bash
KAGGLE_USERNAME=your_username
KAGGLE_KEY=your_api_key_here
```

**Example:**
```bash
# From kaggle.json:
# {"username": "johndoe123", "key": "abc123xyz789..."}

# Add to .env:
KAGGLE_USERNAME=johndoe123
KAGGLE_KEY=abc123xyz789...
```

### Step 3: Test the Setup

```bash
cd "C:\Flow_App (1)\Flow\recommendation_service"
python import_universities.py --kaggle qs-2025 --limit 100
```

---

## Using the Kaggle Integration

Once set up, you can use these commands:

### Import QS Rankings 2025 (Global Universities)
```bash
# Import all universities from QS Rankings 2025
python import_universities.py --kaggle qs-2025

# Import limited number (e.g., top 500)
python import_universities.py --kaggle qs-2025 --limit 500

# Force re-download even if file exists
python import_universities.py --kaggle qs-2025 --force-download
```

### Import Other Datasets
```bash
# Times Higher Education Rankings
python import_universities.py --kaggle times-higher-ed

# Any Kaggle dataset (use full dataset path)
python import_universities.py --kaggle username/dataset-name
```

---

## How It Works

1. **Auto-Download**: The system downloads the dataset from Kaggle to `recommendation_service/data/`
2. **Auto-Extract**: ZIP files are automatically extracted
3. **Auto-Import**: CSV files are parsed and imported into the database
4. **Progress Tracking**: You'll see detailed progress logs

### Example Output:
```
================================================================================
DOWNLOADING DATASET FROM KAGGLE
================================================================================
Dataset: melissamonfared/qs-world-university-rankings-2025
Download directory: C:\Flow_App (1)\Flow\recommendation_service\data
Starting download...
Downloading qs-world-university-rankings-2025.zip to data
100%|████████████████████████████████████| 215k/215k [00:02<00:00, 89.5kB/s]
Download completed successfully!
================================================================================
Importing from: C:\Flow_App (1)\Flow\recommendation_service\data\qs_2025.csv
Successfully parsed 1493 universities from CSV
Saving to database...
================================================================================
IMPORT STATISTICS
================================================================================
Added: 1493
Updated: 0
Skipped: 0
Failed: 0
Total in database: 2005
================================================================================
```

---

## Troubleshooting

### Error: "Kaggle authentication failed"

**Symptom**: You see an error message about Kaggle authentication.

**Solutions**:
1. **Check file location**: Ensure `kaggle.json` is in the correct location:
   - Windows: `C:\Users\<YourUsername>\.kaggle\kaggle.json`
   - Mac/Linux: `~/.kaggle/kaggle.json`

2. **Check file permissions** (Mac/Linux):
   ```bash
   chmod 600 ~/.kaggle/kaggle.json
   ```

3. **Try environment variables instead**: Use the `.env` method described above

4. **Verify credentials**: Open `kaggle.json` and ensure it has both `username` and `key`

### Error: "403 Forbidden" or "Dataset not found"

**Symptom**: Download fails with permission error.

**Solutions**:
1. **Accept dataset rules**: Some datasets require you to accept their terms
   - Visit the dataset page on Kaggle (e.g., https://www.kaggle.com/datasets/melissamonfared/qs-world-university-rankings-2025)
   - Click "Download" on the website at least once to accept terms
   - Then try the command again

2. **Check dataset name**: Ensure you're using the correct dataset identifier

### Error: "No CSV file found after download"

**Symptom**: Download succeeds but import fails.

**Solutions**:
1. **Check data directory**: Look in `recommendation_service/data/` to see what was downloaded
2. **Manual import**: If you see a CSV file, import it directly:
   ```bash
   python import_universities.py --csv data/filename.csv
   ```

---

## What Datasets Are Available?

### Built-in Shortcuts:
- `qs-2025`: QS World University Rankings 2025 (1,500+ universities, 105 countries)
- `times-higher-ed`: Times Higher Education Rankings

### Finding More Datasets:
1. Go to https://www.kaggle.com/datasets
2. Search for "university rankings" or "higher education"
3. Use the full dataset path: `username/dataset-name`

**Example:**
```bash
python import_universities.py --kaggle someuser/university-dataset-2024
```

---

## Privacy & Security

- **API Keys**: Your Kaggle API key is private. Never share it or commit it to version control.
- **kaggle.json**: This file contains your credentials. Keep it secure.
- **.gitignore**: The `.gitignore` file prevents `kaggle.json` and `.env` from being committed to git.

---

## Summary

| Method | Setup Location | Best For |
|--------|---------------|----------|
| kaggle.json file | `C:\Users\<YourUsername>\.kaggle\kaggle.json` | Easy setup, works with all Kaggle tools |
| Environment variables | `.env` file in `recommendation_service/` | Project-specific, keeps credentials with project |

**Recommendation**: Use the `kaggle.json` file method - it's the official Kaggle way and works everywhere.

---

## Next Steps

After setup:

1. **Import global universities**:
   ```bash
   python import_universities.py --kaggle qs-2025
   ```

2. **Verify import**:
   ```bash
   python import_universities.py --stats
   ```

3. **Test recommendations** with the Flutter app using global universities!

---

## Support

For Kaggle-specific issues:
- Kaggle API Documentation: https://www.kaggle.com/docs/api
- Kaggle Support: https://www.kaggle.com/contact

For import issues:
- Check this README
- Review error messages (they include solutions)
- Try manual CSV import if auto-download fails
