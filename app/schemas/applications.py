"""
Application Data Models
Pydantic schemas for application management
"""
from typing import Optional, List, Dict, Any
from pydantic import BaseModel, Field, EmailStr
from datetime import datetime
from enum import Enum


class ApplicationStatus(str, Enum):
    """Application status enumeration"""
    PENDING = "pending"
    UNDER_REVIEW = "under_review"
    ACCEPTED = "accepted"
    REJECTED = "rejected"
    WAITLISTED = "waitlisted"
    WITHDRAWN = "withdrawn"


class ApplicationType(str, Enum):
    """Application type"""
    UNDERGRADUATE = "undergraduate"
    GRADUATE = "graduate"
    CERTIFICATE = "certificate"
    DIPLOMA = "diploma"
    EXCHANGE = "exchange"


# Request Models
class ApplicationCreateRequest(BaseModel):
    """Request model for creating a new application"""
    institution_id: str
    program_id: str
    application_type: ApplicationType = ApplicationType.UNDERGRADUATE

    # Personal Information
    personal_info: Dict[str, Any] = Field(default_factory=dict)

    # Academic Information
    academic_info: Dict[str, Any] = Field(default_factory=dict)

    # Supporting Documents (URLs to uploaded files)
    documents: List[Dict[str, str]] = Field(default_factory=list)

    # Essay/Personal Statement
    essay: Optional[str] = None

    # References
    references: List[Dict[str, Any]] = Field(default_factory=list)

    # Additional Information
    extracurricular: Optional[List[Dict[str, Any]]] = Field(default_factory=list)
    work_experience: Optional[List[Dict[str, Any]]] = Field(default_factory=list)

    # Metadata
    metadata: Optional[Dict[str, Any]] = None


class ApplicationUpdateRequest(BaseModel):
    """Request model for updating an application"""
    personal_info: Optional[Dict[str, Any]] = None
    academic_info: Optional[Dict[str, Any]] = None
    documents: Optional[List[Dict[str, str]]] = None
    essay: Optional[str] = None
    references: Optional[List[Dict[str, Any]]] = None
    extracurricular: Optional[List[Dict[str, Any]]] = None
    work_experience: Optional[List[Dict[str, Any]]] = None
    metadata: Optional[Dict[str, Any]] = None


class ApplicationStatusUpdateRequest(BaseModel):
    """Request model for updating application status (Institution/Admin only)"""
    status: ApplicationStatus
    reviewer_notes: Optional[str] = None
    decision_date: Optional[str] = None


# Response Models
class ApplicationResponse(BaseModel):
    """Response model for application data"""
    id: str
    student_id: str
    institution_id: str
    program_id: str
    application_type: str
    status: str

    # Application Data
    personal_info: Dict[str, Any] = Field(default_factory=dict)
    academic_info: Dict[str, Any] = Field(default_factory=dict)
    documents: List[Dict[str, str]] = Field(default_factory=list)
    essay: Optional[str] = None
    references: List[Dict[str, Any]] = Field(default_factory=list)
    extracurricular: List[Dict[str, Any]] = Field(default_factory=list)
    work_experience: List[Dict[str, Any]] = Field(default_factory=list)

    # Review Information
    reviewed_by: Optional[str] = None
    reviewed_at: Optional[str] = None
    reviewer_notes: Optional[str] = None
    decision_date: Optional[str] = None

    # Submission
    submitted_at: Optional[str] = None
    is_submitted: bool = False

    # Metadata
    metadata: Optional[Dict[str, Any]] = None
    created_at: str
    updated_at: str

    class Config:
        from_attributes = True


class ApplicationListResponse(BaseModel):
    """Response model for paginated application list"""
    applications: List[ApplicationResponse]
    total: int
    page: int
    page_size: int
    has_more: bool


class ApplicationStatistics(BaseModel):
    """Application statistics"""
    total_applications: int
    pending_applications: int
    under_review_applications: int
    accepted_applications: int
    rejected_applications: int
    waitlisted_applications: int
    withdrawn_applications: int
    acceptance_rate: float
