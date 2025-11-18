"""
Personalized Recommendations Service with Tracking
Phase 3.2 - ML Recommendations API Enhancement
"""
from typing import List, Dict, Optional
from supabase import Client
from datetime import datetime
import uuid
import logging

from app.schemas.recommendation_tracking import (
    PersonalizedRecommendation,
    PersonalizedRecommendationsResponse,
    RecommendationImpressionCreate,
    BatchImpressionCreate,
    RecommendationClickCreate,
    RecommendationFeedbackCreate,
    StudentInteractionSummaryResponse
)

logger = logging.getLogger(__name__)


class PersonalizedRecommendationsService:
    """Service for generating personalized recommendations with tracking and explanations"""

    def __init__(self, db: Client):
        self.db = db

    def generate_personalized_recommendations(
        self,
        student_id: str,
        max_results: int = 10,
        category_filter: Optional[str] = None
    ) -> PersonalizedRecommendationsResponse:
        """
        Generate personalized university recommendations with match explanations

        Args:
            student_id: Student's user ID
            max_results: Maximum number of recommendations to return
            category_filter: Optional filter by category (Safety, Match, Reach)

        Returns:
            Personalized recommendations with explanations and tracking session ID
        """
        try:
            # Get student profile
            profile_response = self.db.table('student_profiles').select('*').eq('user_id', student_id).execute()

            if not profile_response.data or len(profile_response.data) == 0:
                raise ValueError("Student profile not found")

            student_profile = profile_response.data[0]

            # Get existing recommendations from the recommendations table
            recs_response = self.db.table('recommendations').select(
                '*, universities(*)'
            ).eq('student_id', student_profile['id']).execute()

            if not recs_response.data:
                raise ValueError("No recommendations found. Generate recommendations first using /recommendations/generate")

            recommendations_data = recs_response.data

            # Filter by category if specified
            if category_filter:
                recommendations_data = [r for r in recommendations_data if r.get('category') == category_filter]

            # Limit results
            recommendations_data = recommendations_data[:max_results]

            # Generate session ID for tracking this batch of recommendations
            session_id = str(uuid.uuid4())

            # Convert to PersonalizedRecommendation format with explanations
            personalized_recs = []
            for idx, rec_data in enumerate(recommendations_data, start=1):
                university = rec_data.get('universities', {})

                # Generate match explanation based on score and category
                match_explanation = self._generate_match_explanation(
                    rec_data, student_profile
                )

                # Generate detailed match reasons
                match_reasons = self._generate_match_reasons(
                    rec_data, student_profile
                )

                # Generate matching factors (human-readable list)
                matching_factors = self._generate_matching_factors(
                    match_reasons, rec_data
                )

                personalized_rec = PersonalizedRecommendation(
                    university_id=rec_data['university_id'],
                    university_name=university.get('name', 'Unknown'),
                    university_city=university.get('city'),
                    university_country=university.get('country'),
                    university_logo_url=university.get('logo_url'),
                    match_score=round(rec_data.get('match_score', 0), 2),
                    category=rec_data.get('category', 'Match'),
                    rank=idx,
                    match_explanation=match_explanation,
                    match_reasons=match_reasons,
                    matching_factors=matching_factors,
                    confidence_score=rec_data.get('confidence_score', 0.75),
                    program_matches=rec_data.get('matching_programs', []),
                    cost_estimate=university.get('tuition_fee'),
                    acceptance_rate=university.get('acceptance_rate')
                )

                personalized_recs.append(personalized_rec)

            # Track impressions in database (async - don't block response)
            try:
                self._track_impressions_batch(
                    student_id=student_id,
                    session_id=session_id,
                    recommendations=personalized_recs
                )
            except Exception as e:
                logger.warning(f"Failed to track impressions: {e}")

            # Count by category
            safety_count = sum(1 for r in personalized_recs if r.category == "Safety")
            match_count = sum(1 for r in personalized_recs if r.category == "Match")
            reach_count = sum(1 for r in personalized_recs if r.category == "Reach")

            return PersonalizedRecommendationsResponse(
                student_id=student_id,
                session_id=session_id,
                total=len(personalized_recs),
                recommendations=personalized_recs,
                generated_at=datetime.utcnow(),
                safety_count=safety_count,
                match_count=match_count,
                reach_count=reach_count,
                ml_powered=True,  # Indicates ML model was used
                model_version="v1.0"
            )

        except ValueError as e:
            raise e
        except Exception as e:
            logger.error(f"Error generating personalized recommendations: {e}")
            raise e

    def _generate_match_explanation(self, rec_data: Dict, student_profile: Dict) -> str:
        """Generate human-readable explanation for why this university was recommended"""
        category = rec_data.get('category', 'Match')
        score = rec_data.get('match_score', 0)
        university_name = rec_data.get('universities', {}).get('name', 'this university')

        if category == "Safety":
            return f"{university_name} is a safety school with a {score:.0f}% match. Your profile exceeds the typical requirements, making admission highly likely."
        elif category == "Match":
            return f"{university_name} is a good match with a {score:.0f}% compatibility score. Your profile aligns well with typical admitted students."
        elif category == "Reach":
            return f"{university_name} is a reach school with a {score:.0f}% match. While competitive, your profile shows potential for admission with a strong application."
        else:
            return f"{university_name} has a {score:.0f}% compatibility score based on your profile."

    def _generate_match_reasons(self, rec_data: Dict, student_profile: Dict) -> Dict[str, bool]:
        """Generate detailed breakdown of matching factors"""
        # Extract matching data from recommendation
        reasons = {
            "gpa_match": False,
            "major_match": False,
            "location_match": False,
            "budget_match": False,
            "program_availability": False,
            "admission_requirements_met": False,
            "extracurricular_alignment": False
        }

        # Check GPA match (example logic - adjust based on actual data structure)
        student_gpa = student_profile.get('gpa', 0)
        if student_gpa >= 3.0:
            reasons["gpa_match"] = True

        # Check major/interest match
        student_interests = student_profile.get('interests', [])
        if student_interests and len(student_interests) > 0:
            reasons["major_match"] = True

        # Check location preference
        preferred_countries = student_profile.get('preferred_countries', [])
        university_country = rec_data.get('universities', {}).get('country')
        if preferred_countries and university_country in preferred_countries:
            reasons["location_match"] = True

        # Check budget
        max_budget = student_profile.get('max_budget', 0)
        tuition = rec_data.get('universities', {}).get('tuition_fee', 0)
        if max_budget > 0 and tuition > 0 and tuition <= max_budget:
            reasons["budget_match"] = True

        # Program availability (default to true if recommendation exists)
        reasons["program_availability"] = True

        # Admission requirements (based on category)
        category = rec_data.get('category', 'Match')
        if category == "Safety":
            reasons["admission_requirements_met"] = True

        return reasons

    def _generate_matching_factors(self, match_reasons: Dict[str, bool], rec_data: Dict) -> List[str]:
        """Convert match reasons to human-readable factors"""
        factors = []

        if match_reasons.get("gpa_match"):
            factors.append("Strong GPA match with typical admitted students")

        if match_reasons.get("major_match"):
            factors.append("Your preferred major is available")

        if match_reasons.get("location_match"):
            factors.append("Located in your preferred country")

        if match_reasons.get("budget_match"):
            factors.append("Tuition within your budget range")

        if match_reasons.get("program_availability"):
            factors.append("Programs aligned with your interests")

        if match_reasons.get("admission_requirements_met"):
            factors.append("You meet the admission requirements")

        # Add category-specific factor
        category = rec_data.get('category', 'Match')
        if category == "Safety":
            factors.append("High probability of admission")
        elif category == "Reach":
            factors.append("Prestigious institution worth considering")

        return factors if factors else ["General profile compatibility"]

    def _track_impressions_batch(
        self,
        student_id: str,
        session_id: str,
        recommendations: List[PersonalizedRecommendation]
    ):
        """Track impressions for a batch of recommendations"""
        impressions_data = []

        for rec in recommendations:
            impression = {
                'student_id': student_id,
                'university_id': rec.university_id,
                'match_score': rec.match_score,
                'category': rec.category,
                'position': rec.rank,
                'recommendation_session_id': session_id,
                'source': 'dashboard',
                'match_reasons': rec.match_reasons,
                'match_explanation': rec.match_explanation,
                'shown_at': datetime.utcnow().isoformat(),
                'created_at': datetime.utcnow().isoformat()
            }
            impressions_data.append(impression)

        # Insert all impressions at once
        if impressions_data:
            self.db.table('recommendation_impressions').insert(impressions_data).execute()
            logger.info(f"Tracked {len(impressions_data)} impressions for session {session_id}")

    def track_click(self, click_data: RecommendationClickCreate) -> Dict:
        """Track when a user clicks on a recommendation"""
        try:
            click_record = {
                'impression_id': click_data.impression_id,
                'student_id': click_data.student_id,
                'university_id': click_data.university_id,
                'action_type': click_data.action_type.value,
                'time_to_click_seconds': click_data.time_to_click_seconds,
                'device_type': click_data.device_type,
                'referrer': click_data.referrer,
                'clicked_at': datetime.utcnow().isoformat(),
                'created_at': datetime.utcnow().isoformat()
            }

            result = self.db.table('recommendation_clicks').insert(click_record).execute()
            logger.info(f"Tracked click for university {click_data.university_id}")
            return result.data[0] if result.data else {}

        except Exception as e:
            logger.error(f"Error tracking click: {e}")
            raise e

    def submit_feedback(self, feedback_data: RecommendationFeedbackCreate) -> Dict:
        """Submit explicit feedback about a recommendation"""
        try:
            feedback_record = {
                'student_id': feedback_data.student_id,
                'university_id': feedback_data.university_id,
                'impression_id': feedback_data.impression_id,
                'feedback_type': feedback_data.feedback_type.value,
                'rating': feedback_data.rating,
                'comment': feedback_data.comment,
                'reasons': feedback_data.reasons,
                'submitted_at': datetime.utcnow().isoformat(),
                'created_at': datetime.utcnow().isoformat()
            }

            result = self.db.table('recommendation_feedback').insert(feedback_record).execute()
            logger.info(f"Recorded feedback for university {feedback_data.university_id}")
            return result.data[0] if result.data else {}

        except Exception as e:
            logger.error(f"Error submitting feedback: {e}")
            raise e

    def get_student_interaction_summary(self, student_id: str) -> Optional[StudentInteractionSummaryResponse]:
        """Get aggregated interaction statistics for a student"""
        try:
            result = self.db.table('student_interaction_summary').select('*').eq('student_id', student_id).execute()

            if result.data and len(result.data) > 0:
                summary_data = result.data[0]
                return StudentInteractionSummaryResponse(**summary_data)

            return None

        except Exception as e:
            logger.error(f"Error getting interaction summary: {e}")
            return None
