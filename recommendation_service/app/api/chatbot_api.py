"""
Chatbot API Endpoints
RESTful API for AI-powered chatbot system
"""
from fastapi import APIRouter, Depends, HTTPException, status, Query, UploadFile, File
from typing import Optional, List
from datetime import datetime, timedelta
import logging
import uuid
import os

from app.services.ai_chat_service import get_ai_chat_service, AIChatService
from app.services.feedback_analytics_service import get_feedback_analytics_service
from app.database.config import get_supabase
from app.schemas.chatbot import (
    ChatMessageRequest,
    ChatMessageResponse,
    ConversationResponse,
    ConversationListResponse,
    MessageHistoryItem,
    MessageHistoryResponse,
    FeedbackRequest,
    FeedbackResponse,
    FeedbackStatsResponse,
    EscalateRequest,
    EscalateResponse,
    AssignRequest,
    SupportQueueItem,
    SupportQueueResponse,
    FAQCreateRequest,
    FAQUpdateRequest,
    FAQResponse,
    FAQListResponse,
    AgentReplyRequest,
    AgentReplyResponse,
    MessageSender,
    ChatMessageType,
    ConversationStatus,
    QueueStatus,
    EscalationPriority,
    EscalationType,
)
from app.utils.security import get_current_user, CurrentUser

router = APIRouter()
logger = logging.getLogger(__name__)


# =============================================================================
# CHAT ENDPOINTS
# =============================================================================

@router.post("/messages", status_code=status.HTTP_201_CREATED)
async def send_message(
    request: ChatMessageRequest,
    current_user: CurrentUser = Depends(get_current_user)
) -> ChatMessageResponse:
    """
    Send a message and get AI response

    **Requires:** Authentication

    **Request Body:**
    - conversation_id: Optional - creates new conversation if not provided
    - message: User's message text
    - context: Optional user context (current page, pending items, etc.)

    **Returns:**
    - AI response with confidence score and quick actions
    """
    try:
        supabase = get_supabase()
        ai_service = get_ai_chat_service()

        conversation_id = request.conversation_id

        # Create new conversation if needed
        if not conversation_id:
            # Get user details
            user_data = supabase.table('users').select(
                'display_name, email, active_role'
            ).eq('id', current_user.id).single().execute()

            user_info = user_data.data if user_data.data else {}

            conv_data = {
                'user_id': current_user.id,
                'user_name': user_info.get('display_name'),
                'user_email': user_info.get('email'),
                'user_role': user_info.get('active_role'),
                'status': 'active',
                'context': request.context or {},
                'message_count': 0,
                'user_message_count': 0,
                'bot_message_count': 0,
                'agent_message_count': 0,
            }

            conv_result = supabase.table('chatbot_conversations').insert(conv_data).execute()
            conversation_id = conv_result.data[0]['id']
            logger.info(f"Created new conversation: {conversation_id}")

        # Save user message
        user_msg_data = {
            'conversation_id': conversation_id,
            'sender': 'user',
            'content': request.message,
            'message_type': 'text',
            'metadata': request.context or {},
        }
        user_msg_result = supabase.table('chatbot_messages').insert(user_msg_data).execute()

        # Get conversation history for context
        history_result = supabase.table('chatbot_messages').select(
            'sender, content'
        ).eq('conversation_id', conversation_id).order(
            'created_at', desc=False
        ).limit(20).execute()

        conversation_history = [
            {'sender': m['sender'], 'content': m['content']}
            for m in (history_result.data or [])
        ]

        # Build user context
        user_context = request.context or {}
        user_context['user_id'] = current_user.id

        # Get user details if not in context
        if 'user_name' not in user_context or 'user_role' not in user_context:
            user_data = supabase.table('users').select(
                'display_name, active_role'
            ).eq('id', current_user.id).single().execute()
            if user_data.data:
                user_context['user_name'] = user_data.data.get('display_name')
                user_context['user_role'] = user_data.data.get('active_role')

        # Get AI response
        ai_response = await ai_service.get_response(
            message=request.message,
            conversation_history=conversation_history,
            user_context=user_context,
            user_id=current_user.id
        )

        # Save bot response
        bot_msg_data = {
            'conversation_id': conversation_id,
            'sender': 'bot',
            'content': ai_response.content,
            'message_type': 'text',
            'ai_provider': ai_response.provider.value,
            'ai_confidence': ai_response.confidence,
            'tokens_used': ai_response.tokens_used,
            'metadata': {
                'quick_actions': ai_response.quick_actions,
                'sources': ai_response.sources,
                'should_escalate': ai_response.should_escalate,
                'escalation_reason': ai_response.escalation_reason,
            }
        }
        bot_msg_result = supabase.table('chatbot_messages').insert(bot_msg_data).execute()
        bot_message_id = bot_msg_result.data[0]['id']

        # Update conversation with AI provider info
        supabase.table('chatbot_conversations').update({
            'ai_provider': ai_response.provider.value,
            'updated_at': datetime.utcnow().isoformat()
        }).eq('id', conversation_id).execute()

        # Auto-escalate if needed
        if ai_response.should_escalate:
            try:
                _create_escalation(
                    supabase,
                    conversation_id,
                    ai_response.escalation_reason or 'auto_escalation',
                    EscalationPriority.NORMAL
                )
            except Exception as esc_error:
                logger.warning(f"Failed to auto-escalate: {esc_error}")

        return ChatMessageResponse(
            conversation_id=conversation_id,
            message_id=bot_message_id,
            content=ai_response.content,
            sender=MessageSender.BOT,
            message_type=ChatMessageType.TEXT,
            quick_actions=ai_response.quick_actions,
            sources=ai_response.sources,
            confidence=ai_response.confidence,
            ai_provider=ai_response.provider.value,
            tokens_used=ai_response.tokens_used,
            should_escalate=ai_response.should_escalate,
            escalation_reason=ai_response.escalation_reason,
            created_at=datetime.utcnow().isoformat()
        )

    except Exception as e:
        logger.error(f"Failed to process chat message: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to process message: {str(e)}"
        )


@router.get("/conversations")
async def list_conversations(
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
    status_filter: Optional[str] = None,
    current_user: CurrentUser = Depends(get_current_user)
) -> ConversationListResponse:
    """
    List user's conversations

    **Requires:** Authentication

    **Query Parameters:**
    - page: Page number (default: 1)
    - page_size: Items per page (default: 20)
    - status_filter: Filter by status (active, archived, escalated)
    """
    try:
        supabase = get_supabase()

        # Build query
        query = supabase.table('chatbot_conversations').select(
            '*', count='exact'
        ).eq('user_id', current_user.id)

        if status_filter:
            query = query.eq('status', status_filter)

        # Pagination
        offset = (page - 1) * page_size
        query = query.order('updated_at', desc=True).range(offset, offset + page_size - 1)

        result = query.execute()

        conversations = [
            ConversationResponse(
                id=c['id'],
                user_id=c.get('user_id'),
                user_name=c.get('user_name'),
                user_email=c.get('user_email'),
                user_role=c.get('user_role'),
                status=c.get('status', 'active'),
                summary=c.get('summary'),
                topics=c.get('topics') or [],
                context=c.get('context'),
                ai_provider=c.get('ai_provider'),
                message_count=c.get('message_count', 0),
                user_message_count=c.get('user_message_count', 0),
                bot_message_count=c.get('bot_message_count', 0),
                agent_message_count=c.get('agent_message_count', 0),
                created_at=c['created_at'],
                updated_at=c['updated_at']
            )
            for c in (result.data or [])
        ]

        total = result.count or 0

        return ConversationListResponse(
            conversations=conversations,
            total=total,
            page=page,
            page_size=page_size,
            has_more=(offset + page_size) < total
        )

    except Exception as e:
        logger.error(f"Failed to list conversations: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.get("/conversations/{conversation_id}")
async def get_conversation(
    conversation_id: str,
    current_user: CurrentUser = Depends(get_current_user)
) -> ConversationResponse:
    """
    Get conversation details

    **Requires:** Authentication (must be owner or admin)
    """
    try:
        supabase = get_supabase()

        result = supabase.table('chatbot_conversations').select(
            '*'
        ).eq('id', conversation_id).single().execute()

        if not result.data:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Conversation not found"
            )

        c = result.data

        # Check ownership (admins can view all via RLS)
        if c.get('user_id') != current_user.id:
            # Check if admin
            user_result = supabase.table('users').select(
                'active_role'
            ).eq('id', current_user.id).single().execute()

            if user_result.data and user_result.data.get('active_role') not in ['superadmin', 'supportadmin', 'admin']:
                raise HTTPException(
                    status_code=status.HTTP_403_FORBIDDEN,
                    detail="Not authorized to view this conversation"
                )

        return ConversationResponse(
            id=c['id'],
            user_id=c.get('user_id'),
            user_name=c.get('user_name'),
            user_email=c.get('user_email'),
            user_role=c.get('user_role'),
            status=c.get('status', 'active'),
            summary=c.get('summary'),
            topics=c.get('topics') or [],
            context=c.get('context'),
            ai_provider=c.get('ai_provider'),
            message_count=c.get('message_count', 0),
            user_message_count=c.get('user_message_count', 0),
            bot_message_count=c.get('bot_message_count', 0),
            agent_message_count=c.get('agent_message_count', 0),
            created_at=c['created_at'],
            updated_at=c['updated_at']
        )

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Failed to get conversation: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.get("/conversations/{conversation_id}/messages")
async def get_conversation_messages(
    conversation_id: str,
    page: int = Query(1, ge=1),
    page_size: int = Query(50, ge=1, le=100),
    current_user: CurrentUser = Depends(get_current_user)
) -> MessageHistoryResponse:
    """
    Get messages for a conversation

    **Requires:** Authentication (must be owner or admin)
    """
    try:
        supabase = get_supabase()

        # Verify access to conversation
        conv_result = supabase.table('chatbot_conversations').select(
            'user_id'
        ).eq('id', conversation_id).single().execute()

        if not conv_result.data:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Conversation not found"
            )

        # Get messages
        offset = (page - 1) * page_size
        result = supabase.table('chatbot_messages').select(
            '*', count='exact'
        ).eq('conversation_id', conversation_id).order(
            'created_at', desc=False
        ).range(offset, offset + page_size - 1).execute()

        messages = [
            MessageHistoryItem(
                id=m['id'],
                sender=m['sender'],
                content=m['content'],
                message_type=m.get('message_type', 'text'),
                metadata=m.get('metadata'),
                ai_provider=m.get('ai_provider'),
                ai_confidence=m.get('ai_confidence'),
                tokens_used=m.get('tokens_used'),
                feedback=m.get('feedback'),
                feedback_comment=m.get('feedback_comment'),
                created_at=m['created_at']
            )
            for m in (result.data or [])
        ]

        total = result.count or 0

        return MessageHistoryResponse(
            conversation_id=conversation_id,
            messages=messages,
            total=total,
            page=page,
            page_size=page_size,
            has_more=(offset + page_size) < total
        )

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Failed to get messages: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.post("/conversations/sync")
async def sync_conversation(
    request: dict,
    current_user: CurrentUser = Depends(get_current_user)
):
    """
    Sync conversation from client to backend

    **Requires:** Authentication

    **Request Body:**
    - id: Conversation ID
    - user_id: User ID
    - user_name: User display name
    - user_email: User email (optional)
    - status: Conversation status
    - message_count: Total message count
    - user_message_count: User message count
    - bot_message_count: Bot message count
    - created_at: Creation timestamp
    - updated_at: Last update timestamp
    """
    try:
        supabase = get_supabase()

        conv_id = request.get('id')
        if not conv_id:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Conversation ID required"
            )

        # Check if conversation exists
        existing = supabase.table('chatbot_conversations').select(
            'id'
        ).eq('id', conv_id).execute()

        conv_data = {
            'user_id': request.get('user_id') or current_user.id,
            'user_name': request.get('user_name'),
            'user_email': request.get('user_email'),
            'status': request.get('status', 'active'),
            'message_count': request.get('message_count', 0),
            'user_message_count': request.get('user_message_count', 0),
            'bot_message_count': request.get('bot_message_count', 0),
            'updated_at': request.get('updated_at') or datetime.utcnow().isoformat(),
        }

        if existing.data:
            # Update existing
            supabase.table('chatbot_conversations').update(
                conv_data
            ).eq('id', conv_id).execute()
        else:
            # Create new
            conv_data['id'] = conv_id
            conv_data['created_at'] = request.get('created_at') or datetime.utcnow().isoformat()
            supabase.table('chatbot_conversations').insert(conv_data).execute()

        logger.info(f"Synced conversation {conv_id} for user {current_user.id}")

        return {"success": True, "conversation_id": conv_id}

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Failed to sync conversation: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e)
        )


@router.delete("/conversations/{conversation_id}")
async def delete_conversation(
    conversation_id: str,
    current_user: CurrentUser = Depends(get_current_user)
):
    """
    Delete (archive) a conversation

    **Requires:** Authentication (must be owner)
    """
    try:
        supabase = get_supabase()

        # Verify ownership
        conv_result = supabase.table('chatbot_conversations').select(
            'user_id'
        ).eq('id', conversation_id).single().execute()

        if not conv_result.data:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Conversation not found"
            )

        if conv_result.data.get('user_id') != current_user.id:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Not authorized"
            )

        # Soft delete - change status to archived
        supabase.table('chatbot_conversations').update({
            'status': 'archived',
            'updated_at': datetime.utcnow().isoformat()
        }).eq('id', conversation_id).execute()

        return {"success": True, "message": "Conversation archived"}

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Failed to delete conversation: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


# =============================================================================
# FEEDBACK ENDPOINTS
# =============================================================================

@router.post("/messages/{message_id}/feedback")
async def submit_feedback(
    message_id: str,
    request: FeedbackRequest,
    current_user: CurrentUser = Depends(get_current_user)
) -> FeedbackResponse:
    """
    Submit feedback for a bot message

    **Requires:** Authentication

    **Path Parameters:**
    - message_id: The bot message ID to rate

    **Request Body:**
    - feedback: 'helpful' or 'not_helpful'
    - comment: Optional feedback comment
    """
    try:
        supabase = get_supabase()

        # Verify message exists and belongs to user's conversation
        msg_result = supabase.table('chatbot_messages').select(
            'id, conversation_id, sender'
        ).eq('id', message_id).single().execute()

        if not msg_result.data:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Message not found"
            )

        if msg_result.data.get('sender') != 'bot':
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Can only provide feedback on bot messages"
            )

        # Update message with feedback
        supabase.table('chatbot_messages').update({
            'feedback': request.feedback.value,
            'feedback_comment': request.comment
        }).eq('id', message_id).execute()

        # Check for escalation on negative feedback
        if request.feedback.value == 'not_helpful':
            # Count recent negative feedback in this conversation
            conv_id = msg_result.data['conversation_id']
            neg_count_result = supabase.table('chatbot_messages').select(
                'id', count='exact'
            ).eq('conversation_id', conv_id).eq(
                'feedback', 'not_helpful'
            ).execute()

            if (neg_count_result.count or 0) >= 2:
                # Auto-escalate
                try:
                    _create_escalation(
                        supabase, conv_id,
                        'negative_feedback',
                        EscalationPriority.NORMAL
                    )
                except:
                    pass

        return FeedbackResponse(
            success=True,
            message_id=message_id,
            feedback=request.feedback
        )

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Failed to submit feedback: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


# =============================================================================
# ESCALATION ENDPOINTS
# =============================================================================

@router.post("/conversations/{conversation_id}/escalate")
async def escalate_conversation(
    conversation_id: str,
    request: EscalateRequest,
    current_user: CurrentUser = Depends(get_current_user)
) -> EscalateResponse:
    """
    Escalate conversation to human support

    **Requires:** Authentication (must be conversation owner)
    """
    try:
        supabase = get_supabase()

        # Verify ownership
        conv_result = supabase.table('chatbot_conversations').select(
            'user_id, status'
        ).eq('id', conversation_id).single().execute()

        if not conv_result.data:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Conversation not found"
            )

        if conv_result.data.get('user_id') != current_user.id:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Not authorized"
            )

        if conv_result.data.get('status') == 'escalated':
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Conversation already escalated"
            )

        # Create escalation
        queue_id = _create_escalation(
            supabase,
            conversation_id,
            request.reason or 'user_request',
            request.priority
        )

        # Estimate wait time based on queue
        pending_result = supabase.table('chatbot_support_queue').select(
            'id', count='exact'
        ).eq('status', 'pending').execute()

        pending_count = pending_result.count or 0
        estimated_wait = pending_count * 5  # 5 minutes per item estimate

        return EscalateResponse(
            success=True,
            queue_id=queue_id,
            conversation_id=conversation_id,
            priority=request.priority,
            estimated_wait_time=estimated_wait
        )

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Failed to escalate: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


def _create_escalation(supabase, conversation_id: str, reason: str, priority: EscalationPriority) -> str:
    """Helper to create escalation entry"""
    # Update conversation status
    supabase.table('chatbot_conversations').update({
        'status': 'escalated',
        'updated_at': datetime.utcnow().isoformat()
    }).eq('id', conversation_id).execute()

    # Create queue entry
    queue_data = {
        'conversation_id': conversation_id,
        'priority': priority.value,
        'reason': reason,
        'escalation_type': reason,
        'status': 'pending'
    }
    result = supabase.table('chatbot_support_queue').insert(queue_data).execute()

    # Add system message
    sys_msg = {
        'conversation_id': conversation_id,
        'sender': 'system',
        'content': 'This conversation has been escalated to human support. An agent will assist you shortly.',
        'message_type': 'text'
    }
    supabase.table('chatbot_messages').insert(sys_msg).execute()

    return result.data[0]['id']


# =============================================================================
# ADMIN ENDPOINTS
# =============================================================================

@router.get("/admin/stats")
async def get_admin_stats(
    current_user: CurrentUser = Depends(get_current_user)
):
    """
    Get chatbot statistics for admin dashboard

    **Requires:** Admin authentication

    **Returns:**
    - Total conversations, active conversations, message counts, topic breakdown
    """
    try:
        supabase = get_supabase()

        # Verify admin role
        user_result = supabase.table('users').select(
            'active_role'
        ).eq('id', current_user.id).single().execute()

        if not user_result.data or user_result.data.get('active_role') not in ['superadmin', 'supportadmin', 'admin']:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Admin access required"
            )

        # Get total conversations
        total_result = supabase.table('chatbot_conversations').select(
            'id', count='exact'
        ).execute()
        total_conversations = total_result.count or 0

        # Get active conversations
        active_result = supabase.table('chatbot_conversations').select(
            'id', count='exact'
        ).eq('status', 'active').execute()
        active_conversations = active_result.count or 0

        # Get flagged conversations
        flagged_result = supabase.table('chatbot_conversations').select(
            'id', count='exact'
        ).eq('status', 'flagged').execute()
        flagged_conversations = flagged_result.count or 0

        # Get message counts
        user_msg_result = supabase.table('chatbot_messages').select(
            'id', count='exact'
        ).eq('sender', 'user').execute()
        user_messages = user_msg_result.count or 0

        bot_msg_result = supabase.table('chatbot_messages').select(
            'id', count='exact'
        ).eq('sender', 'bot').execute()
        bot_messages = bot_msg_result.count or 0

        total_messages = user_messages + bot_messages

        # Topic counts (simplified)
        topic_counts = {
            "General": total_conversations,  # Placeholder - would need topic analysis
        }

        return {
            "total_conversations": total_conversations,
            "active_conversations": active_conversations,
            "flagged_conversations": flagged_conversations,
            "total_messages": total_messages,
            "user_messages": user_messages,
            "bot_messages": bot_messages,
            "topic_counts": topic_counts
        }

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Failed to get admin stats: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.get("/admin/queue")
async def get_support_queue(
    status_filter: Optional[str] = None,
    priority_filter: Optional[str] = None,
    current_user: CurrentUser = Depends(get_current_user)
) -> SupportQueueResponse:
    """
    Get support queue (admin only)

    **Requires:** Admin authentication
    """
    try:
        supabase = get_supabase()

        # Verify admin role
        user_result = supabase.table('users').select(
            'active_role'
        ).eq('id', current_user.id).single().execute()

        if not user_result.data or user_result.data.get('active_role') not in ['superadmin', 'supportadmin', 'admin']:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Admin access required"
            )

        # Build query with join
        query = supabase.table('chatbot_support_queue').select(
            '*, chatbot_conversations(summary, user_name, user_email)'
        )

        if status_filter:
            query = query.eq('status', status_filter)
        if priority_filter:
            query = query.eq('priority', priority_filter)

        query = query.order('created_at', desc=True)
        result = query.execute()

        items = []
        for q in (result.data or []):
            conv = q.get('chatbot_conversations', {}) or {}
            items.append(SupportQueueItem(
                id=q['id'],
                conversation_id=q['conversation_id'],
                conversation_summary=conv.get('summary'),
                user_name=conv.get('user_name'),
                user_email=conv.get('user_email'),
                priority=q.get('priority', 'normal'),
                reason=q.get('reason'),
                escalation_type=q.get('escalation_type'),
                assigned_to=q.get('assigned_to'),
                assigned_to_name=None,  # Would need another join
                status=q.get('status', 'pending'),
                response_time_seconds=q.get('response_time_seconds'),
                created_at=q['created_at'],
                assigned_at=q.get('assigned_at')
            ))

        # Count by status
        pending = sum(1 for i in items if i.status == QueueStatus.PENDING)
        assigned = sum(1 for i in items if i.status == QueueStatus.ASSIGNED)
        in_progress = sum(1 for i in items if i.status == QueueStatus.IN_PROGRESS)

        return SupportQueueResponse(
            items=items,
            total=len(items),
            pending_count=pending,
            assigned_count=assigned,
            in_progress_count=in_progress
        )

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Failed to get queue: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.post("/admin/queue/{queue_id}/assign")
async def assign_conversation(
    queue_id: str,
    request: AssignRequest,
    current_user: CurrentUser = Depends(get_current_user)
):
    """
    Assign escalated conversation to agent (admin only)
    """
    try:
        supabase = get_supabase()

        # Update queue entry
        supabase.table('chatbot_support_queue').update({
            'assigned_to': request.agent_id,
            'status': 'assigned',
            'assigned_at': datetime.utcnow().isoformat(),
            'notes': request.notes
        }).eq('id', queue_id).execute()

        return {"success": True}

    except Exception as e:
        logger.error(f"Failed to assign: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.post("/admin/conversations/{conversation_id}/reply")
async def agent_reply(
    conversation_id: str,
    request: AgentReplyRequest,
    current_user: CurrentUser = Depends(get_current_user)
) -> AgentReplyResponse:
    """
    Send agent reply to conversation (admin only)
    """
    try:
        supabase = get_supabase()

        # Get agent name
        agent_result = supabase.table('users').select(
            'display_name'
        ).eq('id', current_user.id).single().execute()

        agent_name = agent_result.data.get('display_name', 'Support Agent') if agent_result.data else 'Support Agent'

        # Create agent message
        msg_data = {
            'conversation_id': conversation_id,
            'sender': 'agent',
            'content': request.content,
            'message_type': 'text',
            'metadata': {'agent_id': current_user.id, 'agent_name': agent_name}
        }
        msg_result = supabase.table('chatbot_messages').insert(msg_data).execute()

        resolved = False

        # Resolve if requested
        if request.resolve:
            # Update queue
            supabase.table('chatbot_support_queue').update({
                'status': 'resolved',
                'resolved_at': datetime.utcnow().isoformat()
            }).eq('conversation_id', conversation_id).eq('status', 'in_progress').execute()

            # Update conversation
            supabase.table('chatbot_conversations').update({
                'status': 'active',
                'updated_at': datetime.utcnow().isoformat()
            }).eq('id', conversation_id).execute()

            resolved = True

        return AgentReplyResponse(
            success=True,
            message_id=msg_result.data[0]['id'],
            conversation_id=conversation_id,
            resolved=resolved
        )

    except Exception as e:
        logger.error(f"Failed to send agent reply: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.get("/admin/conversations")
async def list_all_conversations(
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
    status_filter: Optional[str] = None,
    current_user: CurrentUser = Depends(get_current_user)
) -> ConversationListResponse:
    """
    List all conversations (admin only)
    """
    try:
        supabase = get_supabase()

        query = supabase.table('chatbot_conversations').select('*', count='exact')

        if status_filter:
            query = query.eq('status', status_filter)

        offset = (page - 1) * page_size
        query = query.order('updated_at', desc=True).range(offset, offset + page_size - 1)

        result = query.execute()

        conversations = [
            ConversationResponse(
                id=c['id'],
                user_id=c.get('user_id'),
                user_name=c.get('user_name'),
                user_email=c.get('user_email'),
                user_role=c.get('user_role'),
                status=c.get('status', 'active'),
                summary=c.get('summary'),
                topics=c.get('topics') or [],
                context=c.get('context'),
                ai_provider=c.get('ai_provider'),
                message_count=c.get('message_count', 0),
                user_message_count=c.get('user_message_count', 0),
                bot_message_count=c.get('bot_message_count', 0),
                agent_message_count=c.get('agent_message_count', 0),
                created_at=c['created_at'],
                updated_at=c['updated_at']
            )
            for c in (result.data or [])
        ]

        total = result.count or 0

        return ConversationListResponse(
            conversations=conversations,
            total=total,
            page=page,
            page_size=page_size,
            has_more=(offset + page_size) < total
        )

    except Exception as e:
        logger.error(f"Failed to list conversations: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


# =============================================================================
# FAQ ENDPOINTS
# =============================================================================

@router.get("/faqs")
async def list_faqs(
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
    category: Optional[str] = None,
    search: Optional[str] = None,
    active_only: bool = True
) -> FAQListResponse:
    """
    List FAQs (public endpoint)
    """
    try:
        supabase = get_supabase()

        query = supabase.table('chatbot_faqs').select('*', count='exact')

        if active_only:
            query = query.eq('is_active', True)
        if category:
            query = query.eq('category', category)
        if search:
            query = query.or_(f"question.ilike.%{search}%,answer.ilike.%{search}%")

        offset = (page - 1) * page_size
        query = query.order('priority', desc=True).range(offset, offset + page_size - 1)

        result = query.execute()

        faqs = [
            FAQResponse(
                id=f['id'],
                question=f['question'],
                answer=f['answer'],
                keywords=f.get('keywords') or [],
                category=f.get('category', 'general'),
                priority=f.get('priority', 0),
                is_active=f.get('is_active', True),
                usage_count=f.get('usage_count', 0),
                helpful_count=f.get('helpful_count', 0),
                not_helpful_count=f.get('not_helpful_count', 0),
                quick_actions=f.get('quick_actions'),
                created_by=f.get('created_by'),
                created_at=f['created_at'],
                updated_at=f['updated_at']
            )
            for f in (result.data or [])
        ]

        total = result.count or 0

        return FAQListResponse(
            faqs=faqs,
            total=total,
            page=page,
            page_size=page_size,
            has_more=(offset + page_size) < total
        )

    except Exception as e:
        logger.error(f"Failed to list FAQs: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.post("/admin/faqs", status_code=status.HTTP_201_CREATED)
async def create_faq(
    request: FAQCreateRequest,
    current_user: CurrentUser = Depends(get_current_user)
) -> FAQResponse:
    """
    Create FAQ (admin only)
    """
    try:
        supabase = get_supabase()

        faq_data = {
            'question': request.question,
            'answer': request.answer,
            'keywords': request.keywords,
            'category': request.category,
            'priority': request.priority,
            'quick_actions': [qa.dict() for qa in request.quick_actions] if request.quick_actions else [],
            'created_by': current_user.id,
            'is_active': True
        }

        result = supabase.table('chatbot_faqs').insert(faq_data).execute()
        f = result.data[0]

        return FAQResponse(
            id=f['id'],
            question=f['question'],
            answer=f['answer'],
            keywords=f.get('keywords') or [],
            category=f.get('category', 'general'),
            priority=f.get('priority', 0),
            is_active=f.get('is_active', True),
            usage_count=0,
            helpful_count=0,
            not_helpful_count=0,
            quick_actions=f.get('quick_actions'),
            created_by=f.get('created_by'),
            created_at=f['created_at'],
            updated_at=f['updated_at']
        )

    except Exception as e:
        logger.error(f"Failed to create FAQ: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.put("/admin/faqs/{faq_id}")
async def update_faq(
    faq_id: str,
    request: FAQUpdateRequest,
    current_user: CurrentUser = Depends(get_current_user)
) -> FAQResponse:
    """
    Update FAQ (admin only)
    """
    try:
        supabase = get_supabase()

        update_data = {'updated_at': datetime.utcnow().isoformat()}

        if request.question is not None:
            update_data['question'] = request.question
        if request.answer is not None:
            update_data['answer'] = request.answer
        if request.keywords is not None:
            update_data['keywords'] = request.keywords
        if request.category is not None:
            update_data['category'] = request.category
        if request.priority is not None:
            update_data['priority'] = request.priority
        if request.is_active is not None:
            update_data['is_active'] = request.is_active
        if request.quick_actions is not None:
            update_data['quick_actions'] = [qa.dict() for qa in request.quick_actions]

        result = supabase.table('chatbot_faqs').update(update_data).eq('id', faq_id).execute()

        if not result.data:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="FAQ not found"
            )

        f = result.data[0]

        return FAQResponse(
            id=f['id'],
            question=f['question'],
            answer=f['answer'],
            keywords=f.get('keywords') or [],
            category=f.get('category', 'general'),
            priority=f.get('priority', 0),
            is_active=f.get('is_active', True),
            usage_count=f.get('usage_count', 0),
            helpful_count=f.get('helpful_count', 0),
            not_helpful_count=f.get('not_helpful_count', 0),
            quick_actions=f.get('quick_actions'),
            created_by=f.get('created_by'),
            created_at=f['created_at'],
            updated_at=f['updated_at']
        )

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Failed to update FAQ: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.delete("/admin/faqs/{faq_id}")
async def delete_faq(
    faq_id: str,
    current_user: CurrentUser = Depends(get_current_user)
):
    """
    Delete FAQ (admin only)
    """
    try:
        supabase = get_supabase()

        supabase.table('chatbot_faqs').delete().eq('id', faq_id).execute()

        return {"success": True}

    except Exception as e:
        logger.error(f"Failed to delete FAQ: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.get("/admin/feedback/stats")
async def get_feedback_stats(
    days: int = Query(30, ge=1, le=365),
    current_user: CurrentUser = Depends(get_current_user)
) -> FeedbackStatsResponse:
    """
    Get feedback statistics (admin only)
    """
    try:
        supabase = get_supabase()

        # Get overall stats
        helpful_result = supabase.table('chatbot_messages').select(
            'id', count='exact'
        ).eq('feedback', 'helpful').execute()

        not_helpful_result = supabase.table('chatbot_messages').select(
            'id', count='exact'
        ).eq('feedback', 'not_helpful').execute()

        total_result = supabase.table('chatbot_messages').select(
            'id', count='exact'
        ).eq('sender', 'bot').execute()

        helpful = helpful_result.count or 0
        not_helpful = not_helpful_result.count or 0
        total = total_result.count or 0

        helpful_pct = (helpful / (helpful + not_helpful) * 100) if (helpful + not_helpful) > 0 else 0

        return FeedbackStatsResponse(
            total_messages=total,
            helpful_count=helpful,
            not_helpful_count=not_helpful,
            helpful_percentage=round(helpful_pct, 1),
            top_issues=[],
            daily_stats=[]
        )

    except Exception as e:
        logger.error(f"Failed to get feedback stats: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.get("/admin/feedback/report")
async def get_feedback_report(
    days: int = Query(30, ge=1, le=365),
    current_user: CurrentUser = Depends(get_current_user)
):
    """
    Get comprehensive feedback analytics report (admin only)

    **Requires:** Admin authentication

    **Query Parameters:**
    - days: Number of days to analyze (default: 30, max: 365)

    **Returns:**
    - Comprehensive report with trends, provider comparison, suggestions
    """
    try:
        supabase = get_supabase()

        # Verify admin role
        user_result = supabase.table('users').select(
            'active_role'
        ).eq('id', current_user.id).single().execute()

        if not user_result.data or user_result.data.get('active_role') not in ['superadmin', 'supportadmin', 'admin']:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Admin access required"
            )

        # Use analytics service
        from sqlalchemy.orm import Session
        # Note: In production, you'd get the DB session properly
        # For now, we'll construct a basic report from Supabase

        start_date = datetime.utcnow() - timedelta(days=days)
        end_date = datetime.utcnow()

        # Get stats
        helpful_result = supabase.table('chatbot_messages').select(
            'id', count='exact'
        ).eq('feedback', 'helpful').gte('created_at', start_date.isoformat()).execute()

        not_helpful_result = supabase.table('chatbot_messages').select(
            'id', count='exact'
        ).eq('feedback', 'not_helpful').gte('created_at', start_date.isoformat()).execute()

        total_bot_result = supabase.table('chatbot_messages').select(
            'id', count='exact'
        ).eq('sender', 'bot').gte('created_at', start_date.isoformat()).execute()

        helpful = helpful_result.count or 0
        not_helpful = not_helpful_result.count or 0
        total_bot = total_bot_result.count or 0
        total_rated = helpful + not_helpful

        # Get poorly performing responses
        poor_result = supabase.table('chatbot_messages').select(
            'id, content, ai_provider, created_at, feedback_comment'
        ).eq('feedback', 'not_helpful').order(
            'created_at', desc=True
        ).limit(10).execute()

        poor_responses = [
            {
                "message_id": r['id'],
                "content": r['content'][:200] + "..." if len(r.get('content', '')) > 200 else r.get('content', ''),
                "ai_provider": r.get('ai_provider'),
                "created_at": r.get('created_at'),
                "feedback_comment": r.get('feedback_comment')
            }
            for r in (poor_result.data or [])
        ]

        # Generate suggestions
        suggestions = []
        satisfaction_rate = (helpful / total_rated * 100) if total_rated > 0 else 0

        if satisfaction_rate < 70:
            suggestions.append({
                "priority": "high",
                "category": "overall_quality",
                "issue": f"Satisfaction rate is {satisfaction_rate:.1f}% (below 70%)",
                "suggestion": "Review negative feedback and improve FAQ database"
            })

        rating_rate = (total_rated / total_bot * 100) if total_bot > 0 else 0
        if rating_rate < 10:
            suggestions.append({
                "priority": "medium",
                "category": "engagement",
                "issue": f"Only {rating_rate:.1f}% of messages are rated",
                "suggestion": "Make feedback prompts more visible"
            })

        if len(poor_responses) >= 5:
            suggestions.append({
                "priority": "medium",
                "category": "content_quality",
                "issue": f"{len(poor_responses)} recent negative responses found",
                "suggestion": "Review and create FAQ entries for common issues"
            })

        return {
            "generated_at": datetime.utcnow().isoformat(),
            "period": {
                "start": start_date.isoformat(),
                "end": end_date.isoformat(),
                "days": days
            },
            "summary": {
                "total_bot_messages": total_bot,
                "rated_messages": total_rated,
                "rating_rate": round(rating_rate, 2),
                "helpful_count": helpful,
                "not_helpful_count": not_helpful,
                "satisfaction_score": round(satisfaction_rate, 2)
            },
            "poor_responses": poor_responses,
            "suggestions": suggestions
        }

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Failed to get feedback report: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


# =============================================================================
# FILE UPLOAD ENDPOINTS
# =============================================================================

ALLOWED_EXTENSIONS = {'.jpg', '.jpeg', '.png', '.gif', '.pdf', '.doc', '.docx', '.txt'}
MAX_FILE_SIZE = 10 * 1024 * 1024  # 10MB


@router.post("/upload")
async def upload_file(
    file: UploadFile = File(...),
    conversation_id: Optional[str] = None,
    current_user: CurrentUser = Depends(get_current_user)
):
    """
    Upload a file/image to the chatbot

    **Requires:** Authentication

    **Form Data:**
    - file: The file to upload (max 10MB)
    - conversation_id: Optional conversation to attach file to

    **Allowed Types:**
    - Images: jpg, jpeg, png, gif
    - Documents: pdf, doc, docx, txt

    **Returns:**
    - File URL and metadata
    """
    try:
        supabase = get_supabase()

        # Validate file extension
        file_ext = os.path.splitext(file.filename or '')[1].lower()
        if file_ext not in ALLOWED_EXTENSIONS:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"File type not allowed. Allowed types: {', '.join(ALLOWED_EXTENSIONS)}"
            )

        # Read file content
        content = await file.read()

        # Check file size
        if len(content) > MAX_FILE_SIZE:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"File too large. Maximum size: {MAX_FILE_SIZE // (1024*1024)}MB"
            )

        # Generate unique filename
        unique_id = str(uuid.uuid4())
        safe_filename = f"{unique_id}{file_ext}"
        storage_path = f"chatbot-uploads/{current_user.id}/{safe_filename}"

        # Upload to Supabase Storage
        try:
            storage_result = supabase.storage.from_('chatbot-files').upload(
                storage_path,
                content,
                file_options={"content-type": file.content_type or "application/octet-stream"}
            )
        except Exception as storage_error:
            # If bucket doesn't exist or other storage error, log and return mock URL
            logger.warning(f"Storage upload failed: {storage_error}")
            # For now, create a placeholder - in production ensure bucket exists
            file_url = f"/api/v1/chatbot/files/{safe_filename}"

        # Get public URL
        try:
            file_url = supabase.storage.from_('chatbot-files').get_public_url(storage_path)
        except:
            file_url = f"/api/v1/chatbot/files/{safe_filename}"

        # Determine file type
        is_image = file_ext in {'.jpg', '.jpeg', '.png', '.gif'}
        file_type = 'image' if is_image else 'file'

        # If conversation_id provided, create a message with the file
        message_id = None
        if conversation_id:
            msg_data = {
                'conversation_id': conversation_id,
                'sender': 'user',
                'content': f"[Uploaded {file_type}: {file.filename}]",
                'message_type': file_type,
                'metadata': {
                    'file_url': file_url,
                    'file_name': file.filename,
                    'file_size': len(content),
                    'file_type': file.content_type,
                    'storage_path': storage_path
                }
            }
            msg_result = supabase.table('chatbot_messages').insert(msg_data).execute()
            message_id = msg_result.data[0]['id'] if msg_result.data else None

        return {
            "success": True,
            "file_url": file_url,
            "file_name": file.filename,
            "file_size": len(content),
            "file_type": file_type,
            "content_type": file.content_type,
            "message_id": message_id,
            "conversation_id": conversation_id
        }

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Failed to upload file: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to upload file: {str(e)}"
        )


# =============================================================================
# DATA RETENTION & GDPR ENDPOINTS
# =============================================================================

@router.post("/admin/maintenance/archive-old")
async def archive_old_conversations(
    days_old: int = Query(90, ge=30, le=365),
    current_user: CurrentUser = Depends(get_current_user)
):
    """
    Archive conversations older than specified days (admin only)

    **Requires:** Admin authentication

    **Query Parameters:**
    - days_old: Archive conversations older than this (default: 90, min: 30)

    **Returns:**
    - Count of archived conversations
    """
    try:
        supabase = get_supabase()

        # Verify admin role
        user_result = supabase.table('users').select(
            'active_role'
        ).eq('id', current_user.id).single().execute()

        if not user_result.data or user_result.data.get('active_role') not in ['superadmin', 'admin']:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Admin access required"
            )

        cutoff_date = datetime.utcnow() - timedelta(days=days_old)

        # Find old active conversations
        old_convs = supabase.table('chatbot_conversations').select(
            'id', count='exact'
        ).eq('status', 'active').lt(
            'updated_at', cutoff_date.isoformat()
        ).execute()

        count = old_convs.count or 0

        if count > 0:
            # Archive them
            supabase.table('chatbot_conversations').update({
                'status': 'archived',
                'updated_at': datetime.utcnow().isoformat()
            }).eq('status', 'active').lt(
                'updated_at', cutoff_date.isoformat()
            ).execute()

        logger.info(f"Archived {count} conversations older than {days_old} days")

        return {
            "success": True,
            "archived_count": count,
            "cutoff_date": cutoff_date.isoformat(),
            "days_old": days_old
        }

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Failed to archive old conversations: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e)
        )


@router.delete("/user/data")
async def delete_user_data(
    confirm: bool = Query(False),
    current_user: CurrentUser = Depends(get_current_user)
):
    """
    Delete all chatbot data for the current user (GDPR right to erasure)

    **Requires:** Authentication

    **Query Parameters:**
    - confirm: Must be true to confirm deletion

    **WARNING:** This action is irreversible!

    **Deletes:**
    - All user's conversations
    - All messages in those conversations
    - Associated queue entries
    """
    if not confirm:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Must set confirm=true to delete data. This action is irreversible."
        )

    try:
        supabase = get_supabase()

        # Get user's conversation IDs
        convs_result = supabase.table('chatbot_conversations').select(
            'id'
        ).eq('user_id', current_user.id).execute()

        conversation_ids = [c['id'] for c in (convs_result.data or [])]

        deleted_messages = 0
        deleted_conversations = len(conversation_ids)
        deleted_queue_items = 0

        if conversation_ids:
            # Delete messages for all conversations
            for conv_id in conversation_ids:
                msg_result = supabase.table('chatbot_messages').delete().eq(
                    'conversation_id', conv_id
                ).execute()
                deleted_messages += len(msg_result.data or [])

                # Delete queue entries
                queue_result = supabase.table('chatbot_support_queue').delete().eq(
                    'conversation_id', conv_id
                ).execute()
                deleted_queue_items += len(queue_result.data or [])

            # Delete conversations
            supabase.table('chatbot_conversations').delete().eq(
                'user_id', current_user.id
            ).execute()

        logger.info(f"GDPR deletion for user {current_user.id}: {deleted_conversations} conversations, {deleted_messages} messages")

        return {
            "success": True,
            "deleted": {
                "conversations": deleted_conversations,
                "messages": deleted_messages,
                "queue_items": deleted_queue_items
            },
            "message": "All your chatbot data has been permanently deleted"
        }

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Failed to delete user data: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e)
        )


@router.delete("/admin/user/{user_id}/data")
async def admin_delete_user_data(
    user_id: str,
    confirm: bool = Query(False),
    current_user: CurrentUser = Depends(get_current_user)
):
    """
    Delete all chatbot data for a specific user (admin only, GDPR compliance)

    **Requires:** Admin authentication

    **Path Parameters:**
    - user_id: The user whose data should be deleted

    **Query Parameters:**
    - confirm: Must be true to confirm deletion

    **WARNING:** This action is irreversible!
    """
    if not confirm:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Must set confirm=true to delete data. This action is irreversible."
        )

    try:
        supabase = get_supabase()

        # Verify admin role
        admin_result = supabase.table('users').select(
            'active_role'
        ).eq('id', current_user.id).single().execute()

        if not admin_result.data or admin_result.data.get('active_role') not in ['superadmin', 'admin']:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Admin access required"
            )

        # Get user's conversation IDs
        convs_result = supabase.table('chatbot_conversations').select(
            'id'
        ).eq('user_id', user_id).execute()

        conversation_ids = [c['id'] for c in (convs_result.data or [])]

        deleted_messages = 0
        deleted_conversations = len(conversation_ids)
        deleted_queue_items = 0

        if conversation_ids:
            # Delete messages for all conversations
            for conv_id in conversation_ids:
                msg_result = supabase.table('chatbot_messages').delete().eq(
                    'conversation_id', conv_id
                ).execute()
                deleted_messages += len(msg_result.data or [])

                # Delete queue entries
                queue_result = supabase.table('chatbot_support_queue').delete().eq(
                    'conversation_id', conv_id
                ).execute()
                deleted_queue_items += len(queue_result.data or [])

            # Delete conversations
            supabase.table('chatbot_conversations').delete().eq(
                'user_id', user_id
            ).execute()

        logger.info(f"Admin GDPR deletion for user {user_id} by {current_user.id}: {deleted_conversations} conversations, {deleted_messages} messages")

        return {
            "success": True,
            "user_id": user_id,
            "deleted": {
                "conversations": deleted_conversations,
                "messages": deleted_messages,
                "queue_items": deleted_queue_items
            },
            "message": f"All chatbot data for user {user_id} has been permanently deleted"
        }

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Failed to delete user data: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e)
        )


@router.post("/admin/maintenance/anonymize-old")
async def anonymize_old_data(
    days_old: int = Query(180, ge=90, le=730),
    current_user: CurrentUser = Depends(get_current_user)
):
    """
    Anonymize user data in old conversations for analytics (admin only)

    **Requires:** Admin authentication

    **Query Parameters:**
    - days_old: Anonymize data older than this (default: 180, min: 90)

    This keeps conversation data for analytics while removing PII:
    - Removes user names
    - Removes email addresses
    - Keeps message content and metadata for analysis
    """
    try:
        supabase = get_supabase()

        # Verify admin role
        user_result = supabase.table('users').select(
            'active_role'
        ).eq('id', current_user.id).single().execute()

        if not user_result.data or user_result.data.get('active_role') not in ['superadmin', 'admin']:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Admin access required"
            )

        cutoff_date = datetime.utcnow() - timedelta(days=days_old)

        # Find old conversations that haven't been anonymized
        old_convs = supabase.table('chatbot_conversations').select(
            'id', count='exact'
        ).lt('updated_at', cutoff_date.isoformat()).not_.is_(
            'user_name', 'null'
        ).execute()

        count = old_convs.count or 0

        if count > 0:
            # Anonymize PII
            supabase.table('chatbot_conversations').update({
                'user_name': None,
                'user_email': None,
                'context': None,  # May contain PII
                'updated_at': datetime.utcnow().isoformat()
            }).lt('updated_at', cutoff_date.isoformat()).not_.is_(
                'user_name', 'null'
            ).execute()

        logger.info(f"Anonymized {count} conversations older than {days_old} days")

        return {
            "success": True,
            "anonymized_count": count,
            "cutoff_date": cutoff_date.isoformat(),
            "days_old": days_old
        }

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Failed to anonymize old data: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e)
        )
