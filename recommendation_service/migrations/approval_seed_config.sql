-- Seed data for Approval Workflow Configuration
-- This populates the default approval configurations for all action types

-- ============================================================================
-- User Management Approvals
-- ============================================================================

INSERT INTO approval_config (
    request_type, action_type, target_resource_type,
    required_approval_level, can_skip_levels, skip_level_conditions,
    allowed_initiator_roles, allowed_approver_roles,
    default_priority, default_expiration_hours,
    requires_mfa, auto_execute, notification_channels,
    is_active, description
) VALUES
-- Delete User Account: Highest security - requires Super Admin
(
    'user_management', 'delete_user_account', 'user',
    3, FALSE, '{}',
    '["support_admin", "regional_admin", "super_admin"]'::jsonb,
    '["regional_admin", "super_admin"]'::jsonb,
    'normal', 168, -- 7 days expiration
    TRUE, TRUE, '["in_app", "email", "push"]'::jsonb,
    TRUE, 'Permanently delete a user account and all associated data'
),
-- Suspend User Account: Regional Admin can approve
(
    'user_management', 'suspend_user_account', 'user',
    2, TRUE, '{"allow_skip_for": ["minor_violation", "temporary_suspension"]}'::jsonb,
    '["support_admin", "regional_admin", "super_admin"]'::jsonb,
    '["regional_admin", "super_admin"]'::jsonb,
    'high', 72, -- 3 days expiration
    FALSE, TRUE, '["in_app", "email", "push"]'::jsonb,
    TRUE, 'Temporarily suspend a user account'
),
-- Unsuspend User Account: Regional Admin can approve
(
    'user_management', 'unsuspend_user_account', 'user',
    2, TRUE, '{}'::jsonb,
    '["support_admin", "regional_admin", "super_admin"]'::jsonb,
    '["regional_admin", "super_admin"]'::jsonb,
    'normal', 72,
    FALSE, TRUE, '["in_app", "email"]'::jsonb,
    TRUE, 'Restore a suspended user account'
),

-- ============================================================================
-- Admin Management Approvals (Super Admin only)
-- ============================================================================
(
    'admin_management', 'grant_admin_role', 'user',
    3, FALSE, '{}',
    '["regional_admin", "super_admin"]'::jsonb,
    '["super_admin"]'::jsonb,
    'normal', 168,
    TRUE, TRUE, '["in_app", "email", "push"]'::jsonb,
    TRUE, 'Grant administrative privileges to a user'
),
(
    'admin_management', 'revoke_admin_role', 'user',
    3, FALSE, '{}',
    '["regional_admin", "super_admin"]'::jsonb,
    '["super_admin"]'::jsonb,
    'high', 72,
    TRUE, TRUE, '["in_app", "email", "push"]'::jsonb,
    TRUE, 'Revoke administrative privileges from a user'
),
(
    'admin_management', 'modify_admin_role', 'user',
    3, FALSE, '{}',
    '["regional_admin", "super_admin"]'::jsonb,
    '["super_admin"]'::jsonb,
    'normal', 168,
    TRUE, TRUE, '["in_app", "email"]'::jsonb,
    TRUE, 'Modify administrative role or permissions'
),

-- ============================================================================
-- Content Management Approvals
-- ============================================================================
(
    'content_management', 'publish_content', 'content',
    2, TRUE, '{"allow_skip_for": ["minor_update", "typo_fix"]}'::jsonb,
    '["content_admin", "regional_admin", "super_admin"]'::jsonb,
    '["regional_admin", "super_admin"]'::jsonb,
    'normal', 120, -- 5 days
    FALSE, TRUE, '["in_app", "email"]'::jsonb,
    TRUE, 'Publish new content to the platform'
),
(
    'content_management', 'unpublish_content', 'content',
    2, TRUE, '{"allow_skip_for": ["content_violation", "legal_issue"]}'::jsonb,
    '["content_admin", "regional_admin", "super_admin"]'::jsonb,
    '["regional_admin", "super_admin"]'::jsonb,
    'normal', 72,
    FALSE, TRUE, '["in_app", "email"]'::jsonb,
    TRUE, 'Remove published content from visibility'
),
(
    'content_management', 'delete_content', 'content',
    3, FALSE, '{}',
    '["content_admin", "regional_admin", "super_admin"]'::jsonb,
    '["regional_admin", "super_admin"]'::jsonb,
    'normal', 168,
    TRUE, TRUE, '["in_app", "email", "push"]'::jsonb,
    TRUE, 'Permanently delete content'
),
(
    'content_management', 'delete_program', 'program',
    3, FALSE, '{}',
    '["content_admin", "regional_admin", "super_admin"]'::jsonb,
    '["super_admin"]'::jsonb,
    'high', 168,
    TRUE, TRUE, '["in_app", "email", "push"]'::jsonb,
    TRUE, 'Delete an educational program and all associated content'
),
(
    'content_management', 'delete_institution_content', 'institution',
    3, FALSE, '{}',
    '["content_admin", "regional_admin", "super_admin"]'::jsonb,
    '["regional_admin", "super_admin"]'::jsonb,
    'normal', 168,
    TRUE, TRUE, '["in_app", "email", "push"]'::jsonb,
    TRUE, 'Delete all content for a specific institution'
),

-- ============================================================================
-- Notification Approvals
-- ============================================================================
(
    'notifications', 'send_bulk_notification', 'notification',
    2, TRUE, '{"allow_skip_for": ["under_1000_recipients", "emergency"]}'::jsonb,
    '["content_admin", "support_admin", "regional_admin", "super_admin"]'::jsonb,
    '["regional_admin", "super_admin"]'::jsonb,
    'normal', 48, -- 2 days
    FALSE, TRUE, '["in_app", "email"]'::jsonb,
    TRUE, 'Send bulk notifications to multiple users'
),
(
    'notifications', 'send_platform_announcement', 'notification',
    3, FALSE, '{}',
    '["content_admin", "super_admin"]'::jsonb,
    '["super_admin"]'::jsonb,
    'high', 24, -- 1 day
    TRUE, TRUE, '["in_app", "email", "push"]'::jsonb,
    TRUE, 'Send platform-wide announcement to all users'
),

-- ============================================================================
-- Financial Approvals
-- ============================================================================
(
    'financial', 'process_large_refund', 'transaction',
    3, FALSE, '{}',
    '["finance_admin", "regional_admin", "super_admin"]'::jsonb,
    '["super_admin"]'::jsonb,
    'high', 72,
    TRUE, TRUE, '["in_app", "email", "push"]'::jsonb,
    TRUE, 'Process refund exceeding threshold amount'
),
(
    'financial', 'modify_fee_structure', 'fee_config',
    3, FALSE, '{}',
    '["finance_admin", "super_admin"]'::jsonb,
    '["super_admin"]'::jsonb,
    'normal', 336, -- 14 days
    TRUE, TRUE, '["in_app", "email", "push"]'::jsonb,
    TRUE, 'Modify platform fee structure or pricing'
),
(
    'financial', 'adjust_commission', 'commission',
    3, FALSE, '{}',
    '["finance_admin", "regional_admin", "super_admin"]'::jsonb,
    '["super_admin"]'::jsonb,
    'normal', 168,
    TRUE, TRUE, '["in_app", "email"]'::jsonb,
    TRUE, 'Adjust commission rates for institutions or partners'
),

-- ============================================================================
-- Data Export Approvals
-- ============================================================================
(
    'data_export', 'export_sensitive_data', 'data',
    3, FALSE, '{}',
    '["analytics_admin", "regional_admin", "super_admin"]'::jsonb,
    '["super_admin"]'::jsonb,
    'normal', 168,
    TRUE, FALSE, '["in_app", "email", "push"]'::jsonb,
    TRUE, 'Export sensitive platform data (PII, financial records)'
),
(
    'data_export', 'export_user_data', 'data',
    2, TRUE, '{"allow_skip_for": ["gdpr_request", "legal_requirement"]}'::jsonb,
    '["analytics_admin", "support_admin", "regional_admin", "super_admin"]'::jsonb,
    '["regional_admin", "super_admin"]'::jsonb,
    'high', 72,
    FALSE, FALSE, '["in_app", "email"]'::jsonb,
    TRUE, 'Export user data for compliance or support'
),
(
    'data_export', 'export_financial_data', 'data',
    3, FALSE, '{}',
    '["finance_admin", "analytics_admin", "super_admin"]'::jsonb,
    '["super_admin"]'::jsonb,
    'normal', 168,
    TRUE, FALSE, '["in_app", "email", "push"]'::jsonb,
    TRUE, 'Export financial reports and transaction data'
),

-- ============================================================================
-- System Management Approvals (Super Admin only)
-- ============================================================================
(
    'system', 'modify_system_settings', 'system',
    3, FALSE, '{}',
    '["super_admin"]'::jsonb,
    '["super_admin"]'::jsonb,
    'high', 24,
    TRUE, TRUE, '["in_app", "email", "push"]'::jsonb,
    TRUE, 'Modify critical system configuration settings'
),
(
    'system', 'delete_institution', 'institution',
    3, FALSE, '{}',
    '["regional_admin", "super_admin"]'::jsonb,
    '["super_admin"]'::jsonb,
    'normal', 336, -- 14 days
    TRUE, TRUE, '["in_app", "email", "push"]'::jsonb,
    TRUE, 'Permanently delete an institution and all associated data'
);

-- ============================================================================
-- Verification Query
-- ============================================================================
-- Run this to verify the seed data was inserted correctly:
-- SELECT request_type, action_type, required_approval_level, requires_mfa FROM approval_config ORDER BY request_type, action_type;
