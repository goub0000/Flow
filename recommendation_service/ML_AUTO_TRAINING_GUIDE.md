# Automated ML Model Training System

## Overview
The ML models automatically retrain as the database gets enriched with higher quality data.

## Automatic Training Triggers

### 1. **After Large Enrichment Batches**
- Automatically triggers after enrichment jobs with **100+ universities**
- Ensures models benefit from significant data improvements
- No manual intervention required

### 2. **Weekly Scheduled Training**
- Runs every **Sunday at 3 AM UTC** via Supabase pg_cron
- Retrains with latest enriched data
- Gradually improves as enrichment system fills NULL values

## Training Data Strategy

The system intelligently scales training data based on database size:
- **Minimum**: 500 universities
- **Maximum**: 1,000 universities
- **Formula**: `min(1000, max(500, total_universities / 20))`
- **Synthetic students**: 300 per training run

As your database of 17,137 universities gets enriched:
- Initial training: ~500 universities
- After enrichment improves: up to 1,000 universities
- Better data quality = better recommendations

## Setup Instructions

### Step 1: Deploy Code (Already Done)
The auto-training code is already integrated into:
- `app/api/enrichment.py` - Triggers ML after large batches
- `app/api/ml_training.py` - Enhanced training logic

### Step 2: Set Up Weekly Cron Job

Run this SQL in **Supabase SQL Editor**:

```sql
-- Enable extensions
CREATE EXTENSION IF NOT EXISTS pg_cron;
CREATE EXTENSION IF NOT EXISTS pg_net;

-- Schedule weekly ML training (Sunday 3 AM)
SELECT cron.schedule(
    'weekly-ml-training',
    '0 3 * * 0',
    $$
    SELECT net.http_post(
        url := 'https://web-production-bcafe.up.railway.app/api/v1/ml/train',
        headers := '{"Content-Type": "application/json"}'::jsonb,
        timeout_milliseconds := 600000
    );
    $$
);
```

### Step 3: Verify Setup

```sql
-- Check cron job exists
SELECT jobid, schedule, command, active
FROM cron.job
WHERE jobname = 'weekly-ml-training';
```

## Manual Training

You can also trigger training manually:

```bash
# Start training
curl -X POST https://web-production-bcafe.up.railway.app/api/v1/ml/train

# Check training status
curl https://web-production-bcafe.up.railway.app/api/v1/ml/training-status
```

## Training Status Response

```json
{
  "is_training": false,
  "status": "completed",
  "message": "Models trained and saved to ml_models/ (training #5)",
  "last_trained": "2025-11-06T00:45:00.123456",
  "training_count": 5
}
```

## How It Works Together

1. **Daily (2 AM UTC)**: Enrichment runs, fills NULL values in 30 universities
2. **Weekly (3 AM Sunday)**: ML models retrain with improved data
3. **Monthly batches**: Enrichment of 300 universities auto-triggers ML training
4. **Continuous improvement**: Models get better as data quality increases

## Expected Timeline

| Time Period | Enrichment Progress | ML Training Frequency |
|-------------|--------------------|-----------------------|
| Week 1-4 | ~210 universities enriched | Weekly |
| Month 1-3 | ~900 universities enriched | Weekly + after monthly batches |
| Month 3-6 | ~2,700 universities enriched | Weekly + significant improvements |
| Month 12+ | Majority of critical fields filled | Weekly maintenance |

## Monitoring

### Check enrichment progress:
```bash
curl https://web-production-bcafe.up.railway.app/api/v1/enrichment/analyze
```

### Check ML training history:
```bash
curl https://web-production-bcafe.up.railway.app/api/v1/ml/training-status
```

### View cron job history:
```sql
SELECT jobid, runid, status, return_message, start_time, end_time
FROM cron.job_run_details
WHERE command LIKE '%ml/train%'
ORDER BY start_time DESC
LIMIT 10;
```

## Benefits

1. **Zero maintenance**: Fully automated training pipeline
2. **Adaptive scaling**: Uses more data as quality improves
3. **Cost-effective**: Free Supabase cron + Railway compute
4. **Self-improving**: Models automatically benefit from enrichment
5. **Transparent**: Full logging and status tracking

## Architecture

```
┌─────────────────────────────────────────────────────┐
│                 Supabase Database                    │
│            17,137 Universities + Data                │
└─────────────────────────────────────────────────────┘
           ↑                            ↑
           │ Daily (2 AM)               │ Weekly (3 AM Sun)
           │ Enrichment                 │ ML Training
           │                            │
┌──────────┴──────────┐      ┌─────────┴──────────┐
│  pg_cron: daily     │      │ pg_cron: weekly    │
│  → /enrichment/daily│      │ → /ml/train        │
└─────────────────────┘      └────────────────────┘
           │                            │
           ↓                            ↓
┌─────────────────────────────────────────────────────┐
│              Railway: FastAPI Service                │
│  • Enrichment API (web scraping)                    │
│  • ML Training API (model retraining)               │
│  • Background task processing                       │
└─────────────────────────────────────────────────────┘
```

## Notes

- Models are saved to `ml_models/` directory in Railway
- Railway may reset on deployment; models retrain automatically
- Training takes ~2-5 minutes depending on data size
- Background tasks don't block API responses
