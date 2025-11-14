# Cache Management API Documentation

## Overview

The Cache Management API provides endpoints to monitor, manage, and maintain the enrichment cache system. These endpoints allow you to track cache performance, invalidate stale data, and perform maintenance operations.

**Base URL**: `https://your-api.railway.app/api/v1/enrichment`

---

## Endpoints

### 1. Get Cache Statistics

Get comprehensive statistics about the enrichment cache.

**Endpoint**: `GET /cache/stats`

**Response**:
```json
{
  "total_entries": 1250,
  "valid_entries": 1100,
  "expired_entries": 150,
  "by_source": {
    "college_scorecard": 450,
    "wikipedia": 320,
    "web_scraping": 230,
    "duckduckgo": 100
  },
  "by_field": {
    "acceptance_rate": 180,
    "tuition_out_state": 175,
    "city": 200,
    "state": 200,
    "zip_code": 180,
    "website": 165
  },
  "message": "Cache statistics retrieved successfully"
}
```

**Example**:
```bash
curl -X GET "https://your-api.railway.app/api/v1/enrichment/cache/stats"
```

**Use Cases**:
- Monitor cache effectiveness
- Identify which data sources are most cached
- Understand field distribution in cache
- Track cache growth over time

---

### 2. Get Cache Health

Check cache health status and get actionable recommendations.

**Endpoint**: `GET /cache/health`

**Response**:
```json
{
  "status": "healthy",
  "metrics": {
    "total_entries": 1250,
    "valid_entries": 1100,
    "expired_entries": 150,
    "expiration_rate": 12.0,
    "cache_age_days": 8.5
  },
  "recommendations": [
    "Consider running cleanup - 150 expired entries found",
    "Cache age is healthy (8.5 days average)"
  ],
  "message": "Cache health check completed"
}
```

**Status Values**:
- `healthy` - Cache is functioning well
- `needs_attention` - High expiration rate or other issues
- `critical` - Significant problems detected

**Example**:
```bash
curl -X GET "https://your-api.railway.app/api/v1/enrichment/cache/health"
```

**Use Cases**:
- Proactive cache monitoring
- Identify when cleanup is needed
- Get automatic recommendations for cache maintenance
- Monitor cache performance trends

---

### 3. Invalidate University Cache

Delete all cached fields for a specific university.

**Endpoint**: `DELETE /cache/university/{university_id}`

**Parameters**:
- `university_id` (path, required): ID of the university

**Response**:
```json
{
  "deleted_count": 12,
  "university_id": 123,
  "message": "Invalidated 12 cache entries for university 123"
}
```

**Example**:
```bash
curl -X DELETE "https://your-api.railway.app/api/v1/enrichment/cache/university/123"
```

**Use Cases**:
- University data changed (new website, updated info)
- Force re-enrichment for specific university
- Fix incorrect cached data
- Manual data refresh requested

**⚠️ Warning**: Next enrichment for this university will be slower as all fields must be re-fetched.

---

### 4. Invalidate Field Cache

Delete a specific field across ALL universities.

**Endpoint**: `DELETE /cache/field/{field_name}`

**Parameters**:
- `field_name` (path, required): Name of the field to invalidate

**Response**:
```json
{
  "deleted_count": 180,
  "field_name": "acceptance_rate",
  "message": "Invalidated 180 cache entries for field 'acceptance_rate'"
}
```

**Example**:
```bash
curl -X DELETE "https://your-api.railway.app/api/v1/enrichment/cache/field/acceptance_rate"
```

**Use Cases**:
- Field definition or calculation changed
- Data source for field changed
- Force refresh of specific field across all universities
- Fix systematic errors in field values

**⚠️ Warning**: This affects ALL universities. Next enrichment will need to re-fetch this field for every university.

---

### 5. Cleanup Expired Cache

Remove all expired cache entries to reclaim disk space.

**Endpoint**: `POST /cache/cleanup`

**Response**:
```json
{
  "deleted_count": 150,
  "space_reclaimed_estimate": "~4.5 MB",
  "message": "Cleaned up 150 expired cache entries"
}
```

**Example**:
```bash
curl -X POST "https://your-api.railway.app/api/v1/enrichment/cache/cleanup"
```

**Use Cases**:
- Reclaim disk space from expired entries
- Regular maintenance (recommended weekly)
- Database optimization
- After bulk enrichment operations

**✅ Best Practice**: Run this weekly via cron job or GitHub Actions.

**Automation Example**:
```yaml
# .github/workflows/cache-cleanup.yml
name: Weekly Cache Cleanup
on:
  schedule:
    - cron: '0 3 * * 0'  # Sunday at 3 AM

jobs:
  cleanup:
    runs-on: ubuntu-latest
    steps:
      - name: Clean up expired cache
        run: |
          curl -X POST \
            https://your-api.railway.app/api/v1/enrichment/cache/cleanup \
            -H "Authorization: Bearer ${{ secrets.API_KEY }}"
```

---

### 6. Clear All Cache

**DANGER**: Delete ALL cache entries (both expired and valid).

**Endpoint**: `DELETE /cache/all`

**Response**:
```json
{
  "deleted_count": 1250,
  "warning": "All cache cleared - next enrichment will be significantly slower",
  "message": "Cleared all cache entries (1250 total)"
}
```

**Example**:
```bash
curl -X DELETE "https://your-api.railway.app/api/v1/enrichment/cache/all"
```

**Use Cases**:
- Complete cache reset needed
- Major data schema changes
- Testing fresh enrichment performance
- Troubleshooting cache-related issues

**⚠️ CRITICAL WARNING**:
- This will delete ALL cached data, including valid entries
- Next enrichment will be 5-10x slower
- Increased API calls and rate limit risk
- Only use when absolutely necessary

**Requires Confirmation**: Consider adding authentication/confirmation for this endpoint in production.

---

## Error Responses

All endpoints return consistent error responses:

**400 Bad Request**:
```json
{
  "detail": "Invalid university_id: must be a positive integer"
}
```

**404 Not Found**:
```json
{
  "detail": "No cache entries found for university 999"
}
```

**500 Internal Server Error**:
```json
{
  "detail": "Cache operation failed: connection timeout"
}
```

---

## Performance Metrics

### Cache Statistics Query Performance
- **Average Response Time**: 50-100ms
- **Database Impact**: Low (indexed queries)
- **Rate Limit**: None (read-only)

### Cache Invalidation Performance
- **Average Response Time**: 100-300ms
- **Database Impact**: Medium (DELETE operations)
- **Rate Limit**: Recommend max 10/minute per endpoint

### Cache Cleanup Performance
- **Average Response Time**: 500ms-2s (depends on expired count)
- **Database Impact**: Medium-High (bulk DELETE)
- **Rate Limit**: Recommend max 1/minute

---

## Monitoring and Alerts

### Recommended Monitoring

**1. Cache Hit Rate**
```python
# Track via enrichment stats
stats = orchestrator.run_enrichment_async(limit=30)
hit_rate = stats['cache']['hit_rate']

if hit_rate < 50:
    alert("Low cache hit rate - check TTL settings")
```

**2. Cache Size Growth**
```bash
# Monitor via GET /cache/stats
total_entries=$(curl -s .../cache/stats | jq '.total_entries')

if [ $total_entries -gt 100000 ]; then
    echo "Cache size exceeds 100k entries - consider cleanup"
fi
```

**3. Expiration Rate**
```bash
# Monitor via GET /cache/health
status=$(curl -s .../cache/health | jq -r '.status')

if [ "$status" != "healthy" ]; then
    echo "Cache health needs attention"
fi
```

### Alert Thresholds

| Metric | Warning | Critical |
|--------|---------|----------|
| **Expiration Rate** | > 20% | > 40% |
| **Total Entries** | > 50k | > 100k |
| **Cache Hit Rate** | < 60% | < 40% |
| **Expired Entries** | > 5k | > 10k |

---

## Best Practices

### DO ✅

1. **Monitor cache health regularly**
   ```bash
   # Daily health check
   curl https://your-api.railway.app/api/v1/enrichment/cache/health
   ```

2. **Run weekly cleanup**
   ```bash
   # Automated via cron or GitHub Actions
   curl -X POST https://your-api.railway.app/api/v1/enrichment/cache/cleanup
   ```

3. **Invalidate after major changes**
   ```bash
   # University website changed
   curl -X DELETE .../cache/university/123

   # Field calculation changed
   curl -X DELETE .../cache/field/acceptance_rate
   ```

4. **Check stats before/after enrichment**
   ```python
   # Before enrichment
   before = requests.get(f"{API_URL}/cache/stats").json()

   # Run enrichment
   orchestrator.run_enrichment_async(limit=30)

   # After enrichment
   after = requests.get(f"{API_URL}/cache/stats").json()

   print(f"New entries: {after['total_entries'] - before['total_entries']}")
   ```

### DON'T ❌

1. **Don't use DELETE /cache/all in production** - Too destructive
2. **Don't skip cleanup** - Expired entries waste disk space
3. **Don't over-invalidate** - Let TTL handle most expirations
4. **Don't ignore health warnings** - Act on recommendations

---

## Integration Examples

### Python Client

```python
import requests

class CacheManager:
    def __init__(self, base_url: str):
        self.base_url = f"{base_url}/api/v1/enrichment"

    def get_stats(self):
        """Get cache statistics"""
        response = requests.get(f"{self.base_url}/cache/stats")
        return response.json()

    def get_health(self):
        """Check cache health"""
        response = requests.get(f"{self.base_url}/cache/health")
        return response.json()

    def invalidate_university(self, university_id: int):
        """Invalidate cache for specific university"""
        response = requests.delete(
            f"{self.base_url}/cache/university/{university_id}"
        )
        return response.json()

    def invalidate_field(self, field_name: str):
        """Invalidate specific field across all universities"""
        response = requests.delete(
            f"{self.base_url}/cache/field/{field_name}"
        )
        return response.json()

    def cleanup(self):
        """Remove expired cache entries"""
        response = requests.post(f"{self.base_url}/cache/cleanup")
        return response.json()

# Usage
cache = CacheManager("https://your-api.railway.app")

# Get statistics
stats = cache.get_stats()
print(f"Valid entries: {stats['valid_entries']}")

# Check health
health = cache.get_health()
if health['status'] != 'healthy':
    print(f"Recommendations: {health['recommendations']}")

# Cleanup
result = cache.cleanup()
print(f"Cleaned up {result['deleted_count']} entries")
```

### JavaScript/Node.js Client

```javascript
class CacheManager {
  constructor(baseUrl) {
    this.baseUrl = `${baseUrl}/api/v1/enrichment`;
  }

  async getStats() {
    const response = await fetch(`${this.baseUrl}/cache/stats`);
    return response.json();
  }

  async getHealth() {
    const response = await fetch(`${this.baseUrl}/cache/health`);
    return response.json();
  }

  async invalidateUniversity(universityId) {
    const response = await fetch(
      `${this.baseUrl}/cache/university/${universityId}`,
      { method: 'DELETE' }
    );
    return response.json();
  }

  async cleanup() {
    const response = await fetch(`${this.baseUrl}/cache/cleanup`, {
      method: 'POST'
    });
    return response.json();
  }
}

// Usage
const cache = new CacheManager('https://your-api.railway.app');

// Get statistics
const stats = await cache.getStats();
console.log(`Valid entries: ${stats.valid_entries}`);

// Cleanup
const result = await cache.cleanup();
console.log(`Cleaned up ${result.deleted_count} entries`);
```

### Bash Script

```bash
#!/bin/bash

API_URL="https://your-api.railway.app/api/v1/enrichment"

# Get cache statistics
get_stats() {
    curl -s "${API_URL}/cache/stats" | jq .
}

# Check cache health
check_health() {
    curl -s "${API_URL}/cache/health" | jq .
}

# Invalidate university cache
invalidate_university() {
    local uni_id=$1
    curl -X DELETE -s "${API_URL}/cache/university/${uni_id}" | jq .
}

# Cleanup expired entries
cleanup() {
    curl -X POST -s "${API_URL}/cache/cleanup" | jq .
}

# Usage
case "$1" in
    stats)
        get_stats
        ;;
    health)
        check_health
        ;;
    invalidate)
        invalidate_university "$2"
        ;;
    cleanup)
        cleanup
        ;;
    *)
        echo "Usage: $0 {stats|health|invalidate <id>|cleanup}"
        exit 1
        ;;
esac
```

---

## Troubleshooting

### Issue: High Expiration Rate

**Symptom**: Health endpoint shows > 30% expiration rate

**Diagnosis**:
```bash
curl https://your-api.railway.app/api/v1/enrichment/cache/health
# Check "expiration_rate" in response
```

**Solutions**:
1. Run cleanup: `POST /cache/cleanup`
2. Increase TTL for stable data sources
3. Schedule more frequent cleanups

---

### Issue: Low Cache Hit Rate

**Symptom**: Enrichment stats show < 50% hit rate on re-enrichment

**Diagnosis**:
```python
stats = orchestrator.run_enrichment_async(limit=30)
print(f"Hit rate: {stats['cache']['hit_rate']}%")
```

**Solutions**:
1. Check if cache entries expired: `GET /cache/stats`
2. Verify universities are being re-enriched (not new ones)
3. Check TTL settings in `async_enrichment_cache.py`
4. Ensure cache table exists: `SELECT * FROM enrichment_cache LIMIT 5`

---

### Issue: Cache Growing Too Large

**Symptom**: Total entries > 100k

**Diagnosis**:
```bash
curl https://your-api.railway.app/api/v1/enrichment/cache/stats | jq '.total_entries'
```

**Solutions**:
1. Run cleanup: `POST /cache/cleanup`
2. Reduce TTL for less critical sources
3. Consider archiving old entries
4. Implement max cache size limit

---

## Security Considerations

### Authentication

**Recommended**: Add authentication to destructive endpoints

```python
from fastapi import Depends, HTTPException, Header

async def verify_api_key(x_api_key: str = Header(...)):
    if x_api_key != os.getenv("CACHE_MANAGEMENT_API_KEY"):
        raise HTTPException(status_code=401, detail="Invalid API key")
    return x_api_key

# Apply to destructive endpoints
@router.delete("/cache/all", dependencies=[Depends(verify_api_key)])
async def clear_all_cache():
    # ...
```

### Rate Limiting

**Recommended**: Add rate limiting to prevent abuse

```python
from slowapi import Limiter
from slowapi.util import get_remote_address

limiter = Limiter(key_func=get_remote_address)

@router.post("/cache/cleanup")
@limiter.limit("10/minute")
async def cleanup_expired_cache(request: Request):
    # ...
```

---

## Changelog

### Version 1.0 (January 2025)
- Initial release
- 6 cache management endpoints
- Statistics, health checks, invalidation, cleanup
- Comprehensive documentation and examples

---

## Summary

The Cache Management API provides powerful tools for monitoring and maintaining the enrichment cache system:

✅ **Monitoring**: Real-time statistics and health checks
✅ **Maintenance**: Automated cleanup and manual invalidation
✅ **Observability**: Detailed metrics and recommendations
✅ **Flexibility**: Granular control (university/field level)

**Quick Start**:
1. Check cache health: `GET /cache/health`
2. View statistics: `GET /cache/stats`
3. Run weekly cleanup: `POST /cache/cleanup`
4. Invalidate as needed: `DELETE /cache/university/{id}` or `DELETE /cache/field/{name}`

---

**Last Updated**: January 2025
**Status**: ✅ Production Ready
