"""
Achievements API Endpoints
RESTful API for achievements and gamification
"""
from fastapi import APIRouter, Depends, HTTPException, status, Query
from typing import Optional

from app.services.achievements_service import AchievementsService
from app.schemas.achievements import (
    StudentAchievementListResponse,
    LeaderboardResponse,
    StudentProgressResponse,
    AchievementStats
)
from app.utils.security import get_current_user, CurrentUser

router = APIRouter()


@router.get("/achievements/me")
async def get_my_achievements(
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
    category: Optional[str] = None,
    current_user: CurrentUser = Depends(get_current_user)
) -> StudentAchievementListResponse:
    """
    Get current user's achievements

    **Requires:** Authentication

    **Query Parameters:**
    - page: Page number (default: 1)
    - page_size: Items per page (default: 20, max: 100)
    - category: Filter by category (academic, progress, social, dedication, excellence, milestone)

    **Returns:**
    - List of earned achievements with details
    - Total points earned
    - Achievement count

    **Example Achievement:**
    ```json
    {
      "id": "uuid",
      "achievement_title": "First Steps",
      "achievement_description": "Complete your first course",
      "category": "progress",
      "rarity": "common",
      "points": 10,
      "earned_at": "2025-01-15T10:30:00Z"
    }
    ```
    """
    try:
        service = AchievementsService()
        result = await service.list_student_achievements(current_user.id, page, page_size, category)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.get("/achievements/progress/me")
async def get_my_progress(
    current_user: CurrentUser = Depends(get_current_user)
) -> StudentProgressResponse:
    """
    Get current user's gamification progress

    **Requires:** Authentication

    **Returns:**
    - Current level and points
    - Points needed for next level
    - Achievement counts by category and rarity
    - Global rank and percentile
    - Streak information

    **Leveling System:**
    - 100 points per level
    - Level 1: 0-99 points
    - Level 2: 100-199 points
    - And so on...
    """
    try:
        service = AchievementsService()
        result = await service.get_student_progress(current_user.id)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.get("/achievements/leaderboard")
async def get_leaderboard(
    period: str = Query("all_time", regex="^(all_time|monthly|weekly)$"),
    limit: int = Query(100, ge=10, le=500),
    current_user: CurrentUser = Depends(get_current_user)
) -> LeaderboardResponse:
    """
    Get achievement leaderboard

    **Requires:** Authentication

    **Query Parameters:**
    - period: Time period (all_time, monthly, weekly) - default: all_time
    - limit: Number of top students (10-500) - default: 100

    **Returns:**
    - Top students ranked by points
    - Each entry includes:
      - Rank
      - Student name
      - Total points
      - Achievement count
      - Current level
    - Current user's rank (if in top results)

    **Note:** Leaderboard promotes healthy competition and motivation
    """
    try:
        service = AchievementsService()
        result = await service.get_leaderboard(period, limit, current_user.id)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.get("/achievements/stats/me")
async def get_my_achievement_stats(
    current_user: CurrentUser = Depends(get_current_user)
) -> AchievementStats:
    """
    Get achievement statistics

    **Requires:** Authentication

    **Returns:**
    - Total achievements count
    - Breakdown by category (academic, progress, social, etc.)
    - Breakdown by rarity (common, rare, epic, legendary)
    - Recent achievements (last 5)
    - Next achievements to unlock (coming soon)

    **Categories:**
    - **Academic:** Course completion, good grades
    - **Progress:** Milestones, consistent progress
    - **Social:** Collaboration, study groups
    - **Dedication:** Time spent, daily streaks
    - **Excellence:** Outstanding performance
    - **Milestone:** Major accomplishments
    """
    try:
        service = AchievementsService()
        result = await service.get_achievement_stats(current_user.id)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )
