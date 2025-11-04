"""
Pydantic schemas for universities
"""
from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime


class ProgramBase(BaseModel):
    """Base schema for academic programs"""
    name: str
    degree_type: str
    field: Optional[str] = None
    description: Optional[str] = None
    median_salary: Optional[float] = None


class ProgramResponse(ProgramBase):
    """Response schema for programs"""
    id: int
    university_id: int
    created_at: datetime

    class Config:
        from_attributes = True


class UniversityBase(BaseModel):
    """Base schema for universities"""
    name: str
    country: str
    state: Optional[str] = None
    city: Optional[str] = None
    website: Optional[str] = None
    logo_url: Optional[str] = None
    description: Optional[str] = None
    university_type: Optional[str] = None
    location_type: Optional[str] = None
    total_students: Optional[int] = None
    global_rank: Optional[int] = None
    national_rank: Optional[int] = None
    acceptance_rate: Optional[float] = None
    gpa_average: Optional[float] = None
    sat_math_25th: Optional[int] = None
    sat_math_75th: Optional[int] = None
    sat_ebrw_25th: Optional[int] = None
    sat_ebrw_75th: Optional[int] = None
    act_composite_25th: Optional[int] = None
    act_composite_75th: Optional[int] = None
    tuition_out_state: Optional[float] = None
    total_cost: Optional[float] = None
    graduation_rate_4year: Optional[float] = None
    median_earnings_10year: Optional[float] = None


class UniversityResponse(UniversityBase):
    """Response schema for universities"""
    id: int
    programs: List[ProgramResponse] = []
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


class UniversitySearchResponse(BaseModel):
    """Response schema for university search"""
    total: int
    universities: List[UniversityResponse]
