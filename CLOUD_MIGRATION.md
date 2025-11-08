# Cloud Migration Guide

Complete guide for migrating from local storage to 100% cloud-based operation.

## Overview

The system has been migrated to use **Supabase (cloud database) for ALL storage**, eliminating local file dependencies:

### Before (Local Storage)
- ❌ Page cache: `cache/pages/` directory (local files)
- ❌ Logs: `logs/` directory (local files)
- ❌ Scheduling: Windows Task Scheduler (platform-specific)

### After (Cloud-Based)
- ✅ Page cache: Supabase `page_cache` table
- ✅ Logs: Supabase `system_logs` table
- ✅ Scheduling: Python service (platform-independent)
- ✅ Data: Supabase `universities` table (already cloud-based)

## Benefits

1. **True Cloud Operation** - Run anywhere without local storage
2. **Centralized Monitoring** - View logs from any location via database queries
3. **Better Performance** - Database-backed caching with indexes
4. **No File Management** - No need to manually clean up old files
5. **Platform Independent** - Works on Windows, Linux, Mac, Docker, cloud platforms
6. **Scalable** - Deploy multiple instances sharing the same cache/logs

## Migration Steps

### Step 1: Apply Database Migrations

Run the migration script to see the SQL that needs to be applied:

```bash
cd "C:\Flow_App (1)\Flow\recommendation_service"
python run_migrations.py
```

This will display two SQL migrations:
1. `create_page_cache_table.sql` - Cloud-based page caching
2. `create_system_logs_table.sql` - Cloud-based logging

#### Applying Migrations

**Option A: Supabase Dashboard (Recommended)**
1. Go to https://supabase.com/dashboard
2. Select your project
3. Go to **SQL Editor** (left sidebar)
4. Copy the SQL from each migration file
5. Paste and click **Run**

**Option B: Supabase CLI**
```bash
# If you have Supabase CLI installed
supabase db push
```

**Option C: Manual Execution**
The migration files are in `migrations/` directory:
- `migrations/create_page_cache_table.sql`
- `migrations/create_system_logs_table.sql`

### Step 2: Verify Migration

Run the migration script again to check status:

```bash
python run_migrations.py
```

You should see:
```
✅ page_cache table exists
✅ system_logs table exists
```

### Step 3: Test Cloud Caching

Test the cloud-based page cache:

```bash
cd "C:\Flow_App (1)\Flow\recommendation_service"
python -c "from app.utils.page_cache import PageCache; cache = PageCache(); print('Cache initialized:', cache.enabled)"
```

Expected output:
```
Page cache initialized: Supabase (7 days)
Cache initialized: True
```

### Step 4: Test Cloud Logging

Test the cloud-based logging:

```bash
python -c "from app.utils.supabase_logger import setup_supabase_logging; logger = setup_supabase_logging('test'); logger.info('Test message'); print('Logging works!')"
```

Check Supabase dashboard to verify the log appears in `system_logs` table.

### Step 5: Run System (Everything Now Cloud-Based)

```bash
# All Phase 2 features now use cloud storage automatically
python smart_update_runner.py --limit 10

# Run scheduler service (logs to Supabase)
python scheduled_updater_service.py
```

## New Components

### 1. Cloud-Based Page Cache

**File**: `app/utils/page_cache.py` (updated)

```python
from app.utils.page_cache import PageCache

# Automatically uses Supabase (no local storage)
cache = PageCache(cache_duration_days=7)

# Same API as before - transparent migration
html = cache.get("https://example.com")
if not html:
    html = fetch_from_web("https://example.com")
    cache.put("https://example.com", html)
```

**Features**:
- Stores in Supabase `page_cache` table
- Automatic expiration (default 7 days)
- Same API as before (drop-in replacement)
- No `cache/` directory needed

### 2. Cloud-Based Logging

**File**: `app/utils/supabase_logger.py` (new)

```python
from app.utils.supabase_logger import setup_supabase_logging

# Setup logger that writes to Supabase
logger = setup_supabase_logging('my_service', level=logging.INFO)

# Log as usual - automatically goes to Supabase
logger.info("Processing started")
logger.error("An error occurred", extra={'university_id': 123})
logger.exception("Exception details")  # Full stack trace to DB
```

**Features**:
- Writes to Supabase `system_logs` table
- Batch insertion for performance
- Also logs to console for development
- Full exception tracking with stack traces
- Query logs via SQL or Python

### 3. Log Viewing & Querying

**View Recent Logs**:
```python
from app.utils.supabase_logger import get_recent_logs

# Get last 100 logs
logs = get_recent_logs(limit=100)

# Filter by level
errors = get_recent_logs(level='ERROR', limit=50)

# Filter by logger name
scheduler_logs = get_recent_logs(logger_name='scheduler_service', limit=100)
```

**SQL Queries** (in Supabase SQL Editor):
```sql
-- Recent errors
SELECT timestamp, logger_name, message, exception_message
FROM system_logs
WHERE level = 'ERROR'
ORDER BY timestamp DESC
LIMIT 100;

-- Logs from specific service
SELECT timestamp, level, message
FROM system_logs
WHERE logger_name = 'scheduler_service'
  AND timestamp > NOW() - INTERVAL '24 hours'
ORDER BY timestamp DESC;

-- Error statistics
SELECT
  logger_name,
  COUNT(*) as error_count
FROM system_logs
WHERE level IN ('ERROR', 'CRITICAL')
  AND timestamp > NOW() - INTERVAL '7 days'
GROUP BY logger_name
ORDER BY error_count DESC;
```

**Get Statistics**:
```python
from app.utils.supabase_logger import get_log_statistics

# Get stats for last 7 days
stats = get_log_statistics(days=7)
print(stats)
# Output: {'ERROR': 5, 'WARNING': 12, 'INFO': 1543, ...}
```

## Database Schema

### page_cache Table

```sql
CREATE TABLE page_cache (
    url_hash TEXT PRIMARY KEY,              -- MD5 hash of URL
    url TEXT NOT NULL,                      -- Original URL
    content TEXT NOT NULL,                  -- Cached HTML
    cached_at TIMESTAMP NOT NULL,           -- When cached
    expires_at TIMESTAMP NOT NULL,          -- Expiration time
    metadata JSONB DEFAULT '{}'::jsonb,     -- Additional data
    content_size INTEGER                    -- Size in bytes
);
```

**Indexes**:
- `url_hash` (primary key) - Fast lookups
- `expires_at` - Efficient expiration cleanup

**Functions**:
- `cleanup_expired_page_cache()` - Removes expired entries

### system_logs Table

```sql
CREATE TABLE system_logs (
    id BIGSERIAL PRIMARY KEY,
    timestamp TIMESTAMP NOT NULL,
    level TEXT NOT NULL,                    -- DEBUG, INFO, WARNING, ERROR, CRITICAL
    logger_name TEXT NOT NULL,              -- Logger name
    message TEXT NOT NULL,                  -- Log message
    module TEXT,                            -- Python module
    function_name TEXT,                     -- Function name
    line_number INTEGER,                    -- Line number
    exception_type TEXT,                    -- Exception class
    exception_message TEXT,                 -- Exception message
    stack_trace TEXT,                       -- Full stack trace
    extra_data JSONB DEFAULT '{}'::jsonb,  -- Custom fields
    process_id INTEGER,                     -- Process ID
    thread_id BIGINT                        -- Thread ID
);
```

**Indexes**:
- `timestamp` - Time-based queries
- `level` - Filter by severity
- `logger_name` - Filter by service
- Composite: `(logger_name, level, timestamp)` - Common queries
- `errors` index - Fast error lookups

**Functions**:
- `cleanup_old_logs()` - Removes logs older than 30 days
- `get_log_statistics(days)` - Returns log statistics

## Maintenance

### Cache Management

```python
from app.utils.page_cache import PageCache

cache = PageCache()

# Clear specific URL
cache.invalidate("https://example.com")

# Clear all cache (removes ALL cached pages from Supabase)
cache.clear()

# Get statistics
stats = cache.get_stats()
print(f"Hit rate: {stats['hit_rate']:.1f}%")
```

### Log Management

**Automatic Cleanup** (recommended):
```sql
-- Run daily via cron or scheduled job
SELECT cleanup_old_logs();  -- Removes logs > 30 days old
```

**Manual Cleanup**:
```sql
-- Delete logs older than 7 days
DELETE FROM system_logs WHERE timestamp < NOW() - INTERVAL '7 days';

-- Delete debug logs older than 1 day
DELETE FROM system_logs
WHERE level = 'DEBUG'
  AND timestamp < NOW() - INTERVAL '1 day';
```

### Monitoring

**Cache Performance**:
```sql
-- Cache statistics
SELECT
  COUNT(*) as total_cached,
  SUM(content_size) as total_size_bytes,
  AVG(content_size) as avg_size_bytes,
  MIN(cached_at) as oldest_cache,
  MAX(cached_at) as newest_cache
FROM page_cache;

-- Expired entries
SELECT COUNT(*) as expired_count
FROM page_cache
WHERE expires_at < NOW();
```

**Log Health**:
```sql
-- Recent error rate
SELECT
  DATE(timestamp) as date,
  level,
  COUNT(*) as count
FROM system_logs
WHERE timestamp > NOW() - INTERVAL '7 days'
GROUP BY DATE(timestamp), level
ORDER BY date DESC, level;

-- Most active loggers
SELECT
  logger_name,
  COUNT(*) as log_count,
  MAX(timestamp) as last_log
FROM system_logs
WHERE timestamp > NOW() - INTERVAL '24 hours'
GROUP BY logger_name
ORDER BY log_count DESC;
```

## Performance Impact

### Page Cache

**Before (Local Files)**:
- Write: ~2-5ms per page
- Read: ~1-3ms per page
- Storage: Local disk space

**After (Supabase)**:
- Write: ~10-20ms per page (batched)
- Read: ~15-30ms per page (cached query)
- Storage: Cloud database (no local usage)

**Note**: Slightly slower but acceptable trade-off for:
- No local storage management
- Centralized cache
- Multi-instance support
- Better monitoring

### Logging

**Before (Local Files)**:
- Write: <1ms per log (local append)
- Access: Manual file viewing

**After (Supabase)**:
- Write: ~5-10ms per log (batched, async)
- Access: SQL queries from anywhere

**Optimization**: Batch writing (10 logs per batch) reduces overhead.

## Migration for Existing Deployments

If you already have a running system with local cache/logs:

### 1. Keep Old Data (Optional)

```bash
# Backup existing cache (optional)
cp -r cache/ cache_backup/

# Backup existing logs (optional)
cp -r logs/ logs_backup/
```

### 2. Apply Migrations

Follow steps 1-2 above to create new tables.

### 3. Switch Over

Just run the system - it will automatically use cloud storage:

```bash
python smart_update_runner.py --limit 10
```

Old `cache/` and `logs/` directories are no longer used.

### 4. Clean Up (Optional)

After verifying cloud storage works:

```bash
# Remove old cache directory (no longer used)
rm -rf cache/

# Keep old logs for reference, or remove
# rm -rf logs/
```

## Troubleshooting

### Issue: "Supabase credentials not found"

**Solution**: Ensure `.env` file has:
```
SUPABASE_URL=your_supabase_url
SUPABASE_KEY=your_supabase_key
```

### Issue: Cache not working

**Check**:
```python
from app.utils.page_cache import PageCache
cache = PageCache()
print("Enabled:", cache.enabled)
print("Supabase:", cache.supabase is not None)
```

**Solution**: Run migrations to create `page_cache` table.

### Issue: Logs not appearing in Supabase

**Check**:
1. Run `python run_migrations.py` to verify table exists
2. Check Supabase dashboard → Tables → `system_logs`
3. Test with:
```python
from app.utils.supabase_logger import setup_supabase_logging
import time
logger = setup_supabase_logging('test')
logger.info("Test message")
time.sleep(2)  # Wait for batch write
```

### Issue: "Too slow" performance

**Solutions**:
1. **Cache**: Already batched, no action needed
2. **Logs**: Increase batch size in `supabase_logger.py`:
```python
handler = SupabaseHandler(batch_size=20)  # Default is 10
```

## API Reference

### PageCache

```python
from app.utils.page_cache import PageCache

# Initialize (uses Supabase)
cache = PageCache(cache_duration_days=7, enabled=True)

# Get cached content
html = cache.get(url)  # Returns None if not cached/expired

# Store content
cache.put(url, html, metadata={'source': 'scraper'})

# Invalidate specific URL
cache.invalidate(url)

# Clear all cache
cache.clear()

# Get statistics
stats = cache.get_stats()
# Returns: {'hits', 'misses', 'hit_rate', 'stores', 'expired', 'errors'}

# Log statistics
cache.log_stats()
```

### Supabase Logger

```python
from app.utils.supabase_logger import setup_supabase_logging, get_recent_logs, get_log_statistics

# Setup logger
logger = setup_supabase_logging(
    logger_name='my_service',
    level=logging.INFO,
    also_log_to_console=True
)

# Log messages
logger.debug("Debug message")
logger.info("Info message")
logger.warning("Warning message")
logger.error("Error message")
logger.critical("Critical message")

# Log with extra data
logger.info("Processing item", extra={'item_id': 123, 'status': 'active'})

# Log exception
try:
    raise ValueError("Error")
except Exception:
    logger.exception("An error occurred")  # Includes full stack trace

# Retrieve logs
recent = get_recent_logs(level='ERROR', limit=100)
scheduler_logs = get_recent_logs(logger_name='scheduler_service', limit=50)

# Get statistics
stats = get_log_statistics(days=7)
```

## Summary

The system now operates **100% cloud-based** with:

- ✅ **Page cache** in Supabase (not local files)
- ✅ **Logs** in Supabase (not local files)
- ✅ **Scheduling** via Python service (not OS-specific)
- ✅ **Data** in Supabase (already was cloud-based)

**Result**: True cloud operation with no local dependencies!

## See Also

- `README_COMPLETE_SYSTEM.md` - System overview
- `PHASE_2_ENHANCEMENTS.md` - Phase 2 features
- `AUTOMATED_SCHEDULING.md` - Scheduler documentation
- Supabase Dashboard: https://supabase.com/dashboard
