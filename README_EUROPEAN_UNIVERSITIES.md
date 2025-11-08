# European & Global Universities Import Guide

This guide explains how to import European and global universities using QS World University Rankings and other data sources.

## ⚡ FASTEST METHOD - Auto-Download Latest Rankings (2026, 2027, etc.)

```bash
cd "C:\Flow_App (1)\Flow\recommendation_service"

# Automatically find and download the LATEST QS Rankings
python import_universities.py --kaggle latest
```

**What this does:**
- Automatically searches for QS Rankings 2027, 2026, 2025, etc.
- Downloads the most recent available dataset
- Falls back to QS 2025 if newer versions aren't available yet
- Imports all 1,500+ universities globally

**See:** [README_AUTO_UPDATES.md](README_AUTO_UPDATES.md) for scheduled automatic updates.

---

## Quick Start - QS Rankings (RECOMMENDED for European universities)

The QS World University Rankings includes **1,500+ universities** globally, with **500+ European universities** from countries like:
- United Kingdom (90+ universities)
- Germany (46 universities)
- France (35 universities)
- Italy (41 universities)
- Spain (32 universities)
- Netherlands (13 universities)
- Switzerland (10 universities)
- And 34+ more European countries!

### Step 1: Download QS Rankings 2025 Dataset

**Option A: Kaggle (FREE, Easiest)**
1. Visit: https://www.kaggle.com/datasets/melissamonfared/qs-world-university-rankings-2025
2. Click "Download" (you may need to create a free Kaggle account)
3. Extract the CSV file (e.g., `qs-world-university-rankings-2025.csv`)
4. Place it in the `recommendation_service` directory

**Option B: Manual Download from QS**
1. Visit: https://www.topuniversities.com/world-university-rankings
2. You can scrape or manually compile the data (CSV format)

### Step 2: Import the Data

Once you have the CSV file:

```bash
cd "C:\Flow_App (1)\Flow\recommendation_service"

# Import all universities from the CSV
python import_universities.py --csv qs-world-university-rankings-2025.csv

# Or import limited number (e.g., top 500)
python import_universities.py --csv qs-world-university-rankings-2025.csv --limit 500
```

### Step 3: Verify Import

```bash
python import_universities.py --stats
```

You should see universities from multiple countries including many European nations!

---

## Alternative Data Sources

### 1. ETER Database (European Tertiary Education Register)

**Best for**: Comprehensive European coverage (3,500+ institutions, 41 countries)

**Data Available**:
- Official government-sourced data
- Student enrollment, finances, research data
- Free access (some restricted data requires researcher registration)

**How to Get Data**:

1. **Option A: CSV Download**
   - Visit: https://www.eter-project.com/
   - Click "Data" → "Download"
   - Register for free account
   - Download full dataset (CSV format)
   - Place in `recommendation_service` directory
   - Import: `python import_universities.py --csv eter_data.csv`

2. **Option B: API Access** (Advanced)
   - Register at eter-project.com
   - Get API credentials
   - We can implement ETER API fetcher (similar to College Scorecard)

### 2. Times Higher Education Rankings

**Coverage**: 1,900+ universities globally (includes many European)

**How to Get Data**:
- CSV datasets available on Kaggle
- Search: "Times Higher Education World University Rankings"
- Import same way as QS Rankings

### 3. Country-Specific Sources

**UK**: HESA (Higher Education Statistics Agency)
- https://www.hesa.ac.uk/data-and-analysis

**Germany**: HRK Database
- https://www.hrk.de/

**France**: data.gouv.fr
- https://data.gouv.fr/ (search for "universités")

---

## CSV File Format Requirements

The importer expects CSV files with these columns (flexible column names):

**Required:**
- `University` or `Institution` or `name` - University name
- `Country` or `country` or `Location` - Country name

**Optional:**
- `Rank` or `rank` - Global ranking
- `Overall Score` - Overall score/rating
- `Academic Reputation` - Academic reputation score
- `Employer Reputation` - Employer reputation score

**Example CSV structure**:
```csv
Rank,University,Country,Overall Score
1,Massachusetts Institute of Technology,United States,100
2,University of Cambridge,United Kingdom,99.2
3,University of Oxford,United Kingdom,98.9
4,ETH Zurich,Switzerland,93.3
5,Sorbonne University,France,88.5
```

The importer will automatically:
- Detect column names (case-insensitive)
- Parse rank ranges (e.g., "101-110" → 101)
- Map country names to ISO codes
- Clean and normalize data

---

## European University Coverage by Country

After importing QS Rankings, you'll have universities from:

**Western Europe:**
- United Kingdom (90+)
- Germany (46)
- France (35)
- Netherlands (13)
- Switzerland (10)
- Belgium (9)
- Austria (8)
- Ireland (7)

**Southern Europe:**
- Italy (41)
- Spain (32)
- Portugal (7)
- Greece (8)

**Northern Europe:**
- Sweden (12)
- Denmark (8)
- Norway (7)
- Finland (10)

**Eastern Europe:**
- Poland (18)
- Czech Republic (7)
- Russia (28)

And many more!

---

## Usage Examples

### Import Top 100 Global Universities (includes top European)
```bash
python import_universities.py --csv qs-world-university-rankings-2025.csv --limit 100
```

### Import All Universities from CSV
```bash
python import_universities.py --csv qs-world-university-rankings-2025.csv
```

### Check What You've Imported
```bash
python import_universities.py --stats
```

### Combine US and European Data
```bash
# First import US universities from College Scorecard
python import_universities.py --source collegecard --limit 500

# Then import global universities from QS
python import_universities.py --csv qs-world-university-rankings-2025.csv

# Check total count
python import_universities.py --stats
```

---

## Troubleshooting

### "CSV file not found"
- Make sure the CSV file is in the `recommendation_service` directory
- Check the filename matches exactly (including extension)
- Use quotes if filename has spaces: `--csv "QS Rankings 2025.csv"`

### "No universities found in CSV"
- Check CSV format (must have University/Institution and Country columns)
- Try opening CSV in text editor to verify structure
- Ensure CSV is not corrupted

### "Failed to parse row X"
- Check that row in CSV for formatting issues
- The importer will skip bad rows and continue

---

## Next Steps

After importing European universities:

1. **Verify Import**
   ```bash
   python import_universities.py --stats
   ```

2. **Test Recommendations**
   - Open the Flutter app
   - Go through the questionnaire
   - Select a European country in "Preferred Countries"
   - View recommendations

3. **Import More Data**
   - Combine multiple sources (QS + ETER + College Scorecard)
   - Import country-specific datasets
   - Add Times Higher Education rankings

4. **Update Regularly**
   - QS updates rankings annually
   - Re-import CSV to get latest rankings

---

## Future Enhancements

We can add:
- **ETER API Integration**: Direct API access to European university data
- **Automatic Updates**: Scheduled imports from multiple sources
- **Country Filters**: Import only specific countries
- **Ranking Filters**: Import only top-ranked universities
- **Data Enrichment**: Combine data from multiple sources

---

## Support

For issues:
1. Check this README
2. Review error messages (they usually include solutions)
3. Verify CSV format
4. Check Kaggle for latest datasets

## Quick Reference

| Task | Command |
|------|---------|
| Import QS Rankings | `python import_universities.py --csv qs-rankings-2025.csv` |
| Import top 500 only | `python import_universities.py --csv qs-rankings-2025.csv --limit 500` |
| View statistics | `python import_universities.py --stats` |
| Import US universities | `python import_universities.py --source collegecard --limit 500` |
| Combine sources | Run multiple imports sequentially |
