"""
Approval Workflow Data Models
Pydantic schemas for multi-level admin approval system
"""
from typing import Optional, List, Dict, Any
from pydantic import BaseModel, Field
from datetime import datetime
from enum import Enum


# ============================================================================
# Enumerations
# ============================================================================

class ApprovalStatus(str, Enum):
    """Approval request status enumeration"""
    DRAFT = "draft"
    PENDING_REVIEW = "pending_review"
    UNDER_REVIEW = "under_review"
    AWAITING_INFO = "awaiting_info"
    ESCALATED = "escalated"
    APPROVED = "approved"
    DENIED = "denied"
    WITHDRAWN = "withdrawn"
    EXPIRED = "expired"
    EXECUTED = "executed"
    FAILED = "failed"


class ApprovalPriority(str, Enum):
    """Approval request priority levels"""
    LOW = "low"
    NORMAL = "normal"
    HIGH = "high"
    URGENT = "urgent"


class ApprovalRequestType(str, Enum):
    """Types of approval requests"""
    USER_MANAGEMENT = "user_management"
    CONTENT_MANAGEMENT = "content_management"
    FINANCIAL = "financial"
    SYSTEM = "system"
    NOTIFICATIONS = "notifications"
    DATA_EXPORT = "data_export"
    ADMIN_MANAGEMENT = "admin_management"


class ApprovalActionType(str, Enum):
    """Specific actions that require approval"""
    # User Management
    DELETE_USER_ACCOUNT = "delete_user_account"
    SUSPEND_USER_ACCOUNT = "suspend_user_account"
    UNSUSPEND_USER_ACCOUNT = "unsuspend_user_account"

    # Admin Management
    GRANT_ADMIN_ROLE = "grant_admin_role"
    REVOKE_ADMIN_ROLE = "revoke_admin_role"
    MODIFY_ADMIN_ROLE = "modify_admin_role"

    # Content Management
    PUBLISH_CONTENT = "publish_content"
    UNPUBLISH_CONTENT = "unpublish_content"
    DELETE_CONTENT = "delete_content"
    DELETE_PROGRAM = "delete_program"
    DELETE_INSTITUTION_CONTENT = "delete_institution_content"

    # Notifications
    SEND_BULK_NOTIFICATION = "send_bulk_notification"
    SEND_PLATFORM_ANNOUNCEMENT = "send_platform_announcement"

    # Financial
    PROCESS_LARGE_REFUND = "process_large_refund"
    MODIFY_FEE_STRUCTURE = "modify_fee_structure"
    ADJUST_COMMISSION = "adjust_commission"

    # Data Export
    EXPORT_SENSITIVE_DATA = "export_sensitive_data"
    EXPORT_USER_DATA = "export_user_data"
    EXPORT_FINANCIAL_DATA = "export_financial_data"

    # System
    MODIFY_SYSTEM_SETTINGS = "modify_system_settings"
    DELETE_INSTITUTION = "delete_institution"


class ReviewActionType(str, Enum):
    """Types of review actions on approval requests"""
    APPROVE = "approve"
    DENY = "deny"
    REQUEST_INFO = "request_info"
    DELEGATE = "delegate"
    ESCALATE = "escalate"
    RESPOND_INFO = "respond_info"
    WITHDRAW = "withdraw"
    COMMENT = "comment"


class ApprovalLevel(int, Enum):
    """Approval authority levels"""
    SPECIALIZED = 1  # Content, Support, Finance, Analytics admins
    REGIONAL = 2     # Regional Admin
    SUPER = 3        # Super Admin


# ============================================================================
# Request Models - Creating/Updating Approvals
# ============================================================================

class ApprovalRequestCreate(BaseModel):
    """Request model for creating an approval request"""
    request_type: ApprovalRequestType
    action_type: ApprovalActionType

    # Target resource
    target_resource_type: str = Field(..., min_length=1, max_length=50)
    target_resource_id: Optional[str] = None
    target_resource_snapshot: Optional[Dict[str, Any]] = None

    # Action details
    action_payload: Dict[str, Any] = Field(default_factory=dict)
    justification: str = Field(..., min_length=10, max_length=2000)

    # Priority
    priority: ApprovalPriority = ApprovalPriority.NORMAL

    # Regional scope (for regional admins)
    regional_scope: Optional[str] = None

    # Attachments
    attachments: List[Dict[str, str]] = Field(default_factory=list)

    # Additional metadata
    metadata: Optional[Dict[str, Any]] = None


class ApprovalRequestUpdate(BaseModel):
    """Request model for updating an approval request (draft/awaiting_info only)"""
    justification: Optional[str] = Field(None, min_length=10, max_length=2000)
    action_payload: Optional[Dict[str, Any]] = None
    priority: Optional[ApprovalPriority] = None
    attachments: Optional[List[Dict[str, str]]] = None
    metadata: Optional[Dict[str, Any]] = None


# ============================================================================
# Request Models - Review Actions
# ============================================================================

class ApprovalReviewAction(BaseModel):
    """Base model for approval review actions"""
    notes: Optional[str] = Field(None, max_length=2000)
    mfa_verified: bool = False


class ApprovalApproveRequest(ApprovalReviewAction):
    """Request model for approving a request"""
    pass


class ApprovalDenyRequest(ApprovalReviewAction):
    """Request model for denying a request"""
    reason: str = Field(..., min_length=10, max_length=2000)


class ApprovalRequestInfoRequest(BaseModel):
    """Request model for requesting additional information"""
    info_requested: str = Field(..., min_length=10, max_length=2000)


class ApprovalRespondInfoRequest(BaseModel):
    """Request model for responding to information request"""
    response: str = Field(..., min_length=10, max_length=2000)
    attachments: List[Dict[str, str]] = Field(default_factory=list)


class ApprovalDelegateRequest(BaseModel):
    """Request model for delegating a request"""
    delegate_to: str  # User ID
    reason: str = Field(..., min_length=5, max_length=500)


class ApprovalEscalateRequest(BaseModel):
    """Request model for escalating a request"""
    reason: str = Field(..., min_length=10, max_length=1000)


# ============================================================================
# Request Models - Comments
# ============================================================================

class ApprovalCommentCreate(BaseModel):
    """Request model for creating a comment"""
    content: str = Field(..., min_length=1, max_length=5000)
    is_internal: bool = False
    attachments: List[Dict[str, str]] = Field(default_factory=list)
    parent_comment_id: Optional[str] = None


class ApprovalCommentUpdate(BaseModel):
    """Request model for updating a comment"""
    content: str = Field(..., min_length=1, max_length=5000)


# ============================================================================
# Response Models
# ============================================================================

class ApprovalActionResponse(BaseModel):
    """Response model for approval action data"""
    id: str
    request_id: str
    reviewer_id: str
    reviewer_role: str
    reviewer_level: int
    action_type: str
    notes: Optional[str] = None
    delegated_to: Optional[str] = None
    delegated_reason: Optional[str] = None
    escalated_to_level: Optional[int] = None
    escalation_reason: Optional[str] = None
    info_requested: Optional[str] = None
    mfa_verified: bool = False
    acted_at: str

    # Reviewer info (populated by join)
    reviewer_name: Optional[str] = None
    reviewer_email: Optional[str] = None

    class Config:
        from_attributes = True


class ApprovalCommentResponse(BaseModel):
    """Response model for approval comment data"""
    id: str
    request_id: str
    author_id: str
    author_role: str
    content: str
    is_internal: bool = False
    attachments: List[Dict[str, str]] = Field(default_factory=list)
    parent_comment_id: Optional[str] = None
    created_at: str
    updated_at: Optional[str] = None
    deleted_at: Optional[str] = None

    # Author info (populated by join)
    author_name: Optional[str] = None
    author_email: Optional[str] = None

    # Nested replies
    replies: List['ApprovalCommentResponse'] = Field(default_factory=list)

    class Config:
        from_attributes = True


class ApprovalRequestResponse(BaseModel):
    """Response model for approval request data"""
    id: str
    request_number: str
    request_type: str

    # Initiator
    initiated_by: str
    initiated_by_role: str
    initiated_at: str

    # Target
    target_resource_type: str
    target_resource_id: Optional[str] = None
    target_resource_snapshot: Optional[Dict[str, Any]] = None

    # Action
    action_type: str
    action_payload: Dict[str, Any] = Field(default_factory=dict)
    justification: str

    # Priority and timing
    priority: str
    expires_at: Optional[str] = None

    # Status
    status: str
    current_approval_level: int
    required_approval_level: int
    approval_chain: List[Dict[str, Any]] = Field(default_factory=list)

    # Scope
    regional_scope: Optional[str] = None

    # Attachments and metadata
    attachments: List[Dict[str, str]] = Field(default_factory=list)
    metadata: Optional[Dict[str, Any]] = None

    # Execution
    executed_at: Optional[str] = None
    execution_result: Optional[Dict[str, Any]] = None

    # Timestamps
    created_at: str
    updated_at: str

    # Related data (populated by joins)
    initiator_name: Optional[str] = None
    initiator_email: Optional[str] = None

    # Nested data
    actions: List[ApprovalActionResponse] = Field(default_factory=list)
    comments: List[ApprovalCommentResponse] = Field(default_factory=list)

    class Config:
        from_attributes = True


class ApprovalRequestListResponse(BaseModel):
    """Response model for paginated approval request list"""
    requests: List[ApprovalRequestResponse]
    total: int
    page: int
    page_size: int
    has_more: bool


class ApprovalConfigResponse(BaseModel):
    """Response model for approval configuration"""
    id: str
    request_type: str
    action_type: str
    target_resource_type: Optional[str] = None
    required_approval_level: int
    can_skip_levels: bool = False
    skip_level_conditions: Dict[str, Any] = Field(default_factory=dict)
    allowed_initiator_roles: List[str] = Field(default_factory=list)
    allowed_approver_roles: List[str] = Field(default_factory=list)
    default_priority: str = "normal"
    default_expiration_hours: Optional[int] = None
    requires_mfa: bool = False
    auto_execute: bool = True
    notification_channels: List[str] = Field(default_factory=list)
    is_active: bool = True
    description: Optional[str] = None
    created_at: str
    updated_at: str

    class Config:
        from_attributes = True


class ApprovalConfigUpdate(BaseModel):
    """Request model for updating approval configuration (Super Admin only)"""
    can_skip_levels: Optional[bool] = None
    skip_level_conditions: Optional[Dict[str, Any]] = None
    default_priority: Optional[ApprovalPriority] = None
    default_expiration_hours: Optional[int] = None
    requires_mfa: Optional[bool] = None
    auto_execute: Optional[bool] = None
    notification_channels: Optional[List[str]] = None
    is_active: Optional[bool] = None
    description: Optional[str] = None


class ApprovalConfigListResponse(BaseModel):
    """Response model for list of approval configurations"""
    configs: List[ApprovalConfigResponse]
    total: int


# ============================================================================
# Statistics and Dashboard Models
# ============================================================================

class ApprovalStatistics(BaseModel):
    """Approval workflow statistics"""
    total_requests: int = 0
    pending_requests: int = 0
    under_review_requests: int = 0
    awaiting_info_requests: int = 0
    approved_requests: int = 0
    denied_requests: int = 0
    withdrawn_requests: int = 0
    expired_requests: int = 0
    executed_requests: int = 0
    failed_requests: int = 0

    # Time-based stats
    requests_today: int = 0
    requests_this_week: int = 0
    requests_this_month: int = 0

    # Performance stats
    avg_approval_time_hours: Optional[float] = None
    approval_rate: Optional[float] = None

    # By type breakdown
    by_request_type: Dict[str, int] = Field(default_factory=dict)
    by_action_type: Dict[str, int] = Field(default_factory=dict)
    by_priority: Dict[str, int] = Field(default_factory=dict)


class PendingApprovalItem(BaseModel):
    """Summary item for pending approval dashboard"""
    id: str
    request_number: str
    request_type: str
    action_type: str
    priority: str
    status: str
    initiated_by: str
    initiator_name: Optional[str] = None
    target_resource_type: str
    current_approval_level: int
    created_at: str
    expires_at: Optional[str] = None


class MyPendingActionsResponse(BaseModel):
    """Response for pending actions for current admin"""
    pending_reviews: List[PendingApprovalItem] = Field(default_factory=list)
    awaiting_my_info: List[PendingApprovalItem] = Field(default_factory=list)
    delegated_to_me: List[PendingApprovalItem] = Field(default_factory=list)
    total: int = 0


class MySubmittedRequestsResponse(BaseModel):
    """Response for requests submitted by current admin"""
    requests: List[ApprovalRequestResponse]
    total: int
    page: int
    page_size: int
    has_more: bool


# ============================================================================
# Audit Log Models
# ============================================================================

class ApprovalAuditLogEntry(BaseModel):
    """Response model for audit log entry"""
    id: str
    request_id: str
    actor_id: str
    actor_role: str
    event_type: str
    event_description: Optional[str] = None
    previous_state: Optional[Dict[str, Any]] = None
    new_state: Optional[Dict[str, Any]] = None
    ip_address: Optional[str] = None
    user_agent: Optional[str] = None
    session_id: Optional[str] = None
    timestamp: str

    # Actor info (populated by join)
    actor_name: Optional[str] = None
    actor_email: Optional[str] = None

    class Config:
        from_attributes = True


class ApprovalAuditLogResponse(BaseModel):
    """Response model for paginated audit log"""
    entries: List[ApprovalAuditLogEntry]
    total: int
    page: int
    page_size: int
    has_more: bool


# ============================================================================
# Filter Models
# ============================================================================

class ApprovalRequestFilter(BaseModel):
    """Filter options for listing approval requests"""
    status: Optional[List[ApprovalStatus]] = None
    request_type: Optional[List[ApprovalRequestType]] = None
    action_type: Optional[List[ApprovalActionType]] = None
    priority: Optional[List[ApprovalPriority]] = None
    initiated_by: Optional[str] = None
    regional_scope: Optional[str] = None
    current_approval_level: Optional[int] = None
    from_date: Optional[str] = None
    to_date: Optional[str] = None
    search: Optional[str] = None  # Search in justification, request_number


# Fix forward reference
ApprovalCommentResponse.model_rebuild()
