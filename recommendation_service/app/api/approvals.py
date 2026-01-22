"""
Approval Workflow API Endpoints
RESTful API for multi-level admin approval system
"""
from fastapi import APIRouter, Depends, HTTPException, status, Query, Request
from typing import Optional, List

from app.services.approval_service import ApprovalService
from app.schemas.approvals import (
    ApprovalRequestCreate,
    ApprovalRequestUpdate,
    ApprovalRequestResponse,
    ApprovalRequestListResponse,
    ApprovalApproveRequest,
    ApprovalDenyRequest,
    ApprovalRequestInfoRequest,
    ApprovalRespondInfoRequest,
    ApprovalDelegateRequest,
    ApprovalEscalateRequest,
    ApprovalCommentCreate,
    ApprovalCommentUpdate,
    ApprovalCommentResponse,
    ApprovalConfigResponse,
    ApprovalConfigUpdate,
    ApprovalConfigListResponse,
    ApprovalStatistics,
    MyPendingActionsResponse,
    MySubmittedRequestsResponse,
    ApprovalAuditLogResponse,
    ApprovalRequestFilter,
    ApprovalStatus,
    ApprovalRequestType,
    ApprovalActionType,
    ApprovalPriority
)
from app.utils.security import (
    get_current_user,
    CurrentUser,
    require_admin,
    require_super_admin,
    UserRole
)

router = APIRouter()


def get_client_info(request: Request) -> tuple:
    """Extract client IP and user agent from request"""
    ip_address = request.client.host if request.client else None
    user_agent = request.headers.get("user-agent")
    return ip_address, user_agent


# ============================================================================
# Core CRUD Endpoints
# ============================================================================

@router.post("/admin/approvals", status_code=status.HTTP_201_CREATED)
async def create_approval_request(
    request_data: ApprovalRequestCreate,
    request: Request,
    current_user: CurrentUser = Depends(require_admin)
) -> ApprovalRequestResponse:
    """
    Create a new approval request

    **Requires:** Admin authentication

    **Request Body:**
    - request_type: Type of request (user_management, content_management, etc.)
    - action_type: Specific action requiring approval
    - target_resource_type: Type of resource being affected
    - target_resource_id: ID of the target resource (optional)
    - action_payload: Data for the action to be performed
    - justification: Reason for the request
    - priority: Request priority (low, normal, high, urgent)

    **Returns:**
    - Created approval request with generated request number
    """
    try:
        ip_address, user_agent = get_client_info(request)
        service = ApprovalService()
        result = await service.create_request(
            admin_id=current_user.id,
            admin_role=UserRole.normalize_role(current_user.role),
            request_data=request_data,
            ip_address=ip_address,
            user_agent=user_agent
        )
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.get("/admin/approvals")
async def list_approval_requests(
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
    status_filter: Optional[List[str]] = Query(None, alias="status"),
    request_type: Optional[List[str]] = Query(None),
    action_type: Optional[List[str]] = Query(None),
    priority: Optional[List[str]] = Query(None),
    initiated_by: Optional[str] = None,
    regional_scope: Optional[str] = None,
    current_approval_level: Optional[int] = None,
    from_date: Optional[str] = None,
    to_date: Optional[str] = None,
    search: Optional[str] = None,
    current_user: CurrentUser = Depends(require_admin)
) -> ApprovalRequestListResponse:
    """
    List approval requests with filtering

    **Requires:** Admin authentication

    **Query Parameters:**
    - page: Page number (default: 1)
    - page_size: Items per page (default: 20, max: 100)
    - status: Filter by status(es)
    - request_type: Filter by request type(s)
    - action_type: Filter by action type(s)
    - priority: Filter by priority(s)
    - initiated_by: Filter by initiator user ID
    - regional_scope: Filter by regional scope
    - current_approval_level: Filter by current approval level
    - from_date: Filter from date (ISO format)
    - to_date: Filter to date (ISO format)
    - search: Search in justification and request number

    **Returns:**
    - Paginated list of approval requests
    """
    try:
        # Build filter object
        filters = ApprovalRequestFilter(
            status=[ApprovalStatus(s) for s in status_filter] if status_filter else None,
            request_type=[ApprovalRequestType(t) for t in request_type] if request_type else None,
            action_type=[ApprovalActionType(a) for a in action_type] if action_type else None,
            priority=[ApprovalPriority(p) for p in priority] if priority else None,
            initiated_by=initiated_by,
            regional_scope=regional_scope,
            current_approval_level=current_approval_level,
            from_date=from_date,
            to_date=to_date,
            search=search
        )

        service = ApprovalService()
        result = await service.list_requests(
            admin_id=current_user.id,
            admin_role=UserRole.normalize_role(current_user.role),
            filters=filters,
            page=page,
            page_size=page_size
        )
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


# ============================================================================
# IMPORTANT: Specific routes MUST be defined BEFORE parameterized routes
# FastAPI matches routes in order, so /stats must come before /{request_id}
# ============================================================================

# Dashboard Endpoints (moved before {request_id} routes)
# ============================================================================

@router.get("/admin/approvals/stats")
async def get_approval_statistics(
    regional_scope: Optional[str] = None,
    current_user: CurrentUser = Depends(require_admin)
) -> ApprovalStatistics:
    """
    Get approval workflow statistics

    **Requires:** Admin authentication

    **Query Parameters:**
    - regional_scope: Filter by regional scope (optional)

    **Returns:**
    - Approval statistics including counts by status, type, and trends
    """
    try:
        service = ApprovalService()
        result = await service.get_statistics(
            admin_id=current_user.id,
            admin_role=UserRole.normalize_role(current_user.role),
            regional_scope=regional_scope
        )
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.get("/admin/approvals/my-pending")
async def get_my_pending_actions(
    current_user: CurrentUser = Depends(require_admin)
) -> MyPendingActionsResponse:
    """
    Get pending actions for the current admin

    **Requires:** Admin authentication

    **Returns:**
    - Pending reviews: Requests awaiting your review
    - Awaiting my info: Your requests that need more information
    - Delegated to me: Requests delegated to you
    """
    try:
        service = ApprovalService()
        result = await service.get_my_pending_actions(
            admin_id=current_user.id,
            admin_role=UserRole.normalize_role(current_user.role)
        )
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.get("/admin/approvals/my-requests")
async def get_my_submitted_requests(
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
    current_user: CurrentUser = Depends(require_admin)
) -> MySubmittedRequestsResponse:
    """
    Get requests submitted by the current admin

    **Requires:** Admin authentication

    **Query Parameters:**
    - page: Page number (default: 1)
    - page_size: Items per page (default: 20, max: 100)

    **Returns:**
    - Paginated list of requests submitted by the current admin
    """
    try:
        service = ApprovalService()
        result = await service.get_my_requests(
            admin_id=current_user.id,
            admin_role=UserRole.normalize_role(current_user.role),
            page=page,
            page_size=page_size
        )
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.get("/admin/approvals/config")
async def list_approval_configs(
    current_user: CurrentUser = Depends(require_admin)
) -> ApprovalConfigListResponse:
    """
    List all approval configurations

    **Requires:** Admin authentication

    **Returns:**
    - List of all approval workflow configurations
    """
    try:
        service = ApprovalService()
        result = await service.list_configs(
            admin_id=current_user.id,
            admin_role=UserRole.normalize_role(current_user.role)
        )
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.get("/admin/approvals/audit")
async def get_system_audit_log(
    page: int = Query(1, ge=1),
    page_size: int = Query(50, ge=1, le=100),
    from_date: Optional[str] = None,
    to_date: Optional[str] = None,
    event_type: Optional[str] = None,
    current_user: CurrentUser = Depends(require_super_admin)
) -> ApprovalAuditLogResponse:
    """
    Get system-wide audit log for approvals

    **Requires:** Super Admin authentication

    **Query Parameters:**
    - page: Page number (default: 1)
    - page_size: Items per page (default: 50, max: 100)
    - from_date: Filter from date (ISO format)
    - to_date: Filter to date (ISO format)
    - event_type: Filter by event type

    **Returns:**
    - Paginated system-wide audit log entries
    """
    try:
        service = ApprovalService()
        result = await service.get_system_audit_log(
            admin_id=current_user.id,
            admin_role=UserRole.normalize_role(current_user.role),
            from_date=from_date,
            to_date=to_date,
            event_type=event_type,
            page=page,
            page_size=page_size
        )
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


# ============================================================================
# Parameterized routes (must come AFTER specific routes)
# ============================================================================

@router.get("/admin/approvals/{request_id}")
async def get_approval_request(
    request_id: str,
    include_actions: bool = Query(True),
    include_comments: bool = Query(True),
    current_user: CurrentUser = Depends(require_admin)
) -> ApprovalRequestResponse:
    """
    Get approval request by ID

    **Requires:** Admin authentication

    **Path Parameters:**
    - request_id: Approval request ID

    **Query Parameters:**
    - include_actions: Include action history (default: true)
    - include_comments: Include comments (default: true)

    **Returns:**
    - Approval request with full details
    """
    try:
        service = ApprovalService()
        result = await service.get_request(
            request_id=request_id,
            include_actions=include_actions,
            include_comments=include_comments
        )
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=str(e)
        )


@router.patch("/admin/approvals/{request_id}")
async def update_approval_request(
    request_id: str,
    update_data: ApprovalRequestUpdate,
    request: Request,
    current_user: CurrentUser = Depends(require_admin)
) -> ApprovalRequestResponse:
    """
    Update an approval request (draft or awaiting_info only)

    **Requires:** Admin authentication (initiator only)

    **Path Parameters:**
    - request_id: Approval request ID

    **Request Body:**
    - justification: Updated justification
    - action_payload: Updated action payload
    - priority: Updated priority
    - attachments: Updated attachments

    **Returns:**
    - Updated approval request
    """
    try:
        ip_address, user_agent = get_client_info(request)
        service = ApprovalService()
        result = await service.update_request(
            request_id=request_id,
            admin_id=current_user.id,
            admin_role=UserRole.normalize_role(current_user.role),
            update_data=update_data,
            ip_address=ip_address,
            user_agent=user_agent
        )
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.post("/admin/approvals/{request_id}/withdraw")
async def withdraw_approval_request(
    request_id: str,
    request: Request,
    reason: Optional[str] = None,
    current_user: CurrentUser = Depends(require_admin)
) -> ApprovalRequestResponse:
    """
    Withdraw an approval request

    **Requires:** Admin authentication (initiator only)

    **Path Parameters:**
    - request_id: Approval request ID

    **Query Parameters:**
    - reason: Reason for withdrawal (optional)

    **Returns:**
    - Updated approval request with withdrawn status
    """
    try:
        ip_address, user_agent = get_client_info(request)
        service = ApprovalService()
        result = await service.withdraw_request(
            request_id=request_id,
            admin_id=current_user.id,
            admin_role=UserRole.normalize_role(current_user.role),
            reason=reason,
            ip_address=ip_address,
            user_agent=user_agent
        )
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


# ============================================================================
# Review Action Endpoints
# ============================================================================

@router.post("/admin/approvals/{request_id}/approve")
async def approve_request(
    request_id: str,
    approve_data: ApprovalApproveRequest,
    request: Request,
    current_user: CurrentUser = Depends(require_admin)
) -> ApprovalRequestResponse:
    """
    Approve an approval request

    **Requires:** Regional Admin or Super Admin authentication

    **Path Parameters:**
    - request_id: Approval request ID

    **Request Body:**
    - notes: Optional notes for the approval
    - mfa_verified: Whether MFA was verified (for high-security actions)

    **Returns:**
    - Updated approval request
    """
    try:
        ip_address, user_agent = get_client_info(request)
        service = ApprovalService()
        result = await service.approve_request(
            request_id=request_id,
            admin_id=current_user.id,
            admin_role=UserRole.normalize_role(current_user.role),
            approve_data=approve_data,
            ip_address=ip_address,
            user_agent=user_agent
        )
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.post("/admin/approvals/{request_id}/deny")
async def deny_request(
    request_id: str,
    deny_data: ApprovalDenyRequest,
    request: Request,
    current_user: CurrentUser = Depends(require_admin)
) -> ApprovalRequestResponse:
    """
    Deny an approval request

    **Requires:** Regional Admin or Super Admin authentication

    **Path Parameters:**
    - request_id: Approval request ID

    **Request Body:**
    - reason: Reason for denial (required)
    - notes: Optional additional notes
    - mfa_verified: Whether MFA was verified

    **Returns:**
    - Updated approval request with denied status
    """
    try:
        ip_address, user_agent = get_client_info(request)
        service = ApprovalService()
        result = await service.deny_request(
            request_id=request_id,
            admin_id=current_user.id,
            admin_role=UserRole.normalize_role(current_user.role),
            deny_data=deny_data,
            ip_address=ip_address,
            user_agent=user_agent
        )
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.post("/admin/approvals/{request_id}/request-info")
async def request_additional_info(
    request_id: str,
    info_data: ApprovalRequestInfoRequest,
    request: Request,
    current_user: CurrentUser = Depends(require_admin)
) -> ApprovalRequestResponse:
    """
    Request additional information from the initiator

    **Requires:** Regional Admin or Super Admin authentication

    **Path Parameters:**
    - request_id: Approval request ID

    **Request Body:**
    - info_requested: Description of information needed

    **Returns:**
    - Updated approval request with awaiting_info status
    """
    try:
        ip_address, user_agent = get_client_info(request)
        service = ApprovalService()
        result = await service.request_info(
            request_id=request_id,
            admin_id=current_user.id,
            admin_role=UserRole.normalize_role(current_user.role),
            info_data=info_data,
            ip_address=ip_address,
            user_agent=user_agent
        )
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.post("/admin/approvals/{request_id}/respond-info")
async def respond_to_info_request(
    request_id: str,
    response_data: ApprovalRespondInfoRequest,
    request: Request,
    current_user: CurrentUser = Depends(require_admin)
) -> ApprovalRequestResponse:
    """
    Respond to an information request

    **Requires:** Admin authentication (initiator only)

    **Path Parameters:**
    - request_id: Approval request ID

    **Request Body:**
    - response: Response to the information request
    - attachments: Additional attachments (optional)

    **Returns:**
    - Updated approval request returned to review status
    """
    try:
        ip_address, user_agent = get_client_info(request)
        service = ApprovalService()
        result = await service.respond_to_info_request(
            request_id=request_id,
            admin_id=current_user.id,
            admin_role=UserRole.normalize_role(current_user.role),
            response_data=response_data,
            ip_address=ip_address,
            user_agent=user_agent
        )
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.post("/admin/approvals/{request_id}/delegate")
async def delegate_request(
    request_id: str,
    delegate_data: ApprovalDelegateRequest,
    request: Request,
    current_user: CurrentUser = Depends(require_admin)
) -> ApprovalRequestResponse:
    """
    Delegate an approval request to another admin

    **Requires:** Regional Admin or Super Admin authentication

    **Path Parameters:**
    - request_id: Approval request ID

    **Request Body:**
    - delegate_to: User ID of the delegate
    - reason: Reason for delegation

    **Returns:**
    - Approval request with delegation recorded
    """
    try:
        ip_address, user_agent = get_client_info(request)
        service = ApprovalService()
        result = await service.delegate_request(
            request_id=request_id,
            admin_id=current_user.id,
            admin_role=UserRole.normalize_role(current_user.role),
            delegate_data=delegate_data,
            ip_address=ip_address,
            user_agent=user_agent
        )
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.post("/admin/approvals/{request_id}/escalate")
async def escalate_request(
    request_id: str,
    escalate_data: ApprovalEscalateRequest,
    request: Request,
    current_user: CurrentUser = Depends(require_admin)
) -> ApprovalRequestResponse:
    """
    Escalate an approval request to a higher level

    **Requires:** Regional Admin or Super Admin authentication

    **Path Parameters:**
    - request_id: Approval request ID

    **Request Body:**
    - reason: Reason for escalation

    **Returns:**
    - Updated approval request with escalated status
    """
    try:
        ip_address, user_agent = get_client_info(request)
        service = ApprovalService()
        result = await service.escalate_request(
            request_id=request_id,
            admin_id=current_user.id,
            admin_role=UserRole.normalize_role(current_user.role),
            escalate_data=escalate_data,
            ip_address=ip_address,
            user_agent=user_agent
        )
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


# ============================================================================
# Comments Endpoints
# ============================================================================

@router.post("/admin/approvals/{request_id}/comments")
async def add_comment(
    request_id: str,
    comment_data: ApprovalCommentCreate,
    current_user: CurrentUser = Depends(require_admin)
) -> ApprovalCommentResponse:
    """
    Add a comment to an approval request

    **Requires:** Admin authentication

    **Path Parameters:**
    - request_id: Approval request ID

    **Request Body:**
    - content: Comment content
    - is_internal: Whether comment is internal (visible only to admins)
    - attachments: Optional attachments
    - parent_comment_id: Parent comment ID for replies

    **Returns:**
    - Created comment
    """
    try:
        service = ApprovalService()
        result = await service.add_comment(
            request_id=request_id,
            admin_id=current_user.id,
            admin_role=UserRole.normalize_role(current_user.role),
            comment_data=comment_data
        )
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.get("/admin/approvals/{request_id}/comments")
async def get_comments(
    request_id: str,
    current_user: CurrentUser = Depends(require_admin)
) -> List[ApprovalCommentResponse]:
    """
    Get comments for an approval request

    **Requires:** Admin authentication

    **Path Parameters:**
    - request_id: Approval request ID

    **Returns:**
    - List of comments
    """
    try:
        service = ApprovalService()
        request_data = await service.get_request(
            request_id=request_id,
            include_actions=False,
            include_comments=True
        )
        return request_data.comments
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=str(e)
        )


@router.patch("/admin/approvals/{request_id}/comments/{comment_id}")
async def update_comment(
    request_id: str,
    comment_id: str,
    comment_data: ApprovalCommentUpdate,
    current_user: CurrentUser = Depends(require_admin)
) -> ApprovalCommentResponse:
    """
    Update a comment

    **Requires:** Admin authentication (author only)

    **Path Parameters:**
    - request_id: Approval request ID
    - comment_id: Comment ID

    **Request Body:**
    - content: Updated comment content

    **Returns:**
    - Updated comment
    """
    try:
        service = ApprovalService()
        result = await service.update_comment(
            request_id=request_id,
            comment_id=comment_id,
            admin_id=current_user.id,
            admin_role=UserRole.normalize_role(current_user.role),
            comment_data=comment_data
        )
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.delete("/admin/approvals/{request_id}/comments/{comment_id}")
async def delete_comment(
    request_id: str,
    comment_id: str,
    current_user: CurrentUser = Depends(require_admin)
):
    """
    Delete a comment (soft delete)

    **Requires:** Admin authentication (author or Super Admin)

    **Path Parameters:**
    - request_id: Approval request ID
    - comment_id: Comment ID

    **Returns:**
    - Success message
    """
    try:
        service = ApprovalService()
        result = await service.delete_comment(
            request_id=request_id,
            comment_id=comment_id,
            admin_id=current_user.id,
            admin_role=UserRole.normalize_role(current_user.role)
        )
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


# ============================================================================
# Configuration Update Endpoint (Super Admin only)
# ============================================================================

@router.patch("/admin/approvals/config/{config_id}")
async def update_approval_config(
    config_id: str,
    update_data: ApprovalConfigUpdate,
    current_user: CurrentUser = Depends(require_super_admin)
) -> ApprovalConfigResponse:
    """
    Update an approval configuration

    **Requires:** Super Admin authentication

    **Path Parameters:**
    - config_id: Configuration ID

    **Request Body:**
    - can_skip_levels: Allow level skipping
    - skip_level_conditions: Conditions for skipping
    - default_priority: Default priority level
    - default_expiration_hours: Default expiration time
    - requires_mfa: Require MFA for approval
    - auto_execute: Auto-execute on final approval
    - notification_channels: Notification channels to use
    - is_active: Whether config is active
    - description: Configuration description

    **Returns:**
    - Updated configuration
    """
    try:
        service = ApprovalService()
        result = await service.update_config(
            config_id=config_id,
            admin_id=current_user.id,
            admin_role=UserRole.normalize_role(current_user.role),
            update_data=update_data
        )
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


# ============================================================================
# Request-Specific Audit Log Endpoint
# ============================================================================

@router.get("/admin/approvals/{request_id}/audit")
async def get_request_audit_log(
    request_id: str,
    page: int = Query(1, ge=1),
    page_size: int = Query(50, ge=1, le=100),
    current_user: CurrentUser = Depends(require_admin)
) -> ApprovalAuditLogResponse:
    """
    Get audit log for a specific approval request

    **Requires:** Regional Admin or Super Admin authentication

    **Path Parameters:**
    - request_id: Approval request ID

    **Query Parameters:**
    - page: Page number (default: 1)
    - page_size: Items per page (default: 50, max: 100)

    **Returns:**
    - Paginated audit log entries for the request
    """
    try:
        service = ApprovalService()
        result = await service.get_request_audit_log(
            request_id=request_id,
            admin_id=current_user.id,
            admin_role=UserRole.normalize_role(current_user.role),
            page=page,
            page_size=page_size
        )
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )
