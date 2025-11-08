# Automated Scheduling System

Cloud-based, platform-independent scheduling for hands-free university data updates.

## Overview

The automated scheduling system runs university data updates on a schedule without manual intervention. It uses a Python-based long-running service that works on any platform and can be deployed to any cloud environment.

**Platform-Independent**: Works on Windows, Linux, Mac, Docker, AWS, GCP, Azure, and any cloud platform.

## Architecture

The system uses:
- **Python `schedule` library** - Platform-independent scheduling
- **Long-running service** - Continuous process that checks schedule every minute
- **Supabase database** - All data stored in cloud database (no local dependencies)
- **Cloud-deployable** - Can run anywhere Python runs

## Components

### Main Service

**scheduled_updater_service.py** - Long-running scheduler service

Features:
- Daily updates (2:00 AM) - Critical priority universities (30/day)
- Weekly updates (Sunday 3:00 AM) - High priority universities (100/week)
- Monthly updates (1st @ 4:00 AM) - Medium priority universities (300/month)
- Continuous operation with 1-minute check interval
- Comprehensive logging to `logs/service/scheduler_service.log`
- Graceful shutdown with Ctrl+C

## Installation

### Prerequisites

- Python 3.8 or later
- Required packages:
  ```bash
  pip install schedule
  ```
- All Phase 1 and Phase 2 dependencies
- Supabase credentials configured in `.env`

### Setup Steps

1. **Navigate to the service directory**
   ```bash
   cd "C:\Flow_App (1)\Flow\recommendation_service"
   ```

2. **Install dependencies** (if not already installed)
   ```bash
   pip install schedule
   ```

3. **Test the service** (optional)
   ```bash
   python scheduled_updater_service.py
   ```
   Press Ctrl+C to stop after verifying it starts correctly.

## Running the Service

### Local Development

Run directly in terminal:
```bash
cd "C:\Flow_App (1)\Flow\recommendation_service"
python scheduled_updater_service.py
```

The service will:
- Display schedule configuration
- Run continuously
- Execute updates at scheduled times
- Log all operations to `logs/service/scheduler_service.log`

Stop with: **Ctrl+C**

### Background Execution

#### Windows (using `pythonw`)
```bash
pythonw scheduled_updater_service.py
```

#### Linux/Mac (using `nohup`)
```bash
nohup python scheduled_updater_service.py &
```

#### Using `screen` (Linux/Mac)
```bash
screen -S university_scheduler
python scheduled_updater_service.py
# Detach: Ctrl+A then D
# Reattach: screen -r university_scheduler
```

#### Using `tmux` (Linux/Mac)
```bash
tmux new -s university_scheduler
python scheduled_updater_service.py
# Detach: Ctrl+B then D
# Reattach: tmux attach -t university_scheduler
```

## Cloud Deployment

### Option 1: AWS EC2

```bash
# Launch EC2 instance (Ubuntu recommended)
# SSH into instance
ssh -i your-key.pem ubuntu@your-instance-ip

# Install Python and dependencies
sudo apt update
sudo apt install python3-pip
pip3 install schedule

# Transfer files
scp -i your-key.pem -r recommendation_service ubuntu@your-instance-ip:~/

# Run with systemd (recommended)
# See systemd configuration below
```

### Option 2: Google Cloud Compute Engine

```bash
# Create VM instance
gcloud compute instances create university-scheduler \
    --machine-type=e2-micro \
    --zone=us-central1-a

# SSH and setup
gcloud compute ssh university-scheduler
# Install dependencies and run service
```

### Option 3: Docker

Create `Dockerfile`:
```dockerfile
FROM python:3.9-slim

WORKDIR /app
COPY recommendation_service/ /app/

RUN pip install --no-cache-dir schedule supabase requests beautifulsoup4

CMD ["python", "scheduled_updater_service.py"]
```

Build and run:
```bash
docker build -t university-scheduler .
docker run -d --restart unless-stopped university-scheduler
```

### Option 4: Platform-as-a-Service

**Heroku:**
```bash
# Create Procfile
echo "worker: python scheduled_updater_service.py" > Procfile
git init
heroku create your-app-name
git push heroku main
heroku ps:scale worker=1
```

**Railway / Render:**
- Connect GitHub repository
- Set build command: `pip install -r requirements.txt`
- Set start command: `python scheduled_updater_service.py`
- Deploy

## Process Management (Production)

### Systemd (Linux - Recommended)

Create `/etc/systemd/system/university-scheduler.service`:

```ini
[Unit]
Description=University Data Scheduler Service
After=network.target

[Service]
Type=simple
User=ubuntu
WorkingDirectory=/home/ubuntu/recommendation_service
ExecStart=/usr/bin/python3 /home/ubuntu/recommendation_service/scheduled_updater_service.py
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

Manage service:
```bash
# Enable and start
sudo systemctl enable university-scheduler
sudo systemctl start university-scheduler

# Check status
sudo systemctl status university-scheduler

# View logs
sudo journalctl -u university-scheduler -f

# Restart
sudo systemctl restart university-scheduler

# Stop
sudo systemctl stop university-scheduler
```

### Supervisor (Linux/Mac)

Install supervisor:
```bash
sudo apt install supervisor  # Ubuntu/Debian
# or
brew install supervisor      # Mac
```

Create `/etc/supervisor/conf.d/university-scheduler.conf`:
```ini
[program:university-scheduler]
command=python scheduled_updater_service.py
directory=/path/to/recommendation_service
autostart=true
autorestart=true
stderr_logfile=/var/log/university-scheduler.err.log
stdout_logfile=/var/log/university-scheduler.out.log
```

Manage:
```bash
sudo supervisorctl reread
sudo supervisorctl update
sudo supervisorctl start university-scheduler
sudo supervisorctl status
```

### PM2 (Cross-platform)

```bash
# Install PM2
npm install -g pm2

# Start service
pm2 start scheduled_updater_service.py --name university-scheduler --interpreter python3

# Auto-restart on system reboot
pm2 startup
pm2 save

# Manage
pm2 status
pm2 logs university-scheduler
pm2 restart university-scheduler
pm2 stop university-scheduler
```

## Monitoring

### Logs

Service logs are written to:
```
recommendation_service/logs/service/scheduler_service.log
```

View recent logs:
```bash
# Last 50 lines
tail -50 logs/service/scheduler_service.log

# Follow in real-time
tail -f logs/service/scheduler_service.log

# Search for errors
grep -i error logs/service/scheduler_service.log
```

### Log Format

```
2024-11-04 02:00:00 - INFO - ================================================================================
2024-11-04 02:00:00 - INFO - DAILY UPDATE - Critical Priority
2024-11-04 02:00:00 - INFO - ================================================================================
2024-11-04 02:00:05 - INFO - Updating 30 critical priority universities...
2024-11-04 02:15:30 - INFO - Daily update completed successfully
```

### Health Checks

Check if service is running:

**Linux/Mac:**
```bash
ps aux | grep scheduled_updater_service.py
```

**Docker:**
```bash
docker ps | grep university-scheduler
```

**Cloud Platform:**
Check platform-specific monitoring dashboard

## Update Schedule Summary

| Task | Frequency | Priority | Count | Duration |
|------|-----------|----------|-------|----------|
| Daily | Every day 2AM | Critical | 30 | 30-60 min |
| Weekly | Sundays 3AM | High | 100 | 2-3 hours |
| Monthly | 1st @ 4AM | Medium | 300 | 4-6 hours |

**Total coverage**: ~530 universities/month automatically updated

## Customization

### Change Update Counts

Edit `scheduled_updater_service.py`:

```python
def daily_update(self):
    self.runner.run_priority_update(
        priority='critical',
        limit=50  # Change from 30 to 50
    )
```

### Change Schedule Times

Edit `scheduled_updater_service.py`:

```python
def setup_schedule(self):
    # Change daily from 2:00 AM to 3:00 AM
    schedule.every().day.at("03:00").do(self.daily_update)

    # Change weekly from Sunday to Saturday
    schedule.every().saturday.at("03:00").do(self.weekly_update)
```

### Add New Scheduled Tasks

```python
def hourly_check(self):
    """Quick check of top 5 universities every hour"""
    self.runner.run_priority_update(priority='critical', limit=5)

def setup_schedule(self):
    # ... existing schedules ...
    schedule.every().hour.do(self.hourly_check)
```

## Troubleshooting

### Service Won't Start

Check:
1. **Python installed**: `python --version` or `python3 --version`
2. **Dependencies installed**: `pip install schedule`
3. **Supabase credentials**: Check `.env` file
4. **Working directory**: Must be in `recommendation_service/`
5. **Logs**: Check for error messages

### Updates Not Running

Check:
1. **Service is running**: `ps aux | grep scheduled_updater_service`
2. **Check logs**: `tail -f logs/service/scheduler_service.log`
3. **System time correct**: `date`
4. **Network connectivity**: `ping supabase.co`

### High Resource Usage

Solutions:
1. Reduce update counts in schedule
2. Increase rate limit delay
3. Run during off-peak hours only
4. Use smaller cloud instance during non-update times

### Database Connection Errors

Check:
1. `.env` file has correct Supabase credentials
2. Network allows outbound HTTPS connections
3. Supabase service is operational
4. API key hasn't expired

## Benefits

- **Platform-Independent** - Works anywhere Python runs
- **Cloud-Ready** - Deploy to any cloud platform
- **No Local Dependencies** - All data in Supabase
- **Hands-Free Operation** - Updates run automatically
- **Scalable** - Easy to deploy multiple instances
- **Flexible** - Easy to customize schedule
- **Comprehensive Logging** - Full audit trail

## Integration with Manual Updates

Automated service and manual updates work together seamlessly:

```bash
# Automated: Runs on schedule via service
# (no action needed)

# Manual: On-demand updates anytime
python smart_update_runner.py --priority high --limit 50
```

Both use the same smart update system with:
- Staleness detection
- Quality tracking
- Fallback strategies
- Page caching
- Data reconciliation

## Next Steps

After deployment:
1. Monitor first 24 hours of operation
2. Check log files for errors
3. Verify database is updating correctly
4. Adjust schedules/counts if needed
5. Set up monitoring/alerting (optional)

## Advanced: Database-Based Scheduling

For even more cloud-native operation, you could create a Supabase table to manage schedules:

```sql
CREATE TABLE update_schedules (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    schedule_time TIME NOT NULL,
    priority TEXT NOT NULL,
    limit_count INT NOT NULL,
    enabled BOOLEAN DEFAULT true,
    last_run TIMESTAMP,
    next_run TIMESTAMP
);
```

Then modify the service to read schedule from database instead of code.

## See Also

- `PHASE_1_ENHANCEMENTS.md` - Smart update system
- `PHASE_2_ENHANCEMENTS.md` - Advanced features
- `smart_update_runner.py` - Manual update interface
- `README_COMPLETE_SYSTEM.md` - Complete system overview
- `DEPLOYMENT_GUIDE.md` - Detailed cloud deployment instructions
