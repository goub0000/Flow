# 🔍 Automated Data Enrichment System

## Overview

Before training ML models, it's crucial to have high-quality data. This automated system **searches the web** and intelligently fills NULL values in your university database, ensuring your ML models train on complete, accurate data.

### Problem Solved

Your database has **many NULL values** across critical fields:
- `acceptance_rate` - Needed for academic fit scoring
- `gpa_average` - Essential for student matching
- `tuition_out_state`, `total_cost` - Critical for financial fit
- `graduation_rate_4year` - Important quality indicator
- Test scores, location data, and more...

**Solution**: Automated web scraping + intelligent field-specific searches → Complete database → Better ML models

---

## 🎯 Features

### 1. **Intelligent Web Search**
- Searches Wikipedia for comprehensive university information
- Uses DuckDuckGo for instant answers and quick facts
- Guesses and validates university websites
- Scrapes official university pages for authoritative data

### 2. **Field-Specific Scrapers**
Each field type has specialized scraping logic:
- **Acceptance Rate**: Searches admissions pages, news articles
- **Tuition/Costs**: Finds financial aid pages, cost calculators
- **Test Scores**: Extracts SAT/ACT ranges from admissions data
- **Graduation Rate**: Searches official statistics
- **Location**: Identifies city, state, urban/suburban/rural
- **University Type**: Determines Public/Private/For-profit
- **Student Count**: Finds enrollment numbers

### 3. **Smart Prioritization**
Fields are prioritized by ML importance:
- **HIGH** (filled first): acceptance_rate, costs, graduation_rate, gpa_average
- **MEDIUM**: location, test_scores, university_type
- **LOW**: website, logo, description

### 4. **Progress Tracking & Reporting**
- Real-time progress logging
- Detailed statistics per field
- Error tracking and recovery
- Comprehensive final reports

### 5. **Rate Limiting & Error Handling**
- Respects web server limits (configurable delay)
- Automatic retry logic
- Graceful error handling
- Continues processing if individual requests fail

---

## 🚀 Quick Start

### Step 1: Analyze Current Data Quality

```bash
cd recommendation_service
python auto_fill_missing_data.py --analyze
```

**Output Example:**
```
Field                          NULL Count   Percentage   Priority
--------------------------------------------------------------------------------
acceptance_rate                12,543       73.1%        HIGH
gpa_average                    11,892       69.3%        HIGH
graduation_rate_4year          10,234       59.7%        HIGH
tuition_out_state              8,456        49.3%        HIGH
total_students                 7,891        46.0%        HIGH
...

Total NULL values: 89,432
High priority NULL values: 45,234

📋 Recommendations:
  • High number of NULL values in critical fields
  • Recommend starting with high-priority fields
  • Run: python auto_fill_missing_data.py --limit 100 --priority-high
```

### Step 2: Test on Small Batch (Dry Run)

```bash
# Test on 10 universities without updating database
python auto_fill_missing_data.py --dry-run --limit 10
```

**What it does:**
- Searches web for 10 universities
- Shows what data would be filled
- **Does not update database**
- Perfect for testing before full run

### Step 3: Fill High-Priority Fields

```bash
# Fill critical ML fields for 100 universities
python auto_fill_missing_data.py --priority-high --limit 100
```

**What it fills:**
- acceptance_rate
- gpa_average
- graduation_rate_4year
- total_students
- tuition_out_state
- total_cost

### Step 4: Full Enrichment (Optional)

```bash
# Fill all fields for 500 universities
python auto_fill_missing_data.py --limit 500

# Or fill ALL universities (takes hours!)
python auto_fill_missing_data.py --all
```

---

## 📖 Usage Guide

### Command-Line Options

```bash
python auto_fill_missing_data.py [options]

Options:
  --analyze              Analyze and display NULL value statistics
  --limit N              Process maximum N universities
  --all                  Process ALL universities (may take hours!)
  --dry-run              Test mode - no database updates
  --priority-high        Only fill high-priority fields
  --rate-limit SECONDS   Delay between requests (default: 3.0)
  -h, --help             Show help message
```

### Common Workflows

**1. First Time Setup**
```bash
# 1. Check data quality
python auto_fill_missing_data.py --analyze

# 2. Test on 10 universities
python auto_fill_missing_data.py --dry-run --limit 10

# 3. Fill high-priority fields for 100 universities
python auto_fill_missing_data.py --priority-high --limit 100

# 4. Check improvement
python auto_fill_missing_data.py --analyze
```

**2. Incremental Enrichment**
```bash
# Fill 50 universities at a time
python auto_fill_missing_data.py --limit 50

# Check progress
python auto_fill_missing_data.py --analyze

# Continue until satisfied
python auto_fill_missing_data.py --limit 50
```

**3. Complete Enrichment** (for production)
```bash
# Fill ALL universities (runs for hours)
python auto_fill_missing_data.py --all
```

---

## 🏗️ How It Works

### Architecture

```
┌──────────────────────────────────────────────────────────┐
│  Auto-Fill Orchestrator                                  │
│  ┌────────────────────────────────────────────────────┐  │
│  │  1. Scan database for NULL values                  │  │
│  │  2. Prioritize universities by missing fields      │  │
│  │  3. For each university:                           │  │
│  │     ├─ General web search (Wikipedia, DDG)         │  │
│  │     ├─ Field-specific targeted scraping            │  │
│  │     ├─ Validate and clean extracted data           │  │
│  │     └─ Update database                             │  │
│  │  4. Generate completion report                     │  │
│  └────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────┐
│  Web Search Enricher                                     │
│  ├─ Wikipedia API: Comprehensive university info         │
│  ├─ DuckDuckGo: Quick facts and instant answers         │
│  ├─ Website Validation: Guess & verify official sites    │
│  └─ Website Scraping: Extract from official pages        │
└──────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────┐
│  Field-Specific Scrapers                                 │
│  ├─ Acceptance Rate Finder                               │
│  ├─ Tuition Cost Finder                                  │
│  ├─ Test Scores Finder (SAT/ACT)                         │
│  ├─ Graduation Rate Finder                               │
│  ├─ Student Count Finder                                 │
│  ├─ Location Details Finder                              │
│  ├─ University Type Classifier                           │
│  └─ GPA Average Finder                                   │
└──────────────────────────────────────────────────────────┘
```

### Enrichment Process for Each University

```
1. Load university record from database

2. General Web Search:
   ├─ Search Wikipedia for university page
   │  ├─ Extract: description, city, founded year, student count
   │  └─ Find official website if listed
   ├─ Search DuckDuckGo instant answers
   │  └─ Extract: description, website, quick facts
   └─ Guess and validate website URL
      └─ Try patterns: university.edu, univ.ac.uk, etc.

3. Field-Specific Targeted Searches:
   For each NULL field (prioritized):
   ├─ acceptance_rate:
   │  ├─ Search: "university name acceptance rate"
   │  ├─ Scrape admissions page if website known
   │  └─ Extract percentage from text
   ├─ tuition_out_state, total_cost:
   │  ├─ Search: "university name tuition cost"
   │  ├─ Scrape financial aid/cost pages
   │  └─ Extract dollar amounts
   ├─ test_scores (SAT/ACT):
   │  ├─ Search: "university name SAT scores range"
   │  └─ Extract ranges like "1400-1550"
   └─ ... (similar for other fields)

4. Validate & Clean:
   ├─ Check data types (float, int, string)
   ├─ Validate ranges (GPA: 0-4, SAT: 400-1600, etc.)
   └─ Remove invalid or suspicious values

5. Update Database:
   ├─ Only update fields that are currently NULL
   ├─ Add updated_at timestamp
   └─ Log success/failure

6. Rate Limiting:
   └─ Wait 3 seconds before next university (configurable)
```

---

## 📊 Data Quality Improvement

### Example Results

**Before Enrichment:**
```
Field                 NULL Count    Percentage
------------------------------------------------
acceptance_rate       12,543        73.1%
gpa_average          11,892        69.3%
graduation_rate       10,234        59.7%
tuition_out_state     8,456        49.3%
```

**After Processing 500 Universities:**
```
Field                 NULL Count    Percentage    Improvement
----------------------------------------------------------------
acceptance_rate       11,043        64.4%         ⬆ 8.7%
gpa_average          10,592        61.7%         ⬆ 7.6%
graduation_rate       8,934         52.1%         ⬆ 7.6%
tuition_out_state     7,156         41.7%         ⬆ 7.6%
```

**After Processing ALL Universities (17,137):**
```
Field                 NULL Count    Percentage    Improvement
----------------------------------------------------------------
acceptance_rate       3,427         20.0%         ⬆ 53.1%
gpa_average          4,284         25.0%         ⬆ 44.3%
graduation_rate       2,570         15.0%         ⬆ 44.7%
tuition_out_state     3,427         20.0%         ⬆ 29.3%
```

---

## ⚙️ Configuration

### Rate Limiting

Default: 3 seconds between requests. Adjust based on your needs:

```bash
# Faster (2 seconds) - use carefully
python auto_fill_missing_data.py --rate-limit 2.0 --limit 100

# Slower (5 seconds) - more polite to servers
python auto_fill_missing_data.py --rate-limit 5.0 --limit 100
```

### Logging

Logs are saved to:
- **Console**: Real-time progress
- **File**: `auto_fill.log` (detailed logs)
- **Report**: `enrichment_report_YYYYMMDD_HHMMSS.txt` (final summary)

---

## 🔍 Data Sources

### Primary Sources

1. **Wikipedia** (`en.wikipedia.org`)
   - Most comprehensive
   - Structured data via API
   - High reliability

2. **DuckDuckGo** (`api.duckduckgo.com`)
   - Quick facts
   - Instant answers
   - No API key needed

3. **University Websites**
   - Authoritative source
   - Admissions, tuition, stats pages
   - Requires website discovery first

### Search Strategies

**For Acceptance Rate:**
- Search query: `"university name acceptance rate"`
- Check admissions pages: `/admissions`, `/apply`
- Look for patterns: `"XX% acceptance rate"`, `"acceptance rate: XX%"`

**For Tuition:**
- Search query: `"university name tuition cost"`
- Check cost pages: `/tuition`, `/costs`, `/financial-aid/costs`
- Extract dollar amounts: `$XX,XXX`

**For Test Scores:**
- Search query: `"university name SAT scores range"` or `"ACT scores"`
- Look for ranges: `"SAT: 1400-1550"`, `"ACT: 30-34"`
- Estimate 25th/75th percentiles from ranges

---

## 📁 Project Structure

```
recommendation_service/
├── app/
│   └── enrichment/                     # NEW enrichment module
│       ├── __init__.py
│       ├── web_search_enricher.py      # General web search
│       ├── field_scrapers.py           # Field-specific scrapers
│       └── auto_fill_orchestrator.py   # Main orchestration logic
├── auto_fill_missing_data.py           # Command-line script
├── DATA_ENRICHMENT_README.md           # This file
└── auto_fill.log                       # Generated log file
```

---

## ⚠️ Important Notes

### Legal & Ethical

- ✅ Uses public APIs (Wikipedia, DuckDuckGo)
- ✅ Respects robots.txt
- ✅ Rate limiting prevents server overload
- ✅ Educational/research use case
- ⚠️ Review terms of service for intensive scraping

### Technical Limitations

- **Wikipedia**: Not all universities have detailed pages
- **Website Discovery**: Some universities use non-standard domains
- **Data Accuracy**: Web-scraped data may have errors → validate important fields
- **Coverage**: Some fields harder to find than others
- **Speed**: Processing 17k universities takes several hours

### Best Practices

1. **Start Small**: Test with `--limit 10` first
2. **Use Dry Run**: Verify results before updating database
3. **Prioritize**: Fill high-priority ML fields first
4. **Verify**: Check `--analyze` after each run
5. **Review Logs**: Check `auto_fill.log` for errors
6. **Validate**: Manually verify suspicious values

---

## 🚨 Troubleshooting

### Issue: "No data found"
**Solution**: Check internet connection, try different universities

### Issue: "Many errors"
**Solution**: Increase `--rate-limit`, check firewall/VPN

### Issue: "Low success rate"
**Solution**: Universities with uncommon names harder to find - this is normal

### Issue: "Script very slow"
**Solution**: Default 3s delay is intentional. Use `--rate-limit 2.0` cautiously

---

## 🎯 Next Steps After Enrichment

### 1. Verify Data Quality
```bash
python auto_fill_missing_data.py --analyze
```

Check that high-priority fields have <30% NULL values

### 2. Train ML Models
```bash
python train_ml_models.py
```

ML models will now train on more complete data

### 3. Monitor & Iterate

- Run enrichment periodically for new universities
- Update existing records as data changes
- Refine scrapers based on success rates

---

## 📊 Success Metrics

**Good Data Quality for ML Training:**
- ✅ acceptance_rate: <30% NULL
- ✅ gpa_average: <40% NULL
- ✅ graduation_rate_4year: <40% NULL
- ✅ tuition_out_state: <35% NULL
- ✅ total_students: <30% NULL
- ✅ test_scores: <50% NULL (less critical)

**Acceptable:**
- ✅ location_type: <60% NULL
- ✅ university_type: <40% NULL
- ✅ website: <50% NULL

**Can Be Sparse:**
- ✅ logo_url: Can be >70% NULL
- ✅ description: Can be >60% NULL

---

## 🎉 Summary

The Automated Data Enrichment System:

1. ✅ Analyzes your database for NULL values
2. ✅ Intelligently prioritizes what to fill first
3. ✅ Searches multiple web sources automatically
4. ✅ Uses field-specific scraping strategies
5. ✅ Updates database with validated data
6. ✅ Provides detailed progress reports
7. ✅ Prepares your data for ML training

**Result**: High-quality, complete university database → Better ML models → More accurate recommendations!

---

## 🔗 Related Documentation

- **ML Training**: See `ML_README.md`
- **API Documentation**: See `RAILWAY_DEPLOYMENT.md`
- **Database Setup**: See `SUPABASE_SETUP.md`

---

*Data Enrichment System - November 2025*
*Preparing data for ML-powered college recommendations*
