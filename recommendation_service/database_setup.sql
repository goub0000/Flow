-- ========================================
-- FLOW EDTECH PLATFORM - SUPABASE DATABASE SETUP
-- ========================================
-- Execute this script in Supabase SQL Editor
-- Last Updated: November 6, 2025
-- ========================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ========================================
-- 1. USERS & AUTHENTICATION
-- ========================================

-- users table (extends Supabase auth.users)
CREATE TABLE IF NOT EXISTS public.users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT UNIQUE NOT NULL,
  display_name TEXT,
  phone_number TEXT,
  photo_url TEXT,
  active_role TEXT NOT NULL DEFAULT 'student' CHECK (active_role IN ('student', 'counselor', 'parent', 'institution', 'recommender', 'superAdmin', 'regionalAdmin', 'contentAdmin')),
  available_roles TEXT[] NOT NULL DEFAULT ARRAY['student'],
  created_at TIMESTAMPTZ DEFAULT NOW(),
  last_login_at TIMESTAMPTZ,
  is_email_verified BOOLEAN DEFAULT FALSE,
  is_phone_verified BOOLEAN DEFAULT FALSE,
  metadata JSONB DEFAULT '{}'::jsonb,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- admin_users table
CREATE TABLE IF NOT EXISTS public.admin_users (
  id UUID PRIMARY KEY REFERENCES public.users(id) ON DELETE CASCADE,
  admin_role TEXT NOT NULL CHECK (admin_role IN ('superAdmin', 'regionalAdmin', 'contentAdmin')),
  permissions TEXT[] NOT NULL DEFAULT ARRAY[]::TEXT[],
  mfa_enabled BOOLEAN DEFAULT FALSE,
  regional_scope TEXT,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ========================================
-- 2. ACADEMIC PROGRAMS & COURSES
-- ========================================

-- programs table
CREATE TABLE IF NOT EXISTS public.programs (
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
CREATE TABLE IF NOT EXISTS public.courses (
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
  rating NUMERIC(2, 1) CHECK (rating >= 0 AND rating <= 5),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- enrollments table
CREATE TABLE IF NOT EXISTS public.enrollments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  course_id UUID NOT NULL REFERENCES public.courses(id) ON DELETE CASCADE,
  enrolled_at TIMESTAMPTZ DEFAULT NOW(),
  status TEXT DEFAULT 'active' CHECK (status IN ('active', 'completed', 'dropped', 'suspended')),
  progress NUMERIC(5, 2) DEFAULT 0 CHECK (progress >= 0 AND progress <= 100),
  grade NUMERIC(5, 2) CHECK (grade >= 0 AND grade <= 100),
  UNIQUE(student_id, course_id)
);

-- ========================================
-- 3. APPLICATIONS & APPLICANTS
-- ========================================

-- applications table
CREATE TABLE IF NOT EXISTS public.applications (
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

-- ========================================
-- 4. PAYMENTS
-- ========================================

-- payments table
CREATE TABLE IF NOT EXISTS public.payments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  item_id UUID NOT NULL,
  item_name TEXT NOT NULL,
  item_type TEXT NOT NULL CHECK (item_type IN ('course', 'program', 'application', 'subscription', 'other')),
  amount NUMERIC(10, 2) NOT NULL CHECK (amount >= 0),
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

-- ========================================
-- 5. DOCUMENTS & STORAGE
-- ========================================

-- documents table
CREATE TABLE IF NOT EXISTS public.documents (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  type TEXT NOT NULL,
  size BIGINT NOT NULL CHECK (size >= 0),
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

-- ========================================
-- 6. MESSAGING & COMMUNICATIONS
-- ========================================

-- conversations table
CREATE TABLE IF NOT EXISTS public.conversations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  participant_1_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  participant_2_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(participant_1_id, participant_2_id)
);

-- messages table
CREATE TABLE IF NOT EXISTS public.messages (
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

-- ========================================
-- 7. NOTIFICATIONS
-- ========================================

-- notifications table
CREATE TABLE IF NOT EXISTS public.notifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  type TEXT NOT NULL CHECK (type IN ('application', 'course', 'payment', 'alert', 'message', 'system')),
  data JSONB DEFAULT '{}'::jsonb,
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ========================================
-- 8. COUNSELING & SUPPORT
-- ========================================

-- student_records table (for counselors)
CREATE TABLE IF NOT EXISTS public.student_records (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  counselor_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  grade TEXT,
  gpa NUMERIC(3, 2) CHECK (gpa >= 0 AND gpa <= 4),
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
CREATE TABLE IF NOT EXISTS public.counseling_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  counselor_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  student_name TEXT,
  scheduled_date TIMESTAMPTZ NOT NULL,
  duration_minutes INTEGER DEFAULT 60 CHECK (duration_minutes > 0),
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
CREATE TABLE IF NOT EXISTS public.recommendations (
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

-- ========================================
-- 9. PARENT & CHILDREN
-- ========================================

-- children table
CREATE TABLE IF NOT EXISTS public.children (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  parent_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  student_id UUID REFERENCES public.users(id) ON DELETE SET NULL,
  name TEXT NOT NULL,
  email TEXT,
  date_of_birth DATE,
  photo_url TEXT,
  school_name TEXT,
  grade TEXT,
  average_grade NUMERIC(5, 2) CHECK (average_grade >= 0 AND average_grade <= 100),
  last_active TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- parent_alerts table
CREATE TABLE IF NOT EXISTS public.parent_alerts (
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

-- ========================================
-- 10. PROGRESS TRACKING
-- ========================================

-- course_progress table
CREATE TABLE IF NOT EXISTS public.course_progress (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  course_id UUID NOT NULL REFERENCES public.courses(id) ON DELETE CASCADE,
  completion_percentage NUMERIC(5, 2) DEFAULT 0 CHECK (completion_percentage >= 0 AND completion_percentage <= 100),
  current_grade NUMERIC(5, 2) CHECK (current_grade >= 0 AND current_grade <= 100),
  assignments_completed INTEGER DEFAULT 0 CHECK (assignments_completed >= 0),
  total_assignments INTEGER DEFAULT 0 CHECK (total_assignments >= 0),
  quizzes_completed INTEGER DEFAULT 0 CHECK (quizzes_completed >= 0),
  total_quizzes INTEGER DEFAULT 0 CHECK (total_quizzes >= 0),
  time_spent_minutes INTEGER DEFAULT 0 CHECK (time_spent_minutes >= 0),
  last_accessed TIMESTAMPTZ,
  modules JSONB DEFAULT '[]'::jsonb,
  grades JSONB DEFAULT '[]'::jsonb,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(student_id, course_id)
);

-- ========================================
-- 11. CHATBOT & CONVERSATIONS
-- ========================================

-- chatbot_conversations table
CREATE TABLE IF NOT EXISTS public.chatbot_conversations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  messages JSONB DEFAULT '[]'::jsonb,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ========================================
-- 12. COOKIE CONSENT & PRIVACY
-- ========================================

-- cookie_consents table
CREATE TABLE IF NOT EXISTS public.cookie_consents (
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

-- ========================================
-- INDEXES FOR PERFORMANCE
-- ========================================

-- Users
CREATE INDEX IF NOT EXISTS idx_users_email ON public.users(email);
CREATE INDEX IF NOT EXISTS idx_users_active_role ON public.users(active_role);

-- Programs
CREATE INDEX IF NOT EXISTS idx_programs_institution ON public.programs(institution_id);
CREATE INDEX IF NOT EXISTS idx_programs_category ON public.programs(category);
CREATE INDEX IF NOT EXISTS idx_programs_is_active ON public.programs(is_active);

-- Courses
CREATE INDEX IF NOT EXISTS idx_courses_institution ON public.courses(institution_id);
CREATE INDEX IF NOT EXISTS idx_courses_category ON public.courses(category);
CREATE INDEX IF NOT EXISTS idx_courses_is_active ON public.courses(is_active);

-- Enrollments
CREATE INDEX IF NOT EXISTS idx_enrollments_student ON public.enrollments(student_id);
CREATE INDEX IF NOT EXISTS idx_enrollments_course ON public.enrollments(course_id);
CREATE INDEX IF NOT EXISTS idx_enrollments_status ON public.enrollments(status);

-- Applications
CREATE INDEX IF NOT EXISTS idx_applications_student ON public.applications(student_id);
CREATE INDEX IF NOT EXISTS idx_applications_institution ON public.applications(institution_id);
CREATE INDEX IF NOT EXISTS idx_applications_status ON public.applications(status);
CREATE INDEX IF NOT EXISTS idx_applications_program ON public.applications(program_id);

-- Payments
CREATE INDEX IF NOT EXISTS idx_payments_user ON public.payments(user_id);
CREATE INDEX IF NOT EXISTS idx_payments_status ON public.payments(status);
CREATE INDEX IF NOT EXISTS idx_payments_transaction ON public.payments(transaction_id);
CREATE INDEX IF NOT EXISTS idx_payments_created ON public.payments(created_at DESC);

-- Documents
CREATE INDEX IF NOT EXISTS idx_documents_uploaded_by ON public.documents(uploaded_by);
CREATE INDEX IF NOT EXISTS idx_documents_category ON public.documents(category);
CREATE INDEX IF NOT EXISTS idx_documents_related_entity ON public.documents(related_entity_type, related_entity_id);

-- Messages
CREATE INDEX IF NOT EXISTS idx_messages_conversation ON public.messages(conversation_id);
CREATE INDEX IF NOT EXISTS idx_messages_sender ON public.messages(sender_id);
CREATE INDEX IF NOT EXISTS idx_messages_timestamp ON public.messages(timestamp DESC);

-- Notifications
CREATE INDEX IF NOT EXISTS idx_notifications_user ON public.notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_read ON public.notifications(user_id, is_read);
CREATE INDEX IF NOT EXISTS idx_notifications_created ON public.notifications(created_at DESC);

-- Student Records
CREATE INDEX IF NOT EXISTS idx_student_records_student ON public.student_records(student_id);
CREATE INDEX IF NOT EXISTS idx_student_records_counselor ON public.student_records(counselor_id);

-- Counseling Sessions
CREATE INDEX IF NOT EXISTS idx_sessions_student ON public.counseling_sessions(student_id);
CREATE INDEX IF NOT EXISTS idx_sessions_counselor ON public.counseling_sessions(counselor_id);
CREATE INDEX IF NOT EXISTS idx_sessions_date ON public.counseling_sessions(scheduled_date);
CREATE INDEX IF NOT EXISTS idx_sessions_status ON public.counseling_sessions(status);

-- Children
CREATE INDEX IF NOT EXISTS idx_children_parent ON public.children(parent_id);
CREATE INDEX IF NOT EXISTS idx_children_student ON public.children(student_id);

-- Parent Alerts
CREATE INDEX IF NOT EXISTS idx_alerts_parent ON public.parent_alerts(parent_id);
CREATE INDEX IF NOT EXISTS idx_alerts_child ON public.parent_alerts(child_id);
CREATE INDEX IF NOT EXISTS idx_alerts_read ON public.parent_alerts(is_read);

-- Course Progress
CREATE INDEX IF NOT EXISTS idx_progress_student ON public.course_progress(student_id);
CREATE INDEX IF NOT EXISTS idx_progress_course ON public.course_progress(course_id);

-- Chatbot
CREATE INDEX IF NOT EXISTS idx_chatbot_user ON public.chatbot_conversations(user_id);

-- Cookie Consents
CREATE INDEX IF NOT EXISTS idx_cookie_user ON public.cookie_consents(user_id);
CREATE INDEX IF NOT EXISTS idx_cookie_session ON public.cookie_consents(session_id);

-- ========================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ========================================

-- Enable RLS on all tables
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.admin_users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.programs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.courses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.enrollments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.applications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.documents ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.student_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.counseling_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.recommendations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.children ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.parent_alerts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.course_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.chatbot_conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.cookie_consents ENABLE ROW LEVEL SECURITY;

-- Users policies
CREATE POLICY "Users can view own profile" ON public.users FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can update own profile" ON public.users FOR UPDATE USING (auth.uid() = id);

-- Programs policies
CREATE POLICY "Anyone can view active programs" ON public.programs FOR SELECT USING (is_active = true);
CREATE POLICY "Institutions can manage own programs" ON public.programs FOR ALL USING (institution_id = auth.uid());

-- Courses policies
CREATE POLICY "Anyone can view active courses" ON public.courses FOR SELECT USING (is_active = true);
CREATE POLICY "Institutions can manage own courses" ON public.courses FOR ALL USING (institution_id = auth.uid());

-- Enrollments policies
CREATE POLICY "Students can view own enrollments" ON public.enrollments FOR SELECT USING (student_id = auth.uid());
CREATE POLICY "Students can enroll in courses" ON public.enrollments FOR INSERT WITH CHECK (student_id = auth.uid());

-- Applications policies
CREATE POLICY "Students can view own applications" ON public.applications FOR SELECT USING (student_id = auth.uid());
CREATE POLICY "Institutions can view applications to them" ON public.applications FOR SELECT USING (institution_id = auth.uid());
CREATE POLICY "Students can create applications" ON public.applications FOR INSERT WITH CHECK (student_id = auth.uid());

-- Payments policies
CREATE POLICY "Users can view own payments" ON public.payments FOR SELECT USING (user_id = auth.uid());

-- Documents policies
CREATE POLICY "Users can view own documents" ON public.documents FOR SELECT USING (uploaded_by = auth.uid());
CREATE POLICY "Users can upload documents" ON public.documents FOR INSERT WITH CHECK (uploaded_by = auth.uid());

-- Messages policies
CREATE POLICY "Users can view own messages" ON public.messages FOR SELECT
  USING (sender_id = auth.uid() OR conversation_id IN (
    SELECT id FROM public.conversations
    WHERE participant_1_id = auth.uid() OR participant_2_id = auth.uid()
  ));

-- Notifications policies
CREATE POLICY "Users can view own notifications" ON public.notifications FOR SELECT USING (user_id = auth.uid());
CREATE POLICY "Users can update own notifications" ON public.notifications FOR UPDATE USING (user_id = auth.uid());

-- Counseling policies
CREATE POLICY "Counselors can view own student records" ON public.student_records FOR SELECT USING (counselor_id = auth.uid());
CREATE POLICY "Students can view own records" ON public.student_records FOR SELECT USING (student_id = auth.uid());

-- Children policies
CREATE POLICY "Parents can view own children" ON public.children FOR SELECT USING (parent_id = auth.uid());
CREATE POLICY "Parents can manage own children" ON public.children FOR ALL USING (parent_id = auth.uid());

-- Progress policies
CREATE POLICY "Students can view own progress" ON public.course_progress FOR SELECT USING (student_id = auth.uid());

-- Chatbot policies
CREATE POLICY "Users can view own conversations" ON public.chatbot_conversations FOR SELECT USING (user_id = auth.uid());
CREATE POLICY "Users can manage own conversations" ON public.chatbot_conversations FOR ALL USING (user_id = auth.uid());

-- Cookie consent policies
CREATE POLICY "Users can view own consent" ON public.cookie_consents FOR SELECT USING (user_id = auth.uid());
CREATE POLICY "Users can manage own consent" ON public.cookie_consents FOR ALL USING (user_id = auth.uid());
CREATE POLICY "Admin can view all consents" ON public.cookie_consents FOR SELECT USING (
  EXISTS (SELECT 1 FROM public.admin_users WHERE id = auth.uid())
);

-- ========================================
-- REALTIME SUBSCRIPTIONS
-- ========================================

-- Enable realtime for messages and notifications
ALTER PUBLICATION supabase_realtime ADD TABLE public.messages;
ALTER PUBLICATION supabase_realtime ADD TABLE public.notifications;

-- ========================================
-- FUNCTIONS & TRIGGERS
-- ========================================

-- Update updated_at timestamp automatically
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
   NEW.updated_at = NOW();
   RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Add triggers to tables with updated_at
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_programs_updated_at BEFORE UPDATE ON public.programs FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_courses_updated_at BEFORE UPDATE ON public.courses FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_applications_updated_at BEFORE UPDATE ON public.applications FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_children_updated_at BEFORE UPDATE ON public.children FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_student_records_updated_at BEFORE UPDATE ON public.student_records FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_counseling_sessions_updated_at BEFORE UPDATE ON public.counseling_sessions FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_course_progress_updated_at BEFORE UPDATE ON public.course_progress FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ========================================
-- SUCCESS MESSAGE
-- ========================================

DO $$
BEGIN
  RAISE NOTICE '✅ Database setup complete! All tables, indexes, and policies created successfully.';
END $$;
