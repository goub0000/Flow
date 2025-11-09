# Flow EdTech Platform - Complete Backend Development Plan
## Supabase + Railway Architecture

---

## PROJECT OVERVIEW

**Frontend**: Flutter (325+ Dart files, 100+ screens)
**Backend**: FastAPI (Python) on Railway
**Database**: Supabase (PostgreSQL)
**Storage**: Supabase Storage
**Auth**: Supabase Auth
**Real-time**: Supabase Realtime

---

## PHASE 1: INFRASTRUCTURE SETUP

### 1.1 Supabase Project Setup ✅ (COMPLETED)
- [x] Supabase project created
- [x] Connection string configured
- [x] Initial tables created (universities, student_profiles, recommendations)

### 1.2 Railway Deployment ✅ (COMPLETED)
- [x] Repository connected to Railway
- [x] Auto-deployment configured
- [x] Environment variables set
- [x] API accessible at: https://web-production-bcafe.up.railway.app

### 1.3 Existing Backend Services ✅
- [x] Find Your Path recommendation system
- [x] ML training pipeline
- [x] Data enrichment system
- [x] Location cleaning automation

---

## PHASE 2: DATABASE SCHEMA (Supabase PostgreSQL)

### Core Tables (20 tables needed)

#### 2.1 Authentication & Users
```sql
-- users table (extends Supabase auth.users)
CREATE TABLE public.users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT UNIQUE NOT NULL,
  display_name TEXT,
  phone_number TEXT,
  photo_url TEXT,
  active_role TEXT NOT NULL CHECK (active_role IN ('student', 'counselor', 'parent', 'institution', 'recommender', 'superAdmin', 'regionalAdmin', 'contentAdmin')),
  available_roles TEXT[] NOT NULL DEFAULT ARRAY['student'],
  created_at TIMESTAMPTZ DEFAULT NOW(),
  last_login_at TIMESTAMPTZ,
  is_email_verified BOOLEAN DEFAULT FALSE,
  is_phone_verified BOOLEAN DEFAULT FALSE,
  metadata JSONB DEFAULT '{}'::jsonb,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- admin_users table (for admin-specific data)
CREATE TABLE public.admin_users (
  id UUID PRIMARY KEY REFERENCES public.users(id) ON DELETE CASCADE,
  admin_role TEXT NOT NULL CHECK (admin_role IN ('superAdmin', 'regionalAdmin', 'contentAdmin')),
  permissions TEXT[] NOT NULL DEFAULT ARRAY[]::TEXT[],
  mfa_enabled BOOLEAN DEFAULT FALSE,
  regional_scope TEXT,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.admin_users ENABLE ROW LEVEL SECURITY;

-- RLS Policies
CREATE POLICY "Users can view own profile" ON public.users FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can update own profile" ON public.users FOR UPDATE USING (auth.uid() = id);
```

#### 2.2 Academic Programs & Courses
```sql
-- programs table
CREATE TABLE public.programs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  institution_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  category TEXT NOT NULL,
  level TEXT NOT NULL CHECK (level IN ('certificate', 'diploma', 'undergraduate', 'graduate', 'postgraduate', 'doctorate')),
  duration_days INTEGER NOT NULL,
  fee NUMERIC(10, 2) NOT NULL,
  currency TEXT DEFAULT 'USD',
  max_students INTEGER,
  enrolled_students INTEGER DEFAULT 0,
  requirements TEXT[],
  application_deadline TIMESTAMPTZ,
  start_date TIMESTAMPTZ,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- courses table
CREATE TABLE public.courses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  description TEXT,
  institution_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  institution_name TEXT,
  image_url TEXT,
  level TEXT CHECK (level IN ('beginner', 'intermediate', 'advanced')),
  category TEXT,
  duration_hours INTEGER,
  fee NUMERIC(10, 2),
  currency TEXT DEFAULT 'USD',
  prerequisites TEXT[],
  start_date TIMESTAMPTZ,
  end_date TIMESTAMPTZ,
  enrolled_students INTEGER DEFAULT 0,
  max_students INTEGER,
  is_active BOOLEAN DEFAULT TRUE,
  is_online BOOLEAN DEFAULT FALSE,
  rating NUMERIC(2, 1),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- enrollments table
CREATE TABLE public.enrollments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  course_id UUID NOT NULL REFERENCES public.courses(id) ON DELETE CASCADE,
  enrolled_at TIMESTAMPTZ DEFAULT NOW(),
  status TEXT DEFAULT 'active' CHECK (status IN ('active', 'completed', 'dropped', 'suspended')),
  progress NUMERIC(5, 2) DEFAULT 0,
  grade NUMERIC(5, 2),
  UNIQUE(student_id, course_id)
);

-- Enable RLS
ALTER TABLE public.programs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.courses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.enrollments ENABLE ROW LEVEL SECURITY;

-- Indexes
CREATE INDEX idx_programs_institution ON public.programs(institution_id);
CREATE INDEX idx_courses_institution ON public.courses(institution_id);
CREATE INDEX idx_enrollments_student ON public.enrollments(student_id);
CREATE INDEX idx_enrollments_course ON public.enrollments(course_id);
```

#### 2.3 Applications & Applicants
```sql
-- applications table
CREATE TABLE public.applications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  institution_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  program_id UUID REFERENCES public.programs(id) ON DELETE SET NULL,
  institution_name TEXT NOT NULL,
  program_name TEXT NOT NULL,
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'under_review', 'accepted', 'rejected', 'waitlisted')),
  submitted_at TIMESTAMPTZ DEFAULT NOW(),
  reviewed_at TIMESTAMPTZ,
  review_notes TEXT,
  documents JSONB DEFAULT '{}'::jsonb,
  personal_info JSONB NOT NULL,
  academic_info JSONB NOT NULL,
  application_fee NUMERIC(10, 2),
  fee_paid BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE public.applications ENABLE ROW LEVEL SECURITY;

-- Indexes
CREATE INDEX idx_applications_student ON public.applications(student_id);
CREATE INDEX idx_applications_institution ON public.applications(institution_id);
CREATE INDEX idx_applications_status ON public.applications(status);
```

#### 2.4 Payments
```sql
-- payments table
CREATE TABLE public.payments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  item_id UUID NOT NULL,
  item_name TEXT NOT NULL,
  item_type TEXT NOT NULL CHECK (item_type IN ('course', 'program', 'application', 'subscription', 'other')),
  amount NUMERIC(10, 2) NOT NULL,
  currency TEXT DEFAULT 'USD',
  method TEXT CHECK (method IN ('card', 'mpesa', 'flutterwave', 'paypal', 'stripe')),
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'processing', 'completed', 'failed', 'refunded')),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  completed_at TIMESTAMPTZ,
  transaction_id TEXT UNIQUE,
  reference TEXT,
  metadata JSONB DEFAULT '{}'::jsonb,
  failure_reason TEXT
);

-- Enable RLS
ALTER TABLE public.payments ENABLE ROW LEVEL SECURITY;

-- Indexes
CREATE INDEX idx_payments_user ON public.payments(user_id);
CREATE INDEX idx_payments_status ON public.payments(status);
CREATE INDEX idx_payments_transaction ON public.payments(transaction_id);
```

#### 2.5 Documents & Storage
```sql
-- documents table
CREATE TABLE public.documents (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  type TEXT NOT NULL,
  size BIGINT NOT NULL,
  url TEXT NOT NULL,
  storage_path TEXT NOT NULL,
  uploaded_by UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  uploaded_by_name TEXT,
  uploaded_at TIMESTAMPTZ DEFAULT NOW(),
  category TEXT CHECK (category IN ('transcript', 'certificate', 'id', 'essay', 'recommendation', 'resume', 'portfolio', 'other')),
  description TEXT,
  is_verified BOOLEAN DEFAULT FALSE,
  related_entity_type TEXT,
  related_entity_id UUID
);

-- Enable RLS
ALTER TABLE public.documents ENABLE ROW LEVEL SECURITY;

-- Indexes
CREATE INDEX idx_documents_uploaded_by ON public.documents(uploaded_by);
CREATE INDEX idx_documents_category ON public.documents(category);
CREATE INDEX idx_documents_related_entity ON public.documents(related_entity_type, related_entity_id);
```

#### 2.6 Messaging & Communications
```sql
-- conversations table
CREATE TABLE public.conversations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  participant_1_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  participant_2_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(participant_1_id, participant_2_id)
);

-- messages table
CREATE TABLE public.messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  conversation_id UUID NOT NULL REFERENCES public.conversations(id) ON DELETE CASCADE,
  sender_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  sender_name TEXT,
  content TEXT NOT NULL,
  type TEXT DEFAULT 'text' CHECK (type IN ('text', 'image', 'file', 'audio')),
  timestamp TIMESTAMPTZ DEFAULT NOW(),
  is_read BOOLEAN DEFAULT FALSE,
  attachments TEXT[]
);

-- Enable RLS
ALTER TABLE public.conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;

-- Enable Realtime
ALTER PUBLICATION supabase_realtime ADD TABLE public.messages;

-- Indexes
CREATE INDEX idx_messages_conversation ON public.messages(conversation_id);
CREATE INDEX idx_messages_sender ON public.messages(sender_id);
CREATE INDEX idx_messages_timestamp ON public.messages(timestamp DESC);
```

#### 2.7 Notifications
```sql
-- notifications table
CREATE TABLE public.notifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  type TEXT NOT NULL CHECK (type IN ('application', 'course', 'payment', 'alert', 'message', 'system')),
  data JSONB DEFAULT '{}'::jsonb,
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

-- Enable Realtime
ALTER PUBLICATION supabase_realtime ADD TABLE public.notifications;

-- Indexes
CREATE INDEX idx_notifications_user ON public.notifications(user_id);
CREATE INDEX idx_notifications_read ON public.notifications(user_id, is_read);
CREATE INDEX idx_notifications_created ON public.notifications(created_at DESC);
```

#### 2.8 Counseling & Support
```sql
-- student_records table (for counselors)
CREATE TABLE public.student_records (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  counselor_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  grade TEXT,
  gpa NUMERIC(3, 2),
  school_name TEXT,
  interests TEXT[],
  strengths TEXT[],
  challenges TEXT[],
  total_sessions INTEGER DEFAULT 0,
  last_session_date TIMESTAMPTZ,
  status TEXT DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'completed')),
  goals TEXT[],
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(student_id, counselor_id)
);

-- counseling_sessions table
CREATE TABLE public.counseling_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  counselor_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  student_name TEXT,
  scheduled_date TIMESTAMPTZ NOT NULL,
  duration_minutes INTEGER DEFAULT 60,
  type TEXT CHECK (type IN ('individual', 'group', 'career', 'academic', 'personal')),
  status TEXT DEFAULT 'scheduled' CHECK (status IN ('scheduled', 'completed', 'cancelled', 'no_show')),
  notes TEXT,
  summary TEXT,
  action_items TEXT[],
  location TEXT,
  follow_up_date TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- recommendations table (recommendation letters)
CREATE TABLE public.recommendations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  counselor_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  student_name TEXT NOT NULL,
  student_email TEXT NOT NULL,
  institution_name TEXT NOT NULL,
  program_name TEXT NOT NULL,
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'in_progress', 'completed', 'declined')),
  content TEXT,
  requested_date TIMESTAMPTZ DEFAULT NOW(),
  submitted_date TIMESTAMPTZ,
  deadline TIMESTAMPTZ
);

-- Enable RLS
ALTER TABLE public.student_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.counseling_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.recommendations ENABLE ROW LEVEL SECURITY;

-- Indexes
CREATE INDEX idx_student_records_student ON public.student_records(student_id);
CREATE INDEX idx_student_records_counselor ON public.student_records(counselor_id);
CREATE INDEX idx_sessions_student ON public.counseling_sessions(student_id);
CREATE INDEX idx_sessions_counselor ON public.counseling_sessions(counselor_id);
CREATE INDEX idx_sessions_date ON public.counseling_sessions(scheduled_date);
```

#### 2.9 Parent & Children
```sql
-- children table
CREATE TABLE public.children (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  parent_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  student_id UUID REFERENCES public.users(id) ON DELETE SET NULL,
  name TEXT NOT NULL,
  email TEXT,
  date_of_birth DATE,
  photo_url TEXT,
  school_name TEXT,
  grade TEXT,
  average_grade NUMERIC(5, 2),
  last_active TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- parent_alerts table
CREATE TABLE public.parent_alerts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  parent_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  child_id UUID REFERENCES public.children(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  message TEXT NOT NULL,
  type TEXT CHECK (type IN ('grade', 'attendance', 'behavior', 'assignment', 'general')),
  severity TEXT DEFAULT 'info' CHECK (severity IN ('info', 'warning', 'critical')),
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE public.children ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.parent_alerts ENABLE ROW LEVEL SECURITY;

-- Indexes
CREATE INDEX idx_children_parent ON public.children(parent_id);
CREATE INDEX idx_children_student ON public.children(student_id);
CREATE INDEX idx_alerts_parent ON public.parent_alerts(parent_id);
```

#### 2.10 Progress Tracking
```sql
-- course_progress table
CREATE TABLE public.course_progress (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  course_id UUID NOT NULL REFERENCES public.courses(id) ON DELETE CASCADE,
  completion_percentage NUMERIC(5, 2) DEFAULT 0,
  current_grade NUMERIC(5, 2),
  assignments_completed INTEGER DEFAULT 0,
  total_assignments INTEGER DEFAULT 0,
  quizzes_completed INTEGER DEFAULT 0,
  total_quizzes INTEGER DEFAULT 0,
  time_spent_minutes INTEGER DEFAULT 0,
  last_accessed TIMESTAMPTZ,
  modules JSONB DEFAULT '[]'::jsonb,
  grades JSONB DEFAULT '[]'::jsonb,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(student_id, course_id)
);

-- Enable RLS
ALTER TABLE public.course_progress ENABLE ROW LEVEL SECURITY;

-- Indexes
CREATE INDEX idx_progress_student ON public.course_progress(student_id);
CREATE INDEX idx_progress_course ON public.course_progress(course_id);
```

#### 2.11 Chatbot & Conversations
```sql
-- chatbot_conversations table
CREATE TABLE public.chatbot_conversations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  messages JSONB DEFAULT '[]'::jsonb,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE public.chatbot_conversations ENABLE ROW LEVEL SECURITY;

-- Indexes
CREATE INDEX idx_chatbot_user ON public.chatbot_conversations(user_id);
```

#### 2.12 Cookie Consent & Privacy
```sql
-- cookie_consents table
CREATE TABLE public.cookie_consents (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
  session_id TEXT,
  necessary BOOLEAN DEFAULT TRUE,
  analytics BOOLEAN DEFAULT FALSE,
  marketing BOOLEAN DEFAULT FALSE,
  preferences BOOLEAN DEFAULT FALSE,
  consent_date TIMESTAMPTZ DEFAULT NOW(),
  last_updated TIMESTAMPTZ DEFAULT NOW(),
  ip_address TEXT,
  user_agent TEXT
);

-- Enable RLS
ALTER TABLE public.cookie_consents ENABLE ROW LEVEL SECURITY;

-- Indexes
CREATE INDEX idx_cookie_user ON public.cookie_consents(user_id);
CREATE INDEX idx_cookie_session ON public.cookie_consents(session_id);
```

---

## PHASE 3: BACKEND API SERVICES (FastAPI on Railway)

### 3.1 Project Structure
```
recommendation_service/
├── app/
│   ├── __init__.py
│   ├── main.py                    # FastAPI app entry point
│   ├── config.py                  # Configuration management
│   ├── database/
│   │   ├── __init__.py
│   │   ├── config.py              # Supabase connection
│   │   └── models.py              # SQLAlchemy models
│   ├── api/
│   │   ├── __init__.py
│   │   ├── auth.py                # Authentication endpoints ✅
│   │   ├── users.py               # User management ✅
│   │   ├── students.py            # Student endpoints ✅
│   │   ├── courses.py             # Courses endpoints
│   │   ├── programs.py            # Programs endpoints ✅
│   │   ├── applications.py        # Applications endpoints
│   │   ├── enrollments.py         # Enrollments endpoints
│   │   ├── payments.py            # Payment endpoints
│   │   ├── documents.py           # Document management
│   │   ├── messages.py            # Messaging endpoints
│   │   ├── notifications.py       # Notifications endpoints
│   │   ├── counseling.py          # Counseling endpoints
│   │   ├── recommendations.py     # Recommendations ✅
│   │   ├── universities.py        # Universities ✅
│   │   ├── progress.py            # Progress tracking
│   │   ├── chatbot.py             # Chatbot endpoints
│   │   ├── admin.py               # Admin endpoints ✅
│   │   ├── monitoring.py          # System monitoring ✅
│   │   ├── enrichment.py          # Data enrichment ✅
│   │   ├── ml_training.py         # ML training ✅
│   │   └── location_cleaning.py   # Location cleaning ✅
│   ├── services/
│   │   ├── __init__.py
│   │   ├── auth_service.py
│   │   ├── payment_service.py     # Flutterwave, M-Pesa, Stripe
│   │   ├── email_service.py       # Email notifications
│   │   ├── sms_service.py         # SMS notifications
│   │   ├── storage_service.py     # File upload/download
│   │   └── notification_service.py
│   ├── utils/
│   │   ├── __init__.py
│   │   ├── security.py
│   │   ├── validators.py
│   │   └── helpers.py
│   └── schemas/
│       ├── __init__.py
│       ├── user.py
│       ├── course.py
│       ├── application.py
│       └── ... (all Pydantic models)
├── requirements.txt
├── Procfile                        # Railway deployment
└── runtime.txt
```

### 3.2 Required API Endpoints

#### Authentication (auth.py)
- `POST /api/v1/auth/register` - User registration
- `POST /api/v1/auth/login` - User login
- `POST /api/v1/auth/logout` - User logout
- `POST /api/v1/auth/refresh` - Refresh token
- `POST /api/v1/auth/forgot-password` - Password reset request
- `POST /api/v1/auth/reset-password` - Reset password
- `POST /api/v1/auth/verify-email` - Verify email
- `POST /api/v1/auth/switch-role` - Switch user role

#### Users (users.py)
- `GET /api/v1/users/me` - Get current user
- `PUT /api/v1/users/me` - Update current user
- `PUT /api/v1/users/me/password` - Change password
- `PUT /api/v1/users/me/email` - Change email
- `POST /api/v1/users/me/photo` - Upload profile photo
- `DELETE /api/v1/users/me` - Delete account

#### Courses (courses.py)
- `GET /api/v1/courses` - List courses
- `GET /api/v1/courses/{id}` - Get course details
- `POST /api/v1/courses` - Create course (institution)
- `PUT /api/v1/courses/{id}` - Update course (institution)
- `DELETE /api/v1/courses/{id}` - Delete course (institution)
- `POST /api/v1/courses/{id}/enroll` - Enroll in course (student)

#### Programs (programs.py) ✅
- `GET /api/v1/programs` - List programs
- `GET /api/v1/programs/{id}` - Get program details
- `POST /api/v1/programs` - Create program
- `PUT /api/v1/programs/{id}` - Update program
- `DELETE /api/v1/programs/{id}` - Delete program

#### Applications (applications.py)
- `GET /api/v1/applications` - List applications
- `GET /api/v1/applications/{id}` - Get application details
- `POST /api/v1/applications` - Submit application
- `PUT /api/v1/applications/{id}` - Update application
- `PUT /api/v1/applications/{id}/status` - Update application status (institution)
- `DELETE /api/v1/applications/{id}` - Delete application

#### Payments (payments.py)
- `GET /api/v1/payments` - List payments
- `GET /api/v1/payments/{id}` - Get payment details
- `POST /api/v1/payments/initiate` - Initiate payment
- `POST /api/v1/payments/verify` - Verify payment
- `POST /api/v1/payments/webhook/flutterwave` - Flutterwave webhook
- `POST /api/v1/payments/webhook/mpesa` - M-Pesa webhook

#### Documents (documents.py)
- `GET /api/v1/documents` - List documents
- `GET /api/v1/documents/{id}` - Get document details
- `POST /api/v1/documents/upload` - Upload document
- `GET /api/v1/documents/{id}/download` - Download document
- `DELETE /api/v1/documents/{id}` - Delete document

#### Messages (messages.py)
- `GET /api/v1/conversations` - List conversations
- `GET /api/v1/conversations/{id}/messages` - Get messages
- `POST /api/v1/conversations/{id}/messages` - Send message
- `PUT /api/v1/messages/{id}/read` - Mark message as read
- `DELETE /api/v1/conversations/{id}` - Delete conversation

#### Notifications (notifications.py)
- `GET /api/v1/notifications` - List notifications
- `PUT /api/v1/notifications/{id}/read` - Mark as read
- `PUT /api/v1/notifications/read-all` - Mark all as read
- `DELETE /api/v1/notifications/{id}` - Delete notification

#### Counseling (counseling.py)
- `GET /api/v1/counseling/students` - List students (counselor)
- `GET /api/v1/counseling/students/{id}` - Get student details
- `POST /api/v1/counseling/students` - Add student
- `GET /api/v1/counseling/sessions` - List sessions
- `POST /api/v1/counseling/sessions` - Create session
- `PUT /api/v1/counseling/sessions/{id}` - Update session
- `POST /api/v1/counseling/recommendations` - Create recommendation
- `PUT /api/v1/counseling/recommendations/{id}` - Update recommendation

#### Progress (progress.py)
- `GET /api/v1/progress/courses/{courseId}` - Get course progress
- `PUT /api/v1/progress/courses/{courseId}` - Update progress
- `GET /api/v1/progress/overview` - Get overview

---

## PHASE 4: AUTHENTICATION & AUTHORIZATION

### 4.1 Supabase Auth Integration
```python
# app/services/auth_service.py
from supabase import create_client, Client
import os

class AuthService:
    def __init__(self):
        self.supabase: Client = create_client(
            os.getenv("SUPABASE_URL"),
            os.getenv("SUPABASE_KEY")
        )

    def register(self, email: str, password: str, user_data: dict):
        # Register user with Supabase Auth
        auth_response = self.supabase.auth.sign_up({
            "email": email,
            "password": password
        })

        # Create user profile in users table
        user_profile = {
            "id": auth_response.user.id,
            "email": email,
            "display_name": user_data.get("display_name"),
            "active_role": user_data.get("role", "student"),
            "available_roles": [user_data.get("role", "student")]
        }

        self.supabase.table("users").insert(user_profile).execute()
        return auth_response

    def login(self, email: str, password: str):
        return self.supabase.auth.sign_in_with_password({
            "email": email,
            "password": password
        })

    def get_user(self, token: str):
        return self.supabase.auth.get_user(token)

    def refresh_token(self, refresh_token: str):
        return self.supabase.auth.refresh_session(refresh_token)
```

### 4.2 JWT Middleware
```python
# app/utils/security.py
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from app.services.auth_service import AuthService

security = HTTPBearer()
auth_service = AuthService()

async def get_current_user(credentials: HTTPAuthorizationCredentials = Depends(security)):
    token = credentials.credentials
    try:
        user = auth_service.get_user(token)
        return user
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid authentication credentials"
        )

def require_role(allowed_roles: list):
    def role_checker(user = Depends(get_current_user)):
        if user.active_role not in allowed_roles:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Insufficient permissions"
            )
        return user
    return role_checker
```

---

## PHASE 5: FILE STORAGE (Supabase Storage)

### 5.1 Storage Buckets
```sql
-- Create storage buckets
INSERT INTO storage.buckets (id, name, public)
VALUES
  ('user-profiles', 'user-profiles', true),
  ('documents', 'documents', false),
  ('course-materials', 'course-materials', false),
  ('chat-attachments', 'chat-attachments', false),
  ('university-logos', 'university-logos', true);

-- Storage policies
CREATE POLICY "Users can upload own profile photo"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'user-profiles' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE POLICY "Users can view own documents"
ON storage.objects FOR SELECT
TO authenticated
USING (bucket_id = 'documents' AND auth.uid()::text = (storage.foldername(name))[1]);
```

### 5.2 Storage Service
```python
# app/services/storage_service.py
class StorageService:
    def __init__(self):
        self.supabase = create_client(
            os.getenv("SUPABASE_URL"),
            os.getenv("SUPABASE_KEY")
        )

    def upload_file(self, bucket: str, file_path: str, file_data: bytes):
        return self.supabase.storage.from_(bucket).upload(file_path, file_data)

    def download_file(self, bucket: str, file_path: str):
        return self.supabase.storage.from_(bucket).download(file_path)

    def get_public_url(self, bucket: str, file_path: str):
        return self.supabase.storage.from_(bucket).get_public_url(file_path)

    def delete_file(self, bucket: str, file_path: str):
        return self.supabase.storage.from_(bucket).remove([file_path])
```

---

## PHASE 6: PAYMENT INTEGRATION

### 6.1 Payment Providers
- **Flutterwave** (Primary - African markets)
- **M-Pesa** (Kenya, East Africa)
- **Stripe** (International)

### 6.2 Payment Service
```python
# app/services/payment_service.py
import requests

class FlutterwaveService:
    def __init__(self):
        self.secret_key = os.getenv("FLUTTERWAVE_SECRET_KEY")
        self.base_url = "https://api.flutterwave.com/v3"

    def initiate_payment(self, amount, currency, email, tx_ref, redirect_url):
        headers = {
            "Authorization": f"Bearer {self.secret_key}",
            "Content-Type": "application/json"
        }

        payload = {
            "tx_ref": tx_ref,
            "amount": amount,
            "currency": currency,
            "redirect_url": redirect_url,
            "customer": {"email": email},
            "payment_options": "card,mobilemoney,ussd"
        }

        response = requests.post(
            f"{self.base_url}/payments",
            json=payload,
            headers=headers
        )
        return response.json()

    def verify_payment(self, transaction_id):
        headers = {"Authorization": f"Bearer {self.secret_key}"}
        response = requests.get(
            f"{self.base_url}/transactions/{transaction_id}/verify",
            headers=headers
        )
        return response.json()

class MPesaService:
    # M-Pesa Daraja API integration
    pass
```

---

## PHASE 7: REAL-TIME FEATURES

### 7.1 Supabase Realtime
```dart
// Flutter - Subscribe to real-time updates
final supabase = Supabase.instance.client;

// Listen to new messages
supabase
  .from('messages')
  .stream(primaryKey: ['id'])
  .eq('conversation_id', conversationId)
  .listen((List<Map<String, dynamic>> data) {
    // Update UI with new messages
  });

// Listen to notifications
supabase
  .from('notifications')
  .stream(primaryKey: ['id'])
  .eq('user_id', userId)
  .listen((List<Map<String, dynamic>> data) {
    // Show notifications
  });
```

---

## PHASE 8: DEPLOYMENT & MONITORING

### 8.1 Environment Variables (Railway)
```env
# Supabase
SUPABASE_URL=https://wmuarotbdjhqbyjyslqg.supabase.co
SUPABASE_KEY=your_supabase_key
SUPABASE_SERVICE_KEY=your_service_key

# Payment Gateways
FLUTTERWAVE_PUBLIC_KEY=
FLUTTERWAVE_SECRET_KEY=
FLUTTERWAVE_ENCRYPTION_KEY=
MPESA_CONSUMER_KEY=
MPESA_CONSUMER_SECRET=
STRIPE_SECRET_KEY=

# Email/SMS
SENDGRID_API_KEY=
TWILIO_ACCOUNT_SID=
TWILIO_AUTH_TOKEN=

# Other
ALLOWED_ORIGINS=*
```

### 8.2 Railway Configuration
```toml
# Procfile
web: uvicorn app.main:app --host 0.0.0.0 --port $PORT

# runtime.txt
python-3.11
```

---

## IMPLEMENTATION PRIORITY

### Week 1: Core Infrastructure
1. ✅ Supabase tables creation
2. ✅ Authentication system
3. ✅ User management API
4. ✅ File upload/storage

### Week 2: Academic Features
1. Courses API
2. Programs API (✅ Partially done)
3. Enrollments API
4. Applications API

### Week 3: Communication
1. Messaging system
2. Notifications system
3. Real-time subscriptions

### Week 4: Payment & Transactions
1. Payment gateway integration
2. Payment processing
3. Transaction management

### Week 5: Specialized Features
1. Counseling system
2. Parent monitoring
3. Progress tracking
4. Chatbot integration

### Week 6: Admin & Analytics
1. Admin panel APIs
2. Analytics endpoints
3. Reporting system

### Week 7: Testing & Optimization
1. API testing
2. Performance optimization
3. Security audit

### Week 8: Flutter Integration
1. Update all providers
2. Replace mock data
3. End-to-end testing
4. Deployment

---

## CURRENT STATUS

### ✅ Completed
- Supabase project setup
- Railway deployment
- Find Your Path API (complete)
- ML training pipeline
- Data enrichment system
- Location cleaning automation
- CORS configuration

### 🚧 In Progress
- Database schema implementation
- Authentication system
- Core API endpoints

### ⏳ Pending
- All Flutter provider connections
- Payment gateway integration
- Real-time messaging
- File upload system
- Email/SMS notifications
- Admin panel APIs

---

## NEXT STEPS

1. **Create Supabase database schema** (Execute all SQL scripts)
2. **Implement authentication API** (auth.py)
3. **Create core API endpoints** (users, courses, programs, applications)
4. **Set up file storage** (Supabase Storage buckets)
5. **Integrate payment gateways** (Flutterwave, M-Pesa)
6. **Update Flutter providers** (Connect to real APIs)
7. **Test end-to-end** (Complete user flows)
8. **Deploy to production** (Railway + Flutter Web)

---

**Last Updated**: November 6, 2025
**Status**: Phase 2 - Database Schema Implementation
