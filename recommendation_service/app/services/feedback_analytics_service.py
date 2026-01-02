"""
Feedback Analytics Service - Track and analyze chatbot feedback
"""

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

    def __init__(self, supabase):
        self.supabase = supabase

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
            # Query all bot messages in date range
            result = self.supabase.table('chatbot_messages').select(
                'id, feedback'
            ).eq('sender', 'bot').gte(
                'created_at', start_date.isoformat()
            ).lte(
                'created_at', end_date.isoformat()
            ).execute()

            messages = result.data if result.data else []

            total = len(messages)
            rated = sum(1 for m in messages if m.get('feedback'))
            helpful = sum(1 for m in messages if m.get('feedback') == 'helpful')
            not_helpful = sum(1 for m in messages if m.get('feedback') == 'not_helpful')

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
            result = self.supabase.table('chatbot_messages').select(
                'id, feedback, created_at'
            ).eq('sender', 'bot').gte(
                'created_at', start_date.isoformat()
            ).execute()

            messages = result.data if result.data else []

            # Group by date
            daily_data = {}
            for msg in messages:
                date_str = msg['created_at'][:10]  # Extract YYYY-MM-DD
                if date_str not in daily_data:
                    daily_data[date_str] = {'total': 0, 'helpful': 0, 'not_helpful': 0}
                daily_data[date_str]['total'] += 1
                if msg.get('feedback') == 'helpful':
                    daily_data[date_str]['helpful'] += 1
                elif msg.get('feedback') == 'not_helpful':
                    daily_data[date_str]['not_helpful'] += 1

            trends = []
            for date_str, data in sorted(daily_data.items(), reverse=True):
                total_rated = data['helpful'] + data['not_helpful']
                trends.append({
                    "date": date_str,
                    "total_messages": data['total'],
                    "helpful": data['helpful'],
                    "not_helpful": data['not_helpful'],
                    "satisfaction_rate": round((data['helpful'] / total_rated * 100), 2) if total_rated > 0 else 0
                })

            return trends

        except Exception as e:
            logger.error(f"Error getting daily trends: {e}")
            return []

    async def get_poorly_performing_responses(
        self,
        limit: int = 20
    ) -> List[Dict[str, Any]]:
        """
        Identify responses that received negative feedback.

        Args:
            limit: Maximum number of results

        Returns:
            List of poorly performing message patterns
        """
        try:
            result = self.supabase.table('chatbot_messages').select(
                'id, content, ai_provider, created_at, feedback_comment, conversation_id'
            ).eq('sender', 'bot').eq(
                'feedback', 'not_helpful'
            ).order('created_at', desc=True).limit(limit).execute()

            messages = result.data if result.data else []

            poor_responses = []
            for msg in messages:
                poor_responses.append({
                    "message_id": str(msg['id']),
                    "content": msg['content'][:200] + "..." if len(msg.get('content', '')) > 200 else msg.get('content', ''),
                    "ai_provider": msg.get('ai_provider'),
                    "created_at": msg.get('created_at'),
                    "feedback_comment": msg.get('feedback_comment'),
                    "conversation_id": str(msg.get('conversation_id')) if msg.get('conversation_id') else None
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
            result = self.supabase.table('chatbot_messages').select(
                'ai_provider, feedback'
            ).eq('sender', 'bot').execute()

            messages = result.data if result.data else []

            # Group by provider
            providers_data = {}
            for msg in messages:
                provider = msg.get('ai_provider') or 'unknown'
                if provider not in providers_data:
                    providers_data[provider] = {'total': 0, 'helpful': 0, 'not_helpful': 0}
                providers_data[provider]['total'] += 1
                if msg.get('feedback') == 'helpful':
                    providers_data[provider]['helpful'] += 1
                elif msg.get('feedback') == 'not_helpful':
                    providers_data[provider]['not_helpful'] += 1

            providers = {}
            for provider, data in providers_data.items():
                total_rated = data['helpful'] + data['not_helpful']
                providers[provider] = {
                    "total_messages": data['total'],
                    "helpful": data['helpful'],
                    "not_helpful": data['not_helpful'],
                    "satisfaction_rate": round((data['helpful'] / total_rated * 100), 2) if total_rated > 0 else 0
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
            # Get conversations with topics
            conv_result = self.supabase.table('chatbot_conversations').select(
                'id, topics'
            ).not_.is_('topics', 'null').execute()

            conversations = conv_result.data if conv_result.data else []
            conv_topics = {c['id']: c['topics'] for c in conversations}

            if not conv_topics:
                return []

            # Get messages for these conversations
            msg_result = self.supabase.table('chatbot_messages').select(
                'conversation_id, feedback'
            ).eq('sender', 'bot').in_(
                'conversation_id', list(conv_topics.keys())
            ).execute()

            messages = msg_result.data if msg_result.data else []

            # Group by topic
            topic_data = {}
            for msg in messages:
                conv_id = msg.get('conversation_id')
                topics = conv_topics.get(conv_id)
                if not topics:
                    continue

                topic_key = str(topics) if isinstance(topics, list) else topics
                if topic_key not in topic_data:
                    topic_data[topic_key] = {'count': 0, 'helpful': 0, 'not_helpful': 0}
                topic_data[topic_key]['count'] += 1
                if msg.get('feedback') == 'helpful':
                    topic_data[topic_key]['helpful'] += 1
                elif msg.get('feedback') == 'not_helpful':
                    topic_data[topic_key]['not_helpful'] += 1

            # Sort by count and limit
            sorted_topics = sorted(topic_data.items(), key=lambda x: x[1]['count'], reverse=True)[:limit]

            topics = []
            for topic_key, data in sorted_topics:
                total_rated = data['helpful'] + data['not_helpful']
                topics.append({
                    "topics": topic_key,
                    "message_count": data['count'],
                    "helpful": data['helpful'],
                    "not_helpful": data['not_helpful'],
                    "satisfaction_rate": round((data['helpful'] / total_rated * 100), 2) if total_rated > 0 else 0
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
        end_date: Optional[datetime] = None
    ) -> Dict[str, Any]:
        """
        Export comprehensive feedback report.

        Args:
            start_date: Start of date range
            end_date: End of date range

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


def get_feedback_analytics_service(supabase) -> FeedbackAnalyticsService:
    """Factory function to create FeedbackAnalyticsService instance"""
    return FeedbackAnalyticsService(supabase)
