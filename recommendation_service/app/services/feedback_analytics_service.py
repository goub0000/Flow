"""
Feedback Analytics Service - Track and analyze chatbot feedback
"""

from sqlalchemy.orm import Session
from sqlalchemy import func, desc, and_, text
from typing import Dict, Any, List, Optional
from datetime import datetime, timedelta
from uuid import UUID
import logging

logger = logging.getLogger(__name__)


class FeedbackAnalyticsService:
    """
    Service for analyzing chatbot feedback data.

    Features:
    - Track helpful/not helpful ratios
    - Identify poorly performing responses
    - Generate improvement suggestions
    - Export feedback reports
    """

    def __init__(self, db: Session):
        self.db = db

    async def get_feedback_stats(
        self,
        start_date: Optional[datetime] = None,
        end_date: Optional[datetime] = None
    ) -> Dict[str, Any]:
        """
        Get overall feedback statistics.

        Args:
            start_date: Start of date range (default: 30 days ago)
            end_date: End of date range (default: now)

        Returns:
            Dict with feedback statistics
        """
        if start_date is None:
            start_date = datetime.utcnow() - timedelta(days=30)
        if end_date is None:
            end_date = datetime.utcnow()

        try:
            # Query feedback counts
            result = self.db.execute(text("""
                SELECT
                    COUNT(*) as total_messages,
                    COUNT(CASE WHEN feedback IS NOT NULL THEN 1 END) as rated_messages,
                    COUNT(CASE WHEN feedback = 'helpful' THEN 1 END) as helpful_count,
                    COUNT(CASE WHEN feedback = 'not_helpful' THEN 1 END) as not_helpful_count
                FROM chatbot_messages
                WHERE sender = 'bot'
                AND created_at BETWEEN :start_date AND :end_date
            """), {"start_date": start_date, "end_date": end_date})

            row = result.fetchone()

            if row:
                total = row.total_messages or 0
                rated = row.rated_messages or 0
                helpful = row.helpful_count or 0
                not_helpful = row.not_helpful_count or 0

                return {
                    "period": {
                        "start": start_date.isoformat(),
                        "end": end_date.isoformat()
                    },
                    "total_bot_messages": total,
                    "rated_messages": rated,
                    "rating_rate": round((rated / total * 100), 2) if total > 0 else 0,
                    "helpful_count": helpful,
                    "not_helpful_count": not_helpful,
                    "helpful_rate": round((helpful / rated * 100), 2) if rated > 0 else 0,
                    "satisfaction_score": round((helpful / (helpful + not_helpful) * 100), 2) if (helpful + not_helpful) > 0 else 0
                }

            return self._empty_stats(start_date, end_date)

        except Exception as e:
            logger.error(f"Error getting feedback stats: {e}")
            return self._empty_stats(start_date, end_date)

    def _empty_stats(self, start_date: datetime, end_date: datetime) -> Dict[str, Any]:
        """Return empty stats structure"""
        return {
            "period": {
                "start": start_date.isoformat(),
                "end": end_date.isoformat()
            },
            "total_bot_messages": 0,
            "rated_messages": 0,
            "rating_rate": 0,
            "helpful_count": 0,
            "not_helpful_count": 0,
            "helpful_rate": 0,
            "satisfaction_score": 0
        }

    async def get_daily_feedback_trends(
        self,
        days: int = 30
    ) -> List[Dict[str, Any]]:
        """
        Get daily feedback trends.

        Args:
            days: Number of days to look back

        Returns:
            List of daily stats
        """
        start_date = datetime.utcnow() - timedelta(days=days)

        try:
            result = self.db.execute(text("""
                SELECT
                    DATE(created_at) as date,
                    COUNT(*) as total,
                    COUNT(CASE WHEN feedback = 'helpful' THEN 1 END) as helpful,
                    COUNT(CASE WHEN feedback = 'not_helpful' THEN 1 END) as not_helpful
                FROM chatbot_messages
                WHERE sender = 'bot'
                AND created_at >= :start_date
                GROUP BY DATE(created_at)
                ORDER BY date DESC
            """), {"start_date": start_date})

            trends = []
            for row in result:
                total_rated = (row.helpful or 0) + (row.not_helpful or 0)
                trends.append({
                    "date": row.date.isoformat() if row.date else None,
                    "total_messages": row.total or 0,
                    "helpful": row.helpful or 0,
                    "not_helpful": row.not_helpful or 0,
                    "satisfaction_rate": round((row.helpful / total_rated * 100), 2) if total_rated > 0 else 0
                })

            return trends

        except Exception as e:
            logger.error(f"Error getting daily trends: {e}")
            return []

    async def get_poorly_performing_responses(
        self,
        limit: int = 20,
        min_negative_count: int = 2
    ) -> List[Dict[str, Any]]:
        """
        Identify responses that received negative feedback.

        Args:
            limit: Maximum number of results
            min_negative_count: Minimum negative feedback count to include

        Returns:
            List of poorly performing message patterns
        """
        try:
            # Get messages with negative feedback
            result = self.db.execute(text("""
                SELECT
                    m.id,
                    m.content,
                    m.ai_provider,
                    m.created_at,
                    m.feedback_comment,
                    c.summary as conversation_summary
                FROM chatbot_messages m
                LEFT JOIN chatbot_conversations c ON m.conversation_id = c.id
                WHERE m.sender = 'bot'
                AND m.feedback = 'not_helpful'
                ORDER BY m.created_at DESC
                LIMIT :limit
            """), {"limit": limit})

            poor_responses = []
            for row in result:
                poor_responses.append({
                    "message_id": str(row.id),
                    "content": row.content[:200] + "..." if len(row.content) > 200 else row.content,
                    "ai_provider": row.ai_provider,
                    "created_at": row.created_at.isoformat() if row.created_at else None,
                    "feedback_comment": row.feedback_comment,
                    "conversation_context": row.conversation_summary
                })

            return poor_responses

        except Exception as e:
            logger.error(f"Error getting poorly performing responses: {e}")
            return []

    async def get_feedback_by_ai_provider(self) -> Dict[str, Dict[str, Any]]:
        """
        Compare feedback across AI providers.

        Returns:
            Dict with stats per provider
        """
        try:
            result = self.db.execute(text("""
                SELECT
                    COALESCE(ai_provider, 'unknown') as provider,
                    COUNT(*) as total,
                    COUNT(CASE WHEN feedback = 'helpful' THEN 1 END) as helpful,
                    COUNT(CASE WHEN feedback = 'not_helpful' THEN 1 END) as not_helpful
                FROM chatbot_messages
                WHERE sender = 'bot'
                GROUP BY ai_provider
            """))

            providers = {}
            for row in result:
                total_rated = (row.helpful or 0) + (row.not_helpful or 0)
                providers[row.provider] = {
                    "total_messages": row.total or 0,
                    "helpful": row.helpful or 0,
                    "not_helpful": row.not_helpful or 0,
                    "satisfaction_rate": round((row.helpful / total_rated * 100), 2) if total_rated > 0 else 0
                }

            return providers

        except Exception as e:
            logger.error(f"Error getting provider stats: {e}")
            return {}

    async def get_feedback_by_topic(self, limit: int = 10) -> List[Dict[str, Any]]:
        """
        Get feedback breakdown by conversation topic.

        Args:
            limit: Maximum number of topics to return

        Returns:
            List of topics with feedback stats
        """
        try:
            result = self.db.execute(text("""
                SELECT
                    c.topics,
                    COUNT(*) as message_count,
                    COUNT(CASE WHEN m.feedback = 'helpful' THEN 1 END) as helpful,
                    COUNT(CASE WHEN m.feedback = 'not_helpful' THEN 1 END) as not_helpful
                FROM chatbot_messages m
                JOIN chatbot_conversations c ON m.conversation_id = c.id
                WHERE m.sender = 'bot'
                AND c.topics IS NOT NULL
                GROUP BY c.topics
                ORDER BY message_count DESC
                LIMIT :limit
            """), {"limit": limit})

            topics = []
            for row in result:
                total_rated = (row.helpful or 0) + (row.not_helpful or 0)
                topics.append({
                    "topics": row.topics,
                    "message_count": row.message_count or 0,
                    "helpful": row.helpful or 0,
                    "not_helpful": row.not_helpful or 0,
                    "satisfaction_rate": round((row.helpful / total_rated * 100), 2) if total_rated > 0 else 0
                })

            return topics

        except Exception as e:
            logger.error(f"Error getting topic stats: {e}")
            return []

    async def generate_improvement_suggestions(self) -> List[Dict[str, Any]]:
        """
        Generate suggestions for improving chatbot responses.

        Returns:
            List of improvement suggestions
        """
        suggestions = []

        try:
            # Get overall stats
            stats = await self.get_feedback_stats()

            # Check satisfaction score
            if stats["satisfaction_score"] < 70:
                suggestions.append({
                    "priority": "high",
                    "category": "overall_quality",
                    "issue": f"Overall satisfaction score is {stats['satisfaction_score']}% (below 70% threshold)",
                    "suggestion": "Review negative feedback comments and update FAQ database with better answers"
                })

            # Check rating rate
            if stats["rating_rate"] < 10:
                suggestions.append({
                    "priority": "medium",
                    "category": "engagement",
                    "issue": f"Only {stats['rating_rate']}% of messages are being rated",
                    "suggestion": "Consider making feedback prompts more prominent or adding incentives"
                })

            # Check provider performance
            provider_stats = await self.get_feedback_by_ai_provider()
            for provider, pstats in provider_stats.items():
                if pstats["satisfaction_rate"] < 60 and pstats["total_messages"] > 10:
                    suggestions.append({
                        "priority": "high",
                        "category": "ai_provider",
                        "issue": f"AI provider '{provider}' has low satisfaction ({pstats['satisfaction_rate']}%)",
                        "suggestion": f"Consider adjusting prompts or switching to a different model for {provider}"
                    })

            # Get poorly performing responses
            poor_responses = await self.get_poorly_performing_responses(limit=5)
            if len(poor_responses) >= 3:
                suggestions.append({
                    "priority": "medium",
                    "category": "content_quality",
                    "issue": f"Found {len(poor_responses)} recent responses with negative feedback",
                    "suggestion": "Review and create FAQ entries for common negative feedback patterns"
                })

            # If no issues found
            if not suggestions:
                suggestions.append({
                    "priority": "low",
                    "category": "maintenance",
                    "issue": "No critical issues found",
                    "suggestion": "Continue monitoring and consider expanding FAQ database"
                })

            return suggestions

        except Exception as e:
            logger.error(f"Error generating suggestions: {e}")
            return [{
                "priority": "low",
                "category": "error",
                "issue": "Could not analyze feedback data",
                "suggestion": "Check database connection and data availability"
            }]

    async def export_feedback_report(
        self,
        start_date: Optional[datetime] = None,
        end_date: Optional[datetime] = None,
        format: str = "json"
    ) -> Dict[str, Any]:
        """
        Export comprehensive feedback report.

        Args:
            start_date: Start of date range
            end_date: End of date range
            format: Export format (json, csv)

        Returns:
            Complete feedback report
        """
        if start_date is None:
            start_date = datetime.utcnow() - timedelta(days=30)
        if end_date is None:
            end_date = datetime.utcnow()

        report = {
            "generated_at": datetime.utcnow().isoformat(),
            "period": {
                "start": start_date.isoformat(),
                "end": end_date.isoformat()
            },
            "summary": await self.get_feedback_stats(start_date, end_date),
            "daily_trends": await self.get_daily_feedback_trends(
                days=(end_date - start_date).days
            ),
            "by_provider": await self.get_feedback_by_ai_provider(),
            "by_topic": await self.get_feedback_by_topic(),
            "poor_responses": await self.get_poorly_performing_responses(limit=10),
            "suggestions": await self.generate_improvement_suggestions()
        }

        return report


def get_feedback_analytics_service(db: Session) -> FeedbackAnalyticsService:
    """Factory function to create FeedbackAnalyticsService instance"""
    return FeedbackAnalyticsService(db)
