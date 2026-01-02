"""
Chatbot Data Models
Pydantic schemas for AI-powered chatbot system
"""
from typing import Optional, List, Dict, Any
from pydantic import BaseModel, Field
from datetime import datetime
from enum import Enum


class MessageSender(str, Enum):
    """Message sender type"""
    USER = "user"
    BOT = "bot"
    SYSTEM = "system"
    AGENT = "agent"


class ChatMessageType(str, Enum):
    """Chat message type"""
    TEXT = "text"
    QUICK_REPLY = "quick_reply"
    CARD = "card"
    IMAGE = "image"
    FILE = "file"
    CAROUSEL = "carousel"
    MARKDOWN = "markdown"


class ConversationStatus(str, Enum):
    """Conversation status"""
    ACTIVE = "active"
    ARCHIVED = "archived"
    FLAGGED = "flagged"
    ESCALATED = "escalated"


class FeedbackType(str, Enum):
    """Feedback type"""
    HELPFUL = "helpful"
    NOT_HELPFUL = "not_helpful"


class EscalationPriority(str, Enum):
    """Escalation priority levels"""
    LOW = "low"
    NORMAL = "normal"
    HIGH = "high"
    URGENT = "urgent"


class EscalationType(str, Enum):
    """Escalation type/reason"""
    USER_REQUEST = "user_request"
    LOW_CONFIDENCE = "low_confidence"
    NEGATIVE_FEEDBACK = "negative_feedback"
    SENSITIVE_TOPIC = "sensitive_topic"
    AI_UNAVAILABLE = "ai_unavailable"


class QueueStatus(str, Enum):
    """Support queue status"""
    PENDING = "pending"
    ASSIGNED = "assigned"
    IN_PROGRESS = "in_progress"
    RESOLVED = "resolved"
    CLOSED = "closed"


# Quick Action Model
class QuickAction(BaseModel):
    """Quick action button"""
    id: str
    label: str
    action: str
    metadata: Optional[Dict[str, Any]] = None


# Chat Message Request/Response
class ChatMessageRequest(BaseModel):
    """Request model for sending a chat message"""
    conversation_id: Optional[str] = None  # None for new conversation
    message: str = Field(..., min_length=1, max_length=4000)
    context: Optional[Dict[str, Any]] = None  # User's current page, role, etc.


class ChatMessageResponse(BaseModel):
    """Response model for chat message"""
    conversation_id: str
    message_id: str
    content: str
    sender: MessageSender = MessageSender.BOT
    message_type: ChatMessageType = ChatMessageType.TEXT
    quick_actions: Optional[List[QuickAction]] = None
    sources: Optional[List[str]] = None
    confidence: float = Field(ge=0.0, le=1.0)
    ai_provider: Optional[str] = None
    tokens_used: int = 0
    should_escalate: bool = False
    escalation_reason: Optional[str] = None
    created_at: str

    class Config:
        from_attributes = True


# Conversation Models
class ConversationResponse(BaseModel):
    """Response model for conversation"""
    id: str
    user_id: Optional[str] = None
    user_name: Optional[str] = None
    user_email: Optional[str] = None
    user_role: Optional[str] = None
    status: ConversationStatus = ConversationStatus.ACTIVE
    summary: Optional[str] = None
    topics: List[str] = Field(default_factory=list)
    context: Optional[Dict[str, Any]] = None
    ai_provider: Optional[str] = None
    message_count: int = 0
    user_message_count: int = 0
    bot_message_count: int = 0
    agent_message_count: int = 0
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


class MessageHistoryItem(BaseModel):
    """Single message in history"""
    id: str
    sender: MessageSender
    content: str
    message_type: ChatMessageType = ChatMessageType.TEXT
    metadata: Optional[Dict[str, Any]] = None
    ai_provider: Optional[str] = None
    ai_confidence: Optional[float] = None
    tokens_used: Optional[int] = None
    feedback: Optional[FeedbackType] = None
    feedback_comment: Optional[str] = None
    created_at: str

    class Config:
        from_attributes = True


class MessageHistoryResponse(BaseModel):
    """Response model for message history"""
    conversation_id: str
    messages: List[MessageHistoryItem]
    total: int
    page: int
    page_size: int
    has_more: bool


# Feedback Models
class FeedbackRequest(BaseModel):
    """Request model for submitting feedback"""
    feedback: FeedbackType
    comment: Optional[str] = Field(None, max_length=1000)


class FeedbackResponse(BaseModel):
    """Response model for feedback submission"""
    success: bool
    message_id: str
    feedback: FeedbackType


class FeedbackStatsResponse(BaseModel):
    """Response model for feedback statistics"""
    total_messages: int
    helpful_count: int
    not_helpful_count: int
    helpful_percentage: float
    top_issues: List[Dict[str, Any]] = Field(default_factory=list)
    daily_stats: List[Dict[str, Any]] = Field(default_factory=list)


# Escalation Models
class EscalateRequest(BaseModel):
    """Request model for escalating a conversation"""
    reason: Optional[str] = None
    priority: EscalationPriority = EscalationPriority.NORMAL


class EscalateResponse(BaseModel):
    """Response model for escalation"""
    success: bool
    queue_id: str
    conversation_id: str
    priority: EscalationPriority
    estimated_wait_time: Optional[int] = None  # in minutes


class AssignRequest(BaseModel):
    """Request model for assigning conversation to agent"""
    agent_id: str
    notes: Optional[str] = None


class SupportQueueItem(BaseModel):
    """Support queue item"""
    id: str
    conversation_id: str
    conversation_summary: Optional[str] = None
    user_name: Optional[str] = None
    user_email: Optional[str] = None
    priority: EscalationPriority
    reason: Optional[str] = None
    escalation_type: Optional[EscalationType] = None
    assigned_to: Optional[str] = None
    assigned_to_name: Optional[str] = None
    status: QueueStatus
    response_time_seconds: Optional[int] = None
    created_at: str
    assigned_at: Optional[str] = None

    class Config:
        from_attributes = True


class SupportQueueResponse(BaseModel):
    """Response model for support queue"""
    items: List[SupportQueueItem]
    total: int
    pending_count: int
    assigned_count: int
    in_progress_count: int


# FAQ Models
class FAQCreateRequest(BaseModel):
    """Request model for creating FAQ"""
    question: str = Field(..., min_length=5, max_length=500)
    answer: str = Field(..., min_length=10, max_length=4000)
    keywords: List[str] = Field(default_factory=list)
    category: str = "general"
    priority: int = Field(default=0, ge=0, le=100)
    quick_actions: Optional[List[QuickAction]] = None


class FAQUpdateRequest(BaseModel):
    """Request model for updating FAQ"""
    question: Optional[str] = Field(None, min_length=5, max_length=500)
    answer: Optional[str] = Field(None, min_length=10, max_length=4000)
    keywords: Optional[List[str]] = None
    category: Optional[str] = None
    priority: Optional[int] = Field(None, ge=0, le=100)
    is_active: Optional[bool] = None
    quick_actions: Optional[List[QuickAction]] = None


class FAQResponse(BaseModel):
    """Response model for FAQ"""
    id: str
    question: str
    answer: str
    keywords: List[str] = Field(default_factory=list)
    category: str
    priority: int
    is_active: bool
    usage_count: int = 0
    helpful_count: int = 0
    not_helpful_count: int = 0
    quick_actions: Optional[List[QuickAction]] = None
    created_by: Optional[str] = None
    created_at: str
    updated_at: str

    class Config:
        from_attributes = True


class FAQListResponse(BaseModel):
    """Response model for FAQ list"""
    faqs: List[FAQResponse]
    total: int
    page: int
    page_size: int
    has_more: bool


# Agent Reply Model
class AgentReplyRequest(BaseModel):
    """Request model for agent reply"""
    content: str = Field(..., min_length=1, max_length=4000)
    resolve: bool = False  # Whether to resolve the escalation


class AgentReplyResponse(BaseModel):
    """Response model for agent reply"""
    success: bool
    message_id: str
    conversation_id: str
    resolved: bool = False
