"""
Pydantic schemas for student profiles
"""
from pydantic import BaseModel, Field
from typing import Optional, List, Dict, Any
from datetime import datetime


class StudentProfileCreate(BaseModel):
    """Request schema for creating student profile"""
    user_id: str

    # Global Academic Information
    grading_system: Optional[str] = None
    grade_value: Optional[str] = None
    nationality: Optional[str] = None
    current_country: Optional[str] = None
    current_region: Optional[str] = None
    standardized_test_type: Optional[str] = None
    test_scores: Optional[Dict[str, Any]] = None

    # Legacy Academic Info (maintained for backward compatibility)
    gpa: Optional[float] = None
    sat_total: Optional[int] = None
    sat_math: Optional[int] = None
    sat_ebrw: Optional[int] = None
    act_composite: Optional[int] = None
    class_rank: Optional[int] = None
    class_size: Optional[int] = None

    # Interests
    intended_major: Optional[str] = None
    field_of_study: Optional[str] = None
    career_goals: Optional[str] = None
    alternative_majors: Optional[List[str]] = None
    career_focused: Optional[int] = 1
    research_opportunities: Optional[int] = 0

    # Preferences
    preferred_states: Optional[List[str]] = None  # Legacy
    preferred_regions: Optional[List[str]] = None  # Global
    preferred_countries: Optional[List[str]] = None
    location_type_preference: Optional[str] = None  # Urban, Suburban, Rural

    # Financial
    budget_range: Optional[str] = None
    max_budget_per_year: Optional[float] = None
    need_financial_aid: Optional[int] = 0
    eligible_for_in_state: Optional[str] = None

    # University characteristics
    preferred_university_type: Optional[str] = None  # Legacy
    university_size_preference: Optional[str] = None
    university_type_preference: Optional[str] = None
    preferred_size: Optional[str] = None  # Legacy
    interested_in_sports: Optional[int] = 0
    sports_important: Optional[int] = 0  # Legacy
    features_desired: Optional[List[str]] = None
    deal_breakers: Optional[List[str]] = None


class StudentProfileUpdate(BaseModel):
    """Request schema for updating student profile"""
    # Global Academic Information
    grading_system: Optional[str] = None
    grade_value: Optional[str] = None
    nationality: Optional[str] = None
    current_country: Optional[str] = None
    current_region: Optional[str] = None
    standardized_test_type: Optional[str] = None
    test_scores: Optional[Dict[str, Any]] = None

    # Legacy Academic Info
    gpa: Optional[float] = None
    sat_total: Optional[int] = None
    sat_math: Optional[int] = None
    sat_ebrw: Optional[int] = None
    act_composite: Optional[int] = None
    class_rank: Optional[int] = None
    class_size: Optional[int] = None

    # Interests
    intended_major: Optional[str] = None
    field_of_study: Optional[str] = None
    career_goals: Optional[str] = None
    alternative_majors: Optional[List[str]] = None
    career_focused: Optional[int] = None
    research_opportunities: Optional[int] = None

    # Preferences
    preferred_states: Optional[List[str]] = None
    preferred_regions: Optional[List[str]] = None
    preferred_countries: Optional[List[str]] = None
    location_type_preference: Optional[str] = None

    # Financial
    budget_range: Optional[str] = None
    max_budget_per_year: Optional[float] = None
    need_financial_aid: Optional[int] = None
    eligible_for_in_state: Optional[str] = None

    # University characteristics
    preferred_university_type: Optional[str] = None
    university_size_preference: Optional[str] = None
    university_type_preference: Optional[str] = None
    preferred_size: Optional[str] = None
    interested_in_sports: Optional[int] = None
    sports_important: Optional[int] = None
    features_desired: Optional[List[str]] = None
    deal_breakers: Optional[List[str]] = None


class StudentProfileResponse(BaseModel):
    """Response schema for student profile"""
    id: int
    user_id: str

    # Global Academic Information
    grading_system: Optional[str] = None
    grade_value: Optional[str] = None
    nationality: Optional[str] = None
    current_country: Optional[str] = None
    current_region: Optional[str] = None
    standardized_test_type: Optional[str] = None
    test_scores: Optional[Dict[str, Any]] = None

    # Legacy Academic Info
    gpa: Optional[float] = None
    sat_total: Optional[int] = None
    sat_math: Optional[int] = None
    sat_ebrw: Optional[int] = None
    act_composite: Optional[int] = None
    class_rank: Optional[int] = None
    class_size: Optional[int] = None

    # Interests
    intended_major: Optional[str] = None
    field_of_study: Optional[str] = None
    career_goals: Optional[str] = None
    alternative_majors: Optional[List[str]] = None
    career_focused: Optional[int] = None
    research_opportunities: Optional[int] = None

    # Preferences
    preferred_states: Optional[List[str]] = None
    preferred_regions: Optional[List[str]] = None
    preferred_countries: Optional[List[str]] = None
    location_type_preference: Optional[str] = None

    # Financial
    budget_range: Optional[str] = None
    max_budget_per_year: Optional[float] = None
    need_financial_aid: Optional[int] = None
    eligible_for_in_state: Optional[str] = None

    # University characteristics
    preferred_university_type: Optional[str] = None
    university_size_preference: Optional[str] = None
    university_type_preference: Optional[str] = None
    preferred_size: Optional[str] = None
    interested_in_sports: Optional[int] = None
    sports_important: Optional[int] = None
    features_desired: Optional[List[str]] = None
    deal_breakers: Optional[List[str]] = None

    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True
