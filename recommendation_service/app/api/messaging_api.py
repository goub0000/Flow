"""
Messaging API Endpoints
RESTful API for real-time messaging system
"""
from fastapi import APIRouter, Depends, HTTPException, status, Query

from app.services.messaging_service import MessagingService
from app.schemas.messaging import (
    ConversationCreateRequest,
    ConversationResponse,
    ConversationListResponse,
    MessageCreateRequest,
    MessageUpdateRequest,
    MessageResponse,
    MessageListResponse,
    TypingIndicatorRequest,
    ReadReceiptRequest
)
from app.utils.security import get_current_user, CurrentUser

router = APIRouter()


@router.post("/conversations", status_code=status.HTTP_201_CREATED)
async def create_conversation(
    conversation_data: ConversationCreateRequest,
    current_user: CurrentUser = Depends(get_current_user)
) -> ConversationResponse:
    """
    Create a new conversation

    **Requires:** Authentication

    **Request Body:**
    - participant_ids: List of user IDs (must include at least 1 other user)
    - conversation_type: "direct" or "group"
    - title: Optional conversation title (required for groups)
    - metadata: Optional additional data

    **Returns:**
    - Created conversation data
    """
    import logging
    logger = logging.getLogger(__name__)

    try:
        logger.info(f"Creating conversation: user={current_user.id}, participants={conversation_data.participant_ids}, type={conversation_data.conversation_type}")
        service = MessagingService()
        result = await service.create_conversation(current_user.id, conversation_data)
        logger.info(f"Conversation created successfully: {result.id}")
        return result
    except Exception as e:
        logger.error(f"Failed to create conversation: {str(e)}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.get("/conversations")
async def list_conversations(
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
    current_user: CurrentUser = Depends(get_current_user)
) -> ConversationListResponse:
    """
    List user's conversations

    **Requires:** Authentication

    **Query Parameters:**
    - page: Page number (default: 1)
    - page_size: Items per page (default: 20, max: 100)

    **Returns:**
    - Paginated list of conversations with unread counts
    """
    try:
        service = MessagingService()
        result = await service.list_user_conversations(current_user.id, page, page_size)
        return result
    except Exception as e:
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
    Get conversation by ID

    **Requires:** Authentication (must be participant)

    **Path Parameters:**
    - conversation_id: Conversation ID

    **Returns:**
    - Conversation data
    """
    try:
        service = MessagingService()
        result = await service.get_conversation(conversation_id, current_user.id)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=str(e)
        )


@router.post("/conversations/{conversation_id}/messages", status_code=status.HTTP_201_CREATED)
async def send_message(
    conversation_id: str,
    message_data: MessageCreateRequest,
    current_user: CurrentUser = Depends(get_current_user)
) -> MessageResponse:
    """
    Send a message in a conversation

    **Requires:** Authentication (must be participant)

    **Path Parameters:**
    - conversation_id: Conversation ID

    **Request Body:**
    - content: Message text
    - message_type: "text", "image", "file", "audio", "video"
    - attachment_url: Optional attachment URL
    - reply_to_id: Optional message ID for threaded replies
    - metadata: Optional additional data

    **Returns:**
    - Created message data

    **Note:** Supabase Realtime will broadcast this message to all connected clients
    """
    try:
        # Ensure conversation_id matches
        message_data.conversation_id = conversation_id

        service = MessagingService()
        result = await service.send_message(current_user.id, message_data)
        return result
    except Exception as e:
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
) -> MessageListResponse:
    """
    Get messages for a conversation

    **Requires:** Authentication (must be participant)

    **Path Parameters:**
    - conversation_id: Conversation ID

    **Query Parameters:**
    - page: Page number (default: 1)
    - page_size: Items per page (default: 50, max: 100)

    **Returns:**
    - Paginated list of messages (oldest first)
    """
    try:
        service = MessagingService()
        result = await service.get_conversation_messages(conversation_id, current_user.id, page, page_size)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.put("/messages/{message_id}")
async def edit_message(
    message_id: str,
    update_data: MessageUpdateRequest,
    current_user: CurrentUser = Depends(get_current_user)
) -> MessageResponse:
    """
    Edit a message (sender only)

    **Requires:** Authentication (must be message sender)

    **Path Parameters:**
    - message_id: Message ID

    **Request Body:**
    - content: New message text

    **Returns:**
    - Updated message data with is_edited flag
    """
    try:
        service = MessagingService()
        result = await service.edit_message(message_id, current_user.id, update_data)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.delete("/messages/{message_id}")
async def delete_message(
    message_id: str,
    current_user: CurrentUser = Depends(get_current_user)
) -> MessageResponse:
    """
    Delete a message (sender only)

    **Requires:** Authentication (must be message sender)

    **Path Parameters:**
    - message_id: Message ID

    **Returns:**
    - Updated message data with is_deleted flag and content replaced with "[Message deleted]"

    **Note:** This is a soft delete. Message metadata is preserved.
    """
    try:
        service = MessagingService()
        result = await service.delete_message(message_id, current_user.id)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.post("/messages/read")
async def mark_messages_as_read(
    read_receipt_data: ReadReceiptRequest,
    current_user: CurrentUser = Depends(get_current_user)
):
    """
    Mark messages as read (read receipts)

    **Requires:** Authentication

    **Request Body:**
    - message_ids: List of message IDs to mark as read

    **Returns:**
    - Success status and count of marked messages

    **Note:** This updates the read_by array for real-time read receipts
    """
    try:
        service = MessagingService()
        result = await service.mark_messages_as_read(current_user.id, read_receipt_data)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.post("/conversations/{conversation_id}/typing")
async def update_typing_indicator(
    conversation_id: str,
    typing_data: TypingIndicatorRequest,
    current_user: CurrentUser = Depends(get_current_user)
):
    """
    Update typing indicator

    **Requires:** Authentication (must be participant)

    **Path Parameters:**
    - conversation_id: Conversation ID

    **Request Body:**
    - is_typing: true when user starts typing, false when stops

    **Returns:**
    - Success status

    **Note:** Client should broadcast this via WebSocket for real-time updates
    """
    try:
        # Ensure conversation_id matches
        typing_data.conversation_id = conversation_id

        service = MessagingService()
        result = await service.update_typing_indicator(current_user.id, typing_data)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.get("/messages/unread-count")
async def get_unread_count(
    current_user: CurrentUser = Depends(get_current_user)
):
    """
    Get unread message count

    **Requires:** Authentication

    **Returns:**
    - total_unread: Total unread messages across all conversations
    - by_conversation: Unread count per conversation

    **Note:** Useful for badges and notification counts
    """
    try:
        service = MessagingService()
        result = await service.get_unread_count(current_user.id)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.get("/users/search")
async def search_users(
    q: str = Query("", description="Search query for name or email"),
    limit: int = Query(50, ge=1, le=100),
    current_user: CurrentUser = Depends(get_current_user)
):
    """
    Search users for starting a new conversation

    **Requires:** Authentication

    **Query Parameters:**
    - q: Search query (optional, searches name and email)
    - limit: Max results (default: 50)

    **Returns:**
    - List of users (excluding current user)
    """
    try:
        service = MessagingService()
        # Get supabase client from service
        supabase = service.db

        # Build query - exclude current user
        query = supabase.table('users').select(
            'id, email, display_name, active_role, photo_url'
        ).neq('id', current_user.id)

        # Add search filter if provided
        if q:
            # Search in display_name or email
            query = query.or_(f"display_name.ilike.%{q}%,email.ilike.%{q}%")

        # Order and limit
        query = query.order('display_name').limit(limit)

        result = query.execute()

        return {
            "users": result.data if result.data else [],
            "count": len(result.data) if result.data else 0
        }
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.get("/setup/check")
async def check_messaging_setup(
    current_user: CurrentUser = Depends(get_current_user)
):
    """
    Check if messaging tables exist and return their status

    **Requires:** Authentication
    """
    try:
        service = MessagingService()
        supabase = service.db

        results = {
            "conversations_table": False,
            "messages_table": False,
            "tables_info": {}
        }

        # Check conversations table
        try:
            conv_check = supabase.table('conversations').select('id').limit(1).execute()
            results["conversations_table"] = True
            results["tables_info"]["conversations"] = "exists"
        except Exception as e:
            results["tables_info"]["conversations"] = f"error: {str(e)}"

        # Check messages table
        try:
            msg_check = supabase.table('messages').select('id').limit(1).execute()
            results["messages_table"] = True
            results["tables_info"]["messages"] = "exists"
        except Exception as e:
            results["tables_info"]["messages"] = f"error: {str(e)}"

        results["ready"] = results["conversations_table"] and results["messages_table"]

        return results

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e)
        )


@router.post("/setup/test-insert")
async def test_conversation_insert(
    current_user: CurrentUser = Depends(get_current_user)
):
    """
    Test inserting a conversation to debug issues
    """
    import logging
    from uuid import uuid4
    from datetime import datetime
    logger = logging.getLogger(__name__)

    try:
        service = MessagingService()
        supabase = service.db

        # Test with a simple insert - let PostgreSQL generate the ID
        test_data = {
            "conversation_type": "direct",
            "title": None,
            "participant_ids": [current_user.id],  # Just the current user for test
            "metadata": {},
            "created_at": datetime.utcnow().isoformat(),
            "updated_at": datetime.utcnow().isoformat(),
        }

        logger.info(f"Test insert data: {test_data}")
        logger.info(f"Current user ID: {current_user.id}")
        logger.info(f"Current user ID type: {type(current_user.id)}")

        try:
            response = supabase.table('conversations').insert(test_data).execute()
            logger.info(f"Test insert response: {response}")

            # Clean up - delete the test conversation using the returned ID
            if response.data and len(response.data) > 0:
                test_id = response.data[0].get('id')
                if test_id:
                    supabase.table('conversations').delete().eq('id', test_id).execute()

            return {
                "success": True,
                "message": "Test insert succeeded",
                "data": response.data[0] if response.data else None
            }
        except Exception as insert_error:
            logger.error(f"Test insert error: {insert_error}", exc_info=True)
            return {
                "success": False,
                "error": str(insert_error),
                "error_type": type(insert_error).__name__,
                "test_data": test_data,
                "user_id": current_user.id,
                "user_id_type": str(type(current_user.id))
            }

    except Exception as e:
        logger.error(f"Test error: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e)
        )


@router.post("/setup/migrate")
async def run_messaging_migration(
    current_user: CurrentUser = Depends(get_current_user)
):
    """
    Create messaging tables if they don't exist

    **Requires:** Authentication (admin only in production)
    """
    try:
        service = MessagingService()
        supabase = service.db

        results = {
            "conversations_created": False,
            "messages_created": False,
            "errors": []
        }

        # Create conversations table
        try:
            # Try to query first to see if exists
            supabase.table('conversations').select('id').limit(1).execute()
            results["conversations_created"] = "already_exists"
        except:
            # Table doesn't exist, create it using raw SQL via RPC or postgrest
            # Note: Supabase client can't run raw SQL directly
            # We'll need to create via Supabase dashboard or use the service role
            results["errors"].append("conversations table needs to be created via Supabase SQL Editor")

        # Create messages table
        try:
            supabase.table('messages').select('id').limit(1).execute()
            results["messages_created"] = "already_exists"
        except:
            results["errors"].append("messages table needs to be created via Supabase SQL Editor")

        if results["errors"]:
            results["sql_to_run"] = """
-- Run this in Supabase SQL Editor:

CREATE TABLE IF NOT EXISTS public.conversations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  conversation_type TEXT DEFAULT 'direct',
  title TEXT,
  participant_ids UUID[] NOT NULL,
  last_message_at TIMESTAMPTZ,
  last_message_preview TEXT,
  unread_count INTEGER DEFAULT 0,
  metadata JSONB DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  conversation_id UUID NOT NULL REFERENCES public.conversations(id) ON DELETE CASCADE,
  sender_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  message_type TEXT DEFAULT 'text',
  attachment_url TEXT,
  reply_to_id UUID,
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

CREATE INDEX IF NOT EXISTS idx_conversations_participant_ids ON public.conversations USING GIN (participant_ids);
CREATE INDEX IF NOT EXISTS idx_messages_conversation ON public.messages(conversation_id, timestamp DESC);
"""

        return results

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e)
        )
