-- ========================================
-- MIGRATION: Remove Courses and Enrollments Functionality
-- ========================================
-- Execute this script in Supabase SQL Editor to remove all courses-related tables
-- Created: November 14, 2025
-- ========================================

-- Drop RLS policies first
DROP POLICY IF EXISTS "Students can view own progress" ON public.course_progress;
DROP POLICY IF EXISTS "Students can enroll in courses" ON public.enrollments;
DROP POLICY IF EXISTS "Students can view own enrollments" ON public.enrollments;
DROP POLICY IF EXISTS "Institutions can manage own courses" ON public.courses;
DROP POLICY IF EXISTS "Anyone can view active courses" ON public.courses;

-- Drop triggers
DROP TRIGGER IF EXISTS update_course_progress_updated_at ON public.course_progress;
DROP TRIGGER IF EXISTS update_courses_updated_at ON public.courses;

-- Drop indexes
DROP INDEX IF EXISTS idx_progress_course;
DROP INDEX IF EXISTS idx_progress_student;
DROP INDEX IF EXISTS idx_enrollments_status;
DROP INDEX IF EXISTS idx_enrollments_course;
DROP INDEX IF EXISTS idx_enrollments_student;
DROP INDEX IF EXISTS idx_courses_is_active;
DROP INDEX IF EXISTS idx_courses_category;
DROP INDEX IF EXISTS idx_courses_institution;

-- Drop tables (in order to respect foreign key constraints)
DROP TABLE IF EXISTS public.course_progress CASCADE;
DROP TABLE IF EXISTS public.enrollments CASCADE;
DROP TABLE IF EXISTS public.courses CASCADE;

-- Update payments table to remove 'course' from item_type constraint
ALTER TABLE public.payments DROP CONSTRAINT IF EXISTS payments_item_type_check;
ALTER TABLE public.payments ADD CONSTRAINT payments_item_type_check
  CHECK (item_type IN ('program', 'application', 'subscription', 'other'));

-- Update notifications table to remove 'course' from type constraint
ALTER TABLE public.notifications DROP CONSTRAINT IF EXISTS notifications_type_check;
ALTER TABLE public.notifications ADD CONSTRAINT notifications_type_check
  CHECK (type IN ('application', 'payment', 'alert', 'message', 'system'));

-- Success message
DO $$
BEGIN
  RAISE NOTICE '✅ Courses and enrollments functionality removed successfully!';
  RAISE NOTICE '✅ Database constraints updated to remove course references!';
END $$;
