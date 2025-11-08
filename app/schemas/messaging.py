"""
Messaging Data Models
Pydantic schemas for real-time messaging system
"""
from typing import Optional, List, Dict, Any
from pydantic import BaseModel, Field
from datetime import datetime
from enum import Enum


class MessageType(str, Enum):
    """Message type enumeration"""
    TEXT = "text"
    IMAGE = "image"
    FILE = "file"
    AUDIO = "audio"
    VIDEO = "video"


class ConversationType(str, Enum):
    """Conversation type"""
    DIRECT = "direct"  # 1-on-1
    GROUP = "group"    # Multiple participants


# Conversation Models
class ConversationCreateRequest(BaseModel):
    """Request model for creating a new conversation"""
    participant_ids: List[str] = Field(..., min_items=1)
    conversation_type: ConversationType = ConversationType.DIRECT
    title: Optional[str] = None
    metadata: Optional[Dict[str, Any]] = None


class ConversationResponse(BaseModel):
    """Response model for conversation data"""
    id: str
    conversation_type: str
    title: Optional[str] = None
    participant_ids: List[str] = Field(default_factory=list)
    last_message_at: Optional[str] = None
    last_message_preview: Optional[str] = None
    unread_count: int = 0
    metadata: Optional[Dict[str, Any]] = None
    created_at: str
    updated_at: str

    class Config:
        from_attributes = True


class ConversationListResponse(BaseModel):
    """Response model for paginated conversation list"""
    conversations: List[ConversationResponse]
    total: int
    page: int
    page_size: int
    has_more: bool


# Message Models
class MessageCreateRequest(BaseModel):
    """Request model for sending a new message"""
    conversation_id: str
    content: str = Field(..., min_length=1)
    message_type: MessageType = MessageType.TEXT
    attachment_url: Optional[str] = None
    reply_to_id: Optional[str] = None  # For threaded replies
    metadata: Optional[Dict[str, Any]] = None


class MessageUpdateRequest(BaseModel):
    """Request model for updating a message (edit)"""
    content: str = Field(..., min_length=1)


class MessageResponse(BaseModel):
    """Response model for message data"""
    id: str
    conversation_id: str
    sender_id: str
    content: str
    message_type: str
    attachment_url: Optional[str] = None
    reply_to_id: Optional[str] = None
    is_edited: bool = False
    is_deleted: bool = False
    read_by: List[str] = Field(default_factory=list)
    delivered_at: Optional[str] = None
    read_at: Optional[str] = None
    metadata: Optional[Dict[str, Any]] = None
    timestamp: str
    created_at: str
    updated_at: str

    class Config:
        from_attributes = True


class MessageListResponse(BaseModel):
    """Response model for paginated message list"""
    messages: List[MessageResponse]
    total: int
    page: int
    page_size: int
    has_more: bool


# Typing Indicator Models
class TypingIndicatorRequest(BaseModel):
    """Request model for typing indicator"""
    conversation_id: str
    is_typing: bool


# Read Receipt Models
class ReadReceiptRequest(BaseModel):
    """Request model for marking messages as read"""
    message_ids: List[str]
