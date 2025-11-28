-- =====================================================
-- ENABLE MESSAGING REALTIME
-- Run this in Supabase SQL Editor to enable real-time messaging
-- =====================================================

-- Step 1: Check if messaging tables exist, create if needed
-- =====================================================

-- Create conversations table (with correct schema)
CREATE TABLE IF NOT EXISTS public.conversations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  conversation_type TEXT DEFAULT 'direct' CHECK (conversation_type IN ('direct', 'group')),
  title TEXT,
  participant_ids UUID[] NOT NULL,
  last_message_at TIMESTAMPTZ,
  last_message_preview TEXT,
  metadata JSONB DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  CONSTRAINT min_participants CHECK (array_length(participant_ids, 1) >= 2)
);

-- Create messages table
CREATE TABLE IF NOT EXISTS public.messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  conversation_id UUID NOT NULL REFERENCES public.conversations(id) ON DELETE CASCADE,
  sender_id UUID NOT NULL,
  content TEXT NOT NULL,
  message_type TEXT DEFAULT 'text' CHECK (message_type IN ('text', 'image', 'file', 'audio', 'video')),
  attachment_url TEXT,
  reply_to_id UUID REFERENCES public.messages(id) ON DELETE SET NULL,
  is_edited BOOLEAN DEFAULT FALSE,
  is_deleted BOOLEAN DEFAULT FALSE,
  read_by UUID[] DEFAULT ARRAY[]::UUID[],
  delivered_at TIMESTAMPTZ,
  read_at TIMESTAMPTZ,
  metadata JSONB DEFAULT '{}'::jsonb,
  timestamp TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create typing indicators table
CREATE TABLE IF NOT EXISTS public.typing_indicators (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  conversation_id UUID NOT NULL REFERENCES public.conversations(id) ON DELETE CASCADE,
  user_id UUID NOT NULL,
  is_typing BOOLEAN DEFAULT TRUE,
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(conversation_id, user_id)
);

-- Step 2: Create indexes for performance
-- =====================================================

CREATE INDEX IF NOT EXISTS idx_conversations_participant_ids
  ON public.conversations USING GIN (participant_ids);
CREATE INDEX IF NOT EXISTS idx_conversations_last_message
  ON public.conversations(last_message_at DESC NULLS LAST);
CREATE INDEX IF NOT EXISTS idx_messages_conversation
  ON public.messages(conversation_id, timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_messages_sender
  ON public.messages(sender_id);
CREATE INDEX IF NOT EXISTS idx_typing_indicators_conversation
  ON public.typing_indicators(conversation_id);

-- Step 3: Enable RLS
-- =====================================================

ALTER TABLE public.conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.typing_indicators ENABLE ROW LEVEL SECURITY;

-- Step 4: Drop and recreate RLS policies (safe to run multiple times)
-- =====================================================

-- Conversations policies
DROP POLICY IF EXISTS "Users can view their own conversations" ON public.conversations;
CREATE POLICY "Users can view their own conversations"
  ON public.conversations FOR SELECT
  USING (auth.uid() = ANY(participant_ids));

DROP POLICY IF EXISTS "Users can create conversations" ON public.conversations;
CREATE POLICY "Users can create conversations"
  ON public.conversations FOR INSERT
  WITH CHECK (auth.uid() = ANY(participant_ids));

DROP POLICY IF EXISTS "Users can update their own conversations" ON public.conversations;
CREATE POLICY "Users can update their own conversations"
  ON public.conversations FOR UPDATE
  USING (auth.uid() = ANY(participant_ids));

-- Service role full access to conversations
DROP POLICY IF EXISTS "Service role full access conversations" ON public.conversations;
CREATE POLICY "Service role full access conversations"
  ON public.conversations FOR ALL
  TO service_role
  USING (true) WITH CHECK (true);

-- Messages policies
DROP POLICY IF EXISTS "Users can view messages in their conversations" ON public.messages;
CREATE POLICY "Users can view messages in their conversations"
  ON public.messages FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.conversations c
      WHERE c.id = messages.conversation_id
      AND auth.uid() = ANY(c.participant_ids)
    )
  );

DROP POLICY IF EXISTS "Users can send messages" ON public.messages;
CREATE POLICY "Users can send messages"
  ON public.messages FOR INSERT
  WITH CHECK (
    auth.uid() = sender_id AND
    EXISTS (
      SELECT 1 FROM public.conversations c
      WHERE c.id = conversation_id
      AND auth.uid() = ANY(c.participant_ids)
    )
  );

DROP POLICY IF EXISTS "Users can update message status" ON public.messages;
CREATE POLICY "Users can update message status"
  ON public.messages FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM public.conversations c
      WHERE c.id = messages.conversation_id
      AND auth.uid() = ANY(c.participant_ids)
    )
  );

-- Service role full access to messages
DROP POLICY IF EXISTS "Service role full access messages" ON public.messages;
CREATE POLICY "Service role full access messages"
  ON public.messages FOR ALL
  TO service_role
  USING (true) WITH CHECK (true);

-- Typing indicators policies
DROP POLICY IF EXISTS "Users can view typing indicators" ON public.typing_indicators;
CREATE POLICY "Users can view typing indicators"
  ON public.typing_indicators FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.conversations c
      WHERE c.id = typing_indicators.conversation_id
      AND auth.uid() = ANY(c.participant_ids)
    )
  );

DROP POLICY IF EXISTS "Users can manage typing indicators" ON public.typing_indicators;
CREATE POLICY "Users can manage typing indicators"
  ON public.typing_indicators FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Service role full access to typing indicators
DROP POLICY IF EXISTS "Service role full access typing" ON public.typing_indicators;
CREATE POLICY "Service role full access typing"
  ON public.typing_indicators FOR ALL
  TO service_role
  USING (true) WITH CHECK (true);

-- Step 5: CRITICAL - Enable Supabase Realtime for messaging tables
-- =====================================================

-- Try to add tables to realtime publication (ignore errors if already added)
DO $$
BEGIN
  -- Enable realtime for conversations
  BEGIN
    ALTER PUBLICATION supabase_realtime ADD TABLE public.conversations;
    RAISE NOTICE 'Added conversations to realtime publication';
  EXCEPTION WHEN duplicate_object THEN
    RAISE NOTICE 'conversations already in realtime publication';
  END;

  -- Enable realtime for messages
  BEGIN
    ALTER PUBLICATION supabase_realtime ADD TABLE public.messages;
    RAISE NOTICE 'Added messages to realtime publication';
  EXCEPTION WHEN duplicate_object THEN
    RAISE NOTICE 'messages already in realtime publication';
  END;

  -- Enable realtime for typing_indicators
  BEGIN
    ALTER PUBLICATION supabase_realtime ADD TABLE public.typing_indicators;
    RAISE NOTICE 'Added typing_indicators to realtime publication';
  EXCEPTION WHEN duplicate_object THEN
    RAISE NOTICE 'typing_indicators already in realtime publication';
  END;
END $$;

-- Step 6: Grant permissions
-- =====================================================

GRANT ALL ON public.conversations TO authenticated;
GRANT ALL ON public.messages TO authenticated;
GRANT ALL ON public.typing_indicators TO authenticated;
GRANT ALL ON public.conversations TO service_role;
GRANT ALL ON public.messages TO service_role;
GRANT ALL ON public.typing_indicators TO service_role;

-- Step 7: Create helper function for unread count
-- =====================================================

CREATE OR REPLACE FUNCTION get_unread_message_count(user_uuid UUID)
RETURNS INTEGER AS $$
DECLARE
  unread_count INTEGER;
BEGIN
  SELECT COUNT(*)::INTEGER INTO unread_count
  FROM public.messages m
  JOIN public.conversations c ON m.conversation_id = c.id
  WHERE user_uuid = ANY(c.participant_ids)
    AND m.sender_id != user_uuid
    AND NOT (user_uuid = ANY(m.read_by))
    AND m.is_deleted = FALSE;
  RETURN COALESCE(unread_count, 0);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION get_unread_message_count(UUID) TO authenticated;

-- Step 8: Verify setup
-- =====================================================

DO $$
BEGIN
  RAISE NOTICE '=====================================================';
  RAISE NOTICE 'MESSAGING REALTIME SETUP COMPLETE';
  RAISE NOTICE '=====================================================';
  RAISE NOTICE 'Tables created: conversations, messages, typing_indicators';
  RAISE NOTICE 'RLS policies: Enabled';
  RAISE NOTICE 'Realtime: Enabled for all messaging tables';
  RAISE NOTICE '';
  RAISE NOTICE 'Next: Enable Realtime in Supabase Dashboard:';
  RAISE NOTICE '1. Go to Database > Replication';
  RAISE NOTICE '2. Ensure conversations, messages, typing_indicators are enabled';
  RAISE NOTICE '=====================================================';
END $$;
