"""
Pydantic schemas for recommendation tracking and ML feedback
Phase 3.2 - ML Recommendations API Enhancement
"""
from pydantic import BaseModel, Field, validator
from typing import List, Optional, Dict, Any
from datetime import datetime
from enum import Enum


# ==================== Enums ====================

class ClickActionType(str, Enum):
    """Types of actions users can take on recommendations"""
    VIEW_DETAILS = "view_details"
    APPLY = "apply"
    FAVORITE = "favorite"
    SHARE = "share"
    COMPARE = "compare"


class FeedbackType(str, Enum):
    """Types of explicit feedback from users"""
    THUMBS_UP = "thumbs_up"
    THUMBS_DOWN = "thumbs_down"
    NOT_INTERESTED = "not_interested"
    ALREADY_APPLIED = "already_applied"
    HELPFUL = "helpful"
    NOT_HELPFUL = "not_helpful"


class RecommendationSource(str, Enum):
    """Where the recommendation was shown"""
    DASHBOARD = "dashboard"
    SEARCH = "search"
    EMAIL = "email"
    NOTIFICATION = "notification"
    DIRECT_LINK = "direct_link"


# ==================== Impression Schemas ====================

class RecommendationImpressionCreate(BaseModel):
    """Create a new impression record (recommendation shown to user)"""
    student_id: str
    university_id: int
    match_score: Optional[float] = None
    category: Optional[str] = None  # Safety, Match, Reach
    position: Optional[int] = None  # Position in list (1, 2, 3, ...)
    recommendation_session_id: Optional[str] = None
    source: RecommendationSource = RecommendationSource.DASHBOARD
    match_reasons: Optional[Dict[str, Any]] = None
    match_explanation: Optional[str] = None

    @validator('match_score')
    def validate_score(cls, v):
        if v is not None and (v < 0 or v > 100):
            raise ValueError('match_score must be between 0 and 100')
        return v

    @validator('position')
    def validate_position(cls, v):
        if v is not None and v < 1:
            raise ValueError('position must be >= 1')
        return v


class RecommendationImpressionResponse(BaseModel):
    """Response model for impression"""
    id: str
    student_id: str
    university_id: int
    match_score: Optional[float]
    category: Optional[str]
    position: Optional[int]
    recommendation_session_id: Optional[str]
    source: str
    match_reasons: Optional[Dict[str, Any]]
    match_explanation: Optional[str]
    shown_at: datetime
    created_at: datetime

    class Config:
        from_attributes = True


class BatchImpressionCreate(BaseModel):
    """Create multiple impressions at once (batch tracking)"""
    student_id: str
    recommendation_session_id: str
    source: RecommendationSource = RecommendationSource.DASHBOARD
    impressions: List[Dict[str, Any]]  # List of {university_id, match_score, category, position, ...}

    @validator('impressions')
    def validate_impressions(cls, v):
        if not v or len(v) == 0:
            raise ValueError('impressions list cannot be empty')
        if len(v) > 50:
            raise ValueError('cannot track more than 50 impressions at once')
        return v


# ==================== Click Schemas ====================

class RecommendationClickCreate(BaseModel):
    """Record a click on a recommendation"""
    impression_id: Optional[str] = None  # Link to impression if available
    student_id: str
    university_id: int
    action_type: ClickActionType
    time_to_click_seconds: Optional[int] = None
    device_type: Optional[str] = None  # web, mobile, tablet
    referrer: Optional[str] = None

    @validator('time_to_click_seconds')
    def validate_time_to_click(cls, v):
        if v is not None and v < 0:
            raise ValueError('time_to_click_seconds must be >= 0')
        return v


class RecommendationClickResponse(BaseModel):
    """Response model for click"""
    id: str
    impression_id: Optional[str]
    student_id: str
    university_id: int
    action_type: str
    time_to_click_seconds: Optional[int]
    device_type: Optional[str]
    referrer: Optional[str]
    clicked_at: datetime
    created_at: datetime

    class Config:
        from_attributes = True


# ==================== Feedback Schemas ====================

class RecommendationFeedbackCreate(BaseModel):
    """Submit explicit feedback about a recommendation"""
    student_id: str
    university_id: int
    impression_id: Optional[str] = None
    feedback_type: FeedbackType
    rating: Optional[int] = None  # 1-5 stars
    comment: Optional[str] = Field(None, max_length=1000)
    reasons: Optional[List[str]] = None  # ["too_expensive", "wrong_major", "wrong_location", ...]

    @validator('rating')
    def validate_rating(cls, v):
        if v is not None and (v < 1 or v > 5):
            raise ValueError('rating must be between 1 and 5')
        return v

    @validator('reasons')
    def validate_reasons(cls, v):
        if v is not None and len(v) > 10:
            raise ValueError('cannot provide more than 10 reasons')
        return v


class RecommendationFeedbackResponse(BaseModel):
    """Response model for feedback"""
    id: str
    student_id: str
    university_id: int
    impression_id: Optional[str]
    feedback_type: str
    rating: Optional[int]
    comment: Optional[str]
    reasons: Optional[List[str]]
    submitted_at: datetime
    created_at: datetime

    class Config:
        from_attributes = True


# ==================== Interaction Summary Schemas ====================

class StudentInteractionSummaryResponse(BaseModel):
    """Aggregated interaction statistics for a student"""
    id: str
    student_id: str
    total_impressions: int
    total_clicks: int
    total_applications: int
    total_favorites: int
    ctr_percentage: Optional[float]  # Click-through rate
    preferred_categories: Optional[Dict[str, Any]]
    preferred_locations: Optional[Dict[str, Any]]
    preferred_cost_range: Optional[Dict[str, Any]]
    last_interaction_at: Optional[datetime]
    updated_at: datetime
    created_at: datetime

    class Config:
        from_attributes = True


# ==================== Enhanced Recommendation with Tracking ====================

class PersonalizedRecommendation(BaseModel):
    """Enhanced recommendation with match explanation and tracking"""
    # University details
    university_id: int
    university_name: str
    university_city: Optional[str]
    university_country: Optional[str]
    university_logo_url: Optional[str]

    # Match details
    match_score: float  # 0-100
    category: str  # Safety, Match, Reach
    rank: int  # Position in recommendation list

    # Match explanation (WHY recommended)
    match_explanation: str  # Human-readable explanation
    match_reasons: Dict[str, bool]  # Detailed breakdown
    # Example: {
    #   "gpa_match": true,
    #   "major_match": true,
    #   "location_match": true,
    #   "budget_match": false,
    #   "program_availability": true
    # }

    # Matching factors
    matching_factors: Optional[List[str]]  # ["Strong GPA match", "Your preferred major available", ...]

    # Confidence
    confidence_score: Optional[float]  # How confident is the ML model (0-1)

    # Additional context
    program_matches: Optional[List[str]]  # List of matching program names
    cost_estimate: Optional[float]
    acceptance_rate: Optional[float]

    @validator('match_score')
    def validate_score(cls, v):
        if v < 0 or v > 100:
            raise ValueError('match_score must be between 0 and 100')
        return v


class PersonalizedRecommendationsResponse(BaseModel):
    """Response for personalized recommendations endpoint"""
    student_id: str
    session_id: str  # Session ID for tracking this batch of recommendations
    total: int
    recommendations: List[PersonalizedRecommendation]
    generated_at: datetime

    # Summary by category
    safety_count: int = 0
    match_count: int = 0
    reach_count: int = 0

    # ML model info
    ml_powered: bool = False  # Whether ML model was used or rule-based
    model_version: Optional[str] = None


# ==================== Tracking Analytics Schemas ====================

class RecommendationAnalytics(BaseModel):
    """Analytics for recommendation performance"""
    total_impressions: int
    total_clicks: int
    total_applications: int
    click_through_rate: float
    application_rate: float

    # By category
    safety_impressions: int
    safety_clicks: int
    match_impressions: int
    match_clicks: int
    reach_impressions: int
    reach_clicks: int

    # Top performing universities
    top_clicked_universities: List[Dict[str, Any]]  # [{university_id, name, click_count}, ...]
    top_applied_universities: List[Dict[str, Any]]

    # Time range
    start_date: datetime
    end_date: datetime


class ClickThroughAnalysis(BaseModel):
    """Analysis of click-through patterns"""
    university_id: int
    university_name: str
    total_impressions: int
    total_clicks: int
    ctr_percentage: float
    avg_match_score: float
    most_common_action: Optional[str]
    avg_time_to_click_seconds: Optional[float]
