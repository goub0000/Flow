-- =====================================================
-- MESSAGING SYSTEM SCHEMA
-- =====================================================
-- Created: 2025-11-17
-- Purpose: Implement real-time messaging between users
-- Features: 1-on-1 conversations, typing indicators, read receipts
-- =====================================================

-- Create conversations table
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

  -- Ensure at least 2 participants
  CONSTRAINT min_participants CHECK (array_length(participant_ids, 1) >= 2)
);

-- Create messages table
CREATE TABLE IF NOT EXISTS public.messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  conversation_id UUID NOT NULL REFERENCES public.conversations(id) ON DELETE CASCADE,
  sender_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
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

-- Create typing indicators table (temporary state)
CREATE TABLE IF NOT EXISTS public.typing_indicators (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  conversation_id UUID NOT NULL REFERENCES public.conversations(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  is_typing BOOLEAN DEFAULT TRUE,
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE(conversation_id, user_id)
);

-- =====================================================
-- INDEXES FOR PERFORMANCE
-- =====================================================

-- Conversation indexes
CREATE INDEX IF NOT EXISTS idx_conversations_participant_ids
  ON public.conversations USING GIN (participant_ids);
CREATE INDEX IF NOT EXISTS idx_conversations_last_message
  ON public.conversations(last_message_at DESC NULLS LAST);
CREATE INDEX IF NOT EXISTS idx_conversations_type
  ON public.conversations(conversation_type);

-- Message indexes
CREATE INDEX IF NOT EXISTS idx_messages_conversation
  ON public.messages(conversation_id, timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_messages_sender
  ON public.messages(sender_id);
CREATE INDEX IF NOT EXISTS idx_messages_read_by
  ON public.messages USING GIN (read_by);
CREATE INDEX IF NOT EXISTS idx_messages_unread
  ON public.messages(conversation_id) WHERE is_deleted = FALSE;
CREATE INDEX IF NOT EXISTS idx_messages_timestamp
  ON public.messages(timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_messages_reply_to
  ON public.messages(reply_to_id) WHERE reply_to_id IS NOT NULL;

-- Typing indicator indexes
CREATE INDEX IF NOT EXISTS idx_typing_indicators_conversation
  ON public.typing_indicators(conversation_id);

-- =====================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- =====================================================

-- Enable RLS
ALTER TABLE public.conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.typing_indicators ENABLE ROW LEVEL SECURITY;

-- Conversations policies
-- Users can view conversations they are part of
CREATE POLICY "Users can view their own conversations"
  ON public.conversations
  FOR SELECT
  USING (
    auth.uid() = ANY(participant_ids)
  );

-- Users can create conversations
CREATE POLICY "Users can create conversations"
  ON public.conversations
  FOR INSERT
  WITH CHECK (
    auth.uid() = ANY(participant_ids)
  );

-- Users can update conversations they are part of
CREATE POLICY "Users can update their own conversations"
  ON public.conversations
  FOR UPDATE
  USING (
    auth.uid() = ANY(participant_ids)
  );

-- Messages policies
-- Users can view messages in their conversations
CREATE POLICY "Users can view their own messages"
  ON public.messages
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.conversations c
      WHERE c.id = messages.conversation_id
      AND auth.uid() = ANY(c.participant_ids)
    )
  );

-- Users can send messages
CREATE POLICY "Users can send messages"
  ON public.messages
  FOR INSERT
  WITH CHECK (
    auth.uid() = sender_id AND
    EXISTS (
      SELECT 1 FROM public.conversations c
      WHERE c.id = conversation_id
      AND auth.uid() = ANY(c.participant_ids)
    )
  );

-- Users can update messages in their conversations (for read receipts and edits)
CREATE POLICY "Users can update message status"
  ON public.messages
  FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM public.conversations c
      WHERE c.id = messages.conversation_id
      AND auth.uid() = ANY(c.participant_ids)
    )
  );

-- Users can delete their own messages
CREATE POLICY "Users can delete their own messages"
  ON public.messages
  FOR DELETE
  USING (
    auth.uid() = sender_id
  );

-- Typing indicators policies
CREATE POLICY "Users can view typing indicators in their conversations"
  ON public.typing_indicators
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.conversations c
      WHERE c.id = typing_indicators.conversation_id
      AND auth.uid() = ANY(c.participant_ids)
    )
  );

CREATE POLICY "Users can manage their own typing indicators"
  ON public.typing_indicators
  FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- =====================================================
-- FUNCTIONS AND TRIGGERS
-- =====================================================

-- Function to update updated_at timestamp on row update
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to auto-update updated_at on conversations
DROP TRIGGER IF EXISTS trigger_update_conversations_updated_at ON public.conversations;
CREATE TRIGGER trigger_update_conversations_updated_at
  BEFORE UPDATE ON public.conversations
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Trigger to auto-update updated_at on messages
DROP TRIGGER IF EXISTS trigger_update_messages_updated_at ON public.messages;
CREATE TRIGGER trigger_update_messages_updated_at
  BEFORE UPDATE ON public.messages
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Function to auto-expire typing indicators
CREATE OR REPLACE FUNCTION cleanup_old_typing_indicators()
RETURNS void AS $$
BEGIN
  DELETE FROM public.typing_indicators
  WHERE updated_at < NOW() - INTERVAL '10 seconds';
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- ENABLE REALTIME FOR MESSAGING TABLES
-- =====================================================

-- Enable realtime for conversations
ALTER PUBLICATION supabase_realtime ADD TABLE public.conversations;

-- Enable realtime for messages
ALTER PUBLICATION supabase_realtime ADD TABLE public.messages;

-- Enable realtime for typing indicators
ALTER PUBLICATION supabase_realtime ADD TABLE public.typing_indicators;

-- =====================================================
-- HELPER FUNCTIONS FOR API
-- =====================================================

-- Function to get unread message count for user
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
$$ LANGUAGE plpgsql;

-- =====================================================
-- INITIAL DATA / COMMENTS
-- =====================================================

COMMENT ON TABLE public.conversations IS 'Stores direct and group conversations between users';
COMMENT ON TABLE public.messages IS 'Stores individual messages within conversations with read receipts';
COMMENT ON TABLE public.typing_indicators IS 'Temporary storage for typing status (auto-cleanup after 10s)';

COMMENT ON COLUMN public.conversations.conversation_type IS 'Type: direct (1-on-1) or group (multiple participants)';
COMMENT ON COLUMN public.conversations.participant_ids IS 'Array of user IDs who are part of this conversation';
COMMENT ON COLUMN public.messages.message_type IS 'Type of message: text, image, file, audio, video';
COMMENT ON COLUMN public.messages.read_by IS 'Array of user IDs who have read this message (for read receipts)';
COMMENT ON COLUMN public.messages.reply_to_id IS 'ID of message being replied to (for threaded conversations)';
COMMENT ON FUNCTION get_unread_message_count IS 'Returns count of unread messages for a user across all conversations';
