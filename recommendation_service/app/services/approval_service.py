"""
Approval Workflow Service
Business logic for multi-level admin approval system
"""
from typing import Optional, List, Dict, Any, Tuple
from datetime import datetime, timedelta
import logging
from uuid import uuid4

from app.database.config import get_supabase
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
    ApprovalActionResponse,
    ApprovalConfigResponse,
    ApprovalConfigUpdate,
    ApprovalConfigListResponse,
    ApprovalStatistics,
    PendingApprovalItem,
    MyPendingActionsResponse,
    MySubmittedRequestsResponse,
    ApprovalAuditLogEntry,
    ApprovalAuditLogResponse,
    ApprovalStatus,
    ApprovalPriority,
    ApprovalRequestType,
    ApprovalActionType,
    ReviewActionType,
    ApprovalLevel,
    ApprovalRequestFilter
)

logger = logging.getLogger(__name__)


# Admin role to approval level mapping
# Supports both naming conventions (snake_case and camelCase without separator)
ROLE_LEVELS = {
    # Snake_case format
    'content_admin': 1,
    'support_admin': 1,
    'finance_admin': 1,
    'analytics_admin': 1,
    'regional_admin': 2,
    'super_admin': 3,
    # Normalized format (from UserRole.normalize_role)
    'contentadmin': 1,
    'supportadmin': 1,
    'financeadmin': 1,
    'analyticsadmin': 1,
    'regionaladmin': 2,
    'superadmin': 3,
}


class ApprovalService:
    """Service for managing approval workflows"""

    def __init__(self):
        self.db = get_supabase()

    def _get_admin_level(self, role: str) -> int:
        """Get approval level for an admin role"""
        return ROLE_LEVELS.get(role, 0)

    def _can_approve_at_level(self, role: str, required_level: int) -> bool:
        """Check if role can approve at a given level"""
        admin_level = self._get_admin_level(role)
        return admin_level >= required_level

    def _is_admin(self, role: str) -> bool:
        """Check if role is an admin role"""
        return role in ROLE_LEVELS

    async def _get_user_info(self, user_id: str) -> Dict[str, str]:
        """Get user display name and email"""
        try:
            response = self.db.table('users').select('display_name, email').eq('id', user_id).single().execute()
            if response.data:
                return {
                    'name': response.data.get('display_name', 'Unknown'),
                    'email': response.data.get('email', 'Unknown')
                }
        except Exception as e:
            logger.warning(f"Failed to get user info for {user_id}: {e}")
        return {'name': 'Unknown', 'email': 'Unknown'}

    async def _get_approval_config(
        self,
        request_type: str,
        action_type: str,
        target_resource_type: Optional[str] = None
    ) -> Optional[Dict[str, Any]]:
        """Get approval configuration for a specific action"""
        try:
            query = self.db.table('approval_config').select('*').eq('request_type', request_type).eq('action_type', action_type).eq('is_active', True)

            if target_resource_type:
                query = query.eq('target_resource_type', target_resource_type)

            response = query.execute()

            if response.data and len(response.data) > 0:
                return response.data[0]

            # Fallback without target_resource_type
            if target_resource_type:
                query = self.db.table('approval_config').select('*').eq('request_type', request_type).eq('action_type', action_type).eq('is_active', True).is_('target_resource_type', 'null')
                response = query.execute()
                if response.data and len(response.data) > 0:
                    return response.data[0]

        except Exception as e:
            logger.error(f"Error getting approval config: {e}")

        return None

    async def _create_audit_log(
        self,
        request_id: str,
        actor_id: str,
        actor_role: str,
        event_type: str,
        event_description: Optional[str] = None,
        previous_state: Optional[Dict[str, Any]] = None,
        new_state: Optional[Dict[str, Any]] = None,
        ip_address: Optional[str] = None,
        user_agent: Optional[str] = None
    ) -> None:
        """Create an audit log entry"""
        try:
            entry = {
                'id': str(uuid4()),
                'request_id': request_id,
                'actor_id': actor_id,
                'actor_role': actor_role,
                'event_type': event_type,
                'event_description': event_description,
                'previous_state': previous_state,
                'new_state': new_state,
                'ip_address': ip_address,
                'user_agent': user_agent,
                'timestamp': datetime.utcnow().isoformat()
            }
            self.db.table('approval_audit_log').insert(entry).execute()
        except Exception as e:
            logger.error(f"Failed to create audit log: {e}")

    async def _send_notification(
        self,
        request_id: str,
        recipient_id: str,
        notification_type: str,
        title: str,
        message: str,
        channels: List[str] = None
    ) -> None:
        """Send notification related to approval workflow"""
        try:
            notification = {
                'id': str(uuid4()),
                'request_id': request_id,
                'recipient_id': recipient_id,
                'notification_type': notification_type,
                'title': title,
                'message': message,
                'channels': channels or ['in_app', 'email'],
                'sent_channels': [],
                'is_read': False,
                'scheduled_for': datetime.utcnow().isoformat(),
                'created_at': datetime.utcnow().isoformat()
            }
            self.db.table('approval_notifications').insert(notification).execute()
        except Exception as e:
            logger.error(f"Failed to send notification: {e}")

    async def _notify_approvers(
        self,
        request: Dict[str, Any],
        notification_type: str,
        title: str,
        message: str
    ) -> None:
        """Notify all eligible approvers for the current approval level"""
        try:
            current_level = request.get('current_approval_level', 1)
            regional_scope = request.get('regional_scope')

            # Get eligible approvers based on level
            query = self.db.table('users').select('id, role')

            if current_level >= 3:
                query = query.eq('role', 'super_admin')
            elif current_level >= 2:
                query = query.in_('role', ['regional_admin', 'super_admin'])
            else:
                # Level 1 cannot approve, only initiate
                return

            response = query.execute()

            if response.data:
                config = await self._get_approval_config(
                    request.get('request_type'),
                    request.get('action_type')
                )
                channels = config.get('notification_channels', ['in_app', 'email']) if config else ['in_app', 'email']

                for user in response.data:
                    # Skip if regional scope mismatch (for regional admins)
                    if regional_scope and user.get('role') == 'regional_admin':
                        # TODO: Check user's region matches regional_scope
                        pass

                    await self._send_notification(
                        request_id=request.get('id'),
                        recipient_id=user.get('id'),
                        notification_type=notification_type,
                        title=title,
                        message=message,
                        channels=channels
                    )

        except Exception as e:
            logger.error(f"Failed to notify approvers: {e}")

    # =========================================================================
    # CRUD Operations
    # =========================================================================

    async def create_request(
        self,
        admin_id: str,
        admin_role: str,
        request_data: ApprovalRequestCreate,
        ip_address: Optional[str] = None,
        user_agent: Optional[str] = None
    ) -> ApprovalRequestResponse:
        """Create a new approval request"""
        try:
            # Verify admin role
            if not self._is_admin(admin_role):
                raise Exception("Only administrators can create approval requests")

            # Get approval configuration
            config = await self._get_approval_config(
                request_data.request_type.value,
                request_data.action_type.value,
                request_data.target_resource_type
            )

            if not config:
                raise Exception(f"No approval configuration found for {request_data.action_type.value}")

            # Check if role is allowed to initiate this type of request
            allowed_initiators = config.get('allowed_initiator_roles', [])
            if admin_role not in allowed_initiators:
                raise Exception(f"Role {admin_role} is not allowed to initiate {request_data.action_type.value} requests")

            # Calculate expiration
            expires_at = None
            if config.get('default_expiration_hours'):
                expires_at = (datetime.utcnow() + timedelta(hours=config['default_expiration_hours'])).isoformat()

            # Build approval request
            approval_request = {
                'id': str(uuid4()),
                'request_type': request_data.request_type.value,
                'action_type': request_data.action_type.value,
                'initiated_by': admin_id,
                'initiated_by_role': admin_role,
                'initiated_at': datetime.utcnow().isoformat(),
                'target_resource_type': request_data.target_resource_type,
                'target_resource_id': request_data.target_resource_id,
                'target_resource_snapshot': request_data.target_resource_snapshot,
                'action_payload': request_data.action_payload,
                'justification': request_data.justification,
                'priority': request_data.priority.value if request_data.priority else config.get('default_priority', 'normal'),
                'expires_at': expires_at,
                'status': ApprovalStatus.PENDING_REVIEW.value,
                'current_approval_level': 1,
                'required_approval_level': config.get('required_approval_level', 3),
                'approval_chain': [],
                'regional_scope': request_data.regional_scope,
                'attachments': request_data.attachments,
                'metadata': request_data.metadata or {},
                'created_at': datetime.utcnow().isoformat(),
                'updated_at': datetime.utcnow().isoformat()
            }

            response = self.db.table('approval_requests').insert(approval_request).execute()

            if not response.data:
                raise Exception("Failed to create approval request")

            created_request = response.data[0]

            # Create audit log
            await self._create_audit_log(
                request_id=created_request['id'],
                actor_id=admin_id,
                actor_role=admin_role,
                event_type='request_created',
                event_description=f"Created approval request for {request_data.action_type.value}",
                new_state={'status': ApprovalStatus.PENDING_REVIEW.value},
                ip_address=ip_address,
                user_agent=user_agent
            )

            # Notify approvers
            user_info = await self._get_user_info(admin_id)
            await self._notify_approvers(
                request=created_request,
                notification_type='approval_request_new',
                title='New Approval Request',
                message=f"{user_info['name']} submitted a request for {request_data.action_type.value.replace('_', ' ')}"
            )

            logger.info(f"Approval request created: {created_request['request_number']} by {admin_id}")

            return await self.get_request(created_request['id'])

        except Exception as e:
            logger.error(f"Create approval request error: {e}")
            raise Exception(f"Failed to create approval request: {str(e)}")

    async def get_request(self, request_id: str, include_actions: bool = True, include_comments: bool = True) -> ApprovalRequestResponse:
        """Get approval request by ID with optional related data"""
        try:
            response = self.db.table('approval_requests').select('*').eq('id', request_id).single().execute()

            if not response.data:
                raise Exception("Approval request not found")

            request_data = response.data

            # Get initiator info
            user_info = await self._get_user_info(request_data['initiated_by'])
            request_data['initiator_name'] = user_info['name']
            request_data['initiator_email'] = user_info['email']

            # Get actions if requested
            actions = []
            if include_actions:
                actions_response = self.db.table('approval_actions').select('*').eq('request_id', request_id).order('acted_at', desc=True).execute()
                if actions_response.data:
                    for action in actions_response.data:
                        action_user = await self._get_user_info(action['reviewer_id'])
                        action['reviewer_name'] = action_user['name']
                        action['reviewer_email'] = action_user['email']
                        actions.append(ApprovalActionResponse(**action))

            # Get comments if requested
            comments = []
            if include_comments:
                comments_response = self.db.table('approval_comments').select('*').eq('request_id', request_id).is_('deleted_at', 'null').order('created_at', desc=False).execute()
                if comments_response.data:
                    for comment in comments_response.data:
                        comment_user = await self._get_user_info(comment['author_id'])
                        comment['author_name'] = comment_user['name']
                        comment['author_email'] = comment_user['email']
                        comment['replies'] = []  # TODO: Implement nested replies
                        comments.append(ApprovalCommentResponse(**comment))

            request_data['actions'] = actions
            request_data['comments'] = comments

            return ApprovalRequestResponse(**request_data)

        except Exception as e:
            logger.error(f"Get approval request error: {e}")
            raise Exception(f"Failed to fetch approval request: {str(e)}")

    async def list_requests(
        self,
        admin_id: str,
        admin_role: str,
        filters: Optional[ApprovalRequestFilter] = None,
        page: int = 1,
        page_size: int = 20
    ) -> ApprovalRequestListResponse:
        """List approval requests with filtering"""
        try:
            if not self._is_admin(admin_role):
                raise Exception("Only administrators can view approval requests")

            query = self.db.table('approval_requests').select('*', count='exact')

            # Apply filters
            if filters:
                if filters.status:
                    query = query.in_('status', [s.value for s in filters.status])
                if filters.request_type:
                    query = query.in_('request_type', [t.value for t in filters.request_type])
                if filters.action_type:
                    query = query.in_('action_type', [a.value for a in filters.action_type])
                if filters.priority:
                    query = query.in_('priority', [p.value for p in filters.priority])
                if filters.initiated_by:
                    query = query.eq('initiated_by', filters.initiated_by)
                if filters.regional_scope:
                    query = query.eq('regional_scope', filters.regional_scope)
                if filters.current_approval_level:
                    query = query.eq('current_approval_level', filters.current_approval_level)
                if filters.from_date:
                    query = query.gte('created_at', filters.from_date)
                if filters.to_date:
                    query = query.lte('created_at', filters.to_date)
                if filters.search:
                    query = query.or_(f"justification.ilike.%{filters.search}%,request_number.ilike.%{filters.search}%")

            # Pagination
            offset = (page - 1) * page_size
            query = query.order('created_at', desc=True).range(offset, offset + page_size - 1)

            response = query.execute()

            requests = []
            if response.data:
                for req_data in response.data:
                    user_info = await self._get_user_info(req_data['initiated_by'])
                    req_data['initiator_name'] = user_info['name']
                    req_data['initiator_email'] = user_info['email']
                    req_data['actions'] = []
                    req_data['comments'] = []
                    requests.append(ApprovalRequestResponse(**req_data))

            total = response.count or 0

            return ApprovalRequestListResponse(
                requests=requests,
                total=total,
                page=page,
                page_size=page_size,
                has_more=(offset + page_size) < total
            )

        except Exception as e:
            logger.error(f"List approval requests error: {e}")
            raise Exception(f"Failed to list approval requests: {str(e)}")

    async def update_request(
        self,
        request_id: str,
        admin_id: str,
        admin_role: str,
        update_data: ApprovalRequestUpdate,
        ip_address: Optional[str] = None,
        user_agent: Optional[str] = None
    ) -> ApprovalRequestResponse:
        """Update an approval request (draft or awaiting_info only)"""
        try:
            request = await self.get_request(request_id, include_actions=False, include_comments=False)

            # Only initiator can update
            if request.initiated_by != admin_id:
                raise Exception("Only the initiator can update this request")

            # Can only update in certain states
            if request.status not in [ApprovalStatus.DRAFT.value, ApprovalStatus.AWAITING_INFO.value]:
                raise Exception(f"Cannot update request in {request.status} status")

            update_dict = {'updated_at': datetime.utcnow().isoformat()}

            if update_data.justification is not None:
                update_dict['justification'] = update_data.justification
            if update_data.action_payload is not None:
                update_dict['action_payload'] = update_data.action_payload
            if update_data.priority is not None:
                update_dict['priority'] = update_data.priority.value
            if update_data.attachments is not None:
                update_dict['attachments'] = update_data.attachments
            if update_data.metadata is not None:
                update_dict['metadata'] = update_data.metadata

            response = self.db.table('approval_requests').update(update_dict).eq('id', request_id).execute()

            if not response.data:
                raise Exception("Failed to update approval request")

            # Create audit log
            await self._create_audit_log(
                request_id=request_id,
                actor_id=admin_id,
                actor_role=admin_role,
                event_type='request_updated',
                event_description='Approval request updated',
                previous_state={'justification': request.justification},
                new_state=update_dict,
                ip_address=ip_address,
                user_agent=user_agent
            )

            logger.info(f"Approval request updated: {request_id}")

            return await self.get_request(request_id)

        except Exception as e:
            logger.error(f"Update approval request error: {e}")
            raise Exception(f"Failed to update approval request: {str(e)}")

    async def withdraw_request(
        self,
        request_id: str,
        admin_id: str,
        admin_role: str,
        reason: Optional[str] = None,
        ip_address: Optional[str] = None,
        user_agent: Optional[str] = None
    ) -> ApprovalRequestResponse:
        """Withdraw an approval request"""
        try:
            request = await self.get_request(request_id, include_actions=False, include_comments=False)

            # Only initiator can withdraw
            if request.initiated_by != admin_id:
                raise Exception("Only the initiator can withdraw this request")

            # Cannot withdraw already completed requests
            if request.status in [ApprovalStatus.APPROVED.value, ApprovalStatus.EXECUTED.value, ApprovalStatus.DENIED.value]:
                raise Exception(f"Cannot withdraw a {request.status} request")

            update_data = {
                'status': ApprovalStatus.WITHDRAWN.value,
                'updated_at': datetime.utcnow().isoformat()
            }

            response = self.db.table('approval_requests').update(update_data).eq('id', request_id).execute()

            if not response.data:
                raise Exception("Failed to withdraw approval request")

            # Record the action
            action = {
                'id': str(uuid4()),
                'request_id': request_id,
                'reviewer_id': admin_id,
                'reviewer_role': admin_role,
                'reviewer_level': self._get_admin_level(admin_role),
                'action_type': ReviewActionType.WITHDRAW.value,
                'notes': reason,
                'acted_at': datetime.utcnow().isoformat()
            }
            self.db.table('approval_actions').insert(action).execute()

            # Create audit log
            await self._create_audit_log(
                request_id=request_id,
                actor_id=admin_id,
                actor_role=admin_role,
                event_type='request_withdrawn',
                event_description=f"Request withdrawn: {reason or 'No reason provided'}",
                previous_state={'status': request.status},
                new_state={'status': ApprovalStatus.WITHDRAWN.value},
                ip_address=ip_address,
                user_agent=user_agent
            )

            logger.info(f"Approval request withdrawn: {request_id}")

            return await self.get_request(request_id)

        except Exception as e:
            logger.error(f"Withdraw approval request error: {e}")
            raise Exception(f"Failed to withdraw approval request: {str(e)}")

    # =========================================================================
    # Review Actions
    # =========================================================================

    async def approve_request(
        self,
        request_id: str,
        admin_id: str,
        admin_role: str,
        approve_data: ApprovalApproveRequest,
        ip_address: Optional[str] = None,
        user_agent: Optional[str] = None
    ) -> ApprovalRequestResponse:
        """Approve an approval request"""
        try:
            request = await self.get_request(request_id, include_actions=False, include_comments=False)

            # Check if request is in a reviewable state
            if request.status not in [ApprovalStatus.PENDING_REVIEW.value, ApprovalStatus.UNDER_REVIEW.value, ApprovalStatus.ESCALATED.value]:
                raise Exception(f"Cannot approve request in {request.status} status")

            # Check if admin can approve at this level
            current_level = request.current_approval_level
            required_level = request.required_approval_level
            admin_level = self._get_admin_level(admin_role)

            if admin_level < 2:  # Level 1 admins cannot approve
                raise Exception("Your role does not have approval authority")

            # Get config to check MFA requirement
            config = await self._get_approval_config(request.request_type, request.action_type)
            if config and config.get('requires_mfa') and not approve_data.mfa_verified:
                raise Exception("MFA verification required for this approval")

            # Determine new status based on approval chain
            new_status = ApprovalStatus.UNDER_REVIEW.value
            new_level = current_level + 1

            # If this is the final approval
            if admin_level >= required_level:
                new_status = ApprovalStatus.APPROVED.value
                new_level = required_level

            # Update approval chain
            approval_chain = request.approval_chain or []
            approval_chain.append({
                'level': admin_level,
                'admin_id': admin_id,
                'admin_role': admin_role,
                'action': 'approved',
                'timestamp': datetime.utcnow().isoformat(),
                'notes': approve_data.notes
            })

            update_data = {
                'status': new_status,
                'current_approval_level': new_level,
                'approval_chain': approval_chain,
                'updated_at': datetime.utcnow().isoformat()
            }

            response = self.db.table('approval_requests').update(update_data).eq('id', request_id).execute()

            if not response.data:
                raise Exception("Failed to approve request")

            # Record the action
            action = {
                'id': str(uuid4()),
                'request_id': request_id,
                'reviewer_id': admin_id,
                'reviewer_role': admin_role,
                'reviewer_level': admin_level,
                'action_type': ReviewActionType.APPROVE.value,
                'notes': approve_data.notes,
                'mfa_verified': approve_data.mfa_verified,
                'acted_at': datetime.utcnow().isoformat(),
                'ip_address': ip_address,
                'user_agent': user_agent
            }
            self.db.table('approval_actions').insert(action).execute()

            # Create audit log
            await self._create_audit_log(
                request_id=request_id,
                actor_id=admin_id,
                actor_role=admin_role,
                event_type='request_approved',
                event_description=f"Approved at level {admin_level}",
                previous_state={'status': request.status, 'level': current_level},
                new_state={'status': new_status, 'level': new_level},
                ip_address=ip_address,
                user_agent=user_agent
            )

            # Execute action if fully approved and auto_execute is enabled
            if new_status == ApprovalStatus.APPROVED.value:
                if config and config.get('auto_execute', True):
                    await self._execute_approved_action(request_id, admin_id, admin_role, ip_address, user_agent)

                # Notify initiator
                await self._send_notification(
                    request_id=request_id,
                    recipient_id=request.initiated_by,
                    notification_type='approval_request_status_changed',
                    title='Request Approved',
                    message=f"Your request {request.request_number} has been approved"
                )
            else:
                # Notify next level approvers
                updated_request = response.data[0]
                await self._notify_approvers(
                    request=updated_request,
                    notification_type='approval_request_new',
                    title='Approval Request Escalated',
                    message=f"Request {request.request_number} requires your approval"
                )

            logger.info(f"Approval request approved: {request_id} by {admin_id} at level {admin_level}")

            return await self.get_request(request_id)

        except Exception as e:
            logger.error(f"Approve request error: {e}")
            raise Exception(f"Failed to approve request: {str(e)}")

    async def deny_request(
        self,
        request_id: str,
        admin_id: str,
        admin_role: str,
        deny_data: ApprovalDenyRequest,
        ip_address: Optional[str] = None,
        user_agent: Optional[str] = None
    ) -> ApprovalRequestResponse:
        """Deny an approval request"""
        try:
            request = await self.get_request(request_id, include_actions=False, include_comments=False)

            # Check if request is in a reviewable state
            if request.status not in [ApprovalStatus.PENDING_REVIEW.value, ApprovalStatus.UNDER_REVIEW.value, ApprovalStatus.ESCALATED.value]:
                raise Exception(f"Cannot deny request in {request.status} status")

            admin_level = self._get_admin_level(admin_role)
            if admin_level < 2:
                raise Exception("Your role does not have denial authority")

            # Update approval chain
            approval_chain = request.approval_chain or []
            approval_chain.append({
                'level': admin_level,
                'admin_id': admin_id,
                'admin_role': admin_role,
                'action': 'denied',
                'timestamp': datetime.utcnow().isoformat(),
                'reason': deny_data.reason
            })

            update_data = {
                'status': ApprovalStatus.DENIED.value,
                'approval_chain': approval_chain,
                'updated_at': datetime.utcnow().isoformat()
            }

            response = self.db.table('approval_requests').update(update_data).eq('id', request_id).execute()

            if not response.data:
                raise Exception("Failed to deny request")

            # Record the action
            action = {
                'id': str(uuid4()),
                'request_id': request_id,
                'reviewer_id': admin_id,
                'reviewer_role': admin_role,
                'reviewer_level': admin_level,
                'action_type': ReviewActionType.DENY.value,
                'notes': deny_data.reason,
                'mfa_verified': deny_data.mfa_verified,
                'acted_at': datetime.utcnow().isoformat(),
                'ip_address': ip_address,
                'user_agent': user_agent
            }
            self.db.table('approval_actions').insert(action).execute()

            # Create audit log
            await self._create_audit_log(
                request_id=request_id,
                actor_id=admin_id,
                actor_role=admin_role,
                event_type='request_denied',
                event_description=f"Denied: {deny_data.reason}",
                previous_state={'status': request.status},
                new_state={'status': ApprovalStatus.DENIED.value},
                ip_address=ip_address,
                user_agent=user_agent
            )

            # Notify initiator
            await self._send_notification(
                request_id=request_id,
                recipient_id=request.initiated_by,
                notification_type='approval_request_status_changed',
                title='Request Denied',
                message=f"Your request {request.request_number} has been denied"
            )

            logger.info(f"Approval request denied: {request_id} by {admin_id}")

            return await self.get_request(request_id)

        except Exception as e:
            logger.error(f"Deny request error: {e}")
            raise Exception(f"Failed to deny request: {str(e)}")

    async def request_info(
        self,
        request_id: str,
        admin_id: str,
        admin_role: str,
        info_data: ApprovalRequestInfoRequest,
        ip_address: Optional[str] = None,
        user_agent: Optional[str] = None
    ) -> ApprovalRequestResponse:
        """Request additional information from the initiator"""
        try:
            request = await self.get_request(request_id, include_actions=False, include_comments=False)

            if request.status not in [ApprovalStatus.PENDING_REVIEW.value, ApprovalStatus.UNDER_REVIEW.value]:
                raise Exception(f"Cannot request info for request in {request.status} status")

            admin_level = self._get_admin_level(admin_role)
            if admin_level < 2:
                raise Exception("Your role does not have authority to request information")

            update_data = {
                'status': ApprovalStatus.AWAITING_INFO.value,
                'updated_at': datetime.utcnow().isoformat()
            }

            response = self.db.table('approval_requests').update(update_data).eq('id', request_id).execute()

            if not response.data:
                raise Exception("Failed to update request")

            # Record the action
            action = {
                'id': str(uuid4()),
                'request_id': request_id,
                'reviewer_id': admin_id,
                'reviewer_role': admin_role,
                'reviewer_level': admin_level,
                'action_type': ReviewActionType.REQUEST_INFO.value,
                'info_requested': info_data.info_requested,
                'acted_at': datetime.utcnow().isoformat(),
                'ip_address': ip_address,
                'user_agent': user_agent
            }
            self.db.table('approval_actions').insert(action).execute()

            # Create audit log
            await self._create_audit_log(
                request_id=request_id,
                actor_id=admin_id,
                actor_role=admin_role,
                event_type='info_requested',
                event_description=f"Information requested: {info_data.info_requested}",
                previous_state={'status': request.status},
                new_state={'status': ApprovalStatus.AWAITING_INFO.value},
                ip_address=ip_address,
                user_agent=user_agent
            )

            # Notify initiator
            await self._send_notification(
                request_id=request_id,
                recipient_id=request.initiated_by,
                notification_type='approval_request_action_needed',
                title='Additional Information Required',
                message=f"More information is needed for request {request.request_number}"
            )

            logger.info(f"Info requested for approval: {request_id}")

            return await self.get_request(request_id)

        except Exception as e:
            logger.error(f"Request info error: {e}")
            raise Exception(f"Failed to request info: {str(e)}")

    async def respond_to_info_request(
        self,
        request_id: str,
        admin_id: str,
        admin_role: str,
        response_data: ApprovalRespondInfoRequest,
        ip_address: Optional[str] = None,
        user_agent: Optional[str] = None
    ) -> ApprovalRequestResponse:
        """Respond to an information request"""
        try:
            request = await self.get_request(request_id, include_actions=False, include_comments=False)

            if request.status != ApprovalStatus.AWAITING_INFO.value:
                raise Exception("Request is not awaiting information")

            if request.initiated_by != admin_id:
                raise Exception("Only the initiator can respond to information requests")

            # Update attachments if provided
            attachments = request.attachments or []
            if response_data.attachments:
                attachments.extend(response_data.attachments)

            update_data = {
                'status': ApprovalStatus.UNDER_REVIEW.value,
                'attachments': attachments,
                'updated_at': datetime.utcnow().isoformat()
            }

            response = self.db.table('approval_requests').update(update_data).eq('id', request_id).execute()

            if not response.data:
                raise Exception("Failed to update request")

            # Record the action
            action = {
                'id': str(uuid4()),
                'request_id': request_id,
                'reviewer_id': admin_id,
                'reviewer_role': admin_role,
                'reviewer_level': self._get_admin_level(admin_role),
                'action_type': ReviewActionType.RESPOND_INFO.value,
                'notes': response_data.response,
                'acted_at': datetime.utcnow().isoformat(),
                'ip_address': ip_address,
                'user_agent': user_agent
            }
            self.db.table('approval_actions').insert(action).execute()

            # Create audit log
            await self._create_audit_log(
                request_id=request_id,
                actor_id=admin_id,
                actor_role=admin_role,
                event_type='info_responded',
                event_description='Initiator responded to information request',
                previous_state={'status': ApprovalStatus.AWAITING_INFO.value},
                new_state={'status': ApprovalStatus.UNDER_REVIEW.value},
                ip_address=ip_address,
                user_agent=user_agent
            )

            # Notify approvers
            updated_request = response.data[0]
            await self._notify_approvers(
                request=updated_request,
                notification_type='approval_request_status_changed',
                title='Information Provided',
                message=f"Initiator responded to info request for {request.request_number}"
            )

            logger.info(f"Info response submitted for approval: {request_id}")

            return await self.get_request(request_id)

        except Exception as e:
            logger.error(f"Respond to info error: {e}")
            raise Exception(f"Failed to respond to info request: {str(e)}")

    async def delegate_request(
        self,
        request_id: str,
        admin_id: str,
        admin_role: str,
        delegate_data: ApprovalDelegateRequest,
        ip_address: Optional[str] = None,
        user_agent: Optional[str] = None
    ) -> ApprovalRequestResponse:
        """Delegate an approval request to another admin"""
        try:
            request = await self.get_request(request_id, include_actions=False, include_comments=False)

            if request.status not in [ApprovalStatus.PENDING_REVIEW.value, ApprovalStatus.UNDER_REVIEW.value]:
                raise Exception(f"Cannot delegate request in {request.status} status")

            admin_level = self._get_admin_level(admin_role)
            if admin_level < 2:
                raise Exception("Your role does not have delegation authority")

            # Verify delegate exists and is an admin
            delegate_response = self.db.table('users').select('id, role').eq('id', delegate_data.delegate_to).single().execute()
            if not delegate_response.data:
                raise Exception("Delegate user not found")

            delegate_role = delegate_response.data.get('role')
            if not self._is_admin(delegate_role):
                raise Exception("Can only delegate to other administrators")

            # Record the action
            action = {
                'id': str(uuid4()),
                'request_id': request_id,
                'reviewer_id': admin_id,
                'reviewer_role': admin_role,
                'reviewer_level': admin_level,
                'action_type': ReviewActionType.DELEGATE.value,
                'delegated_to': delegate_data.delegate_to,
                'delegated_reason': delegate_data.reason,
                'acted_at': datetime.utcnow().isoformat(),
                'ip_address': ip_address,
                'user_agent': user_agent
            }
            self.db.table('approval_actions').insert(action).execute()

            # Create audit log
            await self._create_audit_log(
                request_id=request_id,
                actor_id=admin_id,
                actor_role=admin_role,
                event_type='request_delegated',
                event_description=f"Delegated to {delegate_data.delegate_to}: {delegate_data.reason}",
                ip_address=ip_address,
                user_agent=user_agent
            )

            # Notify delegate
            await self._send_notification(
                request_id=request_id,
                recipient_id=delegate_data.delegate_to,
                notification_type='approval_request_new',
                title='Request Delegated to You',
                message=f"Request {request.request_number} has been delegated to you for review"
            )

            logger.info(f"Approval request delegated: {request_id} to {delegate_data.delegate_to}")

            return await self.get_request(request_id)

        except Exception as e:
            logger.error(f"Delegate request error: {e}")
            raise Exception(f"Failed to delegate request: {str(e)}")

    async def escalate_request(
        self,
        request_id: str,
        admin_id: str,
        admin_role: str,
        escalate_data: ApprovalEscalateRequest,
        ip_address: Optional[str] = None,
        user_agent: Optional[str] = None
    ) -> ApprovalRequestResponse:
        """Escalate an approval request to a higher level"""
        try:
            request = await self.get_request(request_id, include_actions=False, include_comments=False)

            if request.status not in [ApprovalStatus.PENDING_REVIEW.value, ApprovalStatus.UNDER_REVIEW.value]:
                raise Exception(f"Cannot escalate request in {request.status} status")

            admin_level = self._get_admin_level(admin_role)
            if admin_level < 2:
                raise Exception("Your role does not have escalation authority")

            current_level = request.current_approval_level
            new_level = min(current_level + 1, 3)

            if new_level == current_level:
                raise Exception("Request is already at the highest approval level")

            update_data = {
                'status': ApprovalStatus.ESCALATED.value,
                'current_approval_level': new_level,
                'updated_at': datetime.utcnow().isoformat()
            }

            response = self.db.table('approval_requests').update(update_data).eq('id', request_id).execute()

            if not response.data:
                raise Exception("Failed to escalate request")

            # Record the action
            action = {
                'id': str(uuid4()),
                'request_id': request_id,
                'reviewer_id': admin_id,
                'reviewer_role': admin_role,
                'reviewer_level': admin_level,
                'action_type': ReviewActionType.ESCALATE.value,
                'escalated_to_level': new_level,
                'escalation_reason': escalate_data.reason,
                'acted_at': datetime.utcnow().isoformat(),
                'ip_address': ip_address,
                'user_agent': user_agent
            }
            self.db.table('approval_actions').insert(action).execute()

            # Create audit log
            await self._create_audit_log(
                request_id=request_id,
                actor_id=admin_id,
                actor_role=admin_role,
                event_type='request_escalated',
                event_description=f"Escalated to level {new_level}: {escalate_data.reason}",
                previous_state={'level': current_level},
                new_state={'level': new_level, 'status': ApprovalStatus.ESCALATED.value},
                ip_address=ip_address,
                user_agent=user_agent
            )

            # Notify higher level approvers
            updated_request = response.data[0]
            await self._notify_approvers(
                request=updated_request,
                notification_type='approval_request_escalated',
                title='Request Escalated',
                message=f"Request {request.request_number} has been escalated for your review"
            )

            logger.info(f"Approval request escalated: {request_id} to level {new_level}")

            return await self.get_request(request_id)

        except Exception as e:
            logger.error(f"Escalate request error: {e}")
            raise Exception(f"Failed to escalate request: {str(e)}")

    async def _execute_approved_action(
        self,
        request_id: str,
        admin_id: str,
        admin_role: str,
        ip_address: Optional[str] = None,
        user_agent: Optional[str] = None
    ) -> None:
        """Execute the approved action"""
        try:
            request = await self.get_request(request_id, include_actions=False, include_comments=False)

            if request.status != ApprovalStatus.APPROVED.value:
                return

            # TODO: Implement actual action execution based on action_type
            # This would involve calling the appropriate service methods
            # For now, just mark as executed

            execution_result = {
                'executed_by': admin_id,
                'executed_at': datetime.utcnow().isoformat(),
                'success': True,
                'message': 'Action executed successfully'
            }

            update_data = {
                'status': ApprovalStatus.EXECUTED.value,
                'executed_at': datetime.utcnow().isoformat(),
                'execution_result': execution_result,
                'updated_at': datetime.utcnow().isoformat()
            }

            self.db.table('approval_requests').update(update_data).eq('id', request_id).execute()

            # Create audit log
            await self._create_audit_log(
                request_id=request_id,
                actor_id=admin_id,
                actor_role=admin_role,
                event_type='action_executed',
                event_description='Approved action executed successfully',
                new_state={'status': ApprovalStatus.EXECUTED.value, 'result': execution_result},
                ip_address=ip_address,
                user_agent=user_agent
            )

            logger.info(f"Action executed for approval: {request_id}")

        except Exception as e:
            logger.error(f"Execute action error: {e}")
            # Update status to failed
            self.db.table('approval_requests').update({
                'status': ApprovalStatus.FAILED.value,
                'execution_result': {'error': str(e)},
                'updated_at': datetime.utcnow().isoformat()
            }).eq('id', request_id).execute()

    # =========================================================================
    # Comments
    # =========================================================================

    async def add_comment(
        self,
        request_id: str,
        admin_id: str,
        admin_role: str,
        comment_data: ApprovalCommentCreate
    ) -> ApprovalCommentResponse:
        """Add a comment to an approval request"""
        try:
            # Verify request exists
            await self.get_request(request_id, include_actions=False, include_comments=False)

            if not self._is_admin(admin_role):
                raise Exception("Only administrators can comment on approval requests")

            comment = {
                'id': str(uuid4()),
                'request_id': request_id,
                'author_id': admin_id,
                'author_role': admin_role,
                'content': comment_data.content,
                'is_internal': comment_data.is_internal,
                'attachments': comment_data.attachments,
                'parent_comment_id': comment_data.parent_comment_id,
                'created_at': datetime.utcnow().isoformat()
            }

            response = self.db.table('approval_comments').insert(comment).execute()

            if not response.data:
                raise Exception("Failed to add comment")

            comment_result = response.data[0]
            user_info = await self._get_user_info(admin_id)
            comment_result['author_name'] = user_info['name']
            comment_result['author_email'] = user_info['email']
            comment_result['replies'] = []

            logger.info(f"Comment added to approval: {request_id}")

            return ApprovalCommentResponse(**comment_result)

        except Exception as e:
            logger.error(f"Add comment error: {e}")
            raise Exception(f"Failed to add comment: {str(e)}")

    async def update_comment(
        self,
        request_id: str,
        comment_id: str,
        admin_id: str,
        admin_role: str,
        comment_data: ApprovalCommentUpdate
    ) -> ApprovalCommentResponse:
        """Update a comment"""
        try:
            # Verify comment exists and belongs to user
            comment_response = self.db.table('approval_comments').select('*').eq('id', comment_id).eq('request_id', request_id).single().execute()

            if not comment_response.data:
                raise Exception("Comment not found")

            if comment_response.data['author_id'] != admin_id:
                raise Exception("Can only update your own comments")

            update_data = {
                'content': comment_data.content,
                'updated_at': datetime.utcnow().isoformat()
            }

            response = self.db.table('approval_comments').update(update_data).eq('id', comment_id).execute()

            if not response.data:
                raise Exception("Failed to update comment")

            comment_result = response.data[0]
            user_info = await self._get_user_info(admin_id)
            comment_result['author_name'] = user_info['name']
            comment_result['author_email'] = user_info['email']
            comment_result['replies'] = []

            logger.info(f"Comment updated: {comment_id}")

            return ApprovalCommentResponse(**comment_result)

        except Exception as e:
            logger.error(f"Update comment error: {e}")
            raise Exception(f"Failed to update comment: {str(e)}")

    async def delete_comment(
        self,
        request_id: str,
        comment_id: str,
        admin_id: str,
        admin_role: str
    ) -> Dict[str, str]:
        """Soft delete a comment"""
        try:
            comment_response = self.db.table('approval_comments').select('*').eq('id', comment_id).eq('request_id', request_id).single().execute()

            if not comment_response.data:
                raise Exception("Comment not found")

            if comment_response.data['author_id'] != admin_id and admin_role != 'super_admin':
                raise Exception("Can only delete your own comments")

            update_data = {
                'deleted_at': datetime.utcnow().isoformat()
            }

            self.db.table('approval_comments').update(update_data).eq('id', comment_id).execute()

            logger.info(f"Comment deleted: {comment_id}")

            return {'message': 'Comment deleted successfully'}

        except Exception as e:
            logger.error(f"Delete comment error: {e}")
            raise Exception(f"Failed to delete comment: {str(e)}")

    # =========================================================================
    # Dashboard & Statistics
    # =========================================================================

    async def get_statistics(
        self,
        admin_id: str,
        admin_role: str,
        regional_scope: Optional[str] = None
    ) -> ApprovalStatistics:
        """Get approval workflow statistics"""
        try:
            if not self._is_admin(admin_role):
                raise Exception("Only administrators can view statistics")

            query = self.db.table('approval_requests').select('*')

            if regional_scope:
                query = query.eq('regional_scope', regional_scope)

            response = query.execute()

            requests = response.data or []

            # Calculate statistics
            now = datetime.utcnow()
            today_start = now.replace(hour=0, minute=0, second=0, microsecond=0)
            week_start = today_start - timedelta(days=now.weekday())
            month_start = now.replace(day=1, hour=0, minute=0, second=0, microsecond=0)

            by_status = {}
            by_request_type = {}
            by_action_type = {}
            by_priority = {}
            requests_today = 0
            requests_this_week = 0
            requests_this_month = 0
            total_approval_time = 0
            approved_count = 0

            for req in requests:
                status = req.get('status', 'unknown')
                by_status[status] = by_status.get(status, 0) + 1

                req_type = req.get('request_type', 'unknown')
                by_request_type[req_type] = by_request_type.get(req_type, 0) + 1

                action_type = req.get('action_type', 'unknown')
                by_action_type[action_type] = by_action_type.get(action_type, 0) + 1

                priority = req.get('priority', 'normal')
                by_priority[priority] = by_priority.get(priority, 0) + 1

                created_at = datetime.fromisoformat(req.get('created_at', now.isoformat()).replace('Z', '+00:00'))
                if created_at >= today_start.replace(tzinfo=created_at.tzinfo):
                    requests_today += 1
                if created_at >= week_start.replace(tzinfo=created_at.tzinfo):
                    requests_this_week += 1
                if created_at >= month_start.replace(tzinfo=created_at.tzinfo):
                    requests_this_month += 1

                # Calculate average approval time
                if status in ['approved', 'executed']:
                    approved_count += 1
                    updated_at = datetime.fromisoformat(req.get('updated_at', now.isoformat()).replace('Z', '+00:00'))
                    total_approval_time += (updated_at - created_at).total_seconds() / 3600

            total = len(requests)
            approved = by_status.get('approved', 0) + by_status.get('executed', 0)
            decided = approved + by_status.get('denied', 0)

            return ApprovalStatistics(
                total_requests=total,
                pending_requests=by_status.get('pending_review', 0),
                under_review_requests=by_status.get('under_review', 0),
                awaiting_info_requests=by_status.get('awaiting_info', 0),
                approved_requests=by_status.get('approved', 0),
                denied_requests=by_status.get('denied', 0),
                withdrawn_requests=by_status.get('withdrawn', 0),
                expired_requests=by_status.get('expired', 0),
                executed_requests=by_status.get('executed', 0),
                failed_requests=by_status.get('failed', 0),
                requests_today=requests_today,
                requests_this_week=requests_this_week,
                requests_this_month=requests_this_month,
                avg_approval_time_hours=total_approval_time / approved_count if approved_count > 0 else None,
                approval_rate=(approved / decided * 100) if decided > 0 else None,
                by_request_type=by_request_type,
                by_action_type=by_action_type,
                by_priority=by_priority
            )

        except Exception as e:
            logger.error(f"Get statistics error: {e}")
            raise Exception(f"Failed to get statistics: {str(e)}")

    async def get_my_pending_actions(
        self,
        admin_id: str,
        admin_role: str
    ) -> MyPendingActionsResponse:
        """Get pending actions for the current admin"""
        try:
            if not self._is_admin(admin_role):
                raise Exception("Only administrators can view pending actions")

            admin_level = self._get_admin_level(admin_role)
            pending_reviews = []
            awaiting_my_info = []
            delegated_to_me = []

            # Get requests awaiting info from this admin
            if True:  # All admins can have info requests
                info_response = self.db.table('approval_requests').select('*').eq('status', ApprovalStatus.AWAITING_INFO.value).eq('initiated_by', admin_id).execute()
                if info_response.data:
                    for req in info_response.data:
                        awaiting_my_info.append(PendingApprovalItem(
                            id=req['id'],
                            request_number=req['request_number'],
                            request_type=req['request_type'],
                            action_type=req['action_type'],
                            priority=req['priority'],
                            status=req['status'],
                            initiated_by=req['initiated_by'],
                            target_resource_type=req['target_resource_type'],
                            current_approval_level=req['current_approval_level'],
                            created_at=req['created_at'],
                            expires_at=req.get('expires_at')
                        ))

            # Get requests delegated to this admin
            delegated_response = self.db.table('approval_actions').select('request_id').eq('delegated_to', admin_id).eq('action_type', ReviewActionType.DELEGATE.value).execute()
            if delegated_response.data:
                delegated_ids = [d['request_id'] for d in delegated_response.data]
                delegated_requests = self.db.table('approval_requests').select('*').in_('id', delegated_ids).in_('status', [ApprovalStatus.PENDING_REVIEW.value, ApprovalStatus.UNDER_REVIEW.value]).execute()
                if delegated_requests.data:
                    for req in delegated_requests.data:
                        delegated_to_me.append(PendingApprovalItem(
                            id=req['id'],
                            request_number=req['request_number'],
                            request_type=req['request_type'],
                            action_type=req['action_type'],
                            priority=req['priority'],
                            status=req['status'],
                            initiated_by=req['initiated_by'],
                            target_resource_type=req['target_resource_type'],
                            current_approval_level=req['current_approval_level'],
                            created_at=req['created_at'],
                            expires_at=req.get('expires_at')
                        ))

            # Get requests needing review at this admin's level
            if admin_level >= 2:
                review_query = self.db.table('approval_requests').select('*').in_('status', [ApprovalStatus.PENDING_REVIEW.value, ApprovalStatus.UNDER_REVIEW.value, ApprovalStatus.ESCALATED.value]).lte('current_approval_level', admin_level)
                review_response = review_query.execute()
                if review_response.data:
                    for req in review_response.data:
                        user_info = await self._get_user_info(req['initiated_by'])
                        pending_reviews.append(PendingApprovalItem(
                            id=req['id'],
                            request_number=req['request_number'],
                            request_type=req['request_type'],
                            action_type=req['action_type'],
                            priority=req['priority'],
                            status=req['status'],
                            initiated_by=req['initiated_by'],
                            initiator_name=user_info['name'],
                            target_resource_type=req['target_resource_type'],
                            current_approval_level=req['current_approval_level'],
                            created_at=req['created_at'],
                            expires_at=req.get('expires_at')
                        ))

            total = len(pending_reviews) + len(awaiting_my_info) + len(delegated_to_me)

            return MyPendingActionsResponse(
                pending_reviews=pending_reviews,
                awaiting_my_info=awaiting_my_info,
                delegated_to_me=delegated_to_me,
                total=total
            )

        except Exception as e:
            logger.error(f"Get pending actions error: {e}")
            raise Exception(f"Failed to get pending actions: {str(e)}")

    async def get_my_requests(
        self,
        admin_id: str,
        admin_role: str,
        page: int = 1,
        page_size: int = 20
    ) -> MySubmittedRequestsResponse:
        """Get requests submitted by the current admin"""
        try:
            if not self._is_admin(admin_role):
                raise Exception("Only administrators can view their requests")

            query = self.db.table('approval_requests').select('*', count='exact').eq('initiated_by', admin_id)

            offset = (page - 1) * page_size
            query = query.order('created_at', desc=True).range(offset, offset + page_size - 1)

            response = query.execute()

            requests = []
            if response.data:
                for req_data in response.data:
                    req_data['initiator_name'] = None
                    req_data['initiator_email'] = None
                    req_data['actions'] = []
                    req_data['comments'] = []
                    requests.append(ApprovalRequestResponse(**req_data))

            total = response.count or 0

            return MySubmittedRequestsResponse(
                requests=requests,
                total=total,
                page=page,
                page_size=page_size,
                has_more=(offset + page_size) < total
            )

        except Exception as e:
            logger.error(f"Get my requests error: {e}")
            raise Exception(f"Failed to get submitted requests: {str(e)}")

    # =========================================================================
    # Configuration Management (Super Admin only)
    # =========================================================================

    async def list_configs(
        self,
        admin_id: str,
        admin_role: str
    ) -> ApprovalConfigListResponse:
        """List all approval configurations"""
        try:
            if not self._is_admin(admin_role):
                raise Exception("Only administrators can view configurations")

            response = self.db.table('approval_config').select('*').order('request_type').order('action_type').execute()

            configs = []
            if response.data:
                for config_data in response.data:
                    configs.append(ApprovalConfigResponse(**config_data))

            return ApprovalConfigListResponse(
                configs=configs,
                total=len(configs)
            )

        except Exception as e:
            logger.error(f"List configs error: {e}")
            raise Exception(f"Failed to list configurations: {str(e)}")

    async def update_config(
        self,
        config_id: str,
        admin_id: str,
        admin_role: str,
        update_data: ApprovalConfigUpdate
    ) -> ApprovalConfigResponse:
        """Update an approval configuration (Super Admin only)"""
        try:
            if admin_role != 'super_admin':
                raise Exception("Only Super Admins can modify configurations")

            update_dict = {'updated_at': datetime.utcnow().isoformat()}

            if update_data.can_skip_levels is not None:
                update_dict['can_skip_levels'] = update_data.can_skip_levels
            if update_data.skip_level_conditions is not None:
                update_dict['skip_level_conditions'] = update_data.skip_level_conditions
            if update_data.default_priority is not None:
                update_dict['default_priority'] = update_data.default_priority.value
            if update_data.default_expiration_hours is not None:
                update_dict['default_expiration_hours'] = update_data.default_expiration_hours
            if update_data.requires_mfa is not None:
                update_dict['requires_mfa'] = update_data.requires_mfa
            if update_data.auto_execute is not None:
                update_dict['auto_execute'] = update_data.auto_execute
            if update_data.notification_channels is not None:
                update_dict['notification_channels'] = update_data.notification_channels
            if update_data.is_active is not None:
                update_dict['is_active'] = update_data.is_active
            if update_data.description is not None:
                update_dict['description'] = update_data.description

            response = self.db.table('approval_config').update(update_dict).eq('id', config_id).execute()

            if not response.data:
                raise Exception("Configuration not found or update failed")

            logger.info(f"Approval config updated: {config_id} by {admin_id}")

            return ApprovalConfigResponse(**response.data[0])

        except Exception as e:
            logger.error(f"Update config error: {e}")
            raise Exception(f"Failed to update configuration: {str(e)}")

    # =========================================================================
    # Audit Log
    # =========================================================================

    async def get_request_audit_log(
        self,
        request_id: str,
        admin_id: str,
        admin_role: str,
        page: int = 1,
        page_size: int = 50
    ) -> ApprovalAuditLogResponse:
        """Get audit log for a specific request"""
        try:
            admin_level = self._get_admin_level(admin_role)
            if admin_level < 2:
                raise Exception("Only Regional and Super Admins can view audit logs")

            offset = (page - 1) * page_size
            query = self.db.table('approval_audit_log').select('*', count='exact').eq('request_id', request_id).order('timestamp', desc=True).range(offset, offset + page_size - 1)

            response = query.execute()

            entries = []
            if response.data:
                for entry_data in response.data:
                    user_info = await self._get_user_info(entry_data['actor_id'])
                    entry_data['actor_name'] = user_info['name']
                    entry_data['actor_email'] = user_info['email']
                    entries.append(ApprovalAuditLogEntry(**entry_data))

            total = response.count or 0

            return ApprovalAuditLogResponse(
                entries=entries,
                total=total,
                page=page,
                page_size=page_size,
                has_more=(offset + page_size) < total
            )

        except Exception as e:
            logger.error(f"Get audit log error: {e}")
            raise Exception(f"Failed to get audit log: {str(e)}")

    async def get_system_audit_log(
        self,
        admin_id: str,
        admin_role: str,
        from_date: Optional[str] = None,
        to_date: Optional[str] = None,
        event_type: Optional[str] = None,
        page: int = 1,
        page_size: int = 50
    ) -> ApprovalAuditLogResponse:
        """Get system-wide audit log"""
        try:
            if admin_role != 'super_admin':
                raise Exception("Only Super Admins can view system-wide audit logs")

            query = self.db.table('approval_audit_log').select('*', count='exact')

            if from_date:
                query = query.gte('timestamp', from_date)
            if to_date:
                query = query.lte('timestamp', to_date)
            if event_type:
                query = query.eq('event_type', event_type)

            offset = (page - 1) * page_size
            query = query.order('timestamp', desc=True).range(offset, offset + page_size - 1)

            response = query.execute()

            entries = []
            if response.data:
                for entry_data in response.data:
                    user_info = await self._get_user_info(entry_data['actor_id'])
                    entry_data['actor_name'] = user_info['name']
                    entry_data['actor_email'] = user_info['email']
                    entries.append(ApprovalAuditLogEntry(**entry_data))

            total = response.count or 0

            return ApprovalAuditLogResponse(
                entries=entries,
                total=total,
                page=page,
                page_size=page_size,
                has_more=(offset + page_size) < total
            )

        except Exception as e:
            logger.error(f"Get system audit log error: {e}")
            raise Exception(f"Failed to get system audit log: {str(e)}")
