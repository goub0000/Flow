"""
Recommendation Letters Schemas
Data models for letter of recommendation management system
"""
from typing import Optional, List, Dict, Any
from pydantic import BaseModel, Field
from datetime import date, datetime
from enum import Enum


class RequestType(str, Enum):
    """Types of recommendation requests"""
    ACADEMIC = "academic"
    PROFESSIONAL = "professional"
    CHARACTER = "character"
    SCHOLARSHIP = "scholarship"


class RequestStatus(str, Enum):
    """Status of recommendation request"""
    PENDING = "pending"
    ACCEPTED = "accepted"
    DECLINED = "declined"
    IN_PROGRESS = "in_progress"
    COMPLETED = "completed"
    CANCELLED = "cancelled"


class RequestPriority(str, Enum):
    """Priority levels for requests"""
    LOW = "low"
    NORMAL = "normal"
    HIGH = "high"
    URGENT = "urgent"


class LetterStatus(str, Enum):
    """Status of recommendation letter"""
    DRAFT = "draft"
    SUBMITTED = "submitted"
    ARCHIVED = "archived"


class LetterType(str, Enum):
    """Types of letter formats"""
    FORMAL = "formal"
    INFORMAL = "informal"
    EMAIL_FORMAT = "email_format"


class ReminderType(str, Enum):
    """Types of reminders"""
    DEADLINE_APPROACHING = "deadline_approaching"
    OVERDUE = "overdue"
    FOLLOW_UP = "follow_up"


class TemplateCategory(str, Enum):
    """Categories for templates"""
    ACADEMIC = "academic"
    PROFESSIONAL = "professional"
    SCHOLARSHIP = "scholarship"
    CHARACTER = "character"


# ==================== Recommendation Request Models ====================

class RecommendationRequestBase(BaseModel):
    """Base recommendation request model"""
    request_type: RequestType
    purpose: str = Field(..., min_length=10)
    institution_name: Optional[str] = None
    deadline: date
    priority: RequestPriority = RequestPriority.NORMAL
    student_message: Optional[str] = None
    achievements: Optional[str] = None
    goals: Optional[str] = None
    relationship_context: Optional[str] = None


class RecommendationRequestCreate(RecommendationRequestBase):
    """Create new recommendation request"""
    student_id: str
    recommender_id: str


class RecommendationRequestUpdate(BaseModel):
    """Update recommendation request"""
    status: Optional[RequestStatus] = None
    priority: Optional[RequestPriority] = None
    deadline: Optional[date] = None
    purpose: Optional[str] = None
    institution_name: Optional[str] = None
    student_message: Optional[str] = None
    achievements: Optional[str] = None
    goals: Optional[str] = None


class RecommendationRequestResponse(RecommendationRequestBase):
    """Recommendation request response"""
    id: str
    student_id: str
    recommender_id: str
    status: RequestStatus
    accepted_at: Optional[datetime] = None
    declined_at: Optional[datetime] = None
    decline_reason: Optional[str] = None
    requested_at: datetime
    completed_at: Optional[datetime] = None
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


class RecommendationRequestWithDetails(RecommendationRequestResponse):
    """Request with additional details (student/recommender info)"""
    student_name: Optional[str] = None
    student_email: Optional[str] = None
    recommender_name: Optional[str] = None
    recommender_email: Optional[str] = None
    recommender_title: Optional[str] = None
    has_letter: bool = False
    letter_status: Optional[LetterStatus] = None


# ==================== Letter of Recommendation Models ====================

class LetterOfRecommendationBase(BaseModel):
    """Base letter model"""
    content: str = Field(..., min_length=100)
    letter_type: Optional[LetterType] = LetterType.FORMAL
    is_visible_to_student: bool = False


class LetterOfRecommendationCreate(LetterOfRecommendationBase):
    """Create new letter"""
    request_id: str
    template_id: Optional[str] = None


class LetterOfRecommendationUpdate(BaseModel):
    """Update letter"""
    content: Optional[str] = Field(None, min_length=100)
    letter_type: Optional[LetterType] = None
    status: Optional[LetterStatus] = None
    is_visible_to_student: Optional[bool] = None


class LetterOfRecommendationResponse(LetterOfRecommendationBase):
    """Letter response"""
    id: str
    request_id: str
    status: LetterStatus
    is_template_based: bool
    template_id: Optional[str] = None
    word_count: Optional[int] = None
    character_count: Optional[int] = None
    share_token: Optional[str] = None
    attachment_url: Optional[str] = None
    attachment_filename: Optional[str] = None
    drafted_at: datetime
    submitted_at: Optional[datetime] = None
    last_edited_at: datetime
    created_at: datetime

    class Config:
        from_attributes = True


class LetterOfRecommendationWithRequest(LetterOfRecommendationResponse):
    """Letter with request details"""
    request: Optional[RecommendationRequestResponse] = None
    student_name: Optional[str] = None
    institution_name: Optional[str] = None


# ==================== Template Models ====================

class RecommendationTemplateBase(BaseModel):
    """Base template model"""
    name: str = Field(..., min_length=3, max_length=255)
    description: Optional[str] = None
    category: TemplateCategory
    content: str = Field(..., min_length=50)
    custom_fields: List[str] = Field(default_factory=list)


class RecommendationTemplateCreate(RecommendationTemplateBase):
    """Create new template"""
    is_public: bool = False
    created_by: Optional[str] = None


class RecommendationTemplateUpdate(BaseModel):
    """Update template"""
    name: Optional[str] = Field(None, min_length=3, max_length=255)
    description: Optional[str] = None
    content: Optional[str] = Field(None, min_length=50)
    custom_fields: Optional[List[str]] = None
    is_public: Optional[bool] = None


class RecommendationTemplateResponse(RecommendationTemplateBase):
    """Template response"""
    id: str
    is_public: bool
    created_by: Optional[str] = None
    usage_count: int
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


class TemplateWithFields(RecommendationTemplateResponse):
    """Template with field values for rendering"""
    field_values: Optional[Dict[str, str]] = None


# ==================== Reminder Models ====================

class RecommendationReminderBase(BaseModel):
    """Base reminder model"""
    reminder_type: ReminderType
    days_before_deadline: Optional[int] = Field(None, ge=0, le=30)
    message: Optional[str] = None


class RecommendationReminderCreate(RecommendationReminderBase):
    """Create new reminder"""
    request_id: str


class RecommendationReminderResponse(RecommendationReminderBase):
    """Reminder response"""
    id: str
    request_id: str
    sent_at: Optional[datetime] = None
    is_sent: bool
    created_at: datetime

    class Config:
        from_attributes = True


# ==================== Aggregate/Summary Models ====================

class RecommenderDashboardSummary(BaseModel):
    """Summary for recommender dashboard"""
    total_requests: int
    pending_requests: int
    in_progress: int
    completed: int
    overdue_requests: int
    urgent_requests: int
    upcoming_deadlines: List[RecommendationRequestWithDetails]


class StudentRequestsSummary(BaseModel):
    """Summary of student's recommendation requests"""
    total_requests: int
    pending: int
    accepted: int
    declined: int
    completed: int
    active_requests: List[RecommendationRequestWithDetails]


class LetterStatistics(BaseModel):
    """Statistics about a letter"""
    word_count: int
    character_count: int
    paragraph_count: int
    average_words_per_paragraph: float
    estimated_reading_time_minutes: float


class TemplateRenderRequest(BaseModel):
    """Request to render a template with field values"""
    template_id: str
    field_values: Dict[str, str]


class TemplateRenderResponse(BaseModel):
    """Rendered template response"""
    rendered_content: str
    missing_fields: List[str] = Field(default_factory=list)


class RequestAcceptanceAction(BaseModel):
    """Accept a recommendation request"""
    accepted: bool = True
    message: Optional[str] = None


class RequestDeclineAction(BaseModel):
    """Decline a recommendation request"""
    decline_reason: str = Field(..., min_length=10)


class ShareLetterRequest(BaseModel):
    """Generate shareable link for letter"""
    letter_id: str
    expires_in_days: int = Field(default=30, ge=1, le=365)
