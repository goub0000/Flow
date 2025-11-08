# University Data Collection System - Complete Overview

Comprehensive documentation for all university data collection methods in the Flow App.

## System Architecture

The Flow App uses a **multi-layered data collection strategy** that combines:

1. **Search Engine-Based Fillers** - Fast, low accuracy (10-40%)
2. **Direct Website Scraping** - Slower, higher accuracy (variable)
3. **API Integrations** - Structured data when available
4. **Wikipedia Scraping** - Bulk university discovery

All systems work **in parallel** and are designed to complement each other.

---

## 1. Search Engine-Based Data Fillers

### Purpose
Fill missing university data by searching the web and parsing result snippets.

### Strategy
- Query: `"{university name} {country} {field_specific_keywords}"`
- Parse search result snippets
- Extract using regex patterns
- Validate and store

### Components

#### A. Multi-Engine Search Helper (`search_engine_helper.py`)
Automatic fallback across search engines to avoid blocking:
- **Primary**: DuckDuckGo HTML
- **Fallback 1**: Bing
- **Fallback 2**: Yahoo

```python
from search_engine_helper import SearchEngineHelper

helper = SearchEngineHelper()
text = helper.search("Stanford University acceptance rate")
```

#### B. Specialized Fillers (9 programs)

**Working Fillers** (30-40% success):
1. **Website** (`auto_fill_website.py`)
   - Uses URL construction + validation
   - Patterns: stanford.edu, upenn.edu, etc.
   - Success: 30%

2. **Logo** (`auto_fill_logo.py`)
   - Scrapes from university website
   - Finds logo in HTML
   - Requires website field first
   - Success: 30%

3. **Students** (`auto_fill_students.py`)
   - Total enrollment numbers
   - Range: 100-1,000,000
   - Success: 40%

**Recently Improved** (10%+ success):
4. **Acceptance Rate** (`auto_fill_acceptance_rate.py`)
   - Admission/acceptance rates
   - Range: 1-100%
   - Success: 10%+

5. **University Type** (`auto_fill_university_type.py`)
   - Public vs Private
   - Scoring system
   - Success: 10%+

6. **Tuition** (`auto_fill_tuition.py`)
   - US universities only
   - Range: $5,000-$80,000
   - Success: Variable

7. **Graduation Rate** (`auto_fill_graduation_rate.py`)
   - 4-year graduation rates
   - US universities only
   - Range: 10-100%
   - Success: Variable

8. **Location Type** (`auto_fill_location_type.py`)
   - Urban/Suburban/Rural
   - Scoring system
   - Success: 10%+

#### C. Orchestrator (`run_all_fillers.py`)
Runs all fillers in parallel with priority-based execution.

**Usage**:
```bash
# Default: 3 workers
python run_all_fillers.py

# With 8 workers (all in parallel)
python run_all_fillers.py --workers 8

# With 4 workers (balanced)
python run_all_fillers.py --workers 4
```

**Priority System**:
- **Priority 1**: Website, Students, University Type, Location Type (500 each)
- **Priority 2**: Logo, Acceptance Rate (500 each)
- **Priority 3**: Tuition, Graduation Rate (300 each, US only)

---

## 2. Direct University Website Scraping

### Purpose
Extract data directly from official university websites for higher accuracy.

### Strategy
- Start from university homepage
- Find relevant pages (admissions, about, costs)
- Crawl up to 10 pages per university
- Extract structured data
- More accurate but slower (5s per request)

### Components

#### A. Website Scraper Class (`app/data_fetchers/university_website_scraper.py`)
Extends `BaseScraper` with direct crawling capabilities.

**Features**:
- Finds admissions/about/cost pages automatically
- Extracts 12+ data fields
- Pattern-based extraction
- Validates ranges
- Polite 5-second rate limiting

**Data Extracted**:
- Acceptance rate
- Tuition costs
- Graduation rates
- Total students
- University type (Public/Private)
- Location type (Urban/Suburban/Rural)
- Contact information (when columns exist)
- Test scores (SAT/ACT) - ready for future use
- GPA requirements - ready for future use

**Usage**:
```python
from app.data_fetchers.university_website_scraper import UniversityWebsiteScraper

scraper = UniversityWebsiteScraper(rate_limit_delay=5.0)
data = scraper.scrape_university("https://stanford.edu", "Stanford University")
# Returns: {'acceptance_rate': 3.9, 'tuition_out_state': 56169, ...}
```

#### B. Runner Program (`scrape_university_websites.py`)
Processes universities from database that have website URLs.

**Usage**:
```bash
# Process 100 universities with websites
python scrape_university_websites.py --limit 100

# Process US universities only
python scrape_university_websites.py --limit 200 --country US

# Adjust rate limiting (default 5s)
python scrape_university_websites.py --limit 50 --rate-limit 8.0
```

**Features**:
- Fetches universities with non-null websites
- Optional country filtering
- Automatic field exclusion (phone/email until columns added)
- Comprehensive statistics tracking

---

## 3. API Integrations

### A. College Scorecard API (`app/data_fetchers/college_scorecard.py`)
Official US Department of Education data.

**Coverage**: US universities only

**Data**:
- Tuition costs
- Graduation rates
- Median earnings
- Demographics
- Test scores

### B. QS Rankings (`app/data_fetchers/qs_rankings.py`)
World university rankings.

### C. THE Rankings (`app/data_fetchers/the_rankings.py`)
Times Higher Education rankings.

### D. Universities List API (`app/data_fetchers/universities_list_api.py`)
Third-party university directory API.

---

## 4. Wikipedia Scraping

### Purpose
Discover universities in bulk from Wikipedia "List of universities in [Country]" pages.

### Components

#### Wikipedia Scraper (`app/data_fetchers/wikipedia_scraper.py`)
Scrapes 40+ countries for university lists.

**Features**:
- Parses tables and lists
- Extracts name, city, state, website
- Handles multiple page formats
- Deduplication

**Usage**:
```python
from app.data_fetchers.wikipedia_scraper import WikipediaUniversityScraper

scraper = WikipediaUniversityScraper(countries=['Nigeria', 'Kenya', 'Peru'])
universities = scraper.scrape()
```

---

## Comparison: Search vs Direct Scraping

| Feature | Search Engine Fillers | Direct Website Scraping |
|---------|----------------------|-------------------------|
| **Speed** | Fast (3s/university) | Slower (30-60s/university) |
| **Accuracy** | Low-Medium (10-40%) | Medium-High (variable) |
| **Coverage** | All universities | Only those with websites |
| **Data Depth** | Surface-level | Comprehensive |
| **Blocking Risk** | Medium (mitigated) | Low (polite delays) |
| **Dependencies** | None | Requires website field |
| **Best For** | Bulk processing | Detailed data |

---

## Running Both Systems in Parallel

### Recommended Workflow

**Phase 1: Initial Data Collection**
1. Run Wikipedia scraper for bulk discovery
2. Import College Scorecard (US only)
3. Run API integrations (rankings)

**Phase 2: Basic Data Filling** (Parallel)
```bash
# Terminal 1: Search-based fillers
python run_all_fillers.py --workers 4

# Terminal 2: Direct website scraping (after websites filled)
python scrape_university_websites.py --limit 500 --country US
```

**Phase 3: Gap Filling**
- Re-run individual fillers for NULL fields
- Use manual data entry for important universities
- Scheduled automatic updates

### Example: Processing 1000 Universities

```bash
# Day 1: Bulk discovery + basic info
python import_wikipedia_universities.py
python import_college_scorecard_to_supabase.py

# Day 2: Fill missing data (parallel)
# Terminal 1:
python run_all_fillers.py --workers 4  # ~30-40 min for 3600 universities

# Terminal 2 (after website filler completes):
python scrape_university_websites.py --limit 500  # ~4-8 hours

# Day 3: Gap filling
python auto_fill_acceptance_rate.py --limit 500
python auto_fill_tuition.py --limit 300 --country US
```

---

## Performance Metrics

### Search Engine Fillers
- **Speed**: 3-5 seconds per university
- **Success Rates**:
  - Website: 30%
  - Logo: 30%
  - Students: 40%
  - University Type: 10%
  - Acceptance Rate: 10%
  - Location Type: 10%
  - Tuition: Variable
  - Graduation Rate: Variable

### Direct Website Scraping
- **Speed**: 30-60 seconds per university (crawls multiple pages)
- **Success Rate**: Variable (depends on website structure)
- **Data Quality**: Higher (from official source)
- **Coverage**: Only universities with valid websites

### Combined Strategy
For 1000 universities:
- Search fillers: ~6-8 hours total (parallel execution)
- Direct scraping: ~8-16 hours total
- **Total data points**: 1000-2000+ (with overlap)
- **Overall coverage**: 40-60% of NULL fields filled

---

## Database Schema Support

### Current Fields (Supported)
- `name`, `country`, `city`, `state`, `website`
- `description`, `logo_url`
- `acceptance_rate`, `tuition_out_state`, `graduation_rate_4year`
- `total_students`, `university_type`, `location_type`

### Future Fields (Scraper Ready)
- `phone`, `email`
- `sat_math_25th`, `sat_math_75th`
- `sat_ebrw_25th`, `sat_ebrw_75th`
- `act_composite`, `avg_gpa`

*The direct website scraper already extracts these fields but they're filtered out until database columns are added.*

---

## Best Practices

1. **Always start with search fillers** - Fast initial coverage
2. **Use direct scraping for important/popular universities** - Higher accuracy
3. **Run systems at different times** - Avoid detection
4. **Monitor success rates** - Adjust strategies
5. **Use country filtering** - Focus on relevant regions
6. **Implement rate limiting** - Be polite to servers
7. **Log everything** - Track what works

---

## Future Enhancements

### Planned Improvements
1. **Selenium integration** - Handle JavaScript-heavy sites
2. **Program/Major scraping** - Department listings
3. **Faculty information** - Research areas
4. **Application requirements** - Detailed admissions data
5. **Alumni outcomes** - Career statistics
6. **Campus facilities** - Photos, descriptions
7. **AI-powered extraction** - LLM-based data parsing

### Database Schema Additions
- Contact fields (phone, email)
- Test score fields (SAT, ACT, GPA)
- Program/major listings
- Faculty table
- Application requirements table

---

## Troubleshooting

### Search Fillers Getting Blocked
- Increase rate limiting delay
- Reduce worker count
- Run at different times
- Use VPN if needed
- Multi-engine helper handles most blocking

### Direct Scraper Failing
- Check website URL validity
- Increase timeout (default 15s)
- Some sites block automated access
- Try with different User-Agent
- Some universities use heavy JavaScript (need Selenium)

### Low Success Rates
- Normal for some fields (tuition, graduation rates)
- Different websites have different structures
- Non-US universities often have less data
- Consider manual entry for top universities

---

## Monitoring

### Track Progress
```bash
# Check orchestrator status
ps aux | grep run_all_fillers

# Check individual filler logs
tail -f run_all_fillers.log

# Query database for progress
# (Use Supabase dashboard or SQL queries)
```

### Success Metrics
- Fields filled per university
- Overall NULL percentage reduction
- Time per university
- Error rates by field type

---

## Support

For issues or questions:
1. Check filler logs for error messages
2. Verify database connection
3. Test search engine accessibility
4. Review rate limiting settings
5. Check website accessibility for direct scraping

---

**Last Updated**: November 2025
**Version**: 2.0 (Multi-engine + Direct Scraping)
