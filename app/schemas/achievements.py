"""
Achievements and Gamification Data Models
Pydantic schemas for achievements, badges, and gamification
"""
from typing import Optional, List, Dict, Any
from pydantic import BaseModel, Field
from datetime import datetime
from enum import Enum


class AchievementCategory(str, Enum):
    """Achievement categories"""
    ACADEMIC = "academic"  # Academic milestones
    PROGRESS = "progress"  # Progress milestones
    SOCIAL = "social"  # Social/collaboration
    DEDICATION = "dedication"  # Time and effort
    EXCELLENCE = "excellence"  # High performance
    MILESTONE = "milestone"  # Major milestones


class AchievementRarity(str, Enum):
    """Achievement rarity levels"""
    COMMON = "common"
    RARE = "rare"
    EPIC = "epic"
    LEGENDARY = "legendary"


# Achievement Definition Models
class AchievementDefinitionResponse(BaseModel):
    """Achievement definition (template)"""
    id: str
    title: str
    description: str
    category: str
    rarity: str
    points: int  # Points awarded
    icon_url: Optional[str] = None
    criteria: Dict[str, Any] = Field(default_factory=dict)  # How to earn it
    is_active: bool = True
    created_at: str

    class Config:
        from_attributes = True


#  Student Achievement Models
class StudentAchievementResponse(BaseModel):
    """Student's earned achievement"""
    id: str
    student_id: str
    achievement_id: str
    achievement_title: str
    achievement_description: str
    category: str
    rarity: str
    points: int
    icon_url: Optional[str] = None
    earned_at: str
    progress_percentage: float = 100.0  # For progressive achievements

    class Config:
        from_attributes = True


class StudentAchievementListResponse(BaseModel):
    """List of student achievements"""
    achievements: List[StudentAchievementResponse]
    total: int
    total_points: int
    page: int
    page_size: int
    has_more: bool


# Leaderboard Models
class LeaderboardEntry(BaseModel):
    """Leaderboard entry"""
    rank: int
    student_id: str
    student_name: str
    total_points: int
    achievement_count: int
    level: int


class LeaderboardResponse(BaseModel):
    """Leaderboard response"""
    period: str  # "all_time", "monthly", "weekly"
    entries: List[LeaderboardEntry]
    total_students: int
    current_user_rank: Optional[int] = None


# Student Progress/Level Models
class StudentProgressResponse(BaseModel):
    """Student's gamification progress"""
    student_id: str
    level: int
    total_points: int
    points_to_next_level: int
    achievement_count: int
    achievements_by_category: Dict[str, int] = Field(default_factory=dict)
    achievements_by_rarity: Dict[str, int] = Field(default_factory=dict)
    rank: Optional[int] = None
    percentile: Optional[float] = None  # Top X%
    streak_days: int = 0  # Daily login streak
    longest_streak: int = 0


# Statistics Models
class AchievementStats(BaseModel):
    """Achievement statistics"""
    total_achievements: int
    by_category: Dict[str, int]
    by_rarity: Dict[str, int]
    recent_achievements: List[Dict[str, Any]] = Field(default_factory=list)
    next_achievements: List[Dict[str, Any]] = Field(default_factory=list)  # Close to earning
