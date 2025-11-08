# University Data Fillers

Comprehensive collection of automated data filling programs for university database enrichment.

## Overview

This directory contains specialized programs that automatically search the web and fill missing university data. Each program focuses on a specific field and can run independently or in parallel via the orchestrator.

## Available Fillers

### ✅ Tested & Working (30-40% success rate)

1. **Website Filler** (`auto_fill_website.py`)
   - **Target Field**: `website`
   - **NULL Percentage**: 24.8%
   - **Success Rate**: 30%
   - **Strategy**: URL construction patterns + web search fallback
   - **Supported**: US (.edu), UK (.ac.uk), AU (.edu.au), CN (.edu.cn)
   - **Usage**: `python auto_fill_website.py --limit 500`

2. **Logo Filler** (`auto_fill_logo.py`)
   - **Target Field**: `logo_url`
   - **NULL Percentage**: 100%
   - **Success Rate**: 30%
   - **Strategy**: Scrapes logos directly from university websites
   - **Dependency**: Requires `website` field to be filled first
   - **Usage**: `python auto_fill_logo.py --limit 500`

3. **Students Filler** (`auto_fill_students.py`)
   - **Target Field**: `total_students`
   - **NULL Percentage**: 89.5%
   - **Success Rate**: 40%
   - **Strategy**: Pattern matching on search results
   - **Range**: 100 to 1,000,000 students
   - **Usage**: `python auto_fill_students.py --limit 500`

### 🔄 Created (Ready to Use)

4. **Acceptance Rate Filler** (`auto_fill_acceptance_rate.py`)
   - **Target Field**: `acceptance_rate`
   - **NULL Percentage**: 91.1%
   - **Strategy**: Regex pattern matching for percentage rates
   - **Range**: 1% to 100%
   - **Usage**: `python auto_fill_acceptance_rate.py --limit 500`

5. **University Type Filler** (`auto_fill_university_type.py`)
   - **Target Field**: `university_type`
   - **NULL Percentage**: 89.5%
   - **Strategy**: Scoring system for public vs private indicators
   - **Returns**: "Public" or "Private"
   - **Usage**: `python auto_fill_university_type.py --limit 500`

6. **Tuition Filler** (`auto_fill_tuition.py`)
   - **Target Field**: `tuition_out_state`
   - **NULL Percentage**: 89.8%
   - **Focus**: US universities only
   - **Range**: $5,000 to $80,000
   - **Usage**: `python auto_fill_tuition.py --limit 300`

7. **Graduation Rate Filler** (`auto_fill_graduation_rate.py`)
   - **Target Field**: `graduation_rate_4year`
   - **NULL Percentage**: 90.0%
   - **Focus**: US universities only
   - **Range**: 10% to 100%
   - **Usage**: `python auto_fill_graduation_rate.py --limit 300`

8. **Location Type Filler** (`auto_fill_location_type.py`)
   - **Target Field**: `location_type`
   - **NULL Percentage**: 89.5%
   - **Strategy**: Scoring system for urban/suburban/rural indicators
   - **Returns**: "Urban", "Suburban", or "Rural"
   - **Usage**: `python auto_fill_location_type.py --limit 500`

## Search Engine Helper

### `search_engine_helper.py`

Multi-engine search utility that provides automatic fallback across different search engines.

**Features**:
- Automatic fallback: DuckDuckGo → Bing → Yahoo
- Handles HTTP 403 blocking gracefully
- Returns concatenated search snippets for pattern matching
- Shared session management for efficiency
- Consistent User-Agent across all engines

**Usage**:
```python
from search_engine_helper import SearchEngineHelper

helper = SearchEngineHelper()
text = helper.search("Stanford University acceptance rate")
if text:
    # Extract data using regex patterns
    match = re.search(r'(\d+)% acceptance', text)
```

All fillers (except Website and Logo which use different strategies) now use this helper for improved reliability.

## Orchestrator

### `run_all_fillers.py`

Runs all fillers in parallel with priority-based execution.

**Priority Levels**:
- **Priority 1**: Website, Students, University Type, Location Type (run first, in parallel)
- **Priority 2**: Logo, Acceptance Rate (run after priority 1)
- **Priority 3**: Tuition, Graduation Rate (US-only, run last)

**Usage**:
```bash
# Run with default 3 workers
python run_all_fillers.py

# Run with 8 workers (all fillers in parallel)
python run_all_fillers.py --workers 8

# Run with 4 workers (balanced)
python run_all_fillers.py --workers 4
```

**Process Flow**:
1. Sorts fillers by priority
2. Launches all fillers using ThreadPoolExecutor
3. Collects results as they complete
4. Prints comprehensive summary

## Database Fields Coverage

### High Priority Fields (>85% NULL)
- ✅ `logo_url` (100% NULL) - Logo Filler
- ✅ `acceptance_rate` (91.1% NULL) - Acceptance Rate Filler
- ✅ `graduation_rate_4year` (90.0% NULL) - Graduation Rate Filler
- ✅ `tuition_out_state` (89.8% NULL) - Tuition Filler
- ✅ `university_type` (89.5% NULL) - University Type Filler
- ✅ `location_type` (89.5% NULL) - Location Type Filler
- ✅ `total_students` (89.5% NULL) - Students Filler

### Medium Priority Fields (20-85% NULL)
- ✅ `city` (80.2% NULL) - City/State Filler (completed 1000 universities)
- ✅ `state` (75.2% NULL) - City/State Filler (completed 1000 universities)
- ✅ `website` (24.8% NULL) - Website Filler

### Low Priority Fields (<20% NULL)
- ✓ `description` (0% NULL) - No action needed
- ✓ `name`, `country` - Core fields, always present

## Technical Details

### Rate Limiting
- Default: 3 seconds between requests
- Jitter: ±0.5 seconds random variation
- Prevents search engine blocking

### Search Strategy
1. **URL Construction** (Website filler only)
   - Generate likely domain patterns
   - Validate accessibility
   - Fastest method (no web search needed)

2. **Multi-Engine Web Search** (All fillers)
   - Primary: DuckDuckGo HTML interface
   - Fallback 1: Bing search
   - Fallback 2: Yahoo search
   - Parse search result snippets
   - Extract data using regex patterns
   - **New in v2**: Added multi-engine fallback via `SearchEngineHelper` class

3. **Website Scraping** (Logo filler only)
   - Direct access to university website
   - Multiple extraction strategies
   - Finds logo in common HTML patterns

### Data Validation
Each filler validates extracted data:
- Range checks (tuition: $5k-$80k, students: 100-1M, etc.)
- Format validation (URLs, percentages)
- Logical constraints (rates between 1-100%)

## Known Issues

### Search Engine Blocking (Resolved - v2)
**UPDATE**: Multi-engine fallback has been implemented to address blocking issues.

Previously, some fillers experienced temporary blocking from DuckDuckGo (HTTP 403 errors). This has been resolved by implementing a multi-engine search strategy via the `SearchEngineHelper` class:
- Primary: DuckDuckGo HTML interface
- Fallback 1: Bing search
- Fallback 2: Yahoo search

All fillers now use this multi-engine approach, significantly reducing blocking issues. Success rates have improved from 0% to 10%+ for previously blocked fillers.

**Additional Mitigation Strategies**:
1. Run fillers at different times
2. Reduce worker count in orchestrator
3. Increase rate limiting delay
4. Use VPN or different network if needed

The Website, Logo, and Students fillers use URL construction or different search patterns and maintain 30-40% success rates.

## Monitoring Progress

### Individual Filler
Each filler provides real-time progress:
```
[15/500] Stanford University (US)
  ✓ Found: https://stanford.edu
```

### Orchestrator
Monitor background process:
```bash
# Get process ID from orchestrator output
# Then check output periodically
# Results shown when each filler completes
```

## Performance Metrics

### Processing Time
- Single university: ~3-5 seconds (with rate limiting)
- 100 universities: ~6-8 minutes
- 500 universities: ~30-40 minutes
- 1000 universities: ~1-1.5 hours

### Success Rates (Tested)
- Website: 30%
- Logo: 30%
- Students: 40%
- Others: TBD (currently blocked)

### Parallel Execution
Running 8 fillers simultaneously (500 each = 4000 total):
- Expected time: ~30-40 minutes
- Total data points: ~800-1200 (at 20-30% avg success)

## Best Practices

1. **Start Small**: Test with `--limit 10` before large batches
2. **Use Orchestrator**: More efficient than running individually
3. **Monitor First Run**: Check output to ensure working correctly
4. **Stagger Runs**: Don't run multiple orchestrators simultaneously
5. **Check Results**: Verify data quality in database after completion

## Future Enhancements

Potential additional fillers:
- Global Rank Filler (91.2% NULL)
- National Rank Filler (100% NULL)
- Median Earnings Filler (89.9% NULL)
- Total Cost Filler (90.1% NULL)
- SAT/ACT Score Fillers (94-100% NULL)

## Support

For issues or questions:
1. Check individual filler logs for error messages
2. Verify database connection
3. Check DuckDuckGo accessibility
4. Review rate limiting settings
