# Flow EdTech Platform - Admin Roles & Permissions Specification

## Admin Role Hierarchy

### 1. Super Admin (Platform Owner)
**Level:** Highest Authority
**Access:** Unrestricted platform-wide access

#### **Responsibilities:**
- Complete system configuration and management
- Create and manage all other admin accounts
- Configure platform-wide settings and policies
- Override any decision or action
- Access to all modules without restrictions
- System architecture and infrastructure management
- Security configuration and audit
- Platform deployment and updates

#### **Permissions:**
✅ **ALL PERMISSIONS**

#### **UI Features:**
- **Dashboard Views:**
  - Global platform health overview
  - All regional statistics aggregated
  - System performance metrics
  - Security alerts and threats
  - Financial overview (all regions)
  - User growth analytics (all types)
  - Infrastructure monitoring

- **Exclusive Features:**
  - Admin account creation/deletion
  - Permission management interface
  - Global configuration settings
  - System maintenance mode control
  - Database backup/restore
  - API key management
  - Third-party integration setup
  - Feature flag management
  - Environment variable configuration

#### **Color Scheme:**
- Primary: Maroon (#B01116) - Denotes highest authority
- Accent: Gold badge/icon indicators

---

### 2. Regional Admin (Country/Province Manager)
**Level:** Regional Authority
**Access:** Regional scope with comprehensive management capabilities

#### **Responsibilities:**
- Oversee all operations within assigned region(s)
- Manage regional content and curriculum
- Approve institution registrations in region
- Monitor regional financial performance
- Handle regional compliance and regulations
- Manage regional support team
- Regional marketing and growth initiatives

#### **Permissions:**
✅ View/Edit Users (in region)
✅ Manage Institutions (in region)
✅ View/Edit Content (regional content)
✅ View/Manage Payments (regional transactions)
✅ View Analytics (regional data)
✅ Manage Regional Settings
✅ Approve Institution Registrations
✅ Send Regional Announcements
✅ Manage Support Tickets (regional)
✅ View Audit Logs (regional activities)
❌ Create Admin Accounts
❌ Access Global Settings
❌ Manage Other Regions
❌ Infrastructure Access

#### **UI Features:**
- **Dashboard Views:**
  - Regional performance overview
  - Regional user statistics
  - Regional revenue metrics
  - Institution performance comparison
  - Regional compliance status
  - Local payment method analytics
  - Regional support ticket overview

- **Exclusive Features:**
  - Regional institution approval workflow
  - Regional fee structure configuration
  - Local payment provider management
  - Regional discount/scholarship programs
  - Regional content moderation
  - Local language content approval
  - Regional marketing campaign tools

#### **Regional Filters:**
- Country selection dropdown
- Province/State filter
- City-level drill-down
- Institution-level access

#### **Color Scheme:**
- Primary: Blue (#373896)
- Badge: Region flag/icon

---

### 3. Content Admin (Curriculum Manager)
**Level:** Content Authority
**Access:** Content and educational material management

#### **Responsibilities:**
- Create, edit, and publish educational content
- Manage courses and curriculum
- Review and approve content submissions
- Maintain content quality standards
- Manage content versioning
- Coordinate with subject matter experts
- Handle content copyright and licensing
- Manage learning resources and materials

#### **Permissions:**
✅ Full Content Management (create, edit, delete)
✅ Course Management (all courses)
✅ Curriculum Builder Access
✅ Resource Library Management
✅ Content Approval Workflows
✅ Version Control Management
✅ Multi-language Content Management
✅ Assessment/Quiz Builder
✅ View User Engagement (content-related)
✅ Content Analytics
❌ User Management
❌ Financial Management
❌ System Settings
❌ Admin Management
❌ Infrastructure Access

#### **UI Features:**
- **Dashboard Views:**
  - Content performance metrics
  - Course engagement statistics
  - Content completion rates
  - Popular resources tracking
  - Content quality scores
  - Pending content approvals
  - Content update schedule

- **Exclusive Features:**
  - Rich text content editor
  - Video/media upload manager
  - Interactive content builder (quizzes, assignments)
  - Content versioning interface
  - A/B testing setup for content
  - Learning path designer
  - Assessment rubric builder
  - Content translation workflow
  - Plagiarism checker integration
  - Content recommendation engine

#### **Content Workflows:**
1. Draft → Review → Approve → Publish
2. Update request → Version control → Testing → Deploy
3. Translation request → Review → Approve → Publish

#### **Color Scheme:**
- Primary: Blue (#373896)
- Badge: Book/Document icon

---

### 4. Support Admin (Customer Service Manager)
**Level:** Support Authority
**Access:** User support and issue resolution

#### **Responsibilities:**
- Manage support ticket system
- Handle user inquiries and complaints
- Resolve technical issues
- Escalate critical issues
- Manage support team performance
- Update FAQ and knowledge base
- Monitor user satisfaction
- Live chat and communication management

#### **Permissions:**
✅ View User Profiles (limited)
✅ Manage Support Tickets
✅ Access Live Chat System
✅ View/Edit Knowledge Base
✅ Send User Communications
✅ View User Activity Logs
✅ Reset User Passwords
✅ Unlock User Accounts
✅ View Payment History (for support)
✅ Create Support Reports
✅ Manage Canned Responses
❌ Edit User Data (except support-related)
❌ Financial Transactions
❌ Content Management
❌ System Settings
❌ Admin Management

#### **UI Features:**
- **Dashboard Views:**
  - Open ticket queue
  - Ticket priority overview
  - Response time metrics
  - Customer satisfaction scores
  - Support team performance
  - Common issue categories
  - Resolution rate statistics

- **Exclusive Features:**
  - Ticket management interface
  - Priority/severity assignment
  - SLA monitoring dashboard
  - Live chat interface
  - Screen sharing tools
  - User impersonation (for troubleshooting)
  - Canned response library
  - Knowledge base editor
  - FAQ management
  - Support analytics
  - Escalation workflow
  - User feedback collection

#### **Support Workflows:**
1. Ticket received → Assign → Investigate → Resolve → Close
2. Escalation → Senior support → Technical team → Resolution
3. Live chat → Issue identification → Quick resolution/Ticket creation

#### **Color Scheme:**
- Primary: Blue (#373896)
- Badge: Headset/Support icon

---

### 5. Finance Admin (Financial Controller)
**Level:** Financial Authority
**Access:** Payment processing and financial management

#### **Responsibilities:**
- Monitor all financial transactions
- Process refunds and chargebacks
- Reconcile payments with providers
- Generate financial reports
- Manage fee structures and pricing
- Handle payment disputes
- Monitor fraud and suspicious activities
- Tax calculation and compliance
- Settlement management

#### **Permissions:**
✅ View All Transactions
✅ Process Refunds
✅ Manage Chargebacks
✅ Financial Reporting
✅ Fee Structure Configuration
✅ Payment Method Management
✅ Settlement Management
✅ Fraud Detection Access
✅ Tax Configuration
✅ View User Payment History
✅ Revenue Analytics
✅ Commission Management
❌ User Management (except payment-related)
❌ Content Management
❌ System Settings
❌ Admin Management

#### **UI Features:**
- **Dashboard Views:**
  - Real-time transaction monitoring
  - Daily/weekly/monthly revenue
  - Payment success/failure rates
  - Provider performance comparison
  - Pending settlements
  - Refund/chargeback tracking
  - Fraud alerts
  - Revenue by region/institution/course

- **Exclusive Features:**
  - Transaction detail viewer
  - Payment reconciliation tools
  - Refund processing interface
  - Chargeback management
  - Fraud detection dashboard
  - Settlement scheduler
  - Commission calculator
  - Financial report builder
  - Tax computation tools
  - Mobile money reconciliation
  - Bank transfer verification
  - Payment dispute resolution
  - Financial audit trail

#### **Financial Workflows:**
1. Transaction → Verification → Settlement → Reconciliation
2. Refund request → Approval → Processing → Confirmation
3. Chargeback → Investigation → Response → Resolution

#### **Color Scheme:**
- Primary: Blue (#373896)
- Badge: Currency/Money icon
- Alerts: Yellow (#FAA61A) for warnings, Maroon (#B01116) for fraud

---

### 6. Analytics Admin (Data Analyst)
**Level:** Analytics Authority
**Access:** Data analysis and reporting

#### **Responsibilities:**
- Create custom reports and dashboards
- Analyze user behavior and trends
- Generate business intelligence reports
- Monitor KPIs and metrics
- Identify growth opportunities
- Track platform performance
- A/B testing analysis
- Predictive analytics
- Data visualization

#### **Permissions:**
✅ View All Analytics Data
✅ Custom Report Builder
✅ Dashboard Creation
✅ SQL Query Interface
✅ Data Export (all formats)
✅ KPI Configuration
✅ Scheduled Reports
✅ View User Engagement Metrics
✅ Academic Performance Analytics
✅ Business Intelligence Access
✅ A/B Test Results
❌ User Data Modification
❌ Financial Transactions
❌ Content Management
❌ System Settings
❌ Admin Management

#### **UI Features:**
- **Dashboard Views:**
  - Custom dashboard builder
  - Real-time metrics display
  - User engagement analytics
  - Academic performance trends
  - Business intelligence insights
  - Revenue analytics
  - Regional performance comparison
  - Content effectiveness metrics

- **Exclusive Features:**
  - Drag-and-drop report designer
  - Advanced SQL query interface
  - Data visualization tools (charts, graphs, heatmaps)
  - Scheduled report generator
  - Custom KPI builder
  - Cohort analysis tools
  - Funnel analysis
  - Retention rate calculator
  - Churn prediction model
  - A/B test analyzer
  - Export in multiple formats
  - Dashboard sharing
  - Report template library

#### **Analytics Workflows:**
1. Data collection → Analysis → Visualization → Report generation
2. Custom query → Validation → Execution → Export
3. KPI definition → Tracking setup → Monitoring → Alerting

#### **Color Scheme:**
- Primary: Blue (#373896)
- Badge: Chart/Graph icon
- Data visualizations: Use full color palette

---

## Permission Matrix

| Permission | Super Admin | Regional Admin | Content Admin | Support Admin | Finance Admin | Analytics Admin |
|-----------|-------------|----------------|---------------|---------------|---------------|-----------------|
| **User Management** |
| View All Users | ✅ | ✅ (region) | ❌ | ✅ (limited) | ❌ | ✅ (view only) |
| Edit Users | ✅ | ✅ (region) | ❌ | ✅ (support-related) | ❌ | ❌ |
| Delete Users | ✅ | ✅ (region) | ❌ | ❌ | ❌ | ❌ |
| Bulk Operations | ✅ | ✅ (region) | ❌ | ❌ | ❌ | ❌ |
| **Institution Management** |
| View Institutions | ✅ | ✅ (region) | ❌ | ✅ (limited) | ✅ (payment-related) | ✅ (view only) |
| Edit Institutions | ✅ | ✅ (region) | ❌ | ❌ | ❌ | ❌ |
| Approve Institutions | ✅ | ✅ (region) | ❌ | ❌ | ❌ | ❌ |
| **Content Management** |
| View Content | ✅ | ✅ (region) | ✅ | ❌ | ❌ | ✅ (analytics) |
| Create Content | ✅ | ✅ (region) | ✅ | ❌ | ❌ | ❌ |
| Edit Content | ✅ | ✅ (region) | ✅ | ❌ | ❌ | ❌ |
| Delete Content | ✅ | ✅ (region) | ✅ | ❌ | ❌ | ❌ |
| Approve Content | ✅ | ✅ (region) | ✅ | ❌ | ❌ | ❌ |
| Version Control | ✅ | ✅ (region) | ✅ | ❌ | ❌ | ❌ |
| **Financial Management** |
| View Transactions | ✅ | ✅ (region) | ❌ | ✅ (support) | ✅ | ✅ (analytics) |
| Process Refunds | ✅ | ✅ (region) | ❌ | ❌ | ✅ | ❌ |
| Manage Settlements | ✅ | ✅ (region) | ❌ | ❌ | ✅ | ❌ |
| Fee Configuration | ✅ | ✅ (region) | ❌ | ❌ | ✅ | ❌ |
| **Support** |
| View Tickets | ✅ | ✅ (region) | ❌ | ✅ | ❌ | ✅ (analytics) |
| Manage Tickets | ✅ | ✅ (region) | ❌ | ✅ | ❌ | ❌ |
| Live Chat | ✅ | ✅ (region) | ❌ | ✅ | ❌ | ❌ |
| Knowledge Base | ✅ | ✅ (region) | ❌ | ✅ | ❌ | ❌ |
| **Analytics** |
| View Analytics | ✅ | ✅ (region) | ✅ (content) | ✅ (support) | ✅ (financial) | ✅ |
| Custom Reports | ✅ | ✅ (region) | ❌ | ❌ | ✅ (financial) | ✅ |
| SQL Queries | ✅ | ❌ | ❌ | ❌ | ❌ | ✅ |
| Export Data | ✅ | ✅ (region) | ✅ (content) | ✅ (support) | ✅ (financial) | ✅ |
| **Communication** |
| Send Announcements | ✅ | ✅ (region) | ✅ (content-related) | ✅ (support-related) | ❌ | ❌ |
| Email Campaigns | ✅ | ✅ (region) | ❌ | ❌ | ❌ | ❌ |
| SMS/USSD | ✅ | ✅ (region) | ❌ | ✅ (support) | ❌ | ❌ |
| Push Notifications | ✅ | ✅ (region) | ✅ (content) | ✅ (support) | ❌ | ❌ |
| **System Admin** |
| Admin Management | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| System Settings | ✅ | ✅ (regional) | ❌ | ❌ | ❌ | ❌ |
| Security Config | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Infrastructure | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Audit Logs | ✅ | ✅ (region) | ❌ | ❌ | ✅ (financial) | ✅ (all) |
| Feature Flags | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |

---

## Admin Role UI Differentiation

### Navigation Sidebar Content

#### **Super Admin:**
```
📊 Dashboard
👥 User Management
  ├─ Students
  ├─ Institutions
  ├─ Parents
  ├─ Counselors
  └─ Recommenders
📚 Content Management
  ├─ Courses
  ├─ Curriculum
  └─ Resources
💰 Financial Management
  ├─ Transactions
  ├─ Settlements
  └─ Fee Configuration
📈 Analytics & Reports
🔔 Communications
  ├─ Announcements
  ├─ Campaigns
  └─ Templates
🎫 Support Center
⚙️ System Administration
  ├─ Admins
  ├─ Settings
  ├─ Security
  ├─ Infrastructure
  └─ Audit Logs
```

#### **Regional Admin:**
```
📊 Dashboard (Regional)
👥 User Management (Region)
  ├─ Students
  ├─ Institutions
  ├─ Parents
  ├─ Counselors
  └─ Recommenders
📚 Content Management (Regional)
💰 Financial Overview (Region)
📈 Regional Analytics
🔔 Communications (Region)
🎫 Support Center (Region)
⚙️ Regional Settings
```

#### **Content Admin:**
```
📊 Content Dashboard
📚 Content Management
  ├─ Courses
  ├─ Curriculum
  ├─ Assessments
  └─ Resources
📝 Content Creation
✅ Content Approval
🔄 Version Control
📈 Content Analytics
🌐 Translations
```

#### **Support Admin:**
```
📊 Support Dashboard
🎫 Ticket Management
  ├─ Open Tickets
  ├─ In Progress
  ├─ Resolved
  └─ Escalated
💬 Live Chat
📚 Knowledge Base
👥 User Lookup
📈 Support Analytics
⚙️ Support Settings
```

#### **Finance Admin:**
```
📊 Financial Dashboard
💰 Transactions
  ├─ Real-time Monitor
  ├─ Pending
  ├─ Completed
  └─ Failed
🔄 Refunds & Chargebacks
💳 Payment Methods
📊 Settlements
🚨 Fraud Detection
📈 Financial Reports
⚙️ Fee Configuration
```

#### **Analytics Admin:**
```
📊 Analytics Dashboard
📈 Custom Reports
  ├─ Report Builder
  ├─ Scheduled Reports
  └─ Report Library
📊 Data Visualizations
🔍 SQL Query Interface
📉 KPI Monitoring
👥 User Analytics
💰 Revenue Analytics
📚 Content Analytics
📤 Data Exports
```

---

## Color-Coded Badge System

Each admin type has a distinct badge/indicator:

| Role | Badge Color | Icon | Position |
|------|-------------|------|----------|
| Super Admin | Maroon (#B01116) | 👑 Crown | Top-right of avatar |
| Regional Admin | Blue (#373896) | 🌍 Globe | Top-right of avatar |
| Content Admin | Blue (#373896) | 📚 Book | Top-right of avatar |
| Support Admin | Blue (#373896) | 🎧 Headset | Top-right of avatar |
| Finance Admin | Blue (#373896) | 💰 Money | Top-right of avatar |
| Analytics Admin | Blue (#373896) | 📊 Chart | Top-right of avatar |

---

## Access Level Summary

| Level | Scope | Can Create Admins | System Access |
|-------|-------|-------------------|---------------|
| Super Admin | Global | ✅ | Full |
| Regional Admin | Regional | ❌ | Regional |
| Content Admin | Content Only | ❌ | Limited |
| Support Admin | Support Only | ❌ | Limited |
| Finance Admin | Financial Only | ❌ | Limited |
| Analytics Admin | Analytics Only | ❌ | Read-Only |

---

## Implementation Notes

### Admin Account Creation Flow
1. Super Admin creates new admin account
2. Selects admin type from dropdown
3. Assigns specific permissions (optional overrides)
4. Sets regional scope (for Regional Admins)
5. Configures MFA
6. Sends invitation email
7. New admin completes setup

### Permission Inheritance
- Regional Admins inherit base permissions + regional scope
- Specialized admins (Content, Support, Finance, Analytics) have focused permissions
- Super Admin can override any permission for any admin
- Permission changes require Super Admin approval

### Session Management
- All admin roles: 30-minute auto-timeout
- Super Admin: Can extend to 60 minutes
- Regional Admin: 30 minutes (non-extendable)
- Specialized Admins: 30 minutes (non-extendable)
- All require re-authentication after timeout

### Audit Logging
- Every action logged with: Admin ID, Role, Action, Timestamp, IP, Details
- Super Admin can view all logs
- Regional Admin can view regional logs
- Other admins can view their own action logs only
