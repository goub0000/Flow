"""
Recommendation Engine - University Matching Algorithm
"""
from typing import List, Dict, Tuple
from sqlalchemy.orm import Session
from app.models.university import University, StudentProfile, Recommendation, Program
import logging

logger = logging.getLogger(__name__)


class RecommendationEngine:
    """
    Matches students to universities using multi-dimensional scoring:
    - Academic Fit: 30%
    - Financial Fit: 25%
    - Program Match: 20%
    - Location Preference: 15%
    - University Characteristics: 10%
    """

    def __init__(self, db: Session):
        self.db = db

    def generate_recommendations(
        self, student: StudentProfile, max_results: int = 15
    ) -> List[Recommendation]:
        """Generate university recommendations for a student"""

        # Get all universities
        universities = self.db.query(University).all()

        if not universities:
            logger.warning("No universities found in database")
            return []

        # Calculate scores for each university
        scored_universities = []
        for university in universities:
            scores = self._calculate_scores(student, university)
            total_score = self._calculate_total_score(scores)
            category = self._determine_category(student, university, scores)

            scored_universities.append({
                "university": university,
                "total_score": total_score,
                "category": category,
                "scores": scores,
            })

        # Sort by total score
        scored_universities.sort(key=lambda x: x["total_score"], reverse=True)

        # Select top universities (ensure mix of categories)
        selected = self._select_diverse_recommendations(
            scored_universities, max_results
        )

        # Create recommendation objects
        recommendations = []
        for item in selected:
            strengths, concerns = self._generate_insights(
                student, item["university"], item["scores"]
            )

            recommendation = Recommendation(
                student_id=student.id,
                university_id=item["university"].id,
                match_score=round(item["total_score"], 2),
                category=item["category"],
                academic_score=round(item["scores"]["academic"], 2),
                financial_score=round(item["scores"]["financial"], 2),
                program_score=round(item["scores"]["program"], 2),
                location_score=round(item["scores"]["location"], 2),
                characteristics_score=round(item["scores"]["characteristics"], 2),
                strengths=strengths,
                concerns=concerns,
            )
            recommendations.append(recommendation)

        return recommendations

    def _calculate_scores(
        self, student: StudentProfile, university: University
    ) -> Dict[str, float]:
        """Calculate all dimension scores"""
        return {
            "academic": self._calculate_academic_score(student, university),
            "financial": self._calculate_financial_score(student, university),
            "program": self._calculate_program_score(student, university),
            "location": self._calculate_location_score(student, university),
            "characteristics": self._calculate_characteristics_score(student, university),
        }

    def _calculate_academic_score(
        self, student: StudentProfile, university: University
    ) -> float:
        """
        Calculate academic fit score (0-100)
        Compares student's academics to university's standards
        """
        score = 0.0
        factors = 0

        # GPA comparison
        if student.gpa and university.gpa_average:
            gpa_diff = student.gpa - university.gpa_average
            if gpa_diff >= 0.3:
                score += 90  # Well above average
            elif gpa_diff >= 0:
                score += 75  # At or above average
            elif gpa_diff >= -0.3:
                score += 60  # Slightly below
            else:
                score += 40  # Below average
            factors += 1

        # SAT comparison (if student has SAT)
        if student.sat_total and university.sat_math_25th and university.sat_ebrw_25th:
            sat_25th = (university.sat_math_25th or 0) + (university.sat_ebrw_25th or 0)
            sat_75th = (university.sat_math_75th or 0) + (university.sat_ebrw_75th or 0)

            if sat_75th > 0:
                if student.sat_total >= sat_75th:
                    score += 90
                elif student.sat_total >= sat_25th:
                    # Linear interpolation between 25th and 75th percentile
                    pct = (student.sat_total - sat_25th) / (sat_75th - sat_25th)
                    score += 60 + (pct * 20)
                else:
                    score += 40
                factors += 1

        # ACT comparison (if student has ACT)
        if student.act_composite and university.act_composite_25th:
            act_25th = university.act_composite_25th or 0
            act_75th = university.act_composite_75th or 0

            if act_75th > 0:
                if student.act_composite >= act_75th:
                    score += 90
                elif student.act_composite >= act_25th:
                    pct = (student.act_composite - act_25th) / (act_75th - act_25th)
                    score += 60 + (pct * 20)
                else:
                    score += 40
                factors += 1

        # Class rank (if available)
        if student.class_rank and student.class_size:
            percentile = (student.class_size - student.class_rank) / student.class_size
            if percentile >= 0.9:
                score += 90
            elif percentile >= 0.75:
                score += 75
            elif percentile >= 0.5:
                score += 60
            else:
                score += 50
            factors += 1

        return score / factors if factors > 0 else 70.0

    def _calculate_financial_score(
        self, student: StudentProfile, university: University
    ) -> float:
        """Calculate financial fit score (0-100)"""
        if not student.max_budget_per_year or not university.total_cost:
            return 70.0  # Neutral score if no data

        cost_diff = student.max_budget_per_year - university.total_cost

        if cost_diff >= 10000:
            return 95.0  # Well within budget
        elif cost_diff >= 0:
            return 85.0  # Within budget
        elif cost_diff >= -10000:
            return 65.0  # Slightly over budget
        elif cost_diff >= -20000:
            return 45.0  # Moderately over budget
        else:
            return 25.0  # Significantly over budget

    def _calculate_program_score(
        self, student: StudentProfile, university: University
    ) -> float:
        """Calculate program match score (0-100)"""
        if not student.intended_major:
            return 70.0  # Neutral if no major specified

        # Check if university has programs in student's field
        programs = self.db.query(Program).filter(
            Program.university_id == university.id
        ).all()

        if not programs:
            return 60.0

        # Look for exact major match
        for program in programs:
            if student.intended_major.lower() in program.name.lower():
                return 95.0

        # Look for field match
        if student.field_of_study:
            for program in programs:
                if student.field_of_study.lower() in (program.field or "").lower():
                    return 80.0

        return 50.0

    def _calculate_location_score(
        self, student: StudentProfile, university: University
    ) -> float:
        """Calculate location preference score (0-100)"""
        score = 70.0  # Base score

        # Check state preference
        if student.preferred_states and university.state:
            if university.state in student.preferred_states:
                score += 20
            else:
                score -= 10

        # Check country preference
        if student.preferred_countries and university.country:
            if university.country in student.preferred_countries:
                score += 10
            else:
                score -= 20

        # Check location type (Urban/Suburban/Rural)
        if student.location_type_preference and university.location_type:
            if student.location_type_preference == university.location_type:
                score += 10

        return max(0, min(100, score))

    def _calculate_characteristics_score(
        self, student: StudentProfile, university: University
    ) -> float:
        """Calculate university characteristics score (0-100)"""
        score = 70.0  # Base score

        # University type preference
        if student.preferred_university_type and university.university_type:
            if student.preferred_university_type == university.university_type:
                score += 15

        # Size preference
        if student.preferred_size and university.total_students:
            size_category = self._categorize_size(university.total_students)
            if student.preferred_size == size_category:
                score += 15

        return max(0, min(100, score))

    def _calculate_total_score(self, scores: Dict[str, float]) -> float:
        """Calculate weighted total score"""
        weights = {
            "academic": 0.30,
            "financial": 0.25,
            "program": 0.20,
            "location": 0.15,
            "characteristics": 0.10,
        }

        total = sum(scores[key] * weights[key] for key in weights)
        return total

    def _determine_category(
        self, student: StudentProfile, university: University, scores: Dict[str, float]
    ) -> str:
        """Determine if university is Safety, Match, or Reach"""
        academic_score = scores["academic"]

        if academic_score >= 80:
            return "Safety"
        elif academic_score >= 60:
            return "Match"
        else:
            return "Reach"

    def _select_diverse_recommendations(
        self, scored_universities: List[Dict], max_results: int
    ) -> List[Dict]:
        """Select diverse set of recommendations across categories"""
        safety = [u for u in scored_universities if u["category"] == "Safety"]
        match = [u for u in scored_universities if u["category"] == "Match"]
        reach = [u for u in scored_universities if u["category"] == "Reach"]

        # Aim for 40% safety, 40% match, 20% reach
        safety_count = min(len(safety), int(max_results * 0.4))
        match_count = min(len(match), int(max_results * 0.4))
        reach_count = min(len(reach), int(max_results * 0.2))

        # Adjust if categories are undersupplied
        remaining = max_results - (safety_count + match_count + reach_count)
        if remaining > 0:
            if len(safety) > safety_count:
                safety_count += min(remaining, len(safety) - safety_count)
                remaining = max_results - (safety_count + match_count + reach_count)
            if remaining > 0 and len(match) > match_count:
                match_count += min(remaining, len(match) - match_count)

        selected = safety[:safety_count] + match[:match_count] + reach[:reach_count]
        return selected

    def _generate_insights(
        self, student: StudentProfile, university: University, scores: Dict[str, float]
    ) -> Tuple[List[str], List[str]]:
        """Generate strengths and concerns for this match"""
        strengths = []
        concerns = []

        # Academic insights
        if scores["academic"] >= 80:
            strengths.append("Strong academic match - your credentials align well")
        elif scores["academic"] < 50:
            concerns.append("Academics may be challenging - consider preparation")

        # Financial insights
        if scores["financial"] >= 85:
            strengths.append("Excellent financial fit - within your budget")
        elif scores["financial"] < 60:
            concerns.append("May exceed your budget - explore financial aid options")

        # Program insights
        if scores["program"] >= 90:
            strengths.append("Offers your intended major with strong programs")

        # Location insights
        if scores["location"] >= 80:
            strengths.append("Located in your preferred area")

        # Outcomes
        if university.graduation_rate_4year and university.graduation_rate_4year >= 0.8:
            strengths.append(f"High graduation rate ({university.graduation_rate_4year*100:.0f}%)")

        if university.median_earnings_10year and university.median_earnings_10year >= 60000:
            strengths.append(f"Strong career outcomes (${university.median_earnings_10year:,.0f} median earnings)")

        return strengths, concerns

    def _categorize_size(self, total_students: int) -> str:
        """Categorize university by size"""
        if total_students < 5000:
            return "Small"
        elif total_students < 15000:
            return "Medium"
        else:
            return "Large"
