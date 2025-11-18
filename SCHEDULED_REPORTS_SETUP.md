# Scheduled Reports Setup Guide

This document describes how to set up and configure the automated scheduled reports system.

## Overview

The scheduled reports system allows administrators to create automated reports that are generated and emailed on a regular schedule (daily, weekly, or monthly).

## Components

### 1. Frontend (Flutter)
- **Admin UI**: `lib/features/admin/reports/presentation/scheduled_reports_screen.dart`
- **Report Builder**: `lib/features/admin/reports/presentation/report_builder_screen.dart`
- **Export Service**: `lib/core/services/export_service.dart`

### 2. Database Schema
- **Location**: `database_migrations/scheduled_reports_schema.sql`
- **Tables**:
  - `scheduled_reports`: Stores report configurations
  - `scheduled_report_executions`: Tracks execution history

### 3. Backend Integration (To Be Implemented)
The backend service needs to implement the following:

## Backend Implementation Guide

### A. Report Generation Service

Create a service that:
1. Queries `scheduled_reports` table for active reports where `next_run_at <= NOW()`
2. Fetches the required metrics data
3. Generates the report in the specified format (PDF, CSV, or JSON)
4. Sends email to recipients
5. Updates `last_run_at` and `next_run_at` using `calculate_next_run()` function
6. Creates execution record in `scheduled_report_executions`

### B. Cron Job Setup

#### Option 1: Python with APScheduler

```python
from apscheduler.schedulers.background import BackgroundScheduler
from datetime import datetime
import asyncpg

async def process_scheduled_reports():
    """Process all due scheduled reports"""
    conn = await asyncpg.connect(DATABASE_URL)

    # Get all active reports that are due
    reports = await conn.fetch("""
        SELECT * FROM scheduled_reports
        WHERE is_active = true
        AND next_run_at <= NOW()
    """)

    for report in reports:
        try:
            # Generate report
            report_data = await generate_report(report)

            # Send email
            await send_report_email(
                recipients=report['recipients'],
                subject=f"Scheduled Report: {report['title']}",
                report_data=report_data,
                format=report['format']
            )

            # Mark as executed
            await conn.execute("""
                SELECT mark_report_executed($1, 'completed', NULL)
            """, report['id'])

        except Exception as e:
            # Mark as failed
            await conn.execute("""
                SELECT mark_report_executed($1, 'failed', $2)
            """, report['id'], str(e))

    await conn.close()

# Schedule the job to run every hour
scheduler = BackgroundScheduler()
scheduler.add_job(
    process_scheduled_reports,
    'interval',
    hours=1,
    id='process_scheduled_reports'
)
scheduler.start()
```

#### Option 2: Node.js with node-cron

```javascript
const cron = require('node-cron');
const { createClient } = require('@supabase/supabase-js');

const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY);

async function processScheduledReports() {
  const { data: reports, error } = await supabase
    .from('scheduled_reports')
    .select('*')
    .eq('is_active', true)
    .lte('next_run_at', new Date().toISOString());

  for (const report of reports) {
    try {
      // Generate and send report
      const reportData = await generateReport(report);
      await sendReportEmail(report.recipients, reportData, report.format);

      // Mark as executed
      await supabase.rpc('mark_report_executed', {
        report_id: report.id,
        execution_status: 'completed'
      });
    } catch (error) {
      await supabase.rpc('mark_report_executed', {
        report_id: report.id,
        execution_status: 'failed',
        error_msg: error.message
      });
    }
  }
}

// Run every hour
cron.schedule('0 * * * *', processScheduledReports);
```

#### Option 3: PostgreSQL pg_cron Extension

```sql
-- Install pg_cron extension
CREATE EXTENSION IF NOT EXISTS pg_cron;

-- Schedule hourly report processing
SELECT cron.schedule(
    'process-scheduled-reports',
    '0 * * * *',  -- Every hour
    $$
    -- Call your report processing function here
    SELECT process_all_scheduled_reports();
    $$
);
```

### C. Email Service Integration

Choose one of these email services:

#### SendGrid
```python
from sendgrid import SendGridAPIClient
from sendgrid.helpers.mail import Mail, Attachment
import base64

async def send_report_email(recipients, report_data, format):
    message = Mail(
        from_email='reports@flow.com',
        to_emails=recipients,
        subject='Your Scheduled Report',
        html_content='<p>Please find your scheduled report attached.</p>'
    )

    # Attach report file
    encoded = base64.b64encode(report_data).decode()
    attachment = Attachment(
        file_content=encoded,
        file_name=f'report.{format}',
        file_type=f'application/{format}',
        disposition='attachment'
    )
    message.attachment = attachment

    sg = SendGridAPIClient(SENDGRID_API_KEY)
    response = sg.send(message)
    return response
```

#### AWS SES
```python
import boto3
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.application import MIMEApplication

async def send_report_email(recipients, report_data, format):
    ses = boto3.client('ses', region_name='us-east-1')

    msg = MIMEMultipart()
    msg['Subject'] = 'Your Scheduled Report'
    msg['From'] = 'reports@flow.com'
    msg['To'] = ', '.join(recipients)

    body = MIMEText('Please find your scheduled report attached.', 'html')
    msg.attach(body)

    attachment = MIMEApplication(report_data)
    attachment.add_header('Content-Disposition', 'attachment',
                         filename=f'report.{format}')
    msg.attach(attachment)

    response = ses.send_raw_email(
        Source='reports@flow.com',
        Destinations=recipients,
        RawMessage={'Data': msg.as_string()}
    )
    return response
```

### D. Report Generation Function

```python
async def generate_report(report_config):
    """Generate report based on configuration"""
    from datetime import datetime, timedelta

    # Determine date range based on frequency
    end_date = datetime.now()
    if report_config['frequency'] == 'daily':
        start_date = end_date - timedelta(days=1)
    elif report_config['frequency'] == 'weekly':
        start_date = end_date - timedelta(weeks=1)
    else:  # monthly
        start_date = end_date - timedelta(days=30)

    # Fetch metrics data
    metrics_data = {}
    for metric in report_config['metrics']:
        metrics_data[metric] = await fetch_metric_data(
            metric,
            start_date,
            end_date
        )

    # Generate in specified format
    if report_config['format'] == 'pdf':
        return await generate_pdf_report(
            title=report_config['title'],
            metrics=metrics_data,
            date_range={'start': start_date, 'end': end_date}
        )
    elif report_config['format'] == 'csv':
        return generate_csv_report(metrics_data)
    else:  # json
        return json.dumps(metrics_data, indent=2)
```

## Deployment Steps

### 1. Database Setup

```bash
# Run the migration
psql $DATABASE_URL -f database_migrations/scheduled_reports_schema.sql
```

### 2. Environment Variables

Add to your `.env` file:

```bash
# Email Service (choose one)
SENDGRID_API_KEY=your_key_here
# OR
AWS_SES_ACCESS_KEY=your_key_here
AWS_SES_SECRET_KEY=your_secret_here

# Report Generation
REPORT_FROM_EMAIL=reports@flow.com
REPORT_STORAGE_BUCKET=your_s3_bucket  # Optional: for storing generated reports
```

### 3. Backend Service

Deploy your chosen cron service:

- **Railway**: Add as a cron worker service
- **AWS Lambda**: Use EventBridge scheduled events
- **Google Cloud**: Use Cloud Scheduler + Cloud Functions
- **Heroku**: Use Heroku Scheduler add-on

### 4. Testing

Test the system:

```bash
# Create a test scheduled report via the UI
# Then manually trigger the processing

# For Python
python scripts/process_scheduled_reports.py

# For Node.js
node scripts/process-scheduled-reports.js

# Check execution records
psql $DATABASE_URL -c "SELECT * FROM scheduled_report_executions ORDER BY created_at DESC LIMIT 10;"
```

## Monitoring

### Sentry Integration

```python
import sentry_sdk

sentry_sdk.init(
    dsn="your_sentry_dsn",
    traces_sample_rate=1.0
)

async def process_scheduled_reports():
    try:
        # Report processing logic
        pass
    except Exception as e:
        sentry_sdk.capture_exception(e)
        raise
```

### Database Monitoring Queries

```sql
-- Check upcoming scheduled reports
SELECT
    title,
    frequency,
    next_run_at,
    is_active,
    array_length(recipients, 1) as recipient_count
FROM scheduled_reports
WHERE is_active = true
ORDER BY next_run_at;

-- Check recent executions
SELECT
    sr.title,
    sre.status,
    sre.started_at,
    sre.completed_at,
    sre.error_message
FROM scheduled_report_executions sre
JOIN scheduled_reports sr ON sr.id = sre.scheduled_report_id
ORDER BY sre.created_at DESC
LIMIT 20;

-- Check failed reports
SELECT
    sr.title,
    sre.error_message,
    sre.created_at
FROM scheduled_report_executions sre
JOIN scheduled_reports sr ON sr.id = sre.scheduled_report_id
WHERE sre.status = 'failed'
ORDER BY sre.created_at DESC;
```

## Troubleshooting

### Reports Not Being Generated

1. Check if cron job is running:
```bash
# For systemd
systemctl status your-cron-service

# For PM2
pm2 logs report-scheduler
```

2. Check database permissions:
```sql
-- Verify RLS policies
SELECT * FROM pg_policies WHERE tablename = 'scheduled_reports';
```

3. Check email service logs
4. Verify `next_run_at` timestamps are correct

### Email Delivery Issues

1. Check email service API status
2. Verify sender email is verified (for SES/SendGrid)
3. Check recipient email formats
4. Review bounce/complaint rates

## Security Considerations

1. **Email Validation**: Validate all recipient emails before adding to database
2. **Rate Limiting**: Implement rate limiting for report generation
3. **Data Access**: Ensure metrics only include data user has permission to view
4. **Attachment Size**: Limit report attachment sizes (e.g., 10MB max)
5. **API Keys**: Store email service API keys securely (environment variables)

## Performance Optimization

1. **Batch Processing**: Process multiple reports in parallel
2. **Caching**: Cache frequently requested metrics
3. **Asynchronous Generation**: Use async/await for I/O operations
4. **Database Indexing**: Already configured in schema
5. **Report Archiving**: Archive old execution records after 90 days

## Future Enhancements

- [ ] Report templates with custom layouts
- [ ] Dashboard for viewing sent reports
- [ ] Report preview before scheduling
- [ ] Custom date ranges (not just frequency-based)
- [ ] Multiple email formats (HTML vs plain text)
- [ ] Webhook integration for external services
- [ ] Report distribution via Slack/Teams
- [ ] User subscriptions (non-admins can subscribe to reports)

## Support

For issues or questions:
- Check logs: `scheduled_report_executions` table
- Review Sentry errors
- Contact DevOps team

---

**Last Updated**: 2025-11-18
**Version**: 1.0.0
