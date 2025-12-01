"""
Pydantic schemas for parent-teacher/counselor meeting system
"""
from pydantic import BaseModel, Field, validator
from typing import Optional, List
from datetime import datetime, time


class MeetingBase(BaseModel):
    """Base schema for meeting"""
    staff_id: str
    student_id: str
    staff_type: str  # 'teacher' or 'counselor'
    meeting_type: str  # 'parent_teacher' or 'parent_counselor'
    subject: str
    scheduled_date: Optional[datetime] = None
    duration_minutes: int = 30
    meeting_mode: str  # 'in_person', 'video_call', 'phone_call'
    meeting_link: Optional[str] = None
    location: Optional[str] = None
    notes: Optional[str] = None

    @validator('staff_type')
    def validate_staff_type(cls, v):
        if v not in ['teacher', 'counselor']:
            raise ValueError("staff_type must be 'teacher' or 'counselor'")
        return v

    @validator('meeting_type')
    def validate_meeting_type(cls, v):
        if v not in ['parent_teacher', 'parent_counselor']:
            raise ValueError("meeting_type must be 'parent_teacher' or 'parent_counselor'")
        return v

    @validator('meeting_mode')
    def validate_meeting_mode(cls, v):
        if v not in ['in_person', 'video_call', 'phone_call']:
            raise ValueError("meeting_mode must be 'in_person', 'video_call', or 'phone_call'")
        return v

    @validator('duration_minutes')
    def validate_duration(cls, v):
        if v not in [15, 30, 45, 60, 90, 120]:
            raise ValueError("duration_minutes must be one of: 15, 30, 45, 60, 90, 120")
        return v


class MeetingRequest(MeetingBase):
    """Schema for requesting a meeting (parent creates)"""
    parent_notes: Optional[str] = None


class MeetingUpdate(BaseModel):
    """Schema for updating meeting details"""
    scheduled_date: Optional[datetime] = None
    duration_minutes: Optional[int] = None
    meeting_mode: Optional[str] = None
    meeting_link: Optional[str] = None
    location: Optional[str] = None
    subject: Optional[str] = None
    notes: Optional[str] = None
    parent_notes: Optional[str] = None
    staff_notes: Optional[str] = None

    @validator('meeting_mode')
    def validate_meeting_mode(cls, v):
        if v and v not in ['in_person', 'video_call', 'phone_call']:
            raise ValueError("meeting_mode must be 'in_person', 'video_call', or 'phone_call'")
        return v

    @validator('duration_minutes')
    def validate_duration(cls, v):
        if v and v not in [15, 30, 45, 60, 90, 120]:
            raise ValueError("duration_minutes must be one of: 15, 30, 45, 60, 90, 120")
        return v


class MeetingApproval(BaseModel):
    """Schema for approving a meeting"""
    scheduled_date: datetime
    duration_minutes: int = 30
    meeting_link: Optional[str] = None
    location: Optional[str] = None
    staff_notes: Optional[str] = None

    @validator('duration_minutes')
    def validate_duration(cls, v):
        if v not in [15, 30, 45, 60, 90, 120]:
            raise ValueError("duration_minutes must be one of: 15, 30, 45, 60, 90, 120")
        return v


class MeetingDecline(BaseModel):
    """Schema for declining a meeting"""
    staff_notes: str


class MeetingResponse(BaseModel):
    """Response schema for meeting with full details"""
    id: str
    parent_id: str
    parent_name: Optional[str] = None
    student_id: str
    student_name: Optional[str] = None
    staff_id: str
    staff_name: Optional[str] = None
    staff_type: str
    meeting_type: str
    status: str  # 'pending', 'approved', 'declined', 'cancelled', 'completed'
    scheduled_date: Optional[datetime] = None
    duration_minutes: int
    meeting_mode: str
    meeting_link: Optional[str] = None
    location: Optional[str] = None
    subject: str
    notes: Optional[str] = None
    parent_notes: Optional[str] = None
    staff_notes: Optional[str] = None
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


class StaffAvailabilityCreate(BaseModel):
    """Schema for creating staff availability"""
    day_of_week: int  # 0=Sunday, 1=Monday, ..., 6=Saturday
    start_time: time
    end_time: time

    @validator('day_of_week')
    def validate_day_of_week(cls, v):
        if v not in range(0, 7):
            raise ValueError("day_of_week must be between 0 (Sunday) and 6 (Saturday)")
        return v

    @validator('end_time')
    def validate_time_range(cls, v, values):
        if 'start_time' in values and v <= values['start_time']:
            raise ValueError("end_time must be after start_time")
        return v


class StaffAvailabilityUpdate(BaseModel):
    """Schema for updating staff availability"""
    start_time: Optional[time] = None
    end_time: Optional[time] = None
    is_active: Optional[bool] = None

    @validator('end_time')
    def validate_time_range(cls, v, values):
        if v and 'start_time' in values and values['start_time'] and v <= values['start_time']:
            raise ValueError("end_time must be after start_time")
        return v


class StaffAvailabilityResponse(BaseModel):
    """Response schema for staff availability"""
    id: str
    staff_id: str
    day_of_week: int
    day_name: Optional[str] = None
    start_time: time
    end_time: time
    is_active: bool
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


class AvailableSlot(BaseModel):
    """Schema for available time slot"""
    date: datetime
    start_time: datetime
    end_time: datetime
    day_of_week: int
    day_name: str


class AvailableSlotsRequest(BaseModel):
    """Request schema for getting available slots"""
    staff_id: str
    start_date: datetime
    end_date: datetime
    duration_minutes: int = 30

    @validator('duration_minutes')
    def validate_duration(cls, v):
        if v not in [15, 30, 45, 60, 90, 120]:
            raise ValueError("duration_minutes must be one of: 15, 30, 45, 60, 90, 120")
        return v

    @validator('end_date')
    def validate_date_range(cls, v, values):
        if 'start_date' in values and v <= values['start_date']:
            raise ValueError("end_date must be after start_date")
        return v


class StaffListItem(BaseModel):
    """Schema for staff member in list"""
    id: str
    display_name: str
    email: str
    active_role: str
    photo_url: Optional[str] = None  # Matches database column name
    bio: Optional[str] = None

    class Config:
        from_attributes = True


class MeetingStatistics(BaseModel):
    """Schema for meeting statistics"""
    total_meetings: int
    pending_meetings: int
    approved_meetings: int
    declined_meetings: int
    cancelled_meetings: int
    completed_meetings: int
    upcoming_meetings: int
    meetings_by_type: dict
    meetings_by_mode: dict
