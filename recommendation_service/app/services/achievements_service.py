"""
Achievements Service
Business logic for achievements and gamification
"""
from typing import Optional, List
from datetime import datetime
import logging
from uuid import uuid4

from app.database.config import get_supabase
from app.schemas.achievements import (
    StudentAchievementResponse,
    StudentAchievementListResponse,
    LeaderboardEntry,
    LeaderboardResponse,
    StudentProgressResponse,
    AchievementStats
)

logger = logging.getLogger(__name__)


class AchievementsService:
    """Service for achievements and gamification"""

    def __init__(self):
        self.db = get_supabase()

    async def list_student_achievements(
        self,
        student_id: str,
        page: int = 1,
        page_size: int = 20,
        category: Optional[str] = None
    ) -> StudentAchievementListResponse:
        """List student's earned achievements"""
        try:
            query = self.db.table('student_achievements').select('*', count='exact').eq('student_id', student_id)

            if category:
                query = query.eq('category', category)

            offset = (page - 1) * page_size
            query = query.order('earned_at', desc=True).range(offset, offset + page_size - 1)

            response = query.execute()

            achievements = [StudentAchievementResponse(**a) for a in response.data] if response.data else []
            total = response.count or 0

            # Calculate total points
            all_achievements = self.db.table('student_achievements').select('points').eq('student_id', student_id).execute()
            total_points = sum([a['points'] for a in all_achievements.data]) if all_achievements.data else 0

            return StudentAchievementListResponse(
                achievements=achievements,
                total=total,
                total_points=total_points,
                page=page,
                page_size=page_size,
                has_more=(offset + page_size) < total
            )

        except Exception as e:
            logger.error(f"List achievements error: {e}")
            raise Exception(f"Failed to list achievements: {str(e)}")

    async def get_student_progress(self, student_id: str) -> StudentProgressResponse:
        """Get student's gamification progress"""
        try:
            # Get all achievements
            achievements = self.db.table('student_achievements').select('*').eq('student_id', student_id).execute()

            total_achievements = len(achievements.data) if achievements.data else 0
            total_points = sum([a['points'] for a in achievements.data]) if achievements.data else 0

            # Calculate level (e.g., 100 points per level)
            level = (total_points // 100) + 1
            points_to_next = 100 - (total_points % 100)

            # Group by category
            by_category = {}
            for ach in (achievements.data or []):
                cat = ach.get('category', 'unknown')
                by_category[cat] = by_category.get(cat, 0) + 1

            # Group by rarity
            by_rarity = {}
            for ach in (achievements.data or []):
                rarity = ach.get('rarity', 'common')
                by_rarity[rarity] = by_rarity.get(rarity, 0) + 1

            # Get rank (simplified - compare total points)
            all_students = self.db.table('student_achievements').select('student_id, points').execute()

            if all_students.data:
                # Calculate points per student
                student_points = {}
                for ach in all_students.data:
                    sid = ach['student_id']
                    student_points[sid] = student_points.get(sid, 0) + ach['points']

                # Sort and find rank
                sorted_students = sorted(student_points.items(), key=lambda x: x[1], reverse=True)
                rank = next((i + 1 for i, (sid, _) in enumerate(sorted_students) if sid == student_id), None)
                percentile = (rank / len(sorted_students)) * 100 if rank else None
            else:
                rank = None
                percentile = None

            return StudentProgressResponse(
                student_id=student_id,
                level=level,
                total_points=total_points,
                points_to_next_level=points_to_next,
                achievement_count=total_achievements,
                achievements_by_category=by_category,
                achievements_by_rarity=by_rarity,
                rank=rank,
                percentile=percentile,
                streak_days=0,  # TODO: Implement streak tracking
                longest_streak=0
            )

        except Exception as e:
            logger.error(f"Get progress error: {e}")
            raise Exception(f"Failed to get progress: {str(e)}")

    async def get_leaderboard(
        self,
        period: str = "all_time",
        limit: int = 100,
        student_id: Optional[str] = None
    ) -> LeaderboardResponse:
        """Get achievement leaderboard"""
        try:
            # Get all achievements
            all_achievements = self.db.table('student_achievements').select('student_id, points').execute()

            if not all_achievements.data:
                return LeaderboardResponse(
                    period=period,
                    entries=[],
                    total_students=0
                )

            # Calculate points per student
            student_data = {}
            for ach in all_achievements.data:
                sid = ach['student_id']
                if sid not in student_data:
                    student_data[sid] = {"points": 0, "count": 0}
                student_data[sid]["points"] += ach['points']
                student_data[sid]["count"] += 1

            # Sort by points
            sorted_students = sorted(student_data.items(), key=lambda x: x[1]["points"], reverse=True)[:limit]

            # Get student names
            entries = []
            current_user_rank = None

            for rank, (sid, data) in enumerate(sorted_students, 1):
                student = self.db.table('users').select('full_name').eq('id', sid).single().execute()
                student_name = student.data.get('full_name', 'Student') if student.data else 'Student'

                # Calculate level
                level = (data["points"] // 100) + 1

                entry = LeaderboardEntry(
                    rank=rank,
                    student_id=sid,
                    student_name=student_name,
                    total_points=data["points"],
                    achievement_count=data["count"],
                    level=level
                )
                entries.append(entry)

                if student_id and sid == student_id:
                    current_user_rank = rank

            return LeaderboardResponse(
                period=period,
                entries=entries,
                total_students=len(student_data),
                current_user_rank=current_user_rank
            )

        except Exception as e:
            logger.error(f"Get leaderboard error: {e}")
            raise Exception(f"Failed to get leaderboard: {str(e)}")

    async def get_achievement_stats(self, student_id: str) -> AchievementStats:
        """Get achievement statistics"""
        try:
            achievements = self.db.table('student_achievements').select('*').eq('student_id', student_id).execute()

            total = len(achievements.data) if achievements.data else 0

            # Group by category
            by_category = {}
            for ach in (achievements.data or []):
                cat = ach.get('category', 'unknown')
                by_category[cat] = by_category.get(cat, 0) + 1

            # Group by rarity
            by_rarity = {}
            for ach in (achievements.data or []):
                rarity = ach.get('rarity', 'common')
                by_rarity[rarity] = by_rarity.get(rarity, 0) + 1

            # Recent achievements (last 5)
            recent = sorted((achievements.data or []), key=lambda x: x.get('earned_at', ''), reverse=True)[:5]
            recent_achievements = [
                {
                    "id": a.get('id'),
                    "title": a.get('achievement_title'),
                    "category": a.get('category'),
                    "rarity": a.get('rarity'),
                    "points": a.get('points'),
                    "earned_at": a.get('earned_at')
                }
                for a in recent
            ]

            return AchievementStats(
                total_achievements=total,
                by_category=by_category,
                by_rarity=by_rarity,
                recent_achievements=recent_achievements,
                next_achievements=[]  # TODO: Calculate next achievements
            )

        except Exception as e:
            logger.error(f"Get stats error: {e}")
            raise Exception(f"Failed to get stats: {str(e)}")
