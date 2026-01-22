-- Create Approval Workflow System Tables
-- This supports the multi-level admin approval system for critical actions

-- ============================================================================
-- 1. Core Approval Requests Table
-- ============================================================================
CREATE TABLE IF NOT EXISTS approval_requests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    request_number VARCHAR(20) UNIQUE NOT NULL,
    request_type VARCHAR(50) NOT NULL,

    -- Initiator information
    initiated_by UUID NOT NULL,
    initiated_by_role VARCHAR(30) NOT NULL,
    initiated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- Target resource
    target_resource_type VARCHAR(50) NOT NULL,
    target_resource_id UUID,
    target_resource_snapshot JSONB,

    -- Action details
    action_type VARCHAR(50) NOT NULL,
    action_payload JSONB NOT NULL,
    justification TEXT NOT NULL,

    -- Priority and timing
    priority VARCHAR(20) NOT NULL DEFAULT 'normal',
    expires_at TIMESTAMPTZ,

    -- Workflow state
    status VARCHAR(30) NOT NULL DEFAULT 'pending_review',
    current_approval_level INT NOT NULL DEFAULT 1,
    required_approval_level INT NOT NULL,
    approval_chain JSONB NOT NULL DEFAULT '[]',

    -- Regional scope for regional admins
    regional_scope VARCHAR(100),

    -- Attachments and metadata
    attachments JSONB DEFAULT '[]',
    metadata JSONB DEFAULT '{}',

    -- Execution tracking
    executed_at TIMESTAMPTZ,
    execution_result JSONB,

    -- Timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- Foreign key
    CONSTRAINT fk_approval_requests_initiated_by
        FOREIGN KEY (initiated_by)
        REFERENCES auth.users(id)
        ON DELETE CASCADE,

    -- Constraints
    CONSTRAINT valid_status CHECK (status IN (
        'draft', 'pending_review', 'under_review', 'awaiting_info',
        'escalated', 'approved', 'denied', 'withdrawn', 'expired', 'executed', 'failed'
    )),
    CONSTRAINT valid_priority CHECK (priority IN ('urgent', 'high', 'normal', 'low')),
    CONSTRAINT valid_request_type CHECK (request_type IN (
        'user_management', 'content_management', 'financial', 'system',
        'notifications', 'data_export', 'admin_management'
    )),
    CONSTRAINT valid_action_type CHECK (action_type IN (
        'delete_user_account', 'suspend_user_account', 'unsuspend_user_account',
        'grant_admin_role', 'revoke_admin_role', 'modify_admin_role',
        'publish_content', 'unpublish_content', 'delete_content', 'delete_program',
        'send_bulk_notification', 'send_platform_announcement',
        'process_large_refund', 'modify_fee_structure', 'adjust_commission',
        'export_sensitive_data', 'export_user_data', 'export_financial_data',
        'modify_system_settings', 'delete_institution', 'delete_institution_content'
    ))
);

-- ============================================================================
-- 2. Approval Actions Table (Review Records)
-- ============================================================================
CREATE TABLE IF NOT EXISTS approval_actions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    request_id UUID NOT NULL,
    reviewer_id UUID NOT NULL,
    reviewer_role VARCHAR(30) NOT NULL,
    reviewer_level INT NOT NULL,

    -- Action details
    action_type VARCHAR(30) NOT NULL,
    notes TEXT,

    -- Delegation
    delegated_to UUID,
    delegated_reason TEXT,

    -- Escalation
    escalated_to_level INT,
    escalation_reason TEXT,

    -- Additional info request
    info_requested TEXT,

    -- Tracking
    acted_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    ip_address INET,
    user_agent TEXT,

    -- MFA verification
    mfa_verified BOOLEAN DEFAULT FALSE,

    -- Foreign keys
    CONSTRAINT fk_approval_actions_request
        FOREIGN KEY (request_id)
        REFERENCES approval_requests(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_approval_actions_reviewer
        FOREIGN KEY (reviewer_id)
        REFERENCES auth.users(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_approval_actions_delegated_to
        FOREIGN KEY (delegated_to)
        REFERENCES auth.users(id)
        ON DELETE SET NULL,

    -- Constraints
    CONSTRAINT valid_action_type CHECK (action_type IN (
        'approve', 'deny', 'request_info', 'delegate', 'escalate',
        'respond_info', 'withdraw', 'comment'
    ))
);

-- ============================================================================
-- 3. Approval Comments Table
-- ============================================================================
CREATE TABLE IF NOT EXISTS approval_comments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    request_id UUID NOT NULL,
    author_id UUID NOT NULL,
    author_role VARCHAR(30) NOT NULL,

    -- Comment content
    content TEXT NOT NULL,
    is_internal BOOLEAN DEFAULT FALSE, -- Internal comments only visible to admins
    attachments JSONB DEFAULT '[]',

    -- Threading
    parent_comment_id UUID,

    -- Timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ,
    deleted_at TIMESTAMPTZ,

    -- Foreign keys
    CONSTRAINT fk_approval_comments_request
        FOREIGN KEY (request_id)
        REFERENCES approval_requests(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_approval_comments_author
        FOREIGN KEY (author_id)
        REFERENCES auth.users(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_approval_comments_parent
        FOREIGN KEY (parent_comment_id)
        REFERENCES approval_comments(id)
        ON DELETE CASCADE
);

-- ============================================================================
-- 4. Approval Workflow Configuration Table
-- ============================================================================
CREATE TABLE IF NOT EXISTS approval_config (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    request_type VARCHAR(50) NOT NULL,
    action_type VARCHAR(50) NOT NULL,
    target_resource_type VARCHAR(50),

    -- Approval requirements
    required_approval_level INT NOT NULL,
    can_skip_levels BOOLEAN DEFAULT FALSE,
    skip_level_conditions JSONB DEFAULT '{}',

    -- Role permissions
    allowed_initiator_roles JSONB NOT NULL,
    allowed_approver_roles JSONB NOT NULL,

    -- Defaults
    default_priority VARCHAR(20) DEFAULT 'normal',
    default_expiration_hours INT,

    -- Security
    requires_mfa BOOLEAN DEFAULT FALSE,

    -- Execution
    auto_execute BOOLEAN DEFAULT TRUE,

    -- Notifications
    notification_channels JSONB DEFAULT '["in_app", "email", "push"]',

    -- Status
    is_active BOOLEAN DEFAULT TRUE,
    description TEXT,

    -- Timestamps
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),

    -- Unique constraint
    UNIQUE(request_type, action_type, target_resource_type)
);

-- ============================================================================
-- 5. Approval Audit Log Table
-- ============================================================================
CREATE TABLE IF NOT EXISTS approval_audit_log (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    request_id UUID NOT NULL,
    actor_id UUID NOT NULL,
    actor_role VARCHAR(30) NOT NULL,

    -- Event details
    event_type VARCHAR(50) NOT NULL,
    event_description TEXT,

    -- State tracking
    previous_state JSONB,
    new_state JSONB,

    -- Context
    ip_address INET,
    user_agent TEXT,
    session_id VARCHAR(255),

    -- Timestamp
    timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- Foreign keys
    CONSTRAINT fk_approval_audit_log_request
        FOREIGN KEY (request_id)
        REFERENCES approval_requests(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_approval_audit_log_actor
        FOREIGN KEY (actor_id)
        REFERENCES auth.users(id)
        ON DELETE CASCADE
);

-- ============================================================================
-- 6. Approval Notifications Queue Table
-- ============================================================================
CREATE TABLE IF NOT EXISTS approval_notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    request_id UUID NOT NULL,
    recipient_id UUID NOT NULL,

    -- Notification details
    notification_type VARCHAR(50) NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,

    -- Channel tracking
    channels JSONB NOT NULL DEFAULT '["in_app"]',
    sent_channels JSONB DEFAULT '[]',

    -- Status
    is_read BOOLEAN DEFAULT FALSE,
    read_at TIMESTAMPTZ,

    -- Scheduling
    scheduled_for TIMESTAMPTZ DEFAULT NOW(),
    sent_at TIMESTAMPTZ,

    -- Timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- Foreign keys
    CONSTRAINT fk_approval_notifications_request
        FOREIGN KEY (request_id)
        REFERENCES approval_requests(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_approval_notifications_recipient
        FOREIGN KEY (recipient_id)
        REFERENCES auth.users(id)
        ON DELETE CASCADE
);

-- ============================================================================
-- 7. Indexes for Performance
-- ============================================================================

-- Approval requests indexes
CREATE INDEX IF NOT EXISTS idx_approval_requests_status ON approval_requests(status);
CREATE INDEX IF NOT EXISTS idx_approval_requests_initiated_by ON approval_requests(initiated_by);
CREATE INDEX IF NOT EXISTS idx_approval_requests_priority ON approval_requests(priority);
CREATE INDEX IF NOT EXISTS idx_approval_requests_expires_at ON approval_requests(expires_at);
CREATE INDEX IF NOT EXISTS idx_approval_requests_request_type ON approval_requests(request_type);
CREATE INDEX IF NOT EXISTS idx_approval_requests_action_type ON approval_requests(action_type);
CREATE INDEX IF NOT EXISTS idx_approval_requests_current_level ON approval_requests(current_approval_level);
CREATE INDEX IF NOT EXISTS idx_approval_requests_regional_scope ON approval_requests(regional_scope);
CREATE INDEX IF NOT EXISTS idx_approval_requests_created_at ON approval_requests(created_at DESC);

-- Approval actions indexes
CREATE INDEX IF NOT EXISTS idx_approval_actions_request ON approval_actions(request_id);
CREATE INDEX IF NOT EXISTS idx_approval_actions_reviewer ON approval_actions(reviewer_id);
CREATE INDEX IF NOT EXISTS idx_approval_actions_acted_at ON approval_actions(acted_at DESC);

-- Approval comments indexes
CREATE INDEX IF NOT EXISTS idx_approval_comments_request ON approval_comments(request_id);
CREATE INDEX IF NOT EXISTS idx_approval_comments_author ON approval_comments(author_id);
CREATE INDEX IF NOT EXISTS idx_approval_comments_parent ON approval_comments(parent_comment_id);

-- Approval config indexes
CREATE INDEX IF NOT EXISTS idx_approval_config_request_type ON approval_config(request_type);
CREATE INDEX IF NOT EXISTS idx_approval_config_action_type ON approval_config(action_type);
CREATE INDEX IF NOT EXISTS idx_approval_config_active ON approval_config(is_active);

-- Audit log indexes
CREATE INDEX IF NOT EXISTS idx_approval_audit_log_request ON approval_audit_log(request_id);
CREATE INDEX IF NOT EXISTS idx_approval_audit_log_actor ON approval_audit_log(actor_id);
CREATE INDEX IF NOT EXISTS idx_approval_audit_log_timestamp ON approval_audit_log(timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_approval_audit_log_event_type ON approval_audit_log(event_type);

-- Notifications indexes
CREATE INDEX IF NOT EXISTS idx_approval_notifications_request ON approval_notifications(request_id);
CREATE INDEX IF NOT EXISTS idx_approval_notifications_recipient ON approval_notifications(recipient_id);
CREATE INDEX IF NOT EXISTS idx_approval_notifications_is_read ON approval_notifications(is_read);
CREATE INDEX IF NOT EXISTS idx_approval_notifications_scheduled ON approval_notifications(scheduled_for);

-- ============================================================================
-- 8. Row Level Security (RLS)
-- ============================================================================
ALTER TABLE approval_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE approval_actions ENABLE ROW LEVEL SECURITY;
ALTER TABLE approval_comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE approval_config ENABLE ROW LEVEL SECURITY;
ALTER TABLE approval_audit_log ENABLE ROW LEVEL SECURITY;
ALTER TABLE approval_notifications ENABLE ROW LEVEL SECURITY;

-- Approval Requests Policies
CREATE POLICY "Admins can view approval requests"
    ON approval_requests FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM auth.users
            WHERE auth.users.id = auth.uid()
            AND auth.users.role IN ('super_admin', 'regional_admin', 'content_admin', 'support_admin', 'finance_admin', 'analytics_admin')
        )
    );

CREATE POLICY "Admins can create approval requests"
    ON approval_requests FOR INSERT
    WITH CHECK (
        auth.uid() = initiated_by
        AND EXISTS (
            SELECT 1 FROM auth.users
            WHERE auth.users.id = auth.uid()
            AND auth.users.role IN ('super_admin', 'regional_admin', 'content_admin', 'support_admin', 'finance_admin', 'analytics_admin')
        )
    );

CREATE POLICY "Admins can update approval requests"
    ON approval_requests FOR UPDATE
    USING (
        EXISTS (
            SELECT 1 FROM auth.users
            WHERE auth.users.id = auth.uid()
            AND auth.users.role IN ('super_admin', 'regional_admin', 'content_admin', 'support_admin', 'finance_admin', 'analytics_admin')
        )
    );

-- Approval Actions Policies
CREATE POLICY "Admins can view approval actions"
    ON approval_actions FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM auth.users
            WHERE auth.users.id = auth.uid()
            AND auth.users.role IN ('super_admin', 'regional_admin', 'content_admin', 'support_admin', 'finance_admin', 'analytics_admin')
        )
    );

CREATE POLICY "Authorized admins can create approval actions"
    ON approval_actions FOR INSERT
    WITH CHECK (
        auth.uid() = reviewer_id
        AND EXISTS (
            SELECT 1 FROM auth.users
            WHERE auth.users.id = auth.uid()
            AND auth.users.role IN ('super_admin', 'regional_admin')
        )
    );

-- Approval Comments Policies
CREATE POLICY "Admins can view approval comments"
    ON approval_comments FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM auth.users
            WHERE auth.users.id = auth.uid()
            AND auth.users.role IN ('super_admin', 'regional_admin', 'content_admin', 'support_admin', 'finance_admin', 'analytics_admin')
        )
    );

CREATE POLICY "Admins can create approval comments"
    ON approval_comments FOR INSERT
    WITH CHECK (
        auth.uid() = author_id
        AND EXISTS (
            SELECT 1 FROM auth.users
            WHERE auth.users.id = auth.uid()
            AND auth.users.role IN ('super_admin', 'regional_admin', 'content_admin', 'support_admin', 'finance_admin', 'analytics_admin')
        )
    );

CREATE POLICY "Authors can update their comments"
    ON approval_comments FOR UPDATE
    USING (auth.uid() = author_id);

-- Approval Config Policies (Super Admin only)
CREATE POLICY "Super admins can manage approval config"
    ON approval_config FOR ALL
    USING (
        EXISTS (
            SELECT 1 FROM auth.users
            WHERE auth.users.id = auth.uid()
            AND auth.users.role = 'super_admin'
        )
    );

CREATE POLICY "Admins can view approval config"
    ON approval_config FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM auth.users
            WHERE auth.users.id = auth.uid()
            AND auth.users.role IN ('super_admin', 'regional_admin', 'content_admin', 'support_admin', 'finance_admin', 'analytics_admin')
        )
    );

-- Audit Log Policies
CREATE POLICY "Admins can view audit logs"
    ON approval_audit_log FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM auth.users
            WHERE auth.users.id = auth.uid()
            AND auth.users.role IN ('super_admin', 'regional_admin')
        )
    );

CREATE POLICY "System can insert audit logs"
    ON approval_audit_log FOR INSERT
    WITH CHECK (true);

-- Notifications Policies
CREATE POLICY "Recipients can view their notifications"
    ON approval_notifications FOR SELECT
    USING (auth.uid() = recipient_id);

CREATE POLICY "Recipients can update their notifications"
    ON approval_notifications FOR UPDATE
    USING (auth.uid() = recipient_id);

-- ============================================================================
-- 9. Functions and Triggers
-- ============================================================================

-- Function to generate request number
CREATE OR REPLACE FUNCTION generate_approval_request_number()
RETURNS TRIGGER AS $$
DECLARE
    year_month TEXT;
    sequence_num INT;
    new_request_number TEXT;
BEGIN
    year_month := TO_CHAR(NOW(), 'YYMM');

    SELECT COALESCE(MAX(CAST(SUBSTRING(request_number FROM 8) AS INT)), 0) + 1
    INTO sequence_num
    FROM approval_requests
    WHERE request_number LIKE 'APR' || year_month || '%';

    new_request_number := 'APR' || year_month || LPAD(sequence_num::TEXT, 6, '0');
    NEW.request_number := new_request_number;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_generate_approval_request_number
    BEFORE INSERT ON approval_requests
    FOR EACH ROW
    WHEN (NEW.request_number IS NULL)
    EXECUTE FUNCTION generate_approval_request_number();

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_approval_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_approval_requests_updated_at
    BEFORE UPDATE ON approval_requests
    FOR EACH ROW
    EXECUTE FUNCTION update_approval_updated_at();

CREATE TRIGGER trigger_update_approval_config_updated_at
    BEFORE UPDATE ON approval_config
    FOR EACH ROW
    EXECUTE FUNCTION update_approval_updated_at();

-- Function to auto-create audit log entry
CREATE OR REPLACE FUNCTION create_approval_audit_entry()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO approval_audit_log (
            request_id, actor_id, actor_role, event_type,
            event_description, new_state
        )
        VALUES (
            NEW.id, NEW.initiated_by, NEW.initiated_by_role,
            'request_created', 'Approval request created',
            jsonb_build_object('status', NEW.status, 'priority', NEW.priority)
        );
    ELSIF TG_OP = 'UPDATE' AND OLD.status != NEW.status THEN
        INSERT INTO approval_audit_log (
            request_id, actor_id, actor_role, event_type,
            event_description, previous_state, new_state
        )
        VALUES (
            NEW.id, NEW.initiated_by, NEW.initiated_by_role,
            'status_changed',
            'Status changed from ' || OLD.status || ' to ' || NEW.status,
            jsonb_build_object('status', OLD.status),
            jsonb_build_object('status', NEW.status)
        );
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_create_approval_audit_entry
    AFTER INSERT OR UPDATE ON approval_requests
    FOR EACH ROW
    EXECUTE FUNCTION create_approval_audit_entry();

-- Function to check for expired requests
CREATE OR REPLACE FUNCTION expire_old_approval_requests()
RETURNS void AS $$
BEGIN
    UPDATE approval_requests
    SET status = 'expired',
        updated_at = NOW()
    WHERE status IN ('pending_review', 'under_review', 'awaiting_info')
    AND expires_at IS NOT NULL
    AND expires_at < NOW();
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- 10. Comments
-- ============================================================================
COMMENT ON TABLE approval_requests IS 'Core table for admin approval workflow requests';
COMMENT ON TABLE approval_actions IS 'Records of review actions taken on approval requests';
COMMENT ON TABLE approval_comments IS 'Discussion thread for approval requests';
COMMENT ON TABLE approval_config IS 'Configuration for different approval workflow types';
COMMENT ON TABLE approval_audit_log IS 'Complete audit trail for all approval activities';
COMMENT ON TABLE approval_notifications IS 'Notifications related to approval workflows';

COMMENT ON COLUMN approval_requests.request_number IS 'Auto-generated unique request identifier (APRYYMMxxxxxx)';
COMMENT ON COLUMN approval_requests.current_approval_level IS '1=Specialized, 2=Regional, 3=Super Admin';
COMMENT ON COLUMN approval_requests.required_approval_level IS 'Final approval level needed for this request';
COMMENT ON COLUMN approval_requests.approval_chain IS 'JSON array of approval steps taken';
COMMENT ON COLUMN approval_requests.target_resource_snapshot IS 'Snapshot of target resource at request time';

COMMENT ON COLUMN approval_config.can_skip_levels IS 'Allow level skipping when conditions are met';
COMMENT ON COLUMN approval_config.skip_level_conditions IS 'JSON conditions for when level skipping is allowed';
COMMENT ON COLUMN approval_config.requires_mfa IS 'Whether MFA verification is required for approving';
