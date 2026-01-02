"""
User Context Service - Provides personalized context for AI chatbot
"""

from sqlalchemy.orm import Session
from sqlalchemy import desc
from typing import Dict, Any, Optional, List
from datetime import datetime, timedelta
import logging

from app.models.university import StudentProfile, Recommendation, University
from app.api.applications import Application

logger = logging.getLogger(__name__)


class UserContextService:
    """
    Service to gather user context for personalized AI chatbot interactions.

    Collects:
    - User profile data (academic info, preferences)
    - Recent activity (applications, recommendations viewed)
    - Current state (pending tasks, deadlines)
    """

    def __init__(self, db: Session):
        self.db = db

    def get_user_context(
        self,
        user_id: str,
        current_page: Optional[str] = None,
        user_role: Optional[str] = None
    ) -> Dict[str, Any]:
        """
        Get comprehensive user context for AI personalization

        Args:
            user_id: The user's ID
            current_page: Current page/route the user is viewing
            user_role: User's role (student, parent, counselor, admin)

        Returns:
            Dict containing user context for AI system prompt
        """
        context = {
            "user_id": user_id,
            "user_role": user_role or "student",
            "current_page": current_page,
            "profile": None,
            "recent_activity": [],
            "pending_tasks": [],
            "recommendations_summary": None,
            "applications_summary": None,
            "personalization_hints": []
        }

        try:
            # Get user profile
            profile = self._get_user_profile(user_id)
            if profile:
                context["profile"] = self._format_profile(profile)
                context["personalization_hints"].extend(
                    self._get_profile_hints(profile)
                )

            # Get recommendations summary
            recommendations = self._get_recommendations_summary(user_id)
            if recommendations:
                context["recommendations_summary"] = recommendations

            # Get applications summary
            applications = self._get_applications_summary(user_id)
            if applications:
                context["applications_summary"] = applications
                context["pending_tasks"].extend(
                    self._get_application_tasks(user_id)
                )

            # Get recent activity
            context["recent_activity"] = self._get_recent_activity(user_id)

            # Add page-specific hints
            if current_page:
                context["personalization_hints"].extend(
                    self._get_page_hints(current_page, context)
                )

        except Exception as e:
            logger.error(f"Error getting user context for {user_id}: {e}")

        return context

    def _get_user_profile(self, user_id: str) -> Optional[StudentProfile]:
        """Fetch user's student profile"""
        return self.db.query(StudentProfile).filter(
            StudentProfile.user_id == user_id
        ).first()

    def _format_profile(self, profile: StudentProfile) -> Dict[str, Any]:
        """Format profile for AI context (exclude sensitive data)"""
        return {
            "has_gpa": profile.gpa is not None,
            "gpa_range": self._get_gpa_range(profile.gpa) if profile.gpa else None,
            "has_test_scores": profile.sat_total is not None or profile.act_composite is not None,
            "intended_major": profile.intended_major,
            "field_of_study": profile.field_of_study,
            "career_goals": profile.career_goals,
            "preferred_countries": profile.preferred_countries,
            "preferred_states": profile.preferred_states,
            "budget_range": profile.budget_range,
            "needs_financial_aid": profile.need_financial_aid == 1,
            "location_preference": profile.location_type_preference,
            "size_preference": profile.university_size_preference,
            "features_desired": profile.features_desired,
            "profile_completeness": self._calculate_profile_completeness(profile)
        }

    def _get_gpa_range(self, gpa: float) -> str:
        """Convert GPA to a range string for privacy"""
        if gpa >= 3.7:
            return "excellent (3.7+)"
        elif gpa >= 3.3:
            return "strong (3.3-3.7)"
        elif gpa >= 3.0:
            return "good (3.0-3.3)"
        elif gpa >= 2.5:
            return "average (2.5-3.0)"
        else:
            return "below average (<2.5)"

    def _calculate_profile_completeness(self, profile: StudentProfile) -> int:
        """Calculate profile completeness percentage"""
        fields = [
            profile.gpa, profile.intended_major, profile.field_of_study,
            profile.preferred_countries, profile.budget_range,
            profile.location_type_preference, profile.career_goals
        ]
        filled = sum(1 for f in fields if f is not None)
        return int((filled / len(fields)) * 100)

    def _get_profile_hints(self, profile: StudentProfile) -> List[str]:
        """Generate hints based on profile"""
        hints = []

        if profile.intended_major:
            hints.append(f"User is interested in {profile.intended_major}")

        if profile.need_financial_aid == 1:
            hints.append("User needs financial aid information")

        if profile.preferred_countries:
            hints.append(f"User prefers universities in: {', '.join(profile.preferred_countries[:3])}")

        completeness = self._calculate_profile_completeness(profile)
        if completeness < 50:
            hints.append("User profile is incomplete - may need guidance on questionnaire")

        return hints

    def _get_recommendations_summary(self, user_id: str) -> Optional[Dict[str, Any]]:
        """Get summary of user's recommendations"""
        recommendations = self.db.query(Recommendation).filter(
            Recommendation.user_id == user_id
        ).all()

        if not recommendations:
            return None

        safety = [r for r in recommendations if r.category == "Safety"]
        match = [r for r in recommendations if r.category == "Match"]
        reach = [r for r in recommendations if r.category == "Reach"]
        favorited = [r for r in recommendations if r.favorited == 1]

        return {
            "total_count": len(recommendations),
            "safety_count": len(safety),
            "match_count": len(match),
            "reach_count": len(reach),
            "favorited_count": len(favorited),
            "has_recommendations": len(recommendations) > 0,
            "avg_match_score": sum(r.match_score for r in recommendations) / len(recommendations) if recommendations else 0
        }

    def _get_applications_summary(self, user_id: str) -> Optional[Dict[str, Any]]:
        """Get summary of user's applications"""
        applications = self.db.query(Application).filter(
            Application.user_id == user_id
        ).all()

        if not applications:
            return None

        status_counts = {}
        for app in applications:
            status = app.status or "unknown"
            status_counts[status] = status_counts.get(status, 0) + 1

        return {
            "total_count": len(applications),
            "status_breakdown": status_counts,
            "submitted_count": status_counts.get("submitted", 0),
            "in_progress_count": status_counts.get("in_progress", 0),
            "planning_count": status_counts.get("planning", 0),
            "accepted_count": status_counts.get("accepted", 0)
        }

    def _get_application_tasks(self, user_id: str) -> List[str]:
        """Get pending tasks from applications"""
        tasks = []

        applications = self.db.query(Application).filter(
            Application.user_id == user_id,
            Application.status.in_(["planning", "in_progress"])
        ).all()

        for app in applications:
            # Get university name
            university = self.db.query(University).filter(
                University.id == app.university_id
            ).first()
            uni_name = university.name if university else f"University #{app.university_id}"

            if app.essay_status == "not_started":
                tasks.append(f"Start essay for {uni_name}")
            elif app.essay_status == "in_progress":
                tasks.append(f"Complete essay for {uni_name}")

            if app.letters_requested > app.letters_received:
                tasks.append(f"Follow up on recommendation letters for {uni_name}")

            if not app.transcript_sent:
                tasks.append(f"Send transcript to {uni_name}")

            if app.deadline:
                tasks.append(f"Deadline for {uni_name}: {app.deadline}")

        return tasks[:5]  # Return top 5 tasks

    def _get_recent_activity(self, user_id: str) -> List[str]:
        """Get recent user activity"""
        activity = []

        # Recent applications
        recent_apps = self.db.query(Application).filter(
            Application.user_id == user_id
        ).order_by(desc(Application.updated_at)).limit(3).all()

        for app in recent_apps:
            university = self.db.query(University).filter(
                University.id == app.university_id
            ).first()
            if university:
                activity.append(f"Application to {university.name} ({app.status})")

        # Recent favorited recommendations
        recent_favorites = self.db.query(Recommendation).filter(
            Recommendation.user_id == user_id,
            Recommendation.favorited == 1
        ).order_by(desc(Recommendation.created_at)).limit(3).all()

        for rec in recent_favorites:
            university = self.db.query(University).filter(
                University.id == rec.university_id
            ).first()
            if university:
                activity.append(f"Favorited {university.name}")

        return activity

    def _get_page_hints(
        self,
        current_page: str,
        context: Dict[str, Any]
    ) -> List[str]:
        """Generate hints based on current page"""
        hints = []

        if "recommendations" in current_page.lower():
            hints.append("User is viewing recommendations - can help with comparing schools")
        elif "applications" in current_page.lower():
            hints.append("User is managing applications - can help with application process")
        elif "questionnaire" in current_page.lower():
            hints.append("User is filling out profile - can explain questions")
        elif "university" in current_page.lower():
            hints.append("User is viewing university details - can provide more info")
        elif "dashboard" in current_page.lower():
            hints.append("User is on dashboard - can provide overview and suggestions")

        return hints

    def build_system_prompt_context(
        self,
        user_id: str,
        user_name: Optional[str] = None,
        current_page: Optional[str] = None,
        user_role: Optional[str] = None
    ) -> str:
        """
        Build a context string for the AI system prompt

        Returns a formatted string to append to the system prompt
        """
        context = self.get_user_context(user_id, current_page, user_role)

        parts = []

        # User info
        if user_name:
            parts.append(f"The user's name is {user_name}.")

        role = context.get("user_role", "student")
        parts.append(f"They are a {role}.")

        # Profile info
        profile = context.get("profile")
        if profile:
            if profile.get("intended_major"):
                parts.append(f"They are interested in studying {profile['intended_major']}.")

            if profile.get("gpa_range"):
                parts.append(f"Their academic standing is {profile['gpa_range']}.")

            if profile.get("needs_financial_aid"):
                parts.append("They need financial aid.")

            if profile.get("preferred_countries"):
                countries = profile["preferred_countries"][:3]
                parts.append(f"They prefer universities in: {', '.join(countries)}.")

            completeness = profile.get("profile_completeness", 0)
            if completeness < 50:
                parts.append(f"Their profile is {completeness}% complete - encourage them to complete the questionnaire.")

        # Recommendations
        rec_summary = context.get("recommendations_summary")
        if rec_summary:
            parts.append(
                f"They have {rec_summary['total_count']} university recommendations "
                f"({rec_summary['safety_count']} safety, {rec_summary['match_count']} match, "
                f"{rec_summary['reach_count']} reach schools)."
            )
            if rec_summary.get("favorited_count", 0) > 0:
                parts.append(f"They have favorited {rec_summary['favorited_count']} universities.")
        else:
            parts.append("They haven't received recommendations yet - encourage completing the questionnaire.")

        # Applications
        app_summary = context.get("applications_summary")
        if app_summary:
            parts.append(
                f"They have {app_summary['total_count']} applications "
                f"({app_summary.get('submitted_count', 0)} submitted, "
                f"{app_summary.get('in_progress_count', 0)} in progress)."
            )

        # Pending tasks
        tasks = context.get("pending_tasks", [])
        if tasks:
            parts.append(f"Pending tasks: {'; '.join(tasks[:3])}")

        # Current page
        if current_page:
            parts.append(f"They are currently viewing: {current_page}")

        return " ".join(parts)


def get_user_context_service(db: Session) -> UserContextService:
    """Factory function to create UserContextService instance"""
    return UserContextService(db)
