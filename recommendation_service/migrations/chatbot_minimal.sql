-- MINIMAL CHATBOT MIGRATION
-- Run this in Supabase SQL Editor to create the chatbot tables

-- 1. CHATBOT CONVERSATIONS TABLE
CREATE TABLE IF NOT EXISTS public.chatbot_conversations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES public.users(id) ON DELETE SET NULL,
    user_name VARCHAR(255),
    status VARCHAR(20) DEFAULT 'active',
    summary TEXT,
    context JSONB DEFAULT '{}'::jsonb,
    ai_provider VARCHAR(20),
    message_count INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. CHATBOT MESSAGES TABLE
CREATE TABLE IF NOT EXISTS public.chatbot_messages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    conversation_id UUID NOT NULL REFERENCES public.chatbot_conversations(id) ON DELETE CASCADE,
    sender VARCHAR(20) NOT NULL,
    content TEXT NOT NULL,
    message_type VARCHAR(30) DEFAULT 'text',
    metadata JSONB DEFAULT '{}'::jsonb,
    ai_provider VARCHAR(20),
    ai_confidence FLOAT,
    tokens_used INTEGER,
    feedback VARCHAR(20),
    feedback_comment TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. CHATBOT SUPPORT QUEUE TABLE (for human escalation)
CREATE TABLE IF NOT EXISTS public.chatbot_support_queue (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    conversation_id UUID NOT NULL REFERENCES public.chatbot_conversations(id) ON DELETE CASCADE,
    priority VARCHAR(10) DEFAULT 'normal',
    reason TEXT,
    assigned_to UUID REFERENCES public.users(id) ON DELETE SET NULL,
    status VARCHAR(20) DEFAULT 'pending',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    resolved_at TIMESTAMPTZ
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_chatbot_conversations_user_id ON public.chatbot_conversations(user_id);
CREATE INDEX IF NOT EXISTS idx_chatbot_conversations_status ON public.chatbot_conversations(status);
CREATE INDEX IF NOT EXISTS idx_chatbot_messages_conversation_id ON public.chatbot_messages(conversation_id);
CREATE INDEX IF NOT EXISTS idx_chatbot_support_queue_status ON public.chatbot_support_queue(status);
CREATE INDEX IF NOT EXISTS idx_chatbot_support_queue_conversation_id ON public.chatbot_support_queue(conversation_id);

-- Enable RLS
ALTER TABLE public.chatbot_conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.chatbot_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.chatbot_support_queue ENABLE ROW LEVEL SECURITY;

-- Allow authenticated users to manage their own conversations
CREATE POLICY "Users can manage own conversations" ON public.chatbot_conversations
    FOR ALL USING (user_id = auth.uid() OR user_id IS NULL);

CREATE POLICY "Users can manage messages in own conversations" ON public.chatbot_messages
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.chatbot_conversations
            WHERE chatbot_conversations.id = chatbot_messages.conversation_id
            AND (chatbot_conversations.user_id = auth.uid() OR chatbot_conversations.user_id IS NULL)
        )
    );

-- Support queue: users can create escalations for their own conversations
CREATE POLICY "Users can escalate own conversations" ON public.chatbot_support_queue
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.chatbot_conversations
            WHERE chatbot_conversations.id = chatbot_support_queue.conversation_id
            AND chatbot_conversations.user_id = auth.uid()
        )
    );

-- Grant permissions
GRANT SELECT, INSERT, UPDATE, DELETE ON public.chatbot_conversations TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.chatbot_messages TO authenticated;
GRANT SELECT, INSERT ON public.chatbot_support_queue TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.chatbot_conversations TO service_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.chatbot_messages TO service_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.chatbot_support_queue TO service_role;
