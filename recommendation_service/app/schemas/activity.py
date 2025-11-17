"""
Pydantic schemas for Activity Log API
"""
from pydantic import BaseModel, Field
from typing import Optional, List, Dict, Any
from datetime import datetime
from uuid import UUID


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
