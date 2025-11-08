"""
Messaging Service
Business logic for real-time messaging system
"""
from typing import Optional, List, Dict, Any
from datetime import datetime
import logging
from uuid import uuid4

from app.database.config import get_supabase
from app.schemas.messaging import (
    ConversationCreateRequest,
    ConversationResponse,
    ConversationListResponse,
    MessageCreateRequest,
    MessageUpdateRequest,
    MessageResponse,
    MessageListResponse,
    ConversationType,
    MessageType,
    TypingIndicatorRequest,
    ReadReceiptRequest
)

logger = logging.getLogger(__name__)


class MessagingService:
    """Service for managing real-time messaging"""

    def __init__(self):
        self.db = get_supabase()

    async def create_conversation(
        self,
        user_id: str,
        conversation_data: ConversationCreateRequest
    ) -> ConversationResponse:
        """Create a new conversation"""
        try:
            # Validate participants
            if user_id not in conversation_data.participant_ids:
                conversation_data.participant_ids.append(user_id)

            # For direct conversations, ensure exactly 2 participants
            if conversation_data.conversation_type == ConversationType.DIRECT:
                if len(conversation_data.participant_ids) != 2:
                    raise Exception("Direct conversations must have exactly 2 participants")

            # Check if direct conversation already exists between these users
            if conversation_data.conversation_type == ConversationType.DIRECT:
                existing = self.db.table('conversations').select('*').eq(
                    'conversation_type', ConversationType.DIRECT.value
                ).contains('participant_ids', conversation_data.participant_ids).execute()

                if existing.data:
                    # Return existing conversation instead of creating duplicate
                    return ConversationResponse(**existing.data[0])

            conversation = {
                "id": str(uuid4()),
                "conversation_type": conversation_data.conversation_type.value,
                "title": conversation_data.title,
                "participant_ids": conversation_data.participant_ids,
                "metadata": conversation_data.metadata or {},
                "created_at": datetime.utcnow().isoformat(),
                "updated_at": datetime.utcnow().isoformat(),
            }

            response = self.db.table('conversations').insert(conversation).execute()

            if not response.data:
                raise Exception("Failed to create conversation")

            logger.info(f"Conversation created: {response.data[0]['id']}")

            return ConversationResponse(**response.data[0])

        except Exception as e:
            logger.error(f"Create conversation error: {e}")
            raise Exception(f"Failed to create conversation: {str(e)}")

    async def get_conversation(
        self,
        conversation_id: str,
        user_id: str
    ) -> ConversationResponse:
        """Get conversation by ID"""
        try:
            response = self.db.table('conversations').select('*').eq('id', conversation_id).single().execute()

            if not response.data:
                raise Exception("Conversation not found")

            # Check if user is a participant
            if user_id not in response.data.get('participant_ids', []):
                raise Exception("Not authorized to access this conversation")

            return ConversationResponse(**response.data)

        except Exception as e:
            logger.error(f"Get conversation error: {e}")
            raise Exception(f"Failed to fetch conversation: {str(e)}")

    async def list_user_conversations(
        self,
        user_id: str,
        page: int = 1,
        page_size: int = 20
    ) -> ConversationListResponse:
        """List conversations for a user"""
        try:
            query = self.db.table('conversations').select('*', count='exact').contains('participant_ids', [user_id])

            offset = (page - 1) * page_size
            query = query.order('updated_at', desc=True).range(offset, offset + page_size - 1)

            response = query.execute()

            conversations = [ConversationResponse(**c) for c in response.data] if response.data else []
            total = response.count or 0

            return ConversationListResponse(
                conversations=conversations,
                total=total,
                page=page,
                page_size=page_size,
                has_more=(offset + page_size) < total
            )

        except Exception as e:
            logger.error(f"List conversations error: {e}")
            raise Exception(f"Failed to list conversations: {str(e)}")

    async def send_message(
        self,
        sender_id: str,
        message_data: MessageCreateRequest
    ) -> MessageResponse:
        """Send a message in a conversation"""
        try:
            # Verify sender is participant in conversation
            conversation = await self.get_conversation(message_data.conversation_id, sender_id)

            message = {
                "id": str(uuid4()),
                "conversation_id": message_data.conversation_id,
                "sender_id": sender_id,
                "content": message_data.content,
                "message_type": message_data.message_type.value,
                "attachment_url": message_data.attachment_url,
                "reply_to_id": message_data.reply_to_id,
                "is_edited": False,
                "is_deleted": False,
                "read_by": [sender_id],  # Sender has read their own message
                "delivered_at": datetime.utcnow().isoformat(),
                "metadata": message_data.metadata or {},
                "timestamp": datetime.utcnow().isoformat(),
                "created_at": datetime.utcnow().isoformat(),
                "updated_at": datetime.utcnow().isoformat(),
            }

            response = self.db.table('messages').insert(message).execute()

            if not response.data:
                raise Exception("Failed to send message")

            # Update conversation's last_message_at and last_message_preview
            self.db.table('conversations').update({
                "last_message_at": message["timestamp"],
                "last_message_preview": message_data.content[:100],  # First 100 chars
                "updated_at": datetime.utcnow().isoformat()
            }).eq('id', message_data.conversation_id).execute()

            logger.info(f"Message sent: {response.data[0]['id']}")

            # Note: Supabase Realtime will automatically broadcast this to subscribed clients
            return MessageResponse(**response.data[0])

        except Exception as e:
            logger.error(f"Send message error: {e}")
            raise Exception(f"Failed to send message: {str(e)}")

    async def edit_message(
        self,
        message_id: str,
        user_id: str,
        update_data: MessageUpdateRequest
    ) -> MessageResponse:
        """Edit a message (only sender can edit)"""
        try:
            # Get message and verify ownership
            message = self.db.table('messages').select('*').eq('id', message_id).single().execute()

            if not message.data:
                raise Exception("Message not found")

            if message.data['sender_id'] != user_id:
                raise Exception("Not authorized to edit this message")

            if message.data['is_deleted']:
                raise Exception("Cannot edit deleted message")

            update = {
                "content": update_data.content,
                "is_edited": True,
                "updated_at": datetime.utcnow().isoformat()
            }

            response = self.db.table('messages').update(update).eq('id', message_id).execute()

            if not response.data:
                raise Exception("Failed to update message")

            logger.info(f"Message edited: {message_id}")

            return MessageResponse(**response.data[0])

        except Exception as e:
            logger.error(f"Edit message error: {e}")
            raise Exception(f"Failed to edit message: {str(e)}")

    async def delete_message(
        self,
        message_id: str,
        user_id: str
    ) -> MessageResponse:
        """Delete a message (soft delete, only sender can delete)"""
        try:
            # Get message and verify ownership
            message = self.db.table('messages').select('*').eq('id', message_id).single().execute()

            if not message.data:
                raise Exception("Message not found")

            if message.data['sender_id'] != user_id:
                raise Exception("Not authorized to delete this message")

            update = {
                "is_deleted": True,
                "content": "[Message deleted]",
                "updated_at": datetime.utcnow().isoformat()
            }

            response = self.db.table('messages').update(update).eq('id', message_id).execute()

            if not response.data:
                raise Exception("Failed to delete message")

            logger.info(f"Message deleted: {message_id}")

            return MessageResponse(**response.data[0])

        except Exception as e:
            logger.error(f"Delete message error: {e}")
            raise Exception(f"Failed to delete message: {str(e)}")

    async def mark_messages_as_read(
        self,
        user_id: str,
        read_receipt_data: ReadReceiptRequest
    ) -> Dict[str, Any]:
        """Mark multiple messages as read"""
        try:
            updated_count = 0

            for message_id in read_receipt_data.message_ids:
                # Get message
                message = self.db.table('messages').select('*').eq('id', message_id).single().execute()

                if not message.data:
                    continue

                # Check if user is participant in conversation
                conversation_id = message.data['conversation_id']
                conversation = self.db.table('conversations').select('participant_ids').eq('id', conversation_id).single().execute()

                if not conversation.data or user_id not in conversation.data.get('participant_ids', []):
                    continue

                # Add user to read_by list if not already there
                read_by = message.data.get('read_by', [])
                if user_id not in read_by:
                    read_by.append(user_id)

                    update = {
                        "read_by": read_by,
                        "read_at": datetime.utcnow().isoformat(),
                        "updated_at": datetime.utcnow().isoformat()
                    }

                    self.db.table('messages').update(update).eq('id', message_id).execute()
                    updated_count += 1

            logger.info(f"Marked {updated_count} messages as read for user {user_id}")

            return {
                "success": True,
                "marked_count": updated_count
            }

        except Exception as e:
            logger.error(f"Mark messages as read error: {e}")
            raise Exception(f"Failed to mark messages as read: {str(e)}")

    async def get_conversation_messages(
        self,
        conversation_id: str,
        user_id: str,
        page: int = 1,
        page_size: int = 50
    ) -> MessageListResponse:
        """Get messages for a conversation"""
        try:
            # Verify user is participant
            await self.get_conversation(conversation_id, user_id)

            query = self.db.table('messages').select('*', count='exact').eq('conversation_id', conversation_id).eq('is_deleted', False)

            offset = (page - 1) * page_size
            query = query.order('timestamp', desc=True).range(offset, offset + page_size - 1)

            response = query.execute()

            messages = [MessageResponse(**m) for m in response.data] if response.data else []
            total = response.count or 0

            # Reverse to show oldest first (after pagination)
            messages.reverse()

            return MessageListResponse(
                messages=messages,
                total=total,
                page=page,
                page_size=page_size,
                has_more=(offset + page_size) < total
            )

        except Exception as e:
            logger.error(f"Get conversation messages error: {e}")
            raise Exception(f"Failed to fetch messages: {str(e)}")

    async def update_typing_indicator(
        self,
        user_id: str,
        typing_data: TypingIndicatorRequest
    ) -> Dict[str, Any]:
        """Update typing indicator (for real-time broadcast)"""
        try:
            # Verify user is participant
            await self.get_conversation(typing_data.conversation_id, user_id)

            # Store typing indicator with short TTL (e.g., 5 seconds)
            # In a production app, you'd use Redis or similar for ephemeral data
            # For now, we'll just return success and rely on client-side WebSocket broadcasting

            logger.info(f"Typing indicator updated: user={user_id}, conversation={typing_data.conversation_id}, is_typing={typing_data.is_typing}")

            return {
                "success": True,
                "user_id": user_id,
                "conversation_id": typing_data.conversation_id,
                "is_typing": typing_data.is_typing
            }

        except Exception as e:
            logger.error(f"Update typing indicator error: {e}")
            raise Exception(f"Failed to update typing indicator: {str(e)}")

    async def get_unread_count(self, user_id: str) -> Dict[str, int]:
        """Get unread message count for user across all conversations"""
        try:
            # Get all conversations user is part of
            conversations = await self.list_user_conversations(user_id, page=1, page_size=1000)

            total_unread = 0
            unread_by_conversation = {}

            for conversation in conversations.conversations:
                # Count messages not read by this user
                messages = self.db.table('messages').select('*').eq(
                    'conversation_id', conversation.id
                ).eq('is_deleted', False).execute()

                unread = 0
                for message in messages.data:
                    # Skip messages sent by the user
                    if message['sender_id'] == user_id:
                        continue

                    # Check if user has read this message
                    read_by = message.get('read_by', [])
                    if user_id not in read_by:
                        unread += 1

                if unread > 0:
                    unread_by_conversation[conversation.id] = unread
                    total_unread += unread

            return {
                "total_unread": total_unread,
                "by_conversation": unread_by_conversation
            }

        except Exception as e:
            logger.error(f"Get unread count error: {e}")
            raise Exception(f"Failed to get unread count: {str(e)}")
