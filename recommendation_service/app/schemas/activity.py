"""
Pydantic schemas for Activity Log API
"""
from pydantic import BaseModel, Field
from typing import Optional, List, Dict, Any
from datetime import datetime
from uuid import UUID
from enum import Enum


class ActivityLogBase(BaseModel):
    """Base schema for activity log"""
    action_type: str
    description: str
    metadata: Optional[Dict[str, Any]] = Field(default_factory=dict)


class ActivityLogCreate(ActivityLogBase):
    """Schema for creating an activity log"""
    user_id: Optional[str] = None
    user_name: Optional[str] = None
    user_email: Optional[str] = None
    user_role: Optional[str] = None
    ip_address: Optional[str] = None
    user_agent: Optional[str] = None


class ActivityLogResponse(BaseModel):
    """Schema for activity log response"""
    id: str
    timestamp: datetime
    user_id: Optional[str] = None
    user_name: Optional[str] = None
    user_email: Optional[str] = None
    user_role: Optional[str] = None
    action_type: str
    description: str
    metadata: Dict[str, Any] = Field(default_factory=dict)
    ip_address: Optional[str] = None
    user_agent: Optional[str] = None
    created_at: datetime

    class Config:
        from_attributes = True


class RecentActivityResponse(BaseModel):
    """Schema for recent activity feed response"""
    activities: List[ActivityLogResponse]
    total_count: int
    limit: int
    has_more: bool


class ActivityFilterRequest(BaseModel):
    """Schema for filtering activities"""
    limit: int = Field(default=10, ge=1, le=100, description="Maximum number of activities to return")
    user_id: Optional[str] = Field(default=None, description="Filter by user ID")
    action_types: Optional[List[str]] = Field(default=None, description="Filter by action types")
    start_date: Optional[datetime] = Field(default=None, description="Filter by start date")
    end_date: Optional[datetime] = Field(default=None, description="Filter by end date")
    user_role: Optional[str] = Field(default=None, description="Filter by user role")


class UserActivitySummary(BaseModel):
    """Schema for user activity summary"""
    user_id: str
    days: int
    total_activities: int
    activity_breakdown: Dict[str, int]
    error: Optional[str] = None


class ActivityStatsResponse(BaseModel):
    """Schema for activity statistics"""
    total_activities: int
    activities_today: int
    activities_this_week: int
    activities_this_month: int
    top_action_types: Dict[str, int]
    top_users: List[Dict[str, Any]]
    recent_registrations: int
    recent_logins: int
    recent_applications: int


# ==================== Student Activity Feed Schemas ====================


class StudentActivityType(str, Enum):
    """Types of student activities for the activity feed"""
    APPLICATION_SUBMITTED = "application_submitted"
    APPLICATION_STATUS_CHANGED = "application_status_changed"
    ACHIEVEMENT_EARNED = "achievement_earned"
    PAYMENT_MADE = "payment_made"
    MESSAGE_RECEIVED = "message_received"
    COURSE_COMPLETED = "course_completed"
    MEETING_SCHEDULED = "meeting_scheduled"
    MEETING_COMPLETED = "meeting_completed"


class StudentActivity(BaseModel):
    """Student activity feed item"""
    id: str
    timestamp: datetime
    type: StudentActivityType
    title: str
    description: str
    icon: str
    related_entity_id: Optional[str] = Field(
        default=None,
        description="ID of related entity (application_id, achievement_id, etc.)"
    )
    metadata: Dict[str, Any] = Field(
        default_factory=dict,
        description="Additional context data (university_name, amount, status, etc.)"
    )

    class Config:
        from_attributes = True


class StudentActivityFeedResponse(BaseModel):
    """Response for student activity feed with pagination"""
    activities: List[StudentActivity]
    total_count: int
    page: int = Field(default=1, ge=1, description="Current page number")
    limit: int = Field(default=10, ge=1, le=100, description="Items per page")
    has_more: bool = Field(description="Whether more pages are available")


class StudentActivityFilterRequest(BaseModel):
    """Schema for filtering student activities"""
    page: int = Field(default=1, ge=1, description="Page number")
    limit: int = Field(default=10, ge=1, le=100, description="Items per page")
    activity_types: Optional[List[StudentActivityType]] = Field(
        default=None,
        description="Filter by specific activity types"
    )
    start_date: Optional[datetime] = Field(
        default=None,
        description="Filter activities after this date"
    )
    end_date: Optional[datetime] = Field(
        default=None,
        description="Filter activities before this date"
    )
