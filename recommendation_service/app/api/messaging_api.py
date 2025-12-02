"""
Messaging API Endpoints
RESTful API for real-time messaging system
"""
from fastapi import APIRouter, Depends, HTTPException, status, Query, UploadFile, File
from uuid import uuid4
from datetime import datetime

from app.services.messaging_service import MessagingService
from app.database.config import get_supabase
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


@router.post("/conversations/{conversation_id}/read")
async def mark_conversation_as_read(
    conversation_id: str,
    current_user: CurrentUser = Depends(get_current_user)
):
    """
    Mark all messages in a conversation as read
    """
    try:
        service = MessagingService()
        # Get all unread messages in this conversation
        messages_response = await service.get_conversation_messages(
            conversation_id, current_user.id, page=1, page_size=100
        )

        # Mark them as read
        message_ids = [m.id for m in messages_response.messages if current_user.id not in (m.read_by or [])]

        if message_ids:
            result = await service.mark_messages_as_read(
                current_user.id,
                ReadReceiptRequest(message_ids=message_ids)
            )
            return result

        return {"success": True, "marked_count": 0}
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


@router.get("/storage/diagnose")
async def diagnose_storage(
    current_user: CurrentUser = Depends(get_current_user)
):
    """
    Diagnose storage bucket status and configuration
    """
    import logging
    import os
    logger = logging.getLogger(__name__)

    supabase = get_supabase()
    bucket_name = "messaging-attachments"

    diagnosis = {
        "bucket_name": bucket_name,
        "bucket_exists": False,
        "bucket_public": None,
        "all_buckets": [],
        "supabase_key_type": "unknown",
        "errors": []
    }

    # Check what type of key is being used (anon vs service_role)
    key = os.environ.get('SUPABASE_KEY', '')
    if key:
        # Service role keys typically contain "service_role" in decoded JWT
        # Anon keys are shorter and contain "anon"
        if len(key) > 200:
            diagnosis["supabase_key_type"] = "likely_service_role (long key)"
        else:
            diagnosis["supabase_key_type"] = "likely_anon (short key)"

    try:
        # List all buckets
        buckets = supabase.storage.list_buckets()
        diagnosis["all_buckets"] = [{"name": b.name, "public": b.public, "id": b.id} for b in buckets]

        # Check if our bucket exists
        for b in buckets:
            if b.name == bucket_name:
                diagnosis["bucket_exists"] = True
                diagnosis["bucket_public"] = b.public
                break

        # If bucket doesn't exist, try to create it
        if not diagnosis["bucket_exists"]:
            logger.info(f"Bucket {bucket_name} doesn't exist, attempting to create...")
            try:
                supabase.storage.create_bucket(bucket_name, options={"public": True})
                diagnosis["bucket_created"] = True
                diagnosis["bucket_exists"] = True
                diagnosis["bucket_public"] = True
            except Exception as create_error:
                diagnosis["errors"].append(f"Failed to create bucket: {str(create_error)}")

        # Try to list files in the bucket
        if diagnosis["bucket_exists"]:
            try:
                files = supabase.storage.from_(bucket_name).list()
                diagnosis["can_list_files"] = True
                diagnosis["file_count"] = len(files) if files else 0
            except Exception as list_error:
                diagnosis["can_list_files"] = False
                diagnosis["errors"].append(f"Cannot list files: {str(list_error)}")

    except Exception as e:
        diagnosis["errors"].append(f"Diagnosis error: {str(e)}")
        logger.error(f"Storage diagnosis error: {e}", exc_info=True)

    return diagnosis


@router.post("/upload")
async def upload_file(
    file: UploadFile = File(...),
    current_user: CurrentUser = Depends(get_current_user)
):
    """
    Upload a file for messaging attachments

    **Requires:** Authentication

    **Request Body:**
    - file: The file to upload (multipart/form-data)

    **Returns:**
    - url: Public URL of the uploaded file
    - type: File type (image, document, etc.)
    - name: Original filename
    - size: File size in bytes
    """
    import logging
    import os
    logger = logging.getLogger(__name__)

    try:
        # Validate file size (max 10MB)
        MAX_FILE_SIZE = 10 * 1024 * 1024  # 10MB
        contents = await file.read()
        file_size = len(contents)

        if file_size > MAX_FILE_SIZE:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"File too large. Maximum size is 10MB, got {file_size / 1024 / 1024:.2f}MB"
            )

        # Determine file type from content type
        content_type = file.content_type or "application/octet-stream"
        if content_type.startswith("image/"):
            file_type = "image"
        elif content_type.startswith("video/"):
            file_type = "video"
        elif content_type.startswith("audio/"):
            file_type = "audio"
        elif content_type in ["application/pdf", "application/msword",
                              "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
                              "text/plain"]:
            file_type = "document"
        else:
            file_type = "file"

        # Generate unique filename - use simple path without user subfolder to avoid policy issues
        original_filename = file.filename or "unknown"
        extension = original_filename.split(".")[-1] if "." in original_filename else ""
        # Use flat structure: just uuid.extension
        unique_filename = f"{uuid4()}.{extension}" if extension else str(uuid4())

        logger.info(f"Uploading file: {original_filename} -> {unique_filename}, type: {file_type}, size: {file_size}")

        # Upload to Supabase Storage
        supabase = get_supabase()
        bucket_name = "messaging-attachments"

        try:
            # Check if bucket exists
            buckets = supabase.storage.list_buckets()
            bucket_exists = any(b.name == bucket_name for b in buckets)
            logger.info(f"Existing buckets: {[b.name for b in buckets]}")

            if not bucket_exists:
                logger.info(f"Creating bucket: {bucket_name}")
                try:
                    supabase.storage.create_bucket(bucket_name, options={"public": True})
                    logger.info(f"Bucket {bucket_name} created successfully")
                except Exception as bucket_error:
                    logger.warning(f"Bucket creation warning (may already exist): {bucket_error}")

            # Upload the file with upsert option
            logger.info(f"Uploading to bucket {bucket_name}, file: {unique_filename}")
            result = supabase.storage.from_(bucket_name).upload(
                path=unique_filename,
                file=contents,
                file_options={
                    "content-type": content_type,
                    "upsert": "true"
                }
            )
            logger.info(f"Upload result: {result}")

            # Get public URL
            public_url = supabase.storage.from_(bucket_name).get_public_url(unique_filename)
            logger.info(f"Public URL: {public_url}")

            return {
                "url": public_url,
                "type": file_type,
                "name": original_filename,
                "size": file_size,
                "content_type": content_type
            }

        except Exception as storage_error:
            error_str = str(storage_error)
            logger.error(f"Storage error: {storage_error}", exc_info=True)

            # Provide more helpful error message
            if "row-level security" in error_str.lower() or "rls" in error_str.lower():
                detail = (
                    f"Storage RLS policy error. Please run this SQL in Supabase SQL Editor:\n\n"
                    f"-- Create bucket if not exists\n"
                    f"INSERT INTO storage.buckets (id, name, public) "
                    f"VALUES ('{bucket_name}', '{bucket_name}', true) "
                    f"ON CONFLICT (id) DO UPDATE SET public = true;\n\n"
                    f"-- Allow all operations for authenticated users\n"
                    f"CREATE POLICY \"Allow all for authenticated\" ON storage.objects "
                    f"FOR ALL TO authenticated USING (bucket_id = '{bucket_name}') "
                    f"WITH CHECK (bucket_id = '{bucket_name}');\n\n"
                    f"Original error: {error_str}"
                )
            else:
                detail = f"Failed to upload file to storage: {error_str}"

            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=detail
            )

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Upload error: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to upload file: {str(e)}"
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
