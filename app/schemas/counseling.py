"""
Counseling Data Models
Pydantic schemas for counseling sessions and bookings
"""
from typing import Optional, List, Dict, Any
from pydantic import BaseModel, Field
from datetime import datetime
from enum import Enum


class SessionType(str, Enum):
    """Counseling session type"""
    ACADEMIC = "academic"  # Academic counseling
    CAREER = "career"  # Career guidance
    PERSONAL = "personal"  # Personal counseling
    UNIVERSITY = "university"  # University application guidance
    MENTAL_HEALTH = "mental_health"  # Mental health support
    GROUP = "group"  # Group session


class SessionStatus(str, Enum):
    """Session status enumeration"""
    SCHEDULED = "scheduled"
    IN_PROGRESS = "in_progress"
    COMPLETED = "completed"
    CANCELLED = "cancelled"
    NO_SHOW = "no_show"
    RESCHEDULED = "rescheduled"


class SessionMode(str, Enum):
    """Session delivery mode"""
    VIDEO = "video"  # Video call
    AUDIO = "audio"  # Audio call
    CHAT = "chat"  # Text chat
    IN_PERSON = "in_person"  # Face-to-face


# Counseling Session Models
class CounselingSessionCreateRequest(BaseModel):
    """Request model for creating a counseling session booking"""
    counselor_id: str
    student_id: Optional[str] = None  # For counselor creating on behalf
    session_type: SessionType
    session_mode: SessionMode
    scheduled_start: str  # ISO datetime
    scheduled_end: str  # ISO datetime
    topic: Optional[str] = Field(None, max_length=200)
    description: Optional[str] = None
    metadata: Optional[Dict[str, Any]] = None


class CounselingSessionUpdateRequest(BaseModel):
    """Request model for updating a counseling session"""
    scheduled_start: Optional[str] = None
    scheduled_end: Optional[str] = None
    topic: Optional[str] = Field(None, max_length=200)
    description: Optional[str] = None
    session_mode: Optional[SessionMode] = None


class CounselingSessionResponse(BaseModel):
    """Response model for counseling session data"""
    id: str
    counselor_id: str
    student_id: str
    session_type: str
    session_mode: str
    status: str
    scheduled_start: str
    scheduled_end: str
    actual_start: Optional[str] = None
    actual_end: Optional[str] = None
    topic: Optional[str] = None
    description: Optional[str] = None
    meeting_link: Optional[str] = None  # Video/audio call link
    notes_id: Optional[str] = None  # Link to session notes
    feedback_rating: Optional[float] = None
    feedback_comment: Optional[str] = None
    metadata: Optional[Dict[str, Any]] = None
    created_at: str
    updated_at: str

    class Config:
        from_attributes = True


class CounselingSessionListResponse(BaseModel):
    """Response model for paginated session list"""
    sessions: List[CounselingSessionResponse]
    total: int
    page: int
    page_size: int
    has_more: bool


# Session Notes Models
class SessionNotesCreateRequest(BaseModel):
    """Request model for creating session notes"""
    session_id: str
    private_notes: str = Field(..., min_length=1)  # Only counselor can see
    shared_notes: Optional[str] = None  # Student can see
    action_items: Optional[List[str]] = Field(default_factory=list)
    follow_up_required: bool = False
    follow_up_date: Optional[str] = None


class SessionNotesUpdateRequest(BaseModel):
    """Request model for updating session notes"""
    private_notes: Optional[str] = None
    shared_notes: Optional[str] = None
    action_items: Optional[List[str]] = None
    follow_up_required: Optional[bool] = None
    follow_up_date: Optional[str] = None


class SessionNotesResponse(BaseModel):
    """Response model for session notes"""
    id: str
    session_id: str
    counselor_id: str
    private_notes: str  # Only for counselor
    shared_notes: Optional[str] = None
    action_items: List[str] = Field(default_factory=list)
    follow_up_required: bool = False
    follow_up_date: Optional[str] = None
    created_at: str
    updated_at: str

    class Config:
        from_attributes = True


# Counselor Availability Models
class CounselorAvailabilityCreateRequest(BaseModel):
    """Request model for setting counselor availability"""
    day_of_week: int = Field(..., ge=0, le=6)  # 0=Monday, 6=Sunday
    start_time: str = Field(..., pattern=r"^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$")  # HH:MM
    end_time: str = Field(..., pattern=r"^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$")  # HH:MM
    session_duration: int = Field(30, ge=15, le=180)  # Duration in minutes
    max_sessions_per_day: Optional[int] = Field(None, ge=1)


class CounselorAvailabilityResponse(BaseModel):
    """Response model for counselor availability"""
    id: str
    counselor_id: str
    day_of_week: int
    start_time: str
    end_time: str
    session_duration: int
    max_sessions_per_day: Optional[int] = None
    is_active: bool = True
    created_at: str
    updated_at: str

    class Config:
        from_attributes = True


class CounselorAvailabilityListResponse(BaseModel):
    """Response model for counselor availability list"""
    availability: List[CounselorAvailabilityResponse]
    total: int


# Session Feedback Models
class SessionFeedbackRequest(BaseModel):
    """Request model for session feedback"""
    rating: float = Field(..., ge=1.0, le=5.0)
    comment: Optional[str] = Field(None, max_length=1000)


# Statistics Models
class CounselingStats(BaseModel):
    """Counseling statistics"""
    total_sessions: int
    completed_sessions: int
    upcoming_sessions: int
    cancelled_sessions: int
    average_rating: Optional[float] = None
    total_hours: float
    by_type: Dict[str, int]
    by_status: Dict[str, int]
    recent_sessions: List[Dict[str, Any]] = Field(default_factory=list)


class CounselorStats(BaseModel):
    """Counselor-specific statistics"""
    total_students: int
    total_sessions: int
    completed_sessions: int
    average_rating: Optional[float] = None
    total_hours: float
    sessions_this_week: int
    sessions_this_month: int
    by_type: Dict[str, int]
    top_topics: List[Dict[str, Any]] = Field(default_factory=list)


# Available Time Slots Models
class AvailableTimeSlot(BaseModel):
    """Available time slot for booking"""
    date: str  # YYYY-MM-DD
    start_time: str  # HH:MM
    end_time: str  # HH:MM
    is_available: bool


class AvailableTimeSlotsResponse(BaseModel):
    """Response model for available time slots"""
    counselor_id: str
    date_range_start: str
    date_range_end: str
    slots: List[AvailableTimeSlot]
