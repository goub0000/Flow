# Flow EdTech Admin Dashboard - Implementation Plan

## Executive Summary

The admin dashboard has a solid UI foundation (41 screens) but is ~40-50% complete for backend integration. This plan excludes authentication changes (kept for testing).

---

## Current State

### Backend Endpoints That ALREADY EXIST

| Endpoint | Purpose |
|----------|---------|
| `GET /admin/dashboard/recent-activity` | Activity log entries |
| `GET /admin/dashboard/activity-stats` | Activity statistics |
| `GET /admin/users` | All users with role filtering |
| `GET /admin/analytics/metrics` | Enhanced metrics |
| `GET /admin/dashboard/analytics/user-growth` | User growth trends |
| `GET /admin/dashboard/analytics/role-distribution` | Role breakdown |
| `GET /admin/content` | List all courses/content |
| `GET /admin/content/stats` | Content statistics |
| `GET /chatbot/admin/stats` | Chatbot statistics |
| `GET /chatbot/admin/queue` | Support queue |
| `GET /chatbot/admin/conversations` | All conversations |
| `GET /chatbot/faqs` | List FAQs |
| `POST /chatbot/admin/faqs` | Create FAQ |

### Backend Endpoints MISSING (Need Creation)

| Endpoint | Purpose | Priority |
|----------|---------|----------|
| `GET /admin/support/tickets` | Support ticket management | HIGH |
| `POST /admin/support/tickets/{id}/status` | Update ticket status | HIGH |
| `GET /admin/finance/transactions` | Financial transactions | MEDIUM |
| `GET /admin/finance/stats` | Financial statistics | MEDIUM |
| `GET /admin/communications/campaigns` | Communication campaigns | MEDIUM |
| `POST /admin/communications/announcements` | Send announcements | MEDIUM |
| `PUT /admin/users/{id}/status` | Update user status | HIGH |
| `DELETE /admin/users/{id}` | Delete user | MEDIUM |
| `GET /admin/audit-logs` | Full audit log access | MEDIUM |

---

## Implementation Phases

### Phase 1: Backend Endpoint Completion (HIGH Priority)
**Estimated: 3-4 days**

#### Task 1.1: Support Ticket Endpoints
**File:** `recommendation_service/app/api/admin.py`

Create table in Supabase:
```sql
CREATE TABLE support_tickets (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id),
  user_name TEXT,
  user_email TEXT,
  subject TEXT NOT NULL,
  description TEXT,
  category TEXT DEFAULT 'general',
  priority TEXT DEFAULT 'medium',
  status TEXT DEFAULT 'open',
  assigned_to UUID REFERENCES users(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  resolved_at TIMESTAMPTZ
);

CREATE INDEX idx_support_tickets_status ON support_tickets(status);
CREATE INDEX idx_support_tickets_user_id ON support_tickets(user_id);
ALTER TABLE support_tickets ENABLE ROW LEVEL SECURITY;
GRANT SELECT, INSERT, UPDATE, DELETE ON support_tickets TO service_role;
```

Endpoints to add:
- `GET /admin/support/tickets` - List all tickets
- `POST /admin/support/tickets` - Create ticket
- `PUT /admin/support/tickets/{id}/status` - Update status
- `PUT /admin/support/tickets/{id}/assign` - Assign ticket

#### Task 1.2: Finance/Transactions Endpoints
**File:** `recommendation_service/app/api/admin.py`

Create table in Supabase:
```sql
CREATE TABLE transactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id),
  user_name TEXT,
  type TEXT NOT NULL,
  amount DECIMAL(10,2) NOT NULL,
  currency TEXT DEFAULT 'USD',
  status TEXT DEFAULT 'completed',
  description TEXT,
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_transactions_user_id ON transactions(user_id);
CREATE INDEX idx_transactions_status ON transactions(status);
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;
GRANT SELECT, INSERT, UPDATE ON transactions TO service_role;
```

Endpoints to add:
- `GET /admin/finance/transactions` - List transactions
- `GET /admin/finance/stats` - Financial statistics

#### Task 1.3: Communications Endpoints
**File:** `recommendation_service/app/api/admin.py`

Create table in Supabase:
```sql
CREATE TABLE communication_campaigns (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  type TEXT NOT NULL,
  status TEXT DEFAULT 'draft',
  target_audience JSONB DEFAULT '{}',
  content JSONB DEFAULT '{}',
  scheduled_at TIMESTAMPTZ,
  sent_at TIMESTAMPTZ,
  stats JSONB DEFAULT '{}',
  created_by UUID REFERENCES users(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE communication_campaigns ENABLE ROW LEVEL SECURITY;
GRANT SELECT, INSERT, UPDATE, DELETE ON communication_campaigns TO service_role;
```

Endpoints to add:
- `GET /admin/communications/campaigns` - List campaigns
- `POST /admin/communications/campaigns` - Create campaign
- `POST /admin/communications/announcements` - Send announcement

#### Task 1.4: User Management Endpoints
**File:** `recommendation_service/app/api/admin.py`

Endpoints to add:
- `PUT /admin/users/{id}/status` - Activate/deactivate user
- `DELETE /admin/users/{id}` - Soft delete user
- `POST /admin/users/bulk-update-roles` - Bulk role update

---

### Phase 2: Dashboard Integration (HIGH Priority)
**Estimated: 1 day**

#### Task 2.1: Connect Recent Activity Widget
**File:** `lib/features/admin/dashboard/presentation/admin_dashboard_screen.dart`

- Call `/admin/dashboard/recent-activity` endpoint
- Display activity items with user, action, timestamp
- Add click-through navigation

#### Task 2.2: Connect Quick Stats
**File:** `lib/features/admin/dashboard/presentation/admin_dashboard_screen.dart`

- Replace mock stats with real metrics from `/admin/analytics/metrics`

---

### Phase 3: User Management Lists (HIGH Priority)
**Estimated: 1 day**

#### Files to Update:
- `lib/features/admin/users/presentation/students_list_screen.dart`
- `lib/features/admin/users/presentation/counselors_list_screen.dart`
- `lib/features/admin/users/presentation/parents_list_screen.dart`
- `lib/features/admin/users/presentation/recommenders_list_screen.dart`

Tasks:
- Verify data loads from `/admin/users?role={role}`
- Connect edit/delete buttons to backend
- Add bulk action functionality

---

### Phase 4: Support Tickets Integration (MEDIUM Priority)
**Estimated: 1-2 days**

#### Task 4.1: Connect Support Provider
**File:** `lib/features/admin/shared/providers/admin_support_provider.dart`

- Update `fetchTickets()` to use new endpoint

#### Task 4.2: Support Tickets Screen
**File:** `lib/features/admin/support/presentation/support_tickets_screen.dart`

- Display real tickets
- Add status update functionality
- Add assignment functionality

---

### Phase 5: Finance Integration (MEDIUM Priority)
**Estimated: 1-2 days**

#### Task 5.1: Connect Finance Provider
**File:** `lib/features/admin/shared/providers/admin_finance_provider.dart`

#### Task 5.2: Transactions Screen
**File:** `lib/features/admin/finance/presentation/transactions_screen.dart`

- Display real transactions
- Add filtering and search
- Add refund functionality

---

### Phase 6: Communications Integration (MEDIUM Priority)
**Estimated: 1-2 days**

#### Task 6.1: Connect Communications Provider
**File:** `lib/features/admin/shared/providers/admin_communications_provider.dart`

#### Task 6.2: Communications Hub Screen
**File:** `lib/features/admin/communications/presentation/communications_hub_screen.dart`

- Display campaigns
- Add campaign creation
- Add announcement sending

---

### Phase 7: Chatbot Admin Integration (MEDIUM Priority)
**Estimated: 0.5 days**

Backend endpoints already exist. Minor tasks:

#### Task 7.1: FAQ Management
**File:** `lib/features/admin/chatbot/presentation/faq_management_screen.dart`
- Verify CRUD operations work end-to-end

#### Task 7.2: Support Queue
**File:** `lib/features/admin/chatbot/presentation/support_queue_screen.dart`
- Test queue assignment flow

#### Task 7.3: Live Conversations
**File:** `lib/features/admin/chatbot/presentation/live_conversations_screen.dart`
- Consider WebSocket for real-time updates

---

### Phase 8: Export Functionality (LOW Priority)
**Estimated: 1-2 days**

#### Files:
- `lib/features/admin/shared/utils/export_utils.dart`
- `lib/features/admin/shared/services/export_service.dart`

Current State:
- CSV export works (text-based)
- Excel export is just CSV with .xlsx extension
- PDF export is just text

Action:
- Integrate `excel` package for proper XLSX
- Integrate `pdf`/`printing` packages for PDF

---

### Phase 9: Analytics Enhancement (LOW Priority)
**Estimated: 1 day**

#### Task 9.1: Replace Mock Data
**File:** `lib/features/admin/shared/providers/admin_analytics_provider.dart`

- `getRevenueTrends()` returns placeholder data
- `getTopCourses()` returns placeholder data
- Create backend endpoints or derive from existing data

---

## Implementation Sequence

```
Phase 1 (Backend Endpoints)
    ├──> Phase 2 (Dashboard)
    ├──> Phase 3 (User Lists)
    ├──> Phase 4 (Support Tickets)
    ├──> Phase 5 (Finance)
    └──> Phase 6 (Communications)

Phase 7 (Chatbot Admin) - Independent

Phase 8 (Export) - Independent

Phase 9 (Analytics) - After data exists
```

---

## Estimated Total Effort

| Phase | Days | Priority |
|-------|------|----------|
| Phase 1 - Backend | 3-4 | HIGH |
| Phase 2 - Dashboard | 1 | HIGH |
| Phase 3 - User Lists | 1 | HIGH |
| Phase 4 - Support | 1-2 | MEDIUM |
| Phase 5 - Finance | 1-2 | MEDIUM |
| Phase 6 - Communications | 1-2 | MEDIUM |
| Phase 7 - Chatbot | 0.5 | MEDIUM |
| Phase 8 - Export | 1-2 | LOW |
| Phase 9 - Analytics | 1 | LOW |

**Total: 10-15 days**

---

## Quick Wins (Can Do First)

1. **Connect Recent Activity** - Backend exists, just needs frontend wiring
2. **User Lists** - Backend exists at `/admin/users`, verify it works
3. **Chatbot Admin** - Backend fully exists, test and verify
4. **Dashboard Stats** - Backend exists at `/admin/analytics/metrics`

---

## Database Tables Summary

### Existing Tables Used:
- `users` - User management
- `activity_log` - Audit logging
- `courses` - Content management
- `chatbot_conversations` - Chatbot data
- `chatbot_messages` - Chatbot messages
- `chatbot_faqs` - FAQ management
- `chatbot_support_queue` - Escalation queue

### Tables to Create:
- `support_tickets` - Support ticket system
- `transactions` - Financial tracking
- `communication_campaigns` - Campaign management

---

## Implementation Progress

### Completed (2025-01-09)

#### Backend Endpoints Created:
- `GET/POST /admin/support/tickets` - Support ticket management
- `PUT /admin/support/tickets/{id}/status` - Update ticket status
- `PUT /admin/support/tickets/{id}/assign` - Assign ticket
- `GET /admin/support/tickets/{id}` - Get ticket details
- `GET /admin/finance/transactions` - List transactions
- `GET /admin/finance/stats` - Financial statistics
- `GET /admin/communications/campaigns` - List campaigns
- `POST /admin/communications/campaigns` - Create campaign
- `POST /admin/communications/announcements` - Send announcement
- `PUT /admin/communications/campaigns/{id}/status` - Update campaign status

#### Database Migration Created:
- `recommendation_service/migrations/admin_features.sql`
  - Creates `support_tickets`, `transactions`, `communication_campaigns`, `activity_log` tables
  - Includes RLS policies and indexes
  - Sample test data included

#### Frontend Providers Updated:
- `admin_support_provider.dart` - Connected to backend API
- `admin_finance_provider.dart` - Connected to backend API
- `admin_communications_provider.dart` - Connected to backend API

#### Already Working (Verified):
- Dashboard Recent Activity - Connected to `/admin/dashboard/recent-activity`
- Dashboard Stats - Connected to `/admin/analytics/metrics`
- User Growth Chart - Connected to `/admin/dashboard/analytics/user-growth`
- Role Distribution - Connected to `/admin/dashboard/analytics/role-distribution`
- User Lists - Connected to `/admin/users?role={role}`
- Chatbot Admin - Connected to `/chatbot/admin/*` endpoints

### Remaining Tasks:
- Phase 8: Export functionality (proper XLSX/PDF)
- Phase 9: Analytics enhancements (getRevenueTrends, getTopCourses)
- Run database migration in Supabase
