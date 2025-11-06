"""
Course Data Models
Pydantic schemas for course management
"""
from typing import Optional, List, Dict, Any
from pydantic import BaseModel, Field
from datetime import datetime
from enum import Enum


class CourseType(str, Enum):
    """Course type enumeration"""
    VIDEO = "video"
    TEXT = "text"
    INTERACTIVE = "interactive"
    LIVE = "live"
    HYBRID = "hybrid"


class CourseLevel(str, Enum):
    """Course difficulty level"""
    BEGINNER = "beginner"
    INTERMEDIATE = "intermediate"
    ADVANCED = "advanced"
    EXPERT = "expert"


class CourseStatus(str, Enum):
    """Course status"""
    DRAFT = "draft"
    PUBLISHED = "published"
    ARCHIVED = "archived"


# Request Models
class CourseCreateRequest(BaseModel):
    """Request model for creating a new course"""
    title: str = Field(..., min_length=3, max_length=200)
    description: str = Field(..., min_length=10)
    course_type: CourseType
    level: CourseLevel = CourseLevel.BEGINNER
    duration_hours: Optional[float] = Field(None, ge=0)
    price: Optional[float] = Field(0.0, ge=0)
    currency: str = Field(default="USD", max_length=3)
    thumbnail_url: Optional[str] = None
    preview_video_url: Optional[str] = None
    category: Optional[str] = None
    tags: List[str] = Field(default_factory=list)
    learning_outcomes: List[str] = Field(default_factory=list)
    prerequisites: List[str] = Field(default_factory=list)
    max_students: Optional[int] = Field(None, ge=1)
    syllabus: Optional[Dict[str, Any]] = None
    metadata: Optional[Dict[str, Any]] = None


class CourseUpdateRequest(BaseModel):
    """Request model for updating a course"""
    title: Optional[str] = Field(None, min_length=3, max_length=200)
    description: Optional[str] = Field(None, min_length=10)
    course_type: Optional[CourseType] = None
    level: Optional[CourseLevel] = None
    duration_hours: Optional[float] = Field(None, ge=0)
    price: Optional[float] = Field(None, ge=0)
    currency: Optional[str] = Field(None, max_length=3)
    thumbnail_url: Optional[str] = None
    preview_video_url: Optional[str] = None
    category: Optional[str] = None
    tags: Optional[List[str]] = None
    learning_outcomes: Optional[List[str]] = None
    prerequisites: Optional[List[str]] = None
    max_students: Optional[int] = Field(None, ge=1)
    syllabus: Optional[Dict[str, Any]] = None
    status: Optional[CourseStatus] = None
    metadata: Optional[Dict[str, Any]] = None


# Response Models
class CourseResponse(BaseModel):
    """Response model for course data"""
    id: str
    institution_id: str
    title: str
    description: str
    course_type: str
    level: str
    duration_hours: Optional[float] = None
    price: float
    currency: str
    thumbnail_url: Optional[str] = None
    preview_video_url: Optional[str] = None
    category: Optional[str] = None
    tags: List[str] = Field(default_factory=list)
    learning_outcomes: List[str] = Field(default_factory=list)
    prerequisites: List[str] = Field(default_factory=list)
    enrolled_count: int = 0
    max_students: Optional[int] = None
    rating: Optional[float] = None
    review_count: int = 0
    syllabus: Optional[Dict[str, Any]] = None
    status: str
    is_published: bool
    published_at: Optional[str] = None
    metadata: Optional[Dict[str, Any]] = None
    created_at: str
    updated_at: str

    class Config:
        from_attributes = True


class CourseListResponse(BaseModel):
    """Response model for paginated course list"""
    courses: List[CourseResponse]
    total: int
    page: int
    page_size: int
    has_more: bool


class CourseStatistics(BaseModel):
    """Course statistics"""
    total_courses: int
    published_courses: int
    draft_courses: int
    archived_courses: int
    total_enrollments: int
    average_rating: float
    total_revenue: float
