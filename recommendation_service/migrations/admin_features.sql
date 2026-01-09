-- ADMIN FEATURES MIGRATION
-- Run this in Supabase SQL Editor to create tables for support tickets, transactions, and communications

-- =============================================================================
-- 1. SUPPORT TICKETS TABLE
-- =============================================================================
CREATE TABLE IF NOT EXISTS public.support_tickets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.users(id) ON DELETE SET NULL,
    user_name TEXT,
    user_email TEXT,
    subject TEXT NOT NULL,
    description TEXT,
    category TEXT DEFAULT 'general',
    priority TEXT DEFAULT 'medium',
    status TEXT DEFAULT 'open',
    assigned_to UUID REFERENCES public.users(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    resolved_at TIMESTAMPTZ
);

-- Indexes for support tickets
CREATE INDEX IF NOT EXISTS idx_support_tickets_status ON public.support_tickets(status);
CREATE INDEX IF NOT EXISTS idx_support_tickets_user_id ON public.support_tickets(user_id);
CREATE INDEX IF NOT EXISTS idx_support_tickets_priority ON public.support_tickets(priority);
CREATE INDEX IF NOT EXISTS idx_support_tickets_assigned_to ON public.support_tickets(assigned_to);
CREATE INDEX IF NOT EXISTS idx_support_tickets_created_at ON public.support_tickets(created_at DESC);

-- RLS for support tickets
ALTER TABLE public.support_tickets ENABLE ROW LEVEL SECURITY;

-- Users can view their own tickets
CREATE POLICY "Users can view own tickets" ON public.support_tickets
    FOR SELECT USING (user_id = auth.uid());

-- Users can create tickets
CREATE POLICY "Users can create tickets" ON public.support_tickets
    FOR INSERT WITH CHECK (user_id = auth.uid() OR user_id IS NULL);

-- Admins can do everything
CREATE POLICY "Admins full access to tickets" ON public.support_tickets
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.users
            WHERE id = auth.uid()
            AND active_role IN ('superadmin', 'supportadmin', 'admin')
        )
    );

-- Grant permissions
GRANT SELECT, INSERT, UPDATE, DELETE ON public.support_tickets TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.support_tickets TO service_role;


-- =============================================================================
-- 2. TRANSACTIONS TABLE
-- =============================================================================
CREATE TABLE IF NOT EXISTS public.transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.users(id) ON DELETE SET NULL,
    user_name TEXT,
    type TEXT NOT NULL,  -- payment, refund, subscription, payout
    amount DECIMAL(10,2) NOT NULL,
    currency TEXT DEFAULT 'USD',
    status TEXT DEFAULT 'completed',  -- pending, completed, failed, refunded
    description TEXT,
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for transactions
CREATE INDEX IF NOT EXISTS idx_transactions_user_id ON public.transactions(user_id);
CREATE INDEX IF NOT EXISTS idx_transactions_status ON public.transactions(status);
CREATE INDEX IF NOT EXISTS idx_transactions_type ON public.transactions(type);
CREATE INDEX IF NOT EXISTS idx_transactions_created_at ON public.transactions(created_at DESC);

-- RLS for transactions
ALTER TABLE public.transactions ENABLE ROW LEVEL SECURITY;

-- Users can view their own transactions
CREATE POLICY "Users can view own transactions" ON public.transactions
    FOR SELECT USING (user_id = auth.uid());

-- Admins can view all transactions
CREATE POLICY "Admins full access to transactions" ON public.transactions
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.users
            WHERE id = auth.uid()
            AND active_role IN ('superadmin', 'financeadmin', 'admin')
        )
    );

-- Grant permissions
GRANT SELECT ON public.transactions TO authenticated;
GRANT SELECT, INSERT, UPDATE ON public.transactions TO service_role;


-- =============================================================================
-- 3. COMMUNICATION CAMPAIGNS TABLE
-- =============================================================================
CREATE TABLE IF NOT EXISTS public.communication_campaigns (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    type TEXT NOT NULL,  -- email, notification, announcement
    status TEXT DEFAULT 'draft',  -- draft, scheduled, sent, cancelled
    target_audience JSONB DEFAULT '{}',
    content JSONB DEFAULT '{}',
    scheduled_at TIMESTAMPTZ,
    sent_at TIMESTAMPTZ,
    stats JSONB DEFAULT '{"sent": 0, "delivered": 0, "opened": 0, "clicked": 0}',
    created_by UUID REFERENCES public.users(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for communication campaigns
CREATE INDEX IF NOT EXISTS idx_communication_campaigns_status ON public.communication_campaigns(status);
CREATE INDEX IF NOT EXISTS idx_communication_campaigns_type ON public.communication_campaigns(type);
CREATE INDEX IF NOT EXISTS idx_communication_campaigns_created_at ON public.communication_campaigns(created_at DESC);

-- RLS for communication campaigns
ALTER TABLE public.communication_campaigns ENABLE ROW LEVEL SECURITY;

-- Only admins can access campaigns
CREATE POLICY "Admins full access to campaigns" ON public.communication_campaigns
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.users
            WHERE id = auth.uid()
            AND active_role IN ('superadmin', 'contentadmin', 'admin')
        )
    );

-- Grant permissions
GRANT SELECT, INSERT, UPDATE, DELETE ON public.communication_campaigns TO service_role;


-- =============================================================================
-- 4. ACTIVITY LOG TABLE (if not exists)
-- =============================================================================
CREATE TABLE IF NOT EXISTS public.activity_log (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    timestamp TIMESTAMPTZ DEFAULT NOW(),
    user_id UUID REFERENCES public.users(id) ON DELETE SET NULL,
    user_name TEXT,
    user_email TEXT,
    user_role TEXT,
    action_type TEXT NOT NULL,
    description TEXT NOT NULL,
    metadata JSONB DEFAULT '{}',
    ip_address TEXT,
    user_agent TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for activity log
CREATE INDEX IF NOT EXISTS idx_activity_log_user_id ON public.activity_log(user_id);
CREATE INDEX IF NOT EXISTS idx_activity_log_action_type ON public.activity_log(action_type);
CREATE INDEX IF NOT EXISTS idx_activity_log_timestamp ON public.activity_log(timestamp DESC);

-- RLS for activity log
ALTER TABLE public.activity_log ENABLE ROW LEVEL SECURITY;

-- Users can view their own activity
CREATE POLICY "Users can view own activity" ON public.activity_log
    FOR SELECT USING (user_id = auth.uid());

-- Admins can view all activity
CREATE POLICY "Admins full access to activity log" ON public.activity_log
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.users
            WHERE id = auth.uid()
            AND active_role IN ('superadmin', 'analyticsadmin', 'admin')
        )
    );

-- Service role can insert activity logs
CREATE POLICY "Service role can insert activity" ON public.activity_log
    FOR INSERT WITH CHECK (true);

-- Grant permissions
GRANT SELECT ON public.activity_log TO authenticated;
GRANT SELECT, INSERT ON public.activity_log TO service_role;


-- =============================================================================
-- 5. SAMPLE DATA FOR TESTING (Optional)
-- =============================================================================

-- Sample support tickets
INSERT INTO public.support_tickets (subject, description, category, priority, status, created_at)
VALUES
    ('Cannot access my account', 'I am having trouble logging in to my account', 'technical', 'high', 'open', NOW() - INTERVAL '2 days'),
    ('Question about course enrollment', 'How do I enroll in multiple courses?', 'general', 'medium', 'open', NOW() - INTERVAL '1 day'),
    ('Payment not processed', 'My payment was charged but enrollment failed', 'billing', 'urgent', 'in_progress', NOW() - INTERVAL '3 hours'),
    ('Feature request: Dark mode', 'Would love to have a dark mode option', 'feature_request', 'low', 'open', NOW() - INTERVAL '5 days'),
    ('Certificate not received', 'Completed the course but no certificate', 'technical', 'medium', 'resolved', NOW() - INTERVAL '1 week')
ON CONFLICT DO NOTHING;

-- Sample transactions
INSERT INTO public.transactions (type, amount, currency, status, description, created_at)
VALUES
    ('payment', 99.99, 'USD', 'completed', 'Course enrollment: Introduction to AI', NOW() - INTERVAL '1 day'),
    ('payment', 149.99, 'USD', 'completed', 'Course enrollment: Advanced Machine Learning', NOW() - INTERVAL '3 days'),
    ('subscription', 29.99, 'USD', 'completed', 'Monthly Premium subscription', NOW() - INTERVAL '5 days'),
    ('refund', 99.99, 'USD', 'completed', 'Refund for course cancellation', NOW() - INTERVAL '2 days'),
    ('payment', 199.99, 'USD', 'completed', 'Annual Premium subscription', NOW() - INTERVAL '1 week')
ON CONFLICT DO NOTHING;

-- Sample communication campaigns
INSERT INTO public.communication_campaigns (name, type, status, target_audience, content, created_at)
VALUES
    ('Welcome New Users', 'email', 'sent', '{"roles": ["student"]}', '{"subject": "Welcome to Flow!", "body": "We are excited to have you..."}', NOW() - INTERVAL '2 weeks'),
    ('Course Promotion', 'notification', 'scheduled', '{"roles": ["student", "parent"]}', '{"title": "50% off AI courses", "message": "Limited time offer!"}', NOW() + INTERVAL '1 day'),
    ('System Maintenance', 'announcement', 'draft', '{"roles": ["all"]}', '{"title": "Scheduled maintenance", "message": "System will be down for 2 hours..."}', NOW())
ON CONFLICT DO NOTHING;
