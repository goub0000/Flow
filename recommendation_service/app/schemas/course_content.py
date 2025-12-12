"""
Pydantic schemas for course content management
"""

from pydantic import BaseModel, Field, field_validator
from typing import List, Optional, Dict, Any
from datetime import datetime
from enum import Enum
from decimal import Decimal


# ============================================================================
# ENUMS
# ============================================================================

class LessonType(str, Enum):
    """Types of lesson content"""
    VIDEO = "video"
    TEXT = "text"
    QUIZ = "quiz"
    ASSIGNMENT = "assignment"


class QuestionType(str, Enum):
    """Types of quiz questions"""
    MULTIPLE_CHOICE = "multiple_choice"
    TRUE_FALSE = "true_false"
    SHORT_ANSWER = "short_answer"
    ESSAY = "essay"


class SubmissionType(str, Enum):
    """Types of assignment submissions"""
    TEXT = "text"
    FILE = "file"
    URL = "url"
    BOTH = "both"


class QuizAttemptStatus(str, Enum):
    """Status of quiz attempt"""
    IN_PROGRESS = "in_progress"
    SUBMITTED = "submitted"
    GRADED = "graded"


class SubmissionStatus(str, Enum):
    """Status of assignment submission"""
    DRAFT = "draft"
    SUBMITTED = "submitted"
    GRADING = "grading"
    GRADED = "graded"
    RETURNED = "returned"


class VideoPlatform(str, Enum):
    """Video hosting platforms"""
    YOUTUBE = "youtube"
    VIMEO = "vimeo"
    DIRECT = "direct"
    OTHER = "other"


class ContentFormat(str, Enum):
    """Content formatting types"""
    MARKDOWN = "markdown"
    HTML = "html"
    PLAIN = "plain"


# ============================================================================
# COURSE MODULE SCHEMAS
# ============================================================================

class ModuleCreate(BaseModel):
    """Schema for creating a course module"""
    title: str = Field(..., min_length=1, max_length=255)
    description: Optional[str] = None
    order_index: int = Field(default=0, ge=0)
    learning_objectives: Optional[List[str]] = []
    is_published: bool = False

    class Config:
        json_schema_extra = {
            "example": {
                "title": "Introduction to Python",
                "description": "Learn the fundamentals of Python programming",
                "order_index": 0,
                "learning_objectives": [
                    "Understand Python syntax",
                    "Write basic programs",
                    "Use variables and data types"
                ],
                "is_published": False
            }
        }


class ModuleUpdate(BaseModel):
    """Schema for updating a course module"""
    title: Optional[str] = Field(None, min_length=1, max_length=255)
    description: Optional[str] = None
    order_index: Optional[int] = Field(None, ge=0)
    learning_objectives: Optional[List[str]] = None
    is_published: Optional[bool] = None


class ModuleResponse(BaseModel):
    """Schema for returning course module"""
    id: str
    course_id: str
    title: str
    description: Optional[str] = None
    order_index: int = 0
    learning_objectives: List[str] = []
    is_published: bool = False
    lesson_count: int = 0
    duration_minutes: int = 0
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


class ModuleReorderRequest(BaseModel):
    """Schema for reordering modules"""
    module_orders: List[Dict[str, int]]  # [{module_id: order_index}]


# ============================================================================
# COURSE LESSON SCHEMAS
# ============================================================================

class LessonCreate(BaseModel):
    """Schema for creating a course lesson"""
    title: str = Field(..., min_length=1, max_length=255)
    description: Optional[str] = None
    lesson_type: LessonType
    order_index: int = Field(default=0, ge=0)
    duration_minutes: int = Field(default=0, ge=0)
    is_mandatory: bool = True
    is_published: bool = False
    allow_preview: bool = False

    class Config:
        json_schema_extra = {
            "example": {
                "title": "Variables and Data Types",
                "description": "Learn about Python variables",
                "lesson_type": "video",
                "order_index": 0,
                "duration_minutes": 15,
                "is_mandatory": True,
                "is_published": False
            }
        }


class LessonUpdate(BaseModel):
    """Schema for updating a course lesson"""
    title: Optional[str] = Field(None, min_length=1, max_length=255)
    description: Optional[str] = None
    lesson_type: Optional[LessonType] = None
    order_index: Optional[int] = Field(None, ge=0)
    duration_minutes: Optional[int] = Field(None, ge=0)
    is_mandatory: Optional[bool] = None
    is_published: Optional[bool] = None
    allow_preview: Optional[bool] = None


class LessonResponse(BaseModel):
    """Schema for returning course lesson"""
    id: str
    module_id: str
    title: str
    description: Optional[str] = None
    lesson_type: LessonType
    order_index: int = 0
    duration_minutes: int = 0
    is_mandatory: bool = True
    is_published: bool = False
    allow_preview: bool = False
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


class LessonReorderRequest(BaseModel):
    """Schema for reordering lessons"""
    lesson_orders: List[Dict[str, int]]  # [{lesson_id: order_index}]


# ============================================================================
# LESSON CONTENT SCHEMAS - VIDEO
# ============================================================================

class VideoContentCreate(BaseModel):
    """Schema for creating video lesson content"""
    video_url: str
    video_platform: VideoPlatform = VideoPlatform.YOUTUBE
    thumbnail_url: Optional[str] = None
    duration_seconds: Optional[int] = Field(None, ge=0)
    transcript: Optional[str] = None
    allow_download: bool = False
    auto_play: bool = False
    show_controls: bool = True


class VideoContentUpdate(BaseModel):
    """Schema for updating video lesson content"""
    video_url: Optional[str] = None
    video_platform: Optional[VideoPlatform] = None
    thumbnail_url: Optional[str] = None
    duration_seconds: Optional[int] = Field(None, ge=0)
    transcript: Optional[str] = None
    allow_download: Optional[bool] = None
    auto_play: Optional[bool] = None
    show_controls: Optional[bool] = None


class VideoContentResponse(BaseModel):
    """Schema for returning video lesson content"""
    id: str
    lesson_id: str
    video_url: str
    video_platform: VideoPlatform = VideoPlatform.YOUTUBE
    thumbnail_url: Optional[str] = None
    duration_seconds: Optional[int] = None
    transcript: Optional[str] = None
    allow_download: bool = False
    auto_play: bool = False
    show_controls: bool = True
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


# ============================================================================
# LESSON CONTENT SCHEMAS - TEXT
# ============================================================================

class TextContentCreate(BaseModel):
    """Schema for creating text lesson content"""
    content: str
    content_format: ContentFormat = ContentFormat.MARKDOWN
    estimated_reading_time: Optional[int] = Field(None, ge=0)
    attachments: Optional[List[Dict[str, Any]]] = []
    external_links: Optional[List[Dict[str, str]]] = []


class TextContentUpdate(BaseModel):
    """Schema for updating text lesson content"""
    content: Optional[str] = None
    content_format: Optional[ContentFormat] = None
    estimated_reading_time: Optional[int] = Field(None, ge=0)
    attachments: Optional[List[Dict[str, Any]]] = None
    external_links: Optional[List[Dict[str, str]]] = None


class TextContentResponse(BaseModel):
    """Schema for returning text lesson content"""
    id: str
    lesson_id: str
    content: str
    content_format: ContentFormat = ContentFormat.MARKDOWN
    estimated_reading_time: Optional[int] = None
    attachments: List[Dict[str, Any]] = []
    external_links: List[Dict[str, str]] = []
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


# ============================================================================
# LESSON CONTENT SCHEMAS - QUIZ
# ============================================================================

class QuizContentCreate(BaseModel):
    """Schema for creating quiz lesson content"""
    title: Optional[str] = Field(None, max_length=255)
    instructions: Optional[str] = None
    passing_score: Decimal = Field(default=Decimal("70.00"), ge=0, le=100)
    max_attempts: Optional[int] = Field(None, gt=0)
    time_limit_minutes: Optional[int] = Field(None, gt=0)
    shuffle_questions: bool = False
    shuffle_options: bool = False
    show_correct_answers: bool = True
    show_feedback: bool = True


class QuizContentUpdate(BaseModel):
    """Schema for updating quiz lesson content"""
    title: Optional[str] = Field(None, max_length=255)
    instructions: Optional[str] = None
    passing_score: Optional[Decimal] = Field(None, ge=0, le=100)
    max_attempts: Optional[int] = Field(None, gt=0)
    time_limit_minutes: Optional[int] = Field(None, gt=0)
    shuffle_questions: Optional[bool] = None
    shuffle_options: Optional[bool] = None
    show_correct_answers: Optional[bool] = None
    show_feedback: Optional[bool] = None


class QuizContentResponse(BaseModel):
    """Schema for returning quiz lesson content"""
    id: str
    lesson_id: str
    title: Optional[str] = None
    instructions: Optional[str] = None
    passing_score: Decimal = Decimal("70.00")
    max_attempts: Optional[int] = None
    time_limit_minutes: Optional[int] = None
    shuffle_questions: bool = False
    shuffle_options: bool = False
    show_correct_answers: bool = True
    show_feedback: bool = True
    total_points: int = 0
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


# ============================================================================
# LESSON CONTENT SCHEMAS - ASSIGNMENT
# ============================================================================

class AssignmentContentCreate(BaseModel):
    """Schema for creating assignment lesson content"""
    title: str = Field(..., min_length=1, max_length=255)
    instructions: str
    submission_type: SubmissionType = SubmissionType.BOTH
    allowed_file_types: Optional[List[str]] = []
    max_file_size_mb: int = Field(default=10, gt=0)
    points_possible: int = Field(default=100, gt=0)
    rubric: Optional[List[Dict[str, Any]]] = []
    due_date: Optional[datetime] = None
    allow_late_submission: bool = True
    late_penalty_percent: Decimal = Field(default=Decimal("0.00"), ge=0, le=100)


class AssignmentContentUpdate(BaseModel):
    """Schema for updating assignment lesson content"""
    title: Optional[str] = Field(None, min_length=1, max_length=255)
    instructions: Optional[str] = None
    submission_type: Optional[SubmissionType] = None
    allowed_file_types: Optional[List[str]] = None
    max_file_size_mb: Optional[int] = Field(None, gt=0)
    points_possible: Optional[int] = Field(None, gt=0)
    rubric: Optional[List[Dict[str, Any]]] = None
    due_date: Optional[datetime] = None
    allow_late_submission: Optional[bool] = None
    late_penalty_percent: Optional[Decimal] = Field(None, ge=0, le=100)


class AssignmentContentResponse(BaseModel):
    """Schema for returning assignment lesson content"""
    id: str
    lesson_id: str
    title: str
    instructions: str
    submission_type: SubmissionType = SubmissionType.BOTH
    allowed_file_types: List[str] = []
    max_file_size_mb: int = 10
    points_possible: int = 100
    rubric: List[Dict[str, Any]] = []
    due_date: Optional[datetime] = None
    allow_late_submission: bool = True
    late_penalty_percent: Decimal = Decimal("0.00")
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


# ============================================================================
# QUIZ QUESTION SCHEMAS
# ============================================================================

class QuizQuestionCreate(BaseModel):
    """Schema for creating quiz question"""
    question_text: str
    question_type: QuestionType = QuestionType.MULTIPLE_CHOICE
    order_index: int = Field(default=0, ge=0)
    points: int = Field(default=1, gt=0)
    correct_answer: Optional[str] = None
    sample_answer: Optional[str] = None
    explanation: Optional[str] = None
    hint: Optional[str] = None
    is_required: bool = True


class QuizQuestionUpdate(BaseModel):
    """Schema for updating quiz question"""
    question_text: Optional[str] = None
    question_type: Optional[QuestionType] = None
    order_index: Optional[int] = Field(None, ge=0)
    points: Optional[int] = Field(None, gt=0)
    correct_answer: Optional[str] = None
    sample_answer: Optional[str] = None
    explanation: Optional[str] = None
    hint: Optional[str] = None
    is_required: Optional[bool] = None


class QuizQuestionResponse(BaseModel):
    """Schema for returning quiz question"""
    id: str
    quiz_id: str
    question_text: str
    question_type: QuestionType = QuestionType.MULTIPLE_CHOICE
    order_index: int = 0
    points: int = 1
    correct_answer: Optional[str] = None
    sample_answer: Optional[str] = None
    explanation: Optional[str] = None
    hint: Optional[str] = None
    is_required: bool = True
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


# ============================================================================
# QUIZ QUESTION OPTION SCHEMAS
# ============================================================================

class QuestionOptionCreate(BaseModel):
    """Schema for creating quiz question option"""
    option_text: str
    order_index: int = Field(default=0, ge=0)
    is_correct: bool = False
    feedback: Optional[str] = None


class QuestionOptionUpdate(BaseModel):
    """Schema for updating quiz question option"""
    option_text: Optional[str] = None
    order_index: Optional[int] = Field(None, ge=0)
    is_correct: Optional[bool] = None
    feedback: Optional[str] = None


class QuestionOptionResponse(BaseModel):
    """Schema for returning quiz question option"""
    id: str
    question_id: str
    option_text: str
    order_index: int = 0
    is_correct: bool = False
    feedback: Optional[str] = None
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


# ============================================================================
# PROGRESS TRACKING SCHEMAS
# ============================================================================

class LessonCompletionCreate(BaseModel):
    """Schema for marking lesson as complete"""
    user_id: str
    time_spent_minutes: int = Field(default=0, ge=0)
    completed_from_device: Optional[str] = None
    completion_percentage: Decimal = Field(default=Decimal("100.00"), ge=0, le=100)


class CourseProgressResponse(BaseModel):
    """Schema for returning course progress"""
    course_id: str
    user_id: str
    total_modules: int = 0
    total_lessons: int = 0
    completed_lessons: int = 0
    progress_percentage: float = 0.0


class QuizAttemptCreate(BaseModel):
    """Schema for creating quiz attempt"""
    user_id: str
    attempt_number: int = Field(default=1, gt=0)


class QuizAttemptSubmit(BaseModel):
    """Schema for submitting quiz attempt"""
    answers: List[Dict[str, Any]]


class QuizAttemptResponse(BaseModel):
    """Schema for returning quiz attempt"""
    id: str
    quiz_id: str
    user_id: str
    attempt_number: int
    status: QuizAttemptStatus
    score: Decimal = Decimal("0.00")
    points_earned: int = 0
    points_possible: int = 0
    passed: bool = False
    started_at: datetime
    submitted_at: Optional[datetime] = None
    time_taken_minutes: Optional[int] = None
    answers: List[Dict[str, Any]] = []
    instructor_feedback: Optional[str] = None
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


class AssignmentSubmissionCreate(BaseModel):
    """Schema for creating assignment submission"""
    user_id: str
    text_submission: Optional[str] = None
    file_urls: Optional[List[Dict[str, Any]]] = []
    external_url: Optional[str] = None


class AssignmentSubmissionUpdate(BaseModel):
    """Schema for updating assignment submission"""
    status: Optional[SubmissionStatus] = None
    text_submission: Optional[str] = None
    file_urls: Optional[List[Dict[str, Any]]] = None
    external_url: Optional[str] = None
    points_earned: Optional[Decimal] = Field(None, ge=0)
    instructor_feedback: Optional[str] = None
    rubric_scores: Optional[List[Dict[str, Any]]] = None


class AssignmentSubmissionResponse(BaseModel):
    """Schema for returning assignment submission"""
    id: str
    assignment_id: str
    user_id: str
    status: SubmissionStatus = SubmissionStatus.DRAFT
    text_submission: Optional[str] = None
    file_urls: List[Dict[str, Any]] = []
    external_url: Optional[str] = None
    points_earned: Optional[Decimal] = None
    points_possible: Optional[int] = None
    grade_percentage: Optional[Decimal] = None
    instructor_feedback: Optional[str] = None
    rubric_scores: List[Dict[str, Any]] = []
    graded_by: Optional[str] = None
    graded_at: Optional[datetime] = None
    submitted_at: Optional[datetime] = None
    returned_at: Optional[datetime] = None
    is_late: bool = False
    late_days: int = 0
    late_penalty_applied: Decimal = Decimal("0.00")
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True
