"""
Enrollment Data Models
Pydantic schemas for course enrollment management
"""
from typing import Optional, List, Dict, Any
from pydantic import BaseModel, Field
from datetime import datetime
from enum import Enum


class EnrollmentStatus(str, Enum):
    """Enrollment status enumeration"""
    ACTIVE = "active"
    COMPLETED = "completed"
    DROPPED = "dropped"
    SUSPENDED = "suspended"


# Request Models
class EnrollmentCreateRequest(BaseModel):
    """Request model for enrolling in a course"""
    course_id: str
    metadata: Optional[Dict[str, Any]] = None


# Response Models
class EnrollmentResponse(BaseModel):
    """Response model for enrollment data"""
    id: str
    student_id: str
    course_id: str
    status: str
    enrolled_at: str
    completed_at: Optional[str] = None
    progress_percentage: float = 0.0
    metadata: Optional[Dict[str, Any]] = None
    created_at: str
    updated_at: str

    class Config:
        from_attributes = True


class EnrollmentListResponse(BaseModel):
    """Response model for paginated enrollment list"""
    enrollments: List[EnrollmentResponse]
    total: int
    page: int
    page_size: int
    has_more: bool
