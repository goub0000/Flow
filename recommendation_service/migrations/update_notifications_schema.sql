-- ========================================
-- NOTIFICATION SYSTEM SCHEMA UPDATE
-- ========================================
-- This migration adds missing fields to notifications table
-- and creates the notification_preferences table
-- Execute this in Supabase SQL Editor
-- ========================================

-- ========================================
-- 1. UPDATE NOTIFICATIONS TABLE
-- ========================================

-- Add missing columns to notifications table
ALTER TABLE public.notifications
  ADD COLUMN IF NOT EXISTS notification_type TEXT,
  ADD COLUMN IF NOT EXISTS priority TEXT DEFAULT 'normal' CHECK (priority IN ('low', 'normal', 'high', 'urgent')),
  ADD COLUMN IF NOT EXISTS channels TEXT[] DEFAULT ARRAY['in_app']::TEXT[],
  ADD COLUMN IF NOT EXISTS action_url TEXT,
  ADD COLUMN IF NOT EXISTS action_text TEXT,
  ADD COLUMN IF NOT EXISTS image_url TEXT,
  ADD COLUMN IF NOT EXISTS is_delivered BOOLEAN DEFAULT FALSE,
  ADD COLUMN IF NOT EXISTS delivered_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS read_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS metadata JSONB DEFAULT '{}'::jsonb,
  ADD COLUMN IF NOT EXISTS expires_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS scheduled_for TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ DEFAULT NOW();

-- Update notification type constraint to include all new types
ALTER TABLE public.notifications DROP CONSTRAINT IF EXISTS notifications_type_check;
ALTER TABLE public.notifications ADD CONSTRAINT notifications_type_check
  CHECK (type IN (
    'system',
    'application_status',
    'enrollment',
    'course_update',
    'message',
    'payment',
    'deadline_reminder',
    'achievement',
    'recommendation',
    'counseling',
    'parent_alert',
    'grade_update',
    -- Legacy types for backward compatibility
    'application',
    'course',
    'alert'
  ));

-- Migrate existing 'type' values to 'notification_type' if notification_type is null
UPDATE public.notifications
SET notification_type = type
WHERE notification_type IS NULL;

-- Add trigger for updated_at
DROP TRIGGER IF EXISTS update_notifications_updated_at ON public.notifications;
CREATE TRIGGER update_notifications_updated_at
  BEFORE UPDATE ON public.notifications
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- ========================================
-- 2. CREATE NOTIFICATION PREFERENCES TABLE
-- ========================================

-- Create notification preferences table
CREATE TABLE IF NOT EXISTS public.notification_preferences (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL UNIQUE REFERENCES public.users(id) ON DELETE CASCADE,
  email_enabled BOOLEAN DEFAULT TRUE,
  push_enabled BOOLEAN DEFAULT TRUE,
  sms_enabled BOOLEAN DEFAULT FALSE,
  in_app_enabled BOOLEAN DEFAULT TRUE,
  notification_types JSONB DEFAULT '{}'::jsonb,
  quiet_hours_start TEXT,  -- Format: "HH:MM"
  quiet_hours_end TEXT,     -- Format: "HH:MM"
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Add index for user_id lookups
CREATE INDEX IF NOT EXISTS idx_notification_preferences_user
  ON public.notification_preferences(user_id);

-- Enable RLS
ALTER TABLE public.notification_preferences ENABLE ROW LEVEL SECURITY;

-- Add RLS policies
CREATE POLICY "Users can view own notification preferences"
  ON public.notification_preferences FOR SELECT
  USING (user_id = auth.uid());

CREATE POLICY "Users can update own notification preferences"
  ON public.notification_preferences FOR UPDATE
  USING (user_id = auth.uid());

CREATE POLICY "Users can insert own notification preferences"
  ON public.notification_preferences FOR INSERT
  WITH CHECK (user_id = auth.uid());

-- Add trigger for updated_at
CREATE TRIGGER update_notification_preferences_updated_at
  BEFORE UPDATE ON public.notification_preferences
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- ========================================
-- 3. ADD ADDITIONAL INDEXES FOR PERFORMANCE
-- ========================================

-- Index for notification filtering by type and priority
CREATE INDEX IF NOT EXISTS idx_notifications_type
  ON public.notifications(notification_type);

CREATE INDEX IF NOT EXISTS idx_notifications_priority
  ON public.notifications(priority);

-- Index for scheduled notifications
CREATE INDEX IF NOT EXISTS idx_notifications_scheduled
  ON public.notifications(scheduled_for)
  WHERE scheduled_for IS NOT NULL;

-- Index for expired notifications
CREATE INDEX IF NOT EXISTS idx_notifications_expires
  ON public.notifications(expires_at)
  WHERE expires_at IS NOT NULL;

-- Composite index for undelivered notifications
CREATE INDEX IF NOT EXISTS idx_notifications_undelivered
  ON public.notifications(user_id, is_delivered, scheduled_for);

-- ========================================
-- 4. UPDATE REALTIME SUBSCRIPTIONS
-- ========================================

-- Ensure notification_preferences is included in realtime
ALTER PUBLICATION supabase_realtime ADD TABLE public.notification_preferences;

-- ========================================
-- SUCCESS MESSAGE
-- ========================================

DO $$
BEGIN
  RAISE NOTICE '✅ Notification system schema update complete!';
  RAISE NOTICE '   - Updated notifications table with 13 new columns';
  RAISE NOTICE '   - Created notification_preferences table';
  RAISE NOTICE '   - Added 8 new indexes for performance';
  RAISE NOTICE '   - Updated RLS policies';
  RAISE NOTICE '   - Enabled realtime for preferences';
END $$;
