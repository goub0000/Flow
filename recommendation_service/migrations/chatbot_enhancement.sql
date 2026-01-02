-- ================================================================================
-- MIGRATION: Enhanced Chatbot Tables
-- ================================================================================
-- Run this in Supabase SQL Editor to create the chatbot tables
-- Supports: AI conversations, feedback, FAQ management, escalation queue
-- ================================================================================

-- ================================================================================
-- 1. CHATBOT CONVERSATIONS TABLE
-- ================================================================================
CREATE TABLE IF NOT EXISTS public.chatbot_conversations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES public.users(id) ON DELETE SET NULL,
    user_name VARCHAR(255),
    user_email VARCHAR(255),
    user_role VARCHAR(50),
    status VARCHAR(20) DEFAULT 'active',  -- active, archived, flagged, escalated
    summary TEXT,  -- AI-generated conversation summary
    topics JSONB DEFAULT '[]'::jsonb,  -- Extracted topics
    context JSONB DEFAULT '{}'::jsonb,  -- User context at conversation start
    ai_provider VARCHAR(20),  -- 'claude', 'openai', 'faq'
    message_count INTEGER DEFAULT 0,
    user_message_count INTEGER DEFAULT 0,
    bot_message_count INTEGER DEFAULT 0,
    agent_message_count INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for conversations
CREATE INDEX IF NOT EXISTS idx_chatbot_conversations_user_id ON public.chatbot_conversations(user_id);
CREATE INDEX IF NOT EXISTS idx_chatbot_conversations_status ON public.chatbot_conversations(status);
CREATE INDEX IF NOT EXISTS idx_chatbot_conversations_created_at ON public.chatbot_conversations(created_at DESC);

-- ================================================================================
-- 2. CHATBOT MESSAGES TABLE
-- ================================================================================
CREATE TABLE IF NOT EXISTS public.chatbot_messages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    conversation_id UUID NOT NULL REFERENCES public.chatbot_conversations(id) ON DELETE CASCADE,
    sender VARCHAR(20) NOT NULL,  -- 'user', 'bot', 'system', 'agent'
    content TEXT NOT NULL,
    message_type VARCHAR(30) DEFAULT 'text',  -- text, quick_reply, card, image, file, carousel, markdown
    metadata JSONB DEFAULT '{}'::jsonb,  -- For rich content (images, cards, quick actions)
    ai_provider VARCHAR(20),  -- Which AI generated this response
    ai_confidence FLOAT,  -- AI confidence score (0-1)
    tokens_used INTEGER,  -- Token count for this message
    feedback VARCHAR(20),  -- 'helpful', 'not_helpful', null
    feedback_comment TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for messages
CREATE INDEX IF NOT EXISTS idx_chatbot_messages_conversation_id ON public.chatbot_messages(conversation_id);
CREATE INDEX IF NOT EXISTS idx_chatbot_messages_sender ON public.chatbot_messages(sender);
CREATE INDEX IF NOT EXISTS idx_chatbot_messages_created_at ON public.chatbot_messages(created_at);
CREATE INDEX IF NOT EXISTS idx_chatbot_messages_feedback ON public.chatbot_messages(feedback) WHERE feedback IS NOT NULL;

-- ================================================================================
-- 3. CHATBOT FAQ TABLE
-- ================================================================================
CREATE TABLE IF NOT EXISTS public.chatbot_faqs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    question TEXT NOT NULL,
    answer TEXT NOT NULL,
    keywords JSONB DEFAULT '[]'::jsonb,
    category VARCHAR(50) DEFAULT 'general',
    priority INTEGER DEFAULT 0,  -- Higher = checked first
    is_active BOOLEAN DEFAULT true,
    usage_count INTEGER DEFAULT 0,
    helpful_count INTEGER DEFAULT 0,
    not_helpful_count INTEGER DEFAULT 0,
    quick_actions JSONB DEFAULT '[]'::jsonb,  -- Follow-up quick actions
    created_by UUID REFERENCES public.users(id),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for FAQs
CREATE INDEX IF NOT EXISTS idx_chatbot_faqs_category ON public.chatbot_faqs(category);
CREATE INDEX IF NOT EXISTS idx_chatbot_faqs_is_active ON public.chatbot_faqs(is_active);
CREATE INDEX IF NOT EXISTS idx_chatbot_faqs_priority ON public.chatbot_faqs(priority DESC);

-- ================================================================================
-- 4. CHATBOT SUPPORT QUEUE TABLE
-- ================================================================================
CREATE TABLE IF NOT EXISTS public.chatbot_support_queue (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    conversation_id UUID NOT NULL REFERENCES public.chatbot_conversations(id) ON DELETE CASCADE,
    priority VARCHAR(10) DEFAULT 'normal',  -- low, normal, high, urgent
    reason TEXT,  -- Why escalated
    escalation_type VARCHAR(30),  -- 'user_request', 'low_confidence', 'negative_feedback', 'sensitive_topic'
    assigned_to UUID REFERENCES public.users(id),
    status VARCHAR(20) DEFAULT 'pending',  -- pending, assigned, in_progress, resolved, closed
    notes TEXT,  -- Agent notes
    response_time_seconds INTEGER,  -- Time to first agent response
    resolution_time_seconds INTEGER,  -- Total time to resolution
    created_at TIMESTAMPTZ DEFAULT NOW(),
    assigned_at TIMESTAMPTZ,
    resolved_at TIMESTAMPTZ
);

-- Indexes for support queue
CREATE INDEX IF NOT EXISTS idx_chatbot_queue_status ON public.chatbot_support_queue(status);
CREATE INDEX IF NOT EXISTS idx_chatbot_queue_priority ON public.chatbot_support_queue(priority);
CREATE INDEX IF NOT EXISTS idx_chatbot_queue_assigned_to ON public.chatbot_support_queue(assigned_to);
CREATE INDEX IF NOT EXISTS idx_chatbot_queue_created_at ON public.chatbot_support_queue(created_at DESC);

-- ================================================================================
-- 5. CHATBOT FEEDBACK ANALYTICS TABLE
-- ================================================================================
CREATE TABLE IF NOT EXISTS public.chatbot_feedback_analytics (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    date DATE NOT NULL,
    total_messages INTEGER DEFAULT 0,
    helpful_count INTEGER DEFAULT 0,
    not_helpful_count INTEGER DEFAULT 0,
    escalation_count INTEGER DEFAULT 0,
    avg_confidence FLOAT,
    top_topics JSONB DEFAULT '[]'::jsonb,
    ai_provider_stats JSONB DEFAULT '{}'::jsonb,  -- Stats per provider
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Unique constraint for daily analytics
CREATE UNIQUE INDEX IF NOT EXISTS idx_chatbot_analytics_date ON public.chatbot_feedback_analytics(date);

-- ================================================================================
-- 6. ROW LEVEL SECURITY POLICIES
-- ================================================================================

-- Enable RLS on all tables
ALTER TABLE public.chatbot_conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.chatbot_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.chatbot_faqs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.chatbot_support_queue ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.chatbot_feedback_analytics ENABLE ROW LEVEL SECURITY;

-- Conversations: Users see their own, admins see all
CREATE POLICY "Users can view own conversations" ON public.chatbot_conversations
    FOR SELECT USING (user_id = auth.uid());

CREATE POLICY "Users can create own conversations" ON public.chatbot_conversations
    FOR INSERT WITH CHECK (user_id = auth.uid() OR user_id IS NULL);

CREATE POLICY "Users can update own conversations" ON public.chatbot_conversations
    FOR UPDATE USING (user_id = auth.uid());

CREATE POLICY "Admins can manage all conversations" ON public.chatbot_conversations
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.users
            WHERE users.id = auth.uid()
            AND users.active_role IN ('superadmin', 'supportadmin', 'admin')
        )
    );

-- Messages: Users see messages in their conversations
CREATE POLICY "Users can view messages in own conversations" ON public.chatbot_messages
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.chatbot_conversations
            WHERE chatbot_conversations.id = chatbot_messages.conversation_id
            AND chatbot_conversations.user_id = auth.uid()
        )
    );

CREATE POLICY "Users can create messages in own conversations" ON public.chatbot_messages
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.chatbot_conversations
            WHERE chatbot_conversations.id = chatbot_messages.conversation_id
            AND (chatbot_conversations.user_id = auth.uid() OR chatbot_conversations.user_id IS NULL)
        )
    );

CREATE POLICY "Users can update feedback on messages" ON public.chatbot_messages
    FOR UPDATE USING (
        EXISTS (
            SELECT 1 FROM public.chatbot_conversations
            WHERE chatbot_conversations.id = chatbot_messages.conversation_id
            AND chatbot_conversations.user_id = auth.uid()
        )
    );

CREATE POLICY "Admins can manage all messages" ON public.chatbot_messages
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.users
            WHERE users.id = auth.uid()
            AND users.active_role IN ('superadmin', 'supportadmin', 'admin')
        )
    );

-- FAQs: Everyone can read active FAQs, admins can manage
CREATE POLICY "Everyone can read active FAQs" ON public.chatbot_faqs
    FOR SELECT USING (is_active = true);

CREATE POLICY "Admins can manage FAQs" ON public.chatbot_faqs
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.users
            WHERE users.id = auth.uid()
            AND users.active_role IN ('superadmin', 'contentadmin', 'admin')
        )
    );

-- Support Queue: Only admins
CREATE POLICY "Admins can manage support queue" ON public.chatbot_support_queue
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.users
            WHERE users.id = auth.uid()
            AND users.active_role IN ('superadmin', 'supportadmin', 'admin')
        )
    );

-- Analytics: Only admins
CREATE POLICY "Admins can view analytics" ON public.chatbot_feedback_analytics
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.users
            WHERE users.id = auth.uid()
            AND users.active_role IN ('superadmin', 'analyticsadmin', 'admin')
        )
    );

-- ================================================================================
-- 7. GRANT PERMISSIONS
-- ================================================================================
GRANT SELECT, INSERT, UPDATE ON public.chatbot_conversations TO authenticated;
GRANT SELECT, INSERT, UPDATE ON public.chatbot_messages TO authenticated;
GRANT SELECT ON public.chatbot_faqs TO authenticated;
GRANT SELECT ON public.chatbot_faqs TO anon;  -- Allow anonymous FAQ access

-- Admin-only tables
GRANT ALL ON public.chatbot_support_queue TO authenticated;
GRANT ALL ON public.chatbot_feedback_analytics TO authenticated;
GRANT ALL ON public.chatbot_faqs TO authenticated;

-- ================================================================================
-- 8. HELPER FUNCTIONS
-- ================================================================================

-- Function to update conversation stats after message insert
CREATE OR REPLACE FUNCTION update_conversation_stats()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE public.chatbot_conversations
    SET
        message_count = message_count + 1,
        user_message_count = user_message_count + CASE WHEN NEW.sender = 'user' THEN 1 ELSE 0 END,
        bot_message_count = bot_message_count + CASE WHEN NEW.sender = 'bot' THEN 1 ELSE 0 END,
        agent_message_count = agent_message_count + CASE WHEN NEW.sender = 'agent' THEN 1 ELSE 0 END,
        updated_at = NOW()
    WHERE id = NEW.conversation_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to auto-update stats
DROP TRIGGER IF EXISTS trigger_update_conversation_stats ON public.chatbot_messages;
CREATE TRIGGER trigger_update_conversation_stats
    AFTER INSERT ON public.chatbot_messages
    FOR EACH ROW
    EXECUTE FUNCTION update_conversation_stats();

-- Function to update FAQ usage stats
CREATE OR REPLACE FUNCTION update_faq_stats()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.feedback = 'helpful' AND (OLD.feedback IS NULL OR OLD.feedback != 'helpful') THEN
        UPDATE public.chatbot_faqs
        SET helpful_count = helpful_count + 1, updated_at = NOW()
        WHERE id = (NEW.metadata->>'faq_id')::uuid;
    ELSIF NEW.feedback = 'not_helpful' AND (OLD.feedback IS NULL OR OLD.feedback != 'not_helpful') THEN
        UPDATE public.chatbot_faqs
        SET not_helpful_count = not_helpful_count + 1, updated_at = NOW()
        WHERE id = (NEW.metadata->>'faq_id')::uuid;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger for FAQ feedback tracking
DROP TRIGGER IF EXISTS trigger_update_faq_stats ON public.chatbot_messages;
CREATE TRIGGER trigger_update_faq_stats
    AFTER UPDATE OF feedback ON public.chatbot_messages
    FOR EACH ROW
    WHEN (NEW.metadata ? 'faq_id')
    EXECUTE FUNCTION update_faq_stats();

-- ================================================================================
-- 9. SEED DEFAULT FAQs (Optional - uncomment to use)
-- ================================================================================
/*
INSERT INTO public.chatbot_faqs (question, answer, keywords, category, priority, quick_actions) VALUES
('What is Flow?', 'Flow is an AI-powered EdTech platform that helps students find and apply to universities, manage their educational journey, and connect with counselors and institutions.', '["flow", "what is", "about", "platform"]', 'general', 100, '[{"id": "features", "label": "See Features", "action": "features"}]'),
('How do I create an account?', 'To create an account, click the "Sign Up" button on the homepage. You can register as a Student, Parent, Institution, or Counselor. Fill in your details and verify your email to get started.', '["account", "sign up", "register", "create"]', 'registration', 90, '[{"id": "register", "label": "Sign Up Now", "action": "navigate_register"}]'),
('Is Flow free to use?', 'Flow offers a free tier with basic features for students. Premium features and institutional subscriptions are available for advanced functionality.', '["free", "cost", "price", "pricing"]', 'pricing', 80, '[{"id": "pricing", "label": "View Pricing", "action": "pricing"}]'),
('How can I contact support?', 'You can reach our support team by emailing support@flowedtech.com or using the chat feature. Our team typically responds within 24 hours.', '["support", "help", "contact", "email"]', 'support', 70, '[{"id": "email", "label": "Email Support", "action": "email_support"}]')
ON CONFLICT DO NOTHING;
*/

-- ================================================================================
-- VERIFICATION
-- ================================================================================
-- Run these queries to verify the tables were created:
-- SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' AND table_name LIKE 'chatbot%';
-- ================================================================================
