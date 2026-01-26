"""
Pydantic schemas for recommendations
"""
from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime
from app.schemas.university import UniversityResponse


class RecommendationScores(BaseModel):
    """Score breakdown for a recommendation"""
    academic_score: float
    financial_score: float
    program_score: float
    location_score: float
    characteristics_score: float


class RecommendationResponse(BaseModel):
    """Response schema for recommendations"""
    id: int
    university_id: int
    match_score: float
    category: str  # Safety, Match, Reach
    academic_score: Optional[float] = None
    financial_score: Optional[float] = None
    program_score: Optional[float] = None
    location_score: Optional[float] = None
    characteristics_score: Optional[float] = None
    strengths: Optional[List[str]] = None
    concerns: Optional[List[str]] = None
    favorited: int = 0
    notes: Optional[str] = None
    university: Optional[UniversityResponse] = None
    created_at: datetime

    class Config:
        from_attributes = True


class RecommendationListResponse(BaseModel):
    """Response schema for list of recommendations"""
    total: int
    safety_schools: List[RecommendationResponse]
    match_schools: List[RecommendationResponse]
    reach_schools: List[RecommendationResponse]


class GenerateRecommendationsRequest(BaseModel):
    """Request schema for generating recommendations"""
    user_id: str
    max_results: Optional[int] = 30  # Increased from 15 for better coverage across countries


class UpdateRecommendationRequest(BaseModel):
    """Request schema for updating recommendation"""
    favorited: Optional[int] = None
    notes: Optional[str] = None
