# Batch Processing System - Documentation

## Overview

The Batch Processing System allows you to run university enrichment jobs in the background without blocking API requests. Jobs are queued, tracked, and processed asynchronously with full progress monitoring.

## Architecture

```
┌─────────────┐     ┌──────────────┐     ┌─────────────────┐
│   REST API  │────▶│  Job Queue   │────▶│ Background      │
│  Endpoints  │     │  (Database)  │     │ Worker Process  │
└─────────────┘     └──────────────┘     └─────────────────┘
                            │                      │
                            ▼                      ▼
                    ┌──────────────┐     ┌─────────────────┐
                    │  Supabase    │     │  Enrichment     │
                    │  PostgreSQL  │     │  Pipeline       │
                    └──────────────┘     └─────────────────┘
```

### Components

1. **Job Queue** (`app/jobs/job_queue.py`)
   - In-memory queue with database persistence
   - Singleton pattern for single queue instance
   - FIFO job processing

2. **Background Worker** (`app/jobs/enrichment_worker.py`)
   - Processes jobs asynchronously
   - Integrates with full enrichment pipeline
   - Progress callbacks and error handling

3. **REST API** (`app/api/batch_enrichment_api.py`)
   - 9 endpoints for job management
   - Create, monitor, cancel jobs
   - Queue statistics and health checks

4. **Database Table** (`enrichment_jobs`)
   - Stores job state and progress
   - Indexed for fast queries
   - Auto-cleanup of old jobs

## Installation & Setup

### 1. Run SQL Migration

Execute the following SQL in your Supabase SQL Editor:

```sql
-- Located in: migrations/create_enrichment_jobs_table.sql
```

Copy the entire contents of `migrations/create_enrichment_jobs_table.sql` and run in Supabase.

### 2. Verify Installation

Check that the table was created:

```sql
SELECT COUNT(*) FROM enrichment_jobs;
```

Should return `0` (empty table).

## API Endpoints

All endpoints are prefixed with `/api/v1/batch`

### 1. Create Enrichment Job

**POST** `/jobs`

Create a new background enrichment job.

**Request Body:**
```json
{
  "limit": 100,
  "max_concurrent": 10
}
```

**Response:**
```json
{
  "job_id": "550e8400-e29b-41d4-a716-446655440000",
  "status": "pending",
  "created_at": "2025-11-13T23:00:00Z",
  "limit": 100,
  "max_concurrent": 10,
  "total_universities": 0,
  "processed_universities": 0,
  "successful_updates": 0,
  "total_fields_filled": 0,
  "errors_count": 0
}
```

**Parameters:**
- `limit` (optional): Max universities to enrich. If omitted, enriches all.
- `university_ids` (optional): Array of specific university IDs. Overrides `limit`.
- `max_concurrent` (optional): Concurrent operations (1-20, default: 5)

**Examples:**

Enrich all universities:
```bash
curl -X POST https://your-api.com/api/v1/batch/jobs \
  -H "Content-Type: application/json" \
  -d '{"max_concurrent": 10}'
```

Enrich 50 universities:
```bash
curl -X POST https://your-api.com/api/v1/batch/jobs \
  -H "Content-Type: application/json" \
  -d '{"limit": 50, "max_concurrent": 5}'
```

Enrich specific universities:
```bash
curl -X POST https://your-api.com/api/v1/batch/jobs \
  -H "Content-Type: application/json" \
  -d '{"university_ids": [1, 2, 3, 4, 5]}'
```

### 2. Get Job Status

**GET** `/jobs/{job_id}`

Get detailed status and progress of a job.

**Response:**
```json
{
  "job_id": "550e8400-e29b-41d4-a716-446655440000",
  "status": "running",
  "created_at": "2025-11-13T23:00:00Z",
  "started_at": "2025-11-13T23:00:05Z",
  "total_universities": 100,
  "processed_universities": 45,
  "successful_updates": 32,
  "total_fields_filled": 287,
  "errors_count": 2
}
```

**Status Values:**
- `pending`: Queued, waiting to start
- `running`: Currently executing
- `completed`: Finished successfully
- `failed`: Failed with error
- `cancelled`: Cancelled by user

**Example:**
```bash
curl https://your-api.com/api/v1/batch/jobs/550e8400-e29b-41d4-a716-446655440000
```

### 3. List Jobs

**GET** `/jobs?status={status}&limit={limit}&offset={offset}`

List jobs with optional filtering.

**Query Parameters:**
- `status` (optional): Filter by status
- `limit` (optional): Max results (default: 50, max: 200)
- `offset` (optional): Pagination offset (default: 0)

**Example:**
```bash
# Get all running jobs
curl https://your-api.com/api/v1/batch/jobs?status=running

# Get first 10 completed jobs
curl https://your-api.com/api/v1/batch/jobs?status=completed&limit=10

# Pagination (jobs 50-100)
curl https://your-api.com/api/v1/batch/jobs?limit=50&offset=50
```

### 4. Cancel Job

**DELETE** `/jobs/{job_id}`

Cancel a pending job. Only pending jobs can be cancelled.

**Response:**
```json
{
  "success": true,
  "message": "Job 550e8400... cancelled successfully",
  "job_id": "550e8400-e29b-41d4-a716-446655440000"
}
```

**Example:**
```bash
curl -X DELETE https://your-api.com/api/v1/batch/jobs/550e8400-e29b-41d4-a716-446655440000
```

### 5. Queue Statistics

**GET** `/queue/stats`

Get queue health and statistics.

**Response:**
```json
{
  "pending_count": 5,
  "running_count": 1,
  "completed_count": 143,
  "failed_count": 2,
  "cancelled_count": 0,
  "total_jobs": 151,
  "memory_cached_jobs": 25,
  "pending_queue_size": 5
}
```

**Example:**
```bash
curl https://your-api.com/api/v1/batch/queue/stats
```

### 6. Cleanup Old Jobs

**POST** `/queue/cleanup?days={days}`

Delete completed/failed jobs older than specified days.

**Query Parameters:**
- `days` (optional): Days to keep (default: 7, range: 1-365)

**Response:**
```json
{
  "success": true,
  "deleted_count": 87,
  "message": "Deleted 87 jobs older than 30 days"
}
```

**Example:**
```bash
# Delete jobs older than 30 days
curl -X POST https://your-api.com/api/v1/batch/queue/cleanup?days=30
```

### 7. Start Worker Manually

**POST** `/worker/start`

Manually trigger worker to process pending jobs.

Workers start automatically when jobs are created, but this endpoint allows manual control.

**Response:**
```json
{
  "success": true,
  "message": "Worker started to process 5 pending job(s)",
  "pending_count": 5
}
```

**Example:**
```bash
curl -X POST https://your-api.com/api/v1/batch/worker/start
```

### 8. System Health

**GET** `/health`

Check batch processing system health.

**Response:**
```json
{
  "status": "healthy",
  "timestamp": "2025-11-13T23:00:00Z",
  "queue_stats": {
    "pending_count": 2,
    "running_count": 1,
    "completed_count": 143,
    "failed_count": 2
  },
  "warnings": [],
  "recommendations": []
}
```

**Health Status:**
- `healthy`: System operating normally
- `degraded`: Warnings detected (high failure rate, large queue, etc.)

**Example:**
```bash
curl https://your-api.com/api/v1/batch/health
```

## Usage Patterns

### Pattern 1: Enrich All Universities

```python
import requests

# Create job for all universities
response = requests.post('https://your-api.com/api/v1/batch/jobs', json={
    "max_concurrent": 10
})

job = response.json()
job_id = job['job_id']

print(f"Job created: {job_id}")
print(f"Status: {job['status']}")

# Monitor progress
import time
while True:
    status = requests.get(f'https://your-api.com/api/v1/batch/jobs/{job_id}').json()

    if status['status'] in ['completed', 'failed', 'cancelled']:
        break

    progress = (status['processed_universities'] / status['total_universities'] * 100
                if status['total_universities'] > 0 else 0)

    print(f"Progress: {progress:.1f}% ({status['processed_universities']}/{status['total_universities']})")
    print(f"Fields filled: {status['total_fields_filled']}, Errors: {status['errors_count']}")

    time.sleep(10)

print(f"Final status: {status['status']}")
```

### Pattern 2: Enrich Specific Universities

```python
# Enrich specific universities
university_ids = [1, 5, 10, 15, 20]

response = requests.post('https://your-api.com/api/v1/batch/jobs', json={
    "university_ids": university_ids,
    "max_concurrent": 3
})

job_id = response.json()['job_id']
print(f"Enriching {len(university_ids)} universities: {job_id}")
```

### Pattern 3: Schedule Regular Enrichment

```python
# Run daily enrichment of 100 universities
import schedule

def daily_enrichment():
    response = requests.post('https://your-api.com/api/v1/batch/jobs', json={
        "limit": 100,
        "max_concurrent": 10
    })
    print(f"Daily enrichment started: {response.json()['job_id']}")

schedule.every().day.at("02:00").do(daily_enrichment)

while True:
    schedule.run_pending()
    time.sleep(60)
```

### Pattern 4: Monitor Queue Health

```python
# Check queue health before creating job
health = requests.get('https://your-api.com/api/v1/batch/health').json()

if health['status'] == 'healthy':
    # Create job
    response = requests.post('https://your-api.com/api/v1/batch/jobs', json={
        "limit": 50
    })
else:
    print(f"Queue unhealthy: {health['warnings']}")
    # Wait or alert admin
```

## Performance

### Benchmarks

**Test Environment:** Railway deployment, Supabase PostgreSQL

| Universities | Concurrent | Duration | Fields/Uni | Success Rate |
|-------------|-----------|----------|------------|--------------|
| 10          | 3         | ~45s     | 2.1        | 90%          |
| 50          | 5         | ~3.5min  | 1.8        | 85%          |
| 100         | 10        | ~6min    | 1.9        | 87%          |
| 500         | 10        | ~28min   | 1.7        | 83%          |

**Cache Impact:**
- First run (cold cache): ~45s for 10 universities
- Second run (warm cache): ~8s for 10 universities (82% faster)

### Performance Tuning

**1. Adjust Concurrency**

More concurrent operations = faster but higher resource usage:

- `max_concurrent: 3-5`: Conservative (low load)
- `max_concurrent: 5-10`: Balanced (recommended)
- `max_concurrent: 10-15`: Aggressive (high throughput)
- `max_concurrent: 15-20`: Maximum (may hit rate limits)

**2. Batch Size**

- Small batches (10-50): Quick feedback, frequent jobs
- Medium batches (50-200): Balanced
- Large batches (200+): Best efficiency, longer wait

**3. Cache Strategy**

- First enrichment: Slow (hits APIs)
- Re-enrichment (within 7 days): Fast (uses cache)
- Monthly full enrichment: Good practice

## Monitoring & Maintenance

### Daily Monitoring

Check queue health:
```bash
curl https://your-api.com/api/v1/batch/queue/stats
```

### Weekly Cleanup

Remove old jobs (keeps 30 days):
```bash
curl -X POST https://your-api.com/api/v1/batch/queue/cleanup?days=30
```

### Monitor Failures

Check failed jobs:
```bash
curl https://your-api.com/api/v1/batch/jobs?status=failed
```

Investigate errors:
```bash
curl https://your-api.com/api/v1/batch/jobs/{job_id}
# Check error_message and results.errors
```

## Error Handling

### Common Errors

**1. No Universities to Enrich**

```json
{
  "total_universities": 0,
  "status": "completed"
}
```

Solution: Add universities to database first.

**2. High Failure Rate**

```json
{
  "errors_count": 45,
  "successful_updates": 5
}
```

Causes:
- API rate limiting (DuckDuckGo, Wikipedia)
- Network issues
- Invalid university data

Solution: Reduce `max_concurrent`, check network

**3. Job Stuck in Running**

Job shows `running` but not progressing.

Solution:
- Worker may have crashed
- Restart worker: `POST /worker/start`
- Check application logs

### Retry Failed Jobs

```python
# Get failed job
failed_job = requests.get(f'https://your-api.com/api/v1/batch/jobs/{job_id}').json()

# Get universities that failed
failed_unis = [error['university'] for error in failed_job['results']['errors']]

# Get IDs and retry
# ... (fetch IDs from database)
retry_response = requests.post('https://your-api.com/api/v1/batch/jobs', json={
    "university_ids": failed_uni_ids,
    "max_concurrent": 3  # Lower concurrency for retry
})
```

## Troubleshooting

### Issue: Jobs Not Processing

**Symptoms:** Jobs stay in `pending` status

**Solutions:**
1. Manually start worker: `POST /worker/start`
2. Check application logs for errors
3. Verify database connectivity
4. Restart application

### Issue: Slow Processing

**Symptoms:** Jobs take very long to complete

**Solutions:**
1. Increase `max_concurrent` (if system can handle)
2. Check cache hit rate (should be 70-90% on re-enrichment)
3. Reduce batch size for faster feedback
4. Check network latency to APIs

### Issue: High Error Rate

**Symptoms:** Many errors in job results

**Solutions:**
1. Reduce `max_concurrent` to avoid rate limiting
2. Check API status (Wikipedia, DuckDuckGo, College Scorecard)
3. Verify university data quality (valid names, countries)
4. Review error messages for patterns

## Best Practices

1. **Start Small**
   - Test with 10-20 universities first
   - Verify results before scaling up

2. **Monitor Progress**
   - Check job status every 30-60 seconds
   - Don't poll too frequently (adds load)

3. **Schedule Off-Peak**
   - Run large jobs during low-traffic hours
   - Reduces impact on API performance

4. **Regular Cleanup**
   - Remove old jobs weekly/monthly
   - Keeps database performant

5. **Error Analysis**
   - Review failed jobs regularly
   - Identify patterns and fix root causes

6. **Cache Utilization**
   - Re-enrich periodically (weekly/monthly)
   - First run fills cache for future speed

## Integration with Flutter App

### Create Job from Flutter

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> createEnrichmentJob({int limit = 50}) async {
  final response = await http.post(
    Uri.parse('https://your-api.com/api/v1/batch/jobs'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'limit': limit,
      'max_concurrent': 5,
    }),
  );

  if (response.statusCode == 201) {
    final job = jsonDecode(response.body);
    return job['job_id'];
  } else {
    throw Exception('Failed to create job');
  }
}
```

### Monitor Job Progress

```dart
Future<Map<String, dynamic>> getJobStatus(String jobId) async {
  final response = await http.get(
    Uri.parse('https://your-api.com/api/v1/batch/jobs/$jobId'),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to get job status');
  }
}

// Usage with StreamBuilder
Stream<Map<String, dynamic>> jobStatusStream(String jobId) async* {
  while (true) {
    try {
      final status = await getJobStatus(jobId);
      yield status;

      if (['completed', 'failed', 'cancelled'].contains(status['status'])) {
        break;
      }

      await Future.delayed(Duration(seconds: 10));
    } catch (e) {
      yield {'error': e.toString()};
      break;
    }
  }
}
```

## Changelog

### v1.0.0 (2025-11-13)

**Initial Release**

- In-memory job queue with database persistence
- Background worker with async enrichment
- 9 REST API endpoints
- Full progress tracking and error handling
- Integration with enrichment cache system
- College Scorecard support
- Health monitoring and statistics

---

For questions or issues, check the API documentation at `/docs` or review application logs.
