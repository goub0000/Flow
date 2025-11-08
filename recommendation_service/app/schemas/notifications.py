"""
Notifications Data Models
Pydantic schemas for push notifications and in-app notifications
"""
from typing import Optional, List, Dict, Any
from pydantic import BaseModel, Field
from datetime import datetime
from enum import Enum


class NotificationType(str, Enum):
    """Notification type enumeration"""
    SYSTEM = "system"  # System announcements
    APPLICATION_STATUS = "application_status"  # Application updates
    ENROLLMENT = "enrollment"  # Enrollment confirmations
    COURSE_UPDATE = "course_update"  # Course content updates
    MESSAGE = "message"  # New message received
    PAYMENT = "payment"  # Payment confirmations
    DEADLINE_REMINDER = "deadline_reminder"  # Upcoming deadlines
    ACHIEVEMENT = "achievement"  # Achievements/badges
    RECOMMENDATION = "recommendation"  # New recommendations
    COUNSELING = "counseling"  # Counseling session updates
    PARENT_ALERT = "parent_alert"  # Parent monitoring alerts
    GRADE_UPDATE = "grade_update"  # Grade/progress updates


class NotificationPriority(str, Enum):
    """Notification priority levels"""
    LOW = "low"
    NORMAL = "normal"
    HIGH = "high"
    URGENT = "urgent"


class NotificationChannel(str, Enum):
    """Notification delivery channels"""
    IN_APP = "in_app"  # In-app notification
    PUSH = "push"  # Push notification
    EMAIL = "email"  # Email notification
    SMS = "sms"  # SMS notification


# Notification Models
class NotificationCreateRequest(BaseModel):
    """Request model for creating a notification"""
    user_id: str
    notification_type: NotificationType
    title: str = Field(..., min_length=1, max_length=200)
    message: str = Field(..., min_length=1)
    priority: NotificationPriority = NotificationPriority.NORMAL
    channels: List[NotificationChannel] = Field(default=[NotificationChannel.IN_APP])
    action_url: Optional[str] = None  # Deep link or URL
    action_text: Optional[str] = None  # Button text
    image_url: Optional[str] = None
    metadata: Optional[Dict[str, Any]] = None
    expires_at: Optional[str] = None  # Optional expiration
    scheduled_for: Optional[str] = None  # Schedule for later delivery


class NotificationResponse(BaseModel):
    """Response model for notification data"""
    id: str
    user_id: str
    notification_type: str
    title: str
    message: str
    priority: str
    channels: List[str] = Field(default_factory=list)
    action_url: Optional[str] = None
    action_text: Optional[str] = None
    image_url: Optional[str] = None
    is_read: bool = False
    read_at: Optional[str] = None
    is_delivered: bool = False
    delivered_at: Optional[str] = None
    metadata: Optional[Dict[str, Any]] = None
    expires_at: Optional[str] = None
    scheduled_for: Optional[str] = None
    created_at: str
    updated_at: str

    class Config:
        from_attributes = True


class NotificationListResponse(BaseModel):
    """Response model for paginated notification list"""
    notifications: List[NotificationResponse]
    total: int
    unread_count: int
    page: int
    page_size: int
    has_more: bool


class BulkNotificationCreateRequest(BaseModel):
    """Request model for sending notifications to multiple users"""
    user_ids: List[str] = Field(..., min_items=1)
    notification_type: NotificationType
    title: str = Field(..., min_length=1, max_length=200)
    message: str = Field(..., min_length=1)
    priority: NotificationPriority = NotificationPriority.NORMAL
    channels: List[NotificationChannel] = Field(default=[NotificationChannel.IN_APP])
    action_url: Optional[str] = None
    action_text: Optional[str] = None
    image_url: Optional[str] = None
    metadata: Optional[Dict[str, Any]] = None
    scheduled_for: Optional[str] = None


class BroadcastNotificationRequest(BaseModel):
    """Request model for broadcasting to all users or role-based users"""
    notification_type: NotificationType
    title: str = Field(..., min_length=1, max_length=200)
    message: str = Field(..., min_length=1)
    priority: NotificationPriority = NotificationPriority.NORMAL
    channels: List[NotificationChannel] = Field(default=[NotificationChannel.IN_APP])
    target_roles: Optional[List[str]] = None  # None = all users, or specific roles
    action_url: Optional[str] = None
    action_text: Optional[str] = None
    image_url: Optional[str] = None
    metadata: Optional[Dict[str, Any]] = None
    scheduled_for: Optional[str] = None


class MarkNotificationsReadRequest(BaseModel):
    """Request model for marking notifications as read"""
    notification_ids: List[str] = Field(..., min_items=1)


class NotificationPreferencesUpdate(BaseModel):
    """Request model for updating notification preferences"""
    email_enabled: Optional[bool] = None
    push_enabled: Optional[bool] = None
    sms_enabled: Optional[bool] = None
    in_app_enabled: Optional[bool] = None
    notification_types: Optional[Dict[str, bool]] = None  # Enable/disable specific types
    quiet_hours_start: Optional[str] = None  # Format: "HH:MM"
    quiet_hours_end: Optional[str] = None  # Format: "HH:MM"


class NotificationPreferencesResponse(BaseModel):
    """Response model for notification preferences"""
    id: str
    user_id: str
    email_enabled: bool = True
    push_enabled: bool = True
    sms_enabled: bool = False
    in_app_enabled: bool = True
    notification_types: Dict[str, bool] = Field(default_factory=dict)
    quiet_hours_start: Optional[str] = None
    quiet_hours_end: Optional[str] = None
    created_at: str
    updated_at: str

    class Config:
        from_attributes = True


class NotificationStats(BaseModel):
    """Notification statistics"""
    total_notifications: int
    unread_count: int
    read_count: int
    by_type: Dict[str, int]
    by_priority: Dict[str, int]
    recent_activity: List[Dict[str, Any]] = Field(default_factory=list)
