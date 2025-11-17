# Parent Meeting Scheduler - Deployment Checklist

## Pre-Deployment

### Database Setup

- [ ] **Backup existing database**
  ```bash
  # Create backup before any schema changes
  pg_dump your_database > backup_before_meetings_$(date +%Y%m%d).sql
  ```

- [ ] **Verify users table exists**
  ```sql
  SELECT COUNT(*) FROM users;
  ```

- [ ] **Verify required user roles exist**
  ```sql
  SELECT DISTINCT active_role FROM users
  WHERE active_role IN ('parent', 'teacher', 'counselor', 'admin');
  ```

- [ ] **Run database migration**
  - Option A: Execute `MEETINGS_QUICK_SETUP.sql` in Supabase SQL Editor
  - Option B: Run `migrations/create_meetings_tables.sql`

- [ ] **Verify tables created**
  ```sql
  SELECT table_name FROM information_schema.tables
  WHERE table_schema = 'public'
    AND table_name IN ('meetings', 'staff_availability');
  ```
  Expected: 2 tables

- [ ] **Verify indexes created**
  ```sql
  SELECT COUNT(*) FROM pg_indexes
  WHERE tablename IN ('meetings', 'staff_availability');
  ```
  Expected: 13+ indexes

- [ ] **Verify RLS policies**
  ```sql
  SELECT COUNT(*) FROM pg_policies
  WHERE tablename IN ('meetings', 'staff_availability');
  ```
  Expected: 9 policies

- [ ] **Test database connection**
  ```python
  python test_supabase_connection.py
  ```

### Code Deployment

- [ ] **Add schemas to imports**

  In `app/schemas/__init__.py`:
  ```python
  from .meeting import (
      MeetingRequest,
      MeetingResponse,
      StaffAvailabilityCreate,
      StaffAvailabilityResponse,
      # ... other schemas
  )
  ```

- [ ] **Register API routes**

  In `worker.py` or your main FastAPI app:
  ```python
  from app.api import meetings

  app.include_router(
      meetings.router,
      prefix="/api/v1",
      tags=["meetings"]
  )
  ```

- [ ] **Update activity logger (already done)**
  Verify meeting activity types are added to `app/utils/activity_logger.py`

- [ ] **Install dependencies** (if any new ones)
  ```bash
  pip install -r requirements.txt
  ```

- [ ] **Run linter/formatter**
  ```bash
  black app/
  flake8 app/
  ```

### Testing

- [ ] **Test schemas**
  ```python
  from app.schemas.meeting import MeetingRequest
  # Verify imports work
  ```

- [ ] **Test service layer**
  ```python
  from app.services.meeting_service import MeetingService
  service = MeetingService()
  # Test instantiation
  ```

- [ ] **Test API endpoints locally**
  ```bash
  # Start server
  uvicorn worker:app --reload

  # Test health check
  curl http://localhost:8000/health
  ```

- [ ] **Test authentication**
  ```bash
  # Get token
  curl -X POST http://localhost:8000/api/v1/auth/login \
    -H "Content-Type: application/json" \
    -d '{"email":"test@example.com","password":"password"}'
  ```

- [ ] **Test staff list endpoint**
  ```bash
  curl -X GET http://localhost:8000/api/v1/staff/list \
    -H "Authorization: Bearer TOKEN"
  ```

- [ ] **Test meeting request flow**
  1. Parent requests meeting
  2. Staff views request
  3. Staff approves meeting
  4. Parent views approved meeting

- [ ] **Test RLS policies**
  - Parent can only see own meetings
  - Staff can only see assigned meetings
  - Unauthorized access is blocked

### Security Audit

- [ ] **Review RLS policies**
  ```sql
  SELECT * FROM pg_policies
  WHERE tablename IN ('meetings', 'staff_availability');
  ```

- [ ] **Test unauthorized access**
  - Try to access other users' meetings
  - Verify 403 Forbidden returned

- [ ] **Verify JWT validation**
  - Test with expired token
  - Test with invalid token
  - Test without token

- [ ] **Check sensitive data exposure**
  - Parent notes not visible to staff initially
  - Staff notes not visible to parent initially
  - Email addresses properly handled

- [ ] **SQL injection protection**
  - All queries use parameterized statements
  - No raw SQL with user input

### Performance Testing

- [ ] **Test with realistic data volume**
  ```sql
  -- Insert test meetings
  -- Verify query performance
  EXPLAIN ANALYZE SELECT * FROM meetings WHERE staff_id = 'test-id';
  ```

- [ ] **Verify index usage**
  ```sql
  EXPLAIN (ANALYZE, BUFFERS) SELECT * FROM meetings
  WHERE staff_id = 'test-id' AND status = 'pending';
  ```

- [ ] **Test pagination**
  ```bash
  curl "http://localhost:8000/api/v1/meetings/parent/id?limit=20&offset=0"
  ```

- [ ] **Load testing** (optional)
  ```bash
  # Using Apache Bench
  ab -n 1000 -c 10 -H "Authorization: Bearer TOKEN" \
    http://localhost:8000/api/v1/staff/list
  ```

## Deployment

### Staging Environment

- [ ] **Deploy to staging**
  ```bash
  git push staging main
  # Or your deployment command
  ```

- [ ] **Run migrations on staging database**
  ```sql
  -- Execute MEETINGS_QUICK_SETUP.sql on staging DB
  ```

- [ ] **Verify staging deployment**
  - Check all endpoints
  - Test complete workflow
  - Review logs for errors

- [ ] **Smoke tests on staging**
  ```bash
  # Test critical paths
  ./run_smoke_tests.sh staging
  ```

### Production Deployment

- [ ] **Schedule maintenance window**
  - Notify users of brief downtime (if needed)
  - Plan for off-peak hours

- [ ] **Create production backup**
  ```bash
  # Full database backup
  pg_dump production_db > backup_pre_meetings_$(date +%Y%m%d_%H%M%S).sql
  ```

- [ ] **Deploy database migrations**
  ```sql
  -- Execute MEETINGS_QUICK_SETUP.sql on production
  -- Monitor for errors
  ```

- [ ] **Deploy application code**
  ```bash
  git tag -a v1.0-meetings -m "Parent Meeting Scheduler v1.0"
  git push production main --tags
  ```

- [ ] **Restart application servers**
  ```bash
  # Railway/Heroku
  railway restart
  # Or
  heroku ps:restart
  ```

- [ ] **Verify deployment**
  ```bash
  curl https://your-domain.com/api/v1/staff/list \
    -H "Authorization: Bearer TOKEN"
  ```

- [ ] **Check application logs**
  ```bash
  # Railway
  railway logs
  # Heroku
  heroku logs --tail
  ```

### Post-Deployment Verification

- [ ] **Test all endpoints in production**
  - Use Postman collection or automated tests
  - Verify expected responses

- [ ] **Create test meeting**
  1. Login as parent
  2. Request meeting
  3. Login as teacher
  4. Approve meeting
  5. Verify notification logged

- [ ] **Check database**
  ```sql
  -- Verify data integrity
  SELECT COUNT(*) FROM meetings;
  SELECT COUNT(*) FROM staff_availability;

  -- Check activity logs
  SELECT * FROM activity_log
  WHERE action_type LIKE 'meeting_%'
  ORDER BY timestamp DESC
  LIMIT 5;
  ```

- [ ] **Monitor error rates**
  - Check error logs
  - Monitor 4xx/5xx responses
  - Set up alerts for errors

- [ ] **Performance monitoring**
  - Check API response times
  - Monitor database query performance
  - Review server resource usage

### Optional Enhancements

- [ ] **Set up cron job for auto-completion**
  ```sql
  SELECT cron.schedule(
      'auto-complete-meetings',
      '0 * * * *',
      'SELECT auto_complete_past_meetings()'
  );
  ```

- [ ] **Configure email notifications**
  - Meeting request received
  - Meeting approved
  - Meeting reminder (24h before)

- [ ] **Set up monitoring/alerting**
  - Failed meeting requests
  - Database connection issues
  - High error rates

- [ ] **Create analytics dashboard**
  - Meeting request trends
  - Staff availability utilization
  - Meeting completion rates

## Rollback Plan

### If Issues Occur

- [ ] **Immediate rollback steps**
  1. Revert application code
     ```bash
     git revert HEAD
     git push production main
     ```

  2. Restore database (if needed)
     ```bash
     psql production_db < backup_pre_meetings_YYYYMMDD.sql
     ```

- [ ] **Communication plan**
  - Notify affected users
  - Post status update
  - Provide timeline for resolution

- [ ] **Root cause analysis**
  - Review error logs
  - Identify failure point
  - Document lessons learned

## Documentation

- [ ] **Update API documentation**
  - Ensure all endpoints documented
  - Add example requests/responses
  - Update version numbers

- [ ] **Create user guides**
  - Parent guide: How to request meetings
  - Staff guide: How to manage availability and approve meetings
  - Admin guide: System overview and troubleshooting

- [ ] **Update changelog**
  ```markdown
  ## v1.0 - 2025-11-17
  ### Added
  - Parent-teacher/counselor meeting scheduler
  - Staff availability management
  - Meeting request/approval workflow
  - Available time slots calculation
  ```

- [ ] **Internal documentation**
  - Architecture decisions
  - Database schema documentation
  - Troubleshooting guide

## Training

- [ ] **Train support team**
  - How system works
  - Common user questions
  - Troubleshooting procedures

- [ ] **Create demo videos** (optional)
  - Parent workflow
  - Staff workflow
  - Admin features

- [ ] **Prepare FAQ**
  - How to request a meeting
  - How to set availability
  - What happens when meeting is approved
  - How to cancel a meeting

## Monitoring & Maintenance

### Week 1 Post-Launch

- [ ] **Daily log review**
  - Check for errors
  - Monitor API usage
  - Review user feedback

- [ ] **Database health checks**
  ```sql
  -- Check table sizes
  SELECT schemaname, tablename, pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename))
  FROM pg_tables
  WHERE tablename IN ('meetings', 'staff_availability');

  -- Check for locks
  SELECT * FROM pg_locks WHERE relation IN (
      SELECT oid FROM pg_class WHERE relname IN ('meetings', 'staff_availability')
  );
  ```

- [ ] **User feedback collection**
  - Survey parents and staff
  - Track support tickets
  - Monitor feature usage

### Ongoing Maintenance

- [ ] **Weekly database cleanup**
  ```sql
  -- Remove old cancelled meetings (optional)
  DELETE FROM meetings
  WHERE status = 'cancelled'
    AND updated_at < NOW() - INTERVAL '90 days';
  ```

- [ ] **Monthly performance review**
  - Analyze slow queries
  - Review index usage
  - Optimize if needed

- [ ] **Quarterly security audit**
  - Review RLS policies
  - Check access logs
  - Update dependencies

## Success Metrics

Track these KPIs post-launch:

- [ ] **Adoption metrics**
  - Number of meetings requested
  - Number of staff with availability set
  - Percentage of meetings approved

- [ ] **Performance metrics**
  - API response times
  - Error rates
  - System uptime

- [ ] **User satisfaction**
  - Parent satisfaction score
  - Staff feedback
  - Time saved vs. manual scheduling

## Completion

- [ ] **All checklist items completed**
- [ ] **System running smoothly in production**
- [ ] **Documentation complete and accessible**
- [ ] **Team trained and ready to support**
- [ ] **Monitoring and alerts configured**

**Deployment Date:** ___________

**Deployed By:** ___________

**Sign-off:** ___________

---

## Quick Reference Commands

### Start Server
```bash
uvicorn worker:app --reload
```

### Run Migration
```sql
\i MEETINGS_QUICK_SETUP.sql
```

### Test Endpoint
```bash
curl -X GET http://localhost:8000/api/v1/staff/list \
  -H "Authorization: Bearer TOKEN"
```

### Check Logs
```bash
railway logs --tail
# or
heroku logs --tail
```

### Database Query
```sql
SELECT * FROM meetings LIMIT 5;
```
