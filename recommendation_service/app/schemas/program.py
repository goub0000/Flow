"""
Pydantic schemas for institutional programs/courses
"""
from pydantic import BaseModel, Field, UUID4
from typing import Optional, List
from datetime import datetime
from decimal import Decimal


class ProgramBase(BaseModel):
    """Base schema for institutional programs"""
    institution_id: UUID4
    institution_name: str
    name: str
    description: Optional[str] = None
    category: str  # e.g., Technology, Business, Health Sciences
    level: str = Field(..., pattern="^(certificate|diploma|undergraduate|postgraduate|doctoral)$")
    duration_days: int = Field(..., gt=0)
    fee: Decimal = Field(..., ge=0)
    currency: str = "USD"
    max_students: int = Field(..., gt=0)
    enrolled_students: int = Field(default=0, ge=0)
    requirements: List[str] = []
    application_deadline: Optional[datetime] = None
    start_date: Optional[datetime] = None
    is_active: bool = True


class ProgramCreate(ProgramBase):
    """Schema for creating a new program"""
    pass


class ProgramUpdate(BaseModel):
    """Schema for updating a program (all fields optional)"""
    institution_id: Optional[UUID4] = None
    institution_name: Optional[str] = None
    name: Optional[str] = None
    description: Optional[str] = None
    category: Optional[str] = None
    level: Optional[str] = None
    duration_days: Optional[int] = None
    fee: Optional[Decimal] = None
    currency: Optional[str] = None
    max_students: Optional[int] = None
    enrolled_students: Optional[int] = None
    requirements: Optional[List[str]] = None
    application_deadline: Optional[datetime] = None
    start_date: Optional[datetime] = None
    is_active: Optional[bool] = None


class ProgramResponse(ProgramBase):
    """Response schema for programs"""
    id: str  # Changed from UUID4 to str to support integer IDs from database
    available_slots: int
    fill_percentage: Decimal
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


class ProgramListResponse(BaseModel):
    """Response schema for program list"""
    total: int
    programs: List[ProgramResponse]


class ProgramStatistics(BaseModel):
    """Statistics for institutional programs"""
    total_programs: int
    active_programs: int
    inactive_programs: int
    total_capacity: int
    total_enrolled: int
    available_spots: int
    occupancy_rate: float


class ProgramEnrichmentLog(BaseModel):
    """Schema for program enrichment logs"""
    id: UUID4
    program_id: UUID4
    enrichment_type: str
    data_source: str
    fields_updated: List[str]
    success: bool
    error_message: Optional[str] = None
    created_at: datetime

    class Config:
        from_attributes = True
