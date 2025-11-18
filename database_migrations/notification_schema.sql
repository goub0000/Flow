-- =====================================================
-- NOTIFICATION SYSTEM DATABASE SCHEMA
-- Phase 5.2 - In-App Notifications
-- =====================================================

-- ==================== NOTIFICATION TYPES ====================

-- Notification types enum (matches Flutter NotificationType)
DO $$ BEGIN
    CREATE TYPE notification_type AS ENUM (
        'application_status',      -- College application status changed
        'grade_posted',            -- New grade posted
        'message_received',        -- New message from counselor/admin
        'meeting_scheduled',       -- Meeting scheduled
        'meeting_reminder',        -- Upcoming meeting reminder
        'achievement_earned',      -- New achievement/badge earned
        'deadline_reminder',       -- Application/task deadline approaching
        'recommendation_ready',    -- New recommendation available
        'system_announcement',     -- System-wide announcement
        'comment_received',        -- Comment on your post/activity
        'mention',                 -- You were mentioned
        'event_reminder'           -- Event reminder
    );
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- ==================== NOTIFICATIONS TABLE ====================

CREATE TABLE IF NOT EXISTS notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- User receiving the notification
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,

    -- Notification details
    type notification_type NOT NULL,
    title TEXT NOT NULL,
    message TEXT NOT NULL,

    -- Additional data (JSON format for flexibility)
    -- Examples:
    --   application_status: {"application_id": "...", "old_status": "...", "new_status": "..."}
    --   grade_posted: {"course_id": "...", "assignment_id": "...", "grade": ...}
    --   meeting_scheduled: {"meeting_id": "...", "meeting_time": "...", "counselor_name": "..."}
    metadata JSONB DEFAULT '{}'::jsonb,

    -- Navigation/action data
    action_url TEXT,              -- Deep link or route to navigate to

    -- Status flags
    is_read BOOLEAN DEFAULT false,
    is_archived BOOLEAN DEFAULT false,

    -- Priority (optional for future use)
    priority INTEGER DEFAULT 0,   -- 0=normal, 1=high, 2=urgent

    -- Timestamps
    created_at TIMESTAMPTZ DEFAULT NOW(),
    read_at TIMESTAMPTZ,
    archived_at TIMESTAMPTZ,

    -- Soft delete
    deleted_at TIMESTAMPTZ
);

-- ==================== NOTIFICATION PREFERENCES TABLE ====================

CREATE TABLE IF NOT EXISTS notification_preferences (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- User whose preferences these are
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,

    -- Notification type
    notification_type notification_type NOT NULL,

    -- Preference flags
    in_app_enabled BOOLEAN DEFAULT true,        -- Show in notification center
    email_enabled BOOLEAN DEFAULT true,         -- Send email (future feature)
    push_enabled BOOLEAN DEFAULT true,          -- Push notification (future feature)

    -- Quiet hours (optional for future use)
    quiet_hours_start TIME,                     -- e.g., '22:00'
    quiet_hours_end TIME,                       -- e.g., '08:00'

    -- Timestamps
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),

    -- Ensure one preference per user per type
    UNIQUE(user_id, notification_type)
);

-- ==================== INDEXES ====================

-- Performance indexes for notifications
CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_user_unread ON notifications(user_id, is_read) WHERE deleted_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_notifications_user_created ON notifications(user_id, created_at DESC) WHERE deleted_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_notifications_type ON notifications(type);
CREATE INDEX IF NOT EXISTS idx_notifications_created_at ON notifications(created_at DESC);

-- GIN index for metadata JSON queries
CREATE INDEX IF NOT EXISTS idx_notifications_metadata ON notifications USING GIN (metadata);

-- Performance indexes for preferences
CREATE INDEX IF NOT EXISTS idx_notification_preferences_user_id ON notification_preferences(user_id);
CREATE INDEX IF NOT EXISTS idx_notification_preferences_type ON notification_preferences(notification_type);

-- ==================== ROW LEVEL SECURITY (RLS) ====================

-- Enable RLS on notifications table
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

-- Policy: Users can view their own notifications
CREATE POLICY "Users can view own notifications"
ON notifications FOR SELECT
USING (auth.uid() = user_id);

-- Policy: Users can update their own notifications (mark as read, archive, etc.)
CREATE POLICY "Users can update own notifications"
ON notifications FOR UPDATE
USING (auth.uid() = user_id);

-- Policy: Users can soft-delete their own notifications
CREATE POLICY "Users can delete own notifications"
ON notifications FOR DELETE
USING (auth.uid() = user_id);

-- Policy: System/admins can insert notifications (via service role)
-- Note: INSERT is typically done via service role, not from client
CREATE POLICY "Service role can insert notifications"
ON notifications FOR INSERT
WITH CHECK (true);  -- Service role bypasses RLS, but this is for clarity

-- Enable RLS on notification_preferences table
ALTER TABLE notification_preferences ENABLE ROW LEVEL SECURITY;

-- Policy: Users can view their own preferences
CREATE POLICY "Users can view own preferences"
ON notification_preferences FOR SELECT
USING (auth.uid() = user_id);

-- Policy: Users can insert their own preferences
CREATE POLICY "Users can insert own preferences"
ON notification_preferences FOR INSERT
WITH CHECK (auth.uid() = user_id);

-- Policy: Users can update their own preferences
CREATE POLICY "Users can update own preferences"
ON notification_preferences FOR UPDATE
USING (auth.uid() = user_id);

-- Policy: Users can delete their own preferences
CREATE POLICY "Users can delete own preferences"
ON notification_preferences FOR DELETE
USING (auth.uid() = user_id);

-- ==================== HELPER FUNCTIONS ====================

-- Function to mark notification as read
CREATE OR REPLACE FUNCTION mark_notification_read(notification_id UUID)
RETURNS VOID AS $$
BEGIN
    UPDATE notifications
    SET is_read = true,
        read_at = NOW()
    WHERE id = notification_id
      AND user_id = auth.uid()
      AND is_read = false;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to mark all notifications as read for a user
CREATE OR REPLACE FUNCTION mark_all_notifications_read()
RETURNS INTEGER AS $$
DECLARE
    updated_count INTEGER;
BEGIN
    UPDATE notifications
    SET is_read = true,
        read_at = NOW()
    WHERE user_id = auth.uid()
      AND is_read = false
      AND deleted_at IS NULL;

    GET DIAGNOSTICS updated_count = ROW_COUNT;
    RETURN updated_count;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to get unread notification count
CREATE OR REPLACE FUNCTION get_unread_notification_count()
RETURNS INTEGER AS $$
BEGIN
    RETURN (
        SELECT COUNT(*)
        FROM notifications
        WHERE user_id = auth.uid()
          AND is_read = false
          AND deleted_at IS NULL
    )::INTEGER;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to soft-delete old notifications (cleanup job)
CREATE OR REPLACE FUNCTION cleanup_old_notifications(days_to_keep INTEGER DEFAULT 90)
RETURNS INTEGER AS $$
DECLARE
    deleted_count INTEGER;
BEGIN
    UPDATE notifications
    SET deleted_at = NOW()
    WHERE created_at < NOW() - (days_to_keep || ' days')::INTERVAL
      AND deleted_at IS NULL
      AND (is_archived = true OR is_read = true);

    GET DIAGNOSTICS deleted_count = ROW_COUNT;
    RETURN deleted_count;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to create default notification preferences for a user
CREATE OR REPLACE FUNCTION create_default_notification_preferences(target_user_id UUID)
RETURNS VOID AS $$
DECLARE
    notif_type notification_type;
BEGIN
    -- Loop through all notification types and create default preferences
    FOR notif_type IN
        SELECT unnest(enum_range(NULL::notification_type))
    LOOP
        INSERT INTO notification_preferences (user_id, notification_type, in_app_enabled, email_enabled, push_enabled)
        VALUES (target_user_id, notif_type, true, true, true)
        ON CONFLICT (user_id, notification_type) DO NOTHING;
    END LOOP;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ==================== TRIGGERS ====================

-- Trigger to auto-create default preferences on user creation
CREATE OR REPLACE FUNCTION trigger_create_default_preferences()
RETURNS TRIGGER AS $$
BEGIN
    PERFORM create_default_notification_preferences(NEW.id);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Note: This trigger would be on auth.users, but we can't modify that table
-- Instead, we'll call create_default_notification_preferences manually on signup
-- Or via a scheduled job to backfill existing users

-- Trigger to update updated_at timestamp on preferences
CREATE OR REPLACE FUNCTION trigger_update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_notification_preferences_timestamp
    BEFORE UPDATE ON notification_preferences
    FOR EACH ROW
    EXECUTE FUNCTION trigger_update_timestamp();

-- ==================== SAMPLE DATA (for testing) ====================

-- Uncomment to insert sample notifications for testing
/*
-- Sample notification for current user
INSERT INTO notifications (user_id, type, title, message, metadata, action_url)
SELECT
    auth.uid(),
    'system_announcement',
    'Welcome to Flow!',
    'Thank you for joining our platform. Explore features and start your college journey.',
    '{"icon": "celebration", "color": "blue"}'::jsonb,
    '/dashboard'
WHERE auth.uid() IS NOT NULL;

-- Sample grade notification
INSERT INTO notifications (user_id, type, title, message, metadata, action_url)
SELECT
    auth.uid(),
    'grade_posted',
    'New Grade Posted',
    'Your grade for "Introduction to Computer Science - Assignment 1" has been posted.',
    '{"course_id": "cs101", "assignment_id": "hw1", "grade": 95, "max_grade": 100}'::jsonb,
    '/student/courses/cs101'
WHERE auth.uid() IS NOT NULL;
*/

-- ==================== GRANT PERMISSIONS ====================

-- Grant necessary permissions to authenticated users
GRANT SELECT, INSERT, UPDATE, DELETE ON notifications TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON notification_preferences TO authenticated;

-- Grant usage on sequences (for UUID generation)
-- Note: gen_random_uuid() doesn't use sequences

-- ==================== VERIFICATION QUERIES ====================

-- Uncomment to verify schema
/*
-- Check notification types
SELECT enum_range(NULL::notification_type);

-- Check tables exist
SELECT table_name FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_name IN ('notifications', 'notification_preferences');

-- Check RLS is enabled
SELECT tablename, rowsecurity FROM pg_tables
WHERE schemaname = 'public'
  AND tablename IN ('notifications', 'notification_preferences');

-- Check policies
SELECT schemaname, tablename, policyname FROM pg_policies
WHERE tablename IN ('notifications', 'notification_preferences');

-- Check indexes
SELECT tablename, indexname FROM pg_indexes
WHERE tablename IN ('notifications', 'notification_preferences');
*/

-- =====================================================
-- END OF NOTIFICATION SCHEMA
-- =====================================================
