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
    try:
        service = MessagingService()
        result = await service.create_conversation(current_user.id, conversation_data)
        return result
    except Exception as e:
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
