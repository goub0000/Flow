"""
ML-Enhanced Recommendation Engine
Combines traditional rule-based scoring with machine learning predictions
"""
from typing import List, Dict, Optional
from supabase import Client
import logging
import os
import numpy as np

from .feature_engineering import FeatureEngineer
from .models import EnsembleRecommendationModel

logger = logging.getLogger(__name__)


class MLRecommendationEngine:
    """
    Enhanced recommendation engine that uses ML models to improve match accuracy
    Falls back to rule-based scoring if ML models unavailable
    """

    def __init__(self, db: Client, model_dir: Optional[str] = None):
        self.db = db
        self.feature_engineer = FeatureEngineer()
        self.ml_model = None
        self.use_ml = False

        # Try to load ML models if path provided
        if model_dir and os.path.exists(model_dir):
            try:
                self.ml_model = EnsembleRecommendationModel(self.feature_engineer)
                self.ml_model.load(model_dir)
                self.use_ml = True
                logger.info("✅ ML models loaded successfully - using ML-enhanced recommendations")
            except Exception as e:
                logger.warning(f"Failed to load ML models: {e}. Falling back to rule-based scoring.")
                self.use_ml = False
        else:
            logger.info("No ML models found - using rule-based scoring (train models to enable ML)")

    def generate_recommendations(
        self, student: Dict, max_results: int = 15
    ) -> List[Dict]:
        """
        Generate university recommendations for a student using ML if available

        Args:
            student: Student profile dictionary
            max_results: Maximum number of recommendations to return

        Returns:
            List of recommendation dictionaries with scores
        """
        logger.info(f"Generating recommendations for student {student.get('user_id')} (ML: {self.use_ml})")

        # Get all universities from Supabase
        response = self.db.table('universities').select('*').execute()
        universities = response.data

        if not universities:
            logger.warning("No universities found in database")
            return []

        # Filter by preferred countries if specified
        if student.get("preferred_countries") and len(student["preferred_countries"]) > 0:
            initial_count = len(universities)
            universities = [
                u for u in universities
                if u.get("country") in student["preferred_countries"]
            ]
            logger.info(f"Filtered by country preference: {initial_count} -> {len(universities)} universities")

            if not universities:
                logger.warning(f"No universities found in preferred countries: {student['preferred_countries']}")
                return []

        # Batch-load all programs to avoid N+1 queries
        logger.info("Loading programs for matching...")
        programs_response = self.db.table('programs').select('*').execute()
        all_programs = programs_response.data

        # Create index: university_id -> list of programs
        programs_by_university = {}
        for program in all_programs:
            univ_id = program.get('university_id')
            if univ_id:
                if univ_id not in programs_by_university:
                    programs_by_university[univ_id] = []
                programs_by_university[univ_id].append(program)

        logger.info(f"Loaded programs for {len(programs_by_university)} universities")

        if self.use_ml and self.ml_model:
            # Use ML model for predictions
            scores = self._generate_ml_recommendations(
                student, universities, programs_by_university
            )
        else:
            # Fallback to rule-based scoring
            scores = self._generate_rulebased_recommendations(
                student, universities, programs_by_university
            )

        # Sort universities by score
        scored_universities = list(zip(universities, scores))
        scored_universities.sort(key=lambda x: x[1], reverse=True)

        # Select top universities
        top_universities = scored_universities[:max_results]

        # Create recommendation dictionaries
        recommendations = []
        for university, score in top_universities:
            programs = programs_by_university.get(university['id'], [])

            # Calculate dimension scores for insights
            dimension_scores = self._calculate_dimension_scores(
                student, university, programs
            )

            # Determine category based on academic fit
            category = self._determine_category(dimension_scores['academic'])

            # Generate insights
            strengths, concerns = self._generate_insights(
                student, university, dimension_scores
            )

            recommendation = {
                "student_id": student["id"],
                "university_id": university["id"],
                "match_score": round(float(score), 2),
                "category": category,
                "academic_score": round(dimension_scores['academic'], 2),
                "financial_score": round(dimension_scores['financial'], 2),
                "program_score": round(dimension_scores['program'], 2),
                "location_score": round(dimension_scores['location'], 2),
                "characteristics_score": round(dimension_scores['characteristics'], 2),
                "strengths": strengths,
                "concerns": concerns,
                "favorited": 0,
                "notes": None,
            }
            recommendations.append(recommendation)

        logger.info(f"Generated {len(recommendations)} recommendations")
        return recommendations

    def _generate_ml_recommendations(
        self,
        student: Dict,
        universities: List[Dict],
        programs_by_university: Dict[int, List[Dict]]
    ) -> np.ndarray:
        """Generate recommendations using ML model (batch prediction)"""
        logger.info("Using ML model for predictions...")

        try:
            scores = self.ml_model.predict_batch(
                student, universities, programs_by_university
            )
            return scores
        except Exception as e:
            logger.error(f"ML prediction failed: {e}. Falling back to rule-based.")
            return self._generate_rulebased_recommendations(
                student, universities, programs_by_university
            )

    def _generate_rulebased_recommendations(
        self,
        student: Dict,
        universities: List[Dict],
        programs_by_university: Dict[int, List[Dict]]
    ) -> np.ndarray:
        """Generate recommendations using traditional rule-based scoring"""
        logger.info("Using rule-based scoring...")

        scores = []
        for university in universities:
            programs = programs_by_university.get(university['id'], [])
            dimension_scores = self._calculate_dimension_scores(
                student, university, programs
            )

            # Weighted combination
            weights = {
                "academic": 0.30,
                "financial": 0.25,
                "program": 0.20,
                "location": 0.15,
                "characteristics": 0.10,
            }

            total_score = sum(
                dimension_scores[dim] * weight
                for dim, weight in weights.items()
            )

            scores.append(total_score)

        return np.array(scores)

    def _calculate_dimension_scores(
        self, student: Dict, university: Dict, programs: List[Dict]
    ) -> Dict[str, float]:
        """Calculate scores for each dimension (for insights and fallback)"""
        return {
            "academic": self._calculate_academic_score(student, university),
            "financial": self._calculate_financial_score(student, university),
            "program": self._calculate_program_score(student, university, programs),
            "location": self._calculate_location_score(student, university),
            "characteristics": self._calculate_characteristics_score(student, university),
        }

    def _calculate_academic_score(
        self, student: Dict, university: Dict
    ) -> float:
        """Calculate academic fit score (0-100)"""
        score = 0.0
        factors = 0

        # GPA comparison
        if student.get("gpa") and university.get("gpa_average"):
            gpa_diff = student["gpa"] - university["gpa_average"]
            if gpa_diff >= 0.3:
                score += 90
            elif gpa_diff >= 0:
                score += 75
            elif gpa_diff >= -0.3:
                score += 60
            else:
                score += 40
            factors += 1

        # SAT comparison
        if student.get("sat_total") and university.get("sat_math_25th") and university.get("sat_ebrw_25th"):
            sat_25th = (university.get("sat_math_25th") or 0) + (university.get("sat_ebrw_25th") or 0)
            sat_75th = (university.get("sat_math_75th") or 0) + (university.get("sat_ebrw_75th") or 0)

            if sat_75th > 0:
                if student["sat_total"] >= sat_75th:
                    score += 90
                elif student["sat_total"] >= sat_25th:
                    pct = (student["sat_total"] - sat_25th) / (sat_75th - sat_25th)
                    score += 60 + (pct * 20)
                else:
                    score += 40
                factors += 1

        return score / factors if factors > 0 else 70.0

    def _calculate_financial_score(
        self, student: Dict, university: Dict
    ) -> float:
        """Calculate financial fit score (0-100)"""
        if not student.get("max_budget_per_year") or not university.get("total_cost"):
            return 70.0

        cost_diff = student["max_budget_per_year"] - university["total_cost"]

        if cost_diff >= 10000:
            return 95.0
        elif cost_diff >= 0:
            return 85.0
        elif cost_diff >= -10000:
            return 65.0
        elif cost_diff >= -20000:
            return 45.0
        else:
            return 25.0

    def _calculate_program_score(
        self, student: Dict, university: Dict, programs: List[Dict]
    ) -> float:
        """Calculate program match score (0-100)"""
        if not student.get("intended_major"):
            return 70.0

        if not programs:
            return 60.0

        # Look for exact major match
        for program in programs:
            if student["intended_major"].lower() in program["name"].lower():
                return 95.0

        # Look for field match
        if student.get("field_of_study"):
            for program in programs:
                if student["field_of_study"].lower() in (program.get("field") or "").lower():
                    return 80.0

        return 50.0

    def _calculate_location_score(
        self, student: Dict, university: Dict
    ) -> float:
        """Calculate location preference score (0-100)"""
        score = 70.0

        if student.get("preferred_states") and university.get("state"):
            if university["state"] in student["preferred_states"]:
                score += 20
            else:
                score -= 10

        if student.get("preferred_countries") and university.get("country"):
            if university["country"] in student["preferred_countries"]:
                score += 10
            else:
                score -= 20

        if student.get("location_type_preference") and university.get("location_type"):
            if student["location_type_preference"] == university["location_type"]:
                score += 10

        return max(0, min(100, score))

    def _calculate_characteristics_score(
        self, student: Dict, university: Dict
    ) -> float:
        """Calculate university characteristics score (0-100)"""
        score = 70.0

        if student.get("preferred_university_type") and university.get("university_type"):
            if student["preferred_university_type"] == university["university_type"]:
                score += 15

        return max(0, min(100, score))

    def _determine_category(self, academic_score: float) -> str:
        """Determine recommendation category based on academic fit"""
        if academic_score >= 80:
            return "Safety"
        elif academic_score >= 60:
            return "Match"
        else:
            return "Reach"

    def _generate_insights(
        self, student: Dict, university: Dict, scores: Dict[str, float]
    ) -> tuple:
        """Generate strengths and concerns for a recommendation"""
        strengths = []
        concerns = []

        if scores['academic'] >= 80:
            strengths.append("Strong academic match - your credentials align well")
        elif scores['academic'] < 50:
            concerns.append("Academics may be challenging - consider preparation")

        if scores['financial'] >= 85:
            strengths.append("Excellent financial fit - within your budget")
        elif scores['financial'] < 60:
            concerns.append("May exceed your budget - explore financial aid options")

        if scores['program'] >= 90:
            strengths.append("Offers your intended major with strong programs")

        if scores['location'] >= 80:
            strengths.append("Located in your preferred area")

        if university.get('graduation_rate_4year') and university['graduation_rate_4year'] >= 0.8:
            strengths.append(f"High graduation rate ({int(university['graduation_rate_4year']*100)}%)")

        if university.get('median_earnings_10year') and university['median_earnings_10year'] >= 60000:
            strengths.append(f"Strong career outcomes (${int(university['median_earnings_10year']):,} median earnings)")

        return strengths, concerns
