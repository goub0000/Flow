# International University Data Sources

Your current system includes:
- ✅ **QS World University Rankings 2025**: ~1,503 universities (global coverage)
- ✅ **College Scorecard**: ~1,804 universities (USA only)
- ✅ **Total**: 3,295 universities

## Current Global Coverage

**Good news:** Your QS Rankings already include universities from all continents! However, detailed admission data (like College Scorecard provides for USA) is limited outside the US.

---

## Recommended Data Sources by Region

### 1. CANADA 🇨🇦

**Best Source: Common University Data Ontario (CUDO)**
- **URL**: https://ontariosuniversities.ca/open-data/cudo/
- **Coverage**: Ontario universities (Canada's most populous province)
- **Data**: Similar to College Scorecard (enrollment, graduation rates, employment)
- **Format**: Open data, CSV downloads
- **Cost**: Free

**Alternative: Statistics Canada**
- **Coverage**: National data
- **Limitation**: Aggregated, not university-specific
- **URL**: https://www.statcan.gc.ca/

**Implementation Priority**: ⭐⭐⭐ HIGH
- Canada is a top study destination for international students
- CUDO data quality is similar to College Scorecard
- Easy to integrate (CSV format)

---

### 2. GLOBAL RANKINGS (All Regions)

**Best Source: Times Higher Education (THE) Rankings**
- **Kaggle Dataset**: https://www.kaggle.com/datasets/raymondtoo/the-world-university-rankings-2016-2024
- **Coverage**: 1,500+ universities globally (2016-2025 data)
- **Format**: CSV
- **Cost**: Free
- **Update**: Community-maintained, updated annually

**What THE adds to your database:**
- Different ranking methodology than QS
- Additional universities not in QS Rankings
- Teaching quality scores
- Research impact scores
- International outlook scores

**Implementation Priority**: ⭐⭐⭐⭐⭐ HIGHEST
- Complements QS Rankings perfectly
- Easy to integrate (already using Kaggle)
- Covers all regions you want

---

### 3. LATIN AMERICA 🌎

**Best Source: UNESCO WHED (World Higher Education Database)**
- **URL**: https://whed.net/
- **Coverage**: All Latin American countries
- **Data**: University names, locations, programs, accreditation
- **Format**: Web portal (may require scraping or API request)
- **Cost**: Free for basic access

**Alternative: Universities List API**
- **URL**: https://www.jsonapi.co/public-api/Universities%20List
- **Coverage**: Global, includes Latin America
- **Data**: Names, countries, domains, websites
- **Format**: JSON API
- **Cost**: Free

**Regional Data Portals:**
- Argentina: datos.gob.ar
- Brazil: dados.gov.br
- Chile: datos.gob.cl
- Colombia: datos.gov.co (has university location data)
- Mexico: datos.gob.mx

**Implementation Priority**: ⭐⭐⭐ MEDIUM-HIGH
- Growing market for international students
- Basic data available via API
- Regional portals for detailed data

---

### 4. AFRICA 🌍

**Best Source: openAFRICA**
- **URL**: https://open.africa/
- **Coverage**: All African countries
- **Data**: Educational institutions, varies by country
- **Format**: Various (CSV, JSON, APIs)
- **Cost**: Free

**Alternative: Africa Information Highway Portal**
- **URL**: https://dataportal.opendataforafrica.org/
- **Coverage**: 54 African countries + 16 regional organizations
- **Data**: Statistics including education
- **API**: https://dataportal.opendataforafrica.org/dev/explorer
- **Cost**: Free

**Alternative: DataFirst (University of Cape Town)**
- **Coverage**: South Africa and other African countries
- **Data**: Survey and administrative data
- **Quality**: High (research-grade data)

**Implementation Priority**: ⭐⭐ MEDIUM
- Fragmented data across countries
- May require multiple data sources
- Growing market but data availability varies

---

### 5. ASIA 🌏

**Best Source: Universities List API**
- **URL**: https://publicapi.dev/universities-list-api
- **Coverage**: All Asian countries
- **Data**: Names, countries, domains, websites
- **Format**: JSON API
- **Cost**: Free

**Alternative: UNESCO WHED (Asia)**
- **URL**: https://whed.net/search_by_region.php?region=Asia
- **Coverage**: Comprehensive Asia coverage
- **Data**: Institutional details, programs, accreditation
- **Format**: Web portal

**Country-Specific:**
- **China**: China Academic Degrees and Graduate Education Information
- **India**: AICTE, UGC databases (government sources)
- **Japan**: JASSO (Japan Student Services Organization)
- **South Korea**: KESS (Korean Educational Statistics Service)

**Implementation Priority**: ⭐⭐⭐⭐ HIGH
- Largest international student market
- API available for basic data
- Country-specific sources for detailed data

---

## Implementation Roadmap

### Phase 1: High-Value, Easy Integrations (Now)

1. **Times Higher Education Rankings** (Kaggle)
   - Similar to your QS Rankings integration
   - Adds ~1,500 universities globally
   - **Effort**: LOW (2-3 hours)
   - **Value**: HIGH

2. **Universities List API**
   - Global coverage, simple API
   - Basic data (name, country, website, domain)
   - **Effort**: LOW (1-2 hours)
   - **Value**: MEDIUM-HIGH

### Phase 2: Regional Deep Dives (Next)

3. **Canada: CUDO**
   - Ontario universities with detailed data
   - Similar quality to College Scorecard
   - **Effort**: MEDIUM (4-6 hours)
   - **Value**: HIGH

4. **UNESCO WHED**
   - Global coverage, all regions
   - Institutional details
   - **Effort**: MEDIUM-HIGH (may need scraping)
   - **Value**: HIGH

### Phase 3: Country-Specific (Later)

5. **Latin America Regional Portals**
   - Country-by-country integration
   - **Effort**: HIGH (varies by country)
   - **Value**: MEDIUM

6. **Africa Open Data Platforms**
   - Multiple sources needed
   - **Effort**: HIGH
   - **Value**: MEDIUM

---

## Quick Start: Add THE Rankings Today

### Step 1: Download THE Rankings from Kaggle

```python
# Add to kaggle_downloader.py
def download_the_rankings(self, year='2025', force=False):
    """Download Times Higher Education World University Rankings"""
    dataset_ref = 'raymondtoo/the-world-university-rankings-2016-2024'
    return self.download_dataset(dataset_ref, force=force)
```

### Step 2: Parse THE Rankings CSV

Similar to QS Rankings, create a parser for THE data structure.

### Step 3: Import to Supabase

Merge with existing university records or add new ones.

---

## Quick Start: Add Universities List API

### API Endpoint
```
GET http://universities.hipolabs.com/search
```

### Query Parameters
- `country` - Filter by country name or code
- `name` - Filter by university name

### Example Requests

**All universities in Canada:**
```
http://universities.hipolabs.com/search?country=Canada
```

**All universities in Brazil:**
```
http://universities.hipolabs.com/search?country=Brazil
```

**All universities in South Africa:**
```
http://universities.hipolabs.com/search?country=South%20Africa
```

### Response Format
```json
[
  {
    "name": "University of Toronto",
    "country": "Canada",
    "alpha_two_code": "CA",
    "state-province": "Ontario",
    "domains": ["utoronto.ca"],
    "web_pages": ["https://www.utoronto.ca"]
  }
]
```

### Implementation
```python
import requests

def fetch_universities_by_country(country):
    url = f"http://universities.hipolabs.com/search?country={country}"
    response = requests.get(url)
    return response.json()

# Fetch all Canadian universities
canadian_unis = fetch_universities_by_country("Canada")

# Fetch all Brazilian universities
brazilian_unis = fetch_universities_by_country("Brazil")
```

---

## Data Quality Comparison

| Source | Coverage | Detail Level | Update Frequency | Ease of Integration |
|--------|----------|--------------|------------------|---------------------|
| QS Rankings | Global (1,503) | Medium | Annual | ✅ Already done |
| College Scorecard | USA (1,804) | High | Annual | ✅ Already done |
| THE Rankings | Global (1,500+) | Medium | Annual | ⭐⭐⭐⭐⭐ Easy (Kaggle) |
| Universities List API | Global (9,000+) | Basic | Unknown | ⭐⭐⭐⭐⭐ Easy (API) |
| CUDO (Canada) | Ontario | High | Annual | ⭐⭐⭐⭐ Easy (CSV) |
| UNESCO WHED | Global | Medium | Ongoing | ⭐⭐⭐ Medium (Portal) |
| Regional Portals | Varies | Varies | Varies | ⭐⭐ Complex |

---

## Estimated Total Coverage After Implementation

**Current:**
- 3,295 universities (QS + College Scorecard)
- Strong coverage: USA, Europe, Asia (top universities)
- Weak coverage: Africa, Latin America, Canada (details)

**After Phase 1 (THE + Universities List API):**
- **~12,000+ universities globally**
- Excellent coverage: All regions
- Detail level: Basic to medium for most, high for USA

**After Phase 2 (CUDO + UNESCO):**
- **~15,000+ universities**
- Excellent coverage: All regions
- Detail level: High for USA + Canada, medium for others

---

## Recommendation

**Start with Phase 1 today:**

1. **Add THE Rankings** (2-3 hours)
   - Download from Kaggle: https://www.kaggle.com/datasets/raymondtoo/the-world-university-rankings-2016-2024
   - Parse CSV (similar to QS)
   - Import to Supabase
   - **Result**: +1,500 universities, better global coverage

2. **Add Universities List API** (1-2 hours)
   - Simple HTTP API
   - Fetch data for target countries (Canada, Brazil, Mexico, South Africa, Kenya, India, China, etc.)
   - Import basic info (name, country, website)
   - **Result**: +8,000 universities with basic data

**Total time investment: 3-5 hours**
**Total universities: ~12,000+**
**Global coverage: Excellent**

This gives you comprehensive global coverage quickly, and you can add detailed data sources (CUDO, regional portals) later as needed.

---

## Next Steps

1. Review this document and decide which sources to prioritize
2. I can help implement THE Rankings integration (similar to QS)
3. I can help implement Universities List API integration
4. Set up automated monthly updates for all sources

Which source would you like to add first?
