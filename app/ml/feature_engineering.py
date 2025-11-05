"""
Feature Engineering for ML-Enhanced Recommendation System
Extracts and transforms features from student and university data
"""
import numpy as np
import pandas as pd
from typing import Dict, List, Tuple, Optional
from sklearn.preprocessing import StandardScaler, LabelEncoder
import logging

logger = logging.getLogger(__name__)


class FeatureEngineer:
    """
    Converts student and university data into ML-ready features
    """

    def __init__(self):
        self.scalers = {}
        self.encoders = {}
        self.feature_names = []

    def extract_student_features(self, student: Dict) -> np.ndarray:
        """
        Extract numerical features from student profile

        Returns:
            numpy array of shape (n_features,)
        """
        features = []

        # Academic features
        features.append(student.get('gpa', 0.0) / 4.0)  # Normalize to 0-1
        features.append(student.get('sat_total', 0) / 1600.0)  # Normalize
        features.append(student.get('sat_math', 0) / 800.0)
        features.append(student.get('sat_ebrw', 0) / 800.0)
        features.append(student.get('act_composite', 0) / 36.0)

        # Class rank percentile
        if student.get('class_rank') and student.get('class_size'):
            percentile = (student['class_size'] - student['class_rank']) / student['class_size']
            features.append(percentile)
        else:
            features.append(0.5)  # Neutral

        # Financial features
        budget = student.get('max_budget_per_year', 0)
        features.append(min(budget / 100000.0, 1.0))  # Normalize (cap at 100k)
        features.append(1.0 if student.get('need_financial_aid') else 0.0)

        # Boolean preferences
        features.append(1.0 if student.get('career_focused') else 0.0)
        features.append(1.0 if student.get('research_opportunities') else 0.0)
        features.append(1.0 if student.get('interested_in_sports') else 0.0)

        # Preference counts (how specific the student is)
        features.append(len(student.get('preferred_states', []) or []) / 10.0)
        features.append(len(student.get('preferred_countries', []) or []) / 10.0)

        return np.array(features, dtype=np.float32)

    def extract_university_features(self, university: Dict) -> np.ndarray:
        """
        Extract numerical features from university profile

        Returns:
            numpy array of shape (n_features,)
        """
        features = []

        # Academic selectivity
        features.append(university.get('acceptance_rate', 0.5))  # Lower = more selective
        features.append(university.get('gpa_average', 3.0) / 4.0)

        # Test score ranges (75th percentile)
        sat_75th = ((university.get('sat_math_75th', 0) or 0) +
                    (university.get('sat_ebrw_75th', 0) or 0)) / 1600.0
        features.append(sat_75th)
        features.append((university.get('act_composite_75th', 0) or 0) / 36.0)

        # Financial
        cost = university.get('total_cost', 0) or university.get('tuition_out_state', 0) or 0
        features.append(min(cost / 100000.0, 1.0))  # Normalize

        # Outcomes
        features.append(university.get('graduation_rate_4year', 0.7))
        earnings = university.get('median_earnings_10year', 0) or 0
        features.append(min(earnings / 150000.0, 1.0))  # Normalize

        # Rankings
        global_rank = university.get('global_rank', 1000)
        features.append(1.0 - min(global_rank / 1000.0, 1.0))  # Inverse: higher = better

        # Size
        total_students = university.get('total_students', 10000) or 10000
        features.append(min(total_students / 50000.0, 1.0))  # Normalize

        # University type (one-hot encoding)
        univ_type = university.get('university_type', 'Unknown')
        features.append(1.0 if univ_type == 'Private' else 0.0)
        features.append(1.0 if univ_type == 'Public' else 0.0)

        # Location type (one-hot encoding)
        loc_type = university.get('location_type', 'Unknown')
        features.append(1.0 if loc_type == 'Urban' else 0.0)
        features.append(1.0 if loc_type == 'Suburban' else 0.0)
        features.append(1.0 if loc_type == 'Rural' else 0.0)

        return np.array(features, dtype=np.float32)

    def extract_interaction_features(
        self,
        student: Dict,
        university: Dict,
        programs: List[Dict]
    ) -> np.ndarray:
        """
        Extract interaction features between student and university
        These capture the "fit" between student preferences and university characteristics

        Returns:
            numpy array of shape (n_features,)
        """
        features = []

        # Academic fit: difference between student and university standards
        if student.get('gpa') and university.get('gpa_average'):
            gpa_diff = student['gpa'] - university['gpa_average']
            features.append(gpa_diff / 4.0)  # Normalized difference
            features.append(1.0 if gpa_diff > 0 else 0.0)  # Above/below indicator
        else:
            features.extend([0.0, 0.5])

        # SAT fit
        if student.get('sat_total'):
            sat_25th = ((university.get('sat_math_25th', 0) or 0) +
                       (university.get('sat_ebrw_25th', 0) or 0))
            sat_75th = ((university.get('sat_math_75th', 0) or 0) +
                       (university.get('sat_ebrw_75th', 0) or 0))

            if sat_75th > 0:
                sat_pct = (student['sat_total'] - sat_25th) / (sat_75th - sat_25th + 1)
                features.append(np.clip(sat_pct, 0, 1))
            else:
                features.append(0.5)
        else:
            features.append(0.5)

        # Financial fit: affordability
        if student.get('max_budget_per_year') and university.get('total_cost'):
            cost_ratio = university['total_cost'] / (student['max_budget_per_year'] + 1)
            features.append(min(cost_ratio, 2.0) / 2.0)  # 0=affordable, 1=2x budget
            features.append(1.0 if cost_ratio <= 1.0 else 0.0)  # Affordable indicator
        else:
            features.extend([0.5, 0.5])

        # Location preference match
        location_match = 0.0
        if student.get('preferred_states') and university.get('state'):
            if university['state'] in student['preferred_states']:
                location_match += 0.5
        if student.get('preferred_countries') and university.get('country'):
            if university['country'] in student['preferred_countries']:
                location_match += 0.5
        features.append(location_match)

        # Location type match
        if student.get('location_type_preference') and university.get('location_type'):
            features.append(1.0 if student['location_type_preference'] == university['location_type'] else 0.0)
        else:
            features.append(0.5)

        # University type match
        if student.get('preferred_university_type') and university.get('university_type'):
            features.append(1.0 if student['preferred_university_type'] == university['university_type'] else 0.0)
        else:
            features.append(0.5)

        # Program match score
        program_match = self._calculate_program_match_score(student, programs)
        features.append(program_match)

        # Size preference match
        if student.get('preferred_size') and university.get('total_students'):
            size_match = self._match_size_preference(
                student['preferred_size'],
                university['total_students']
            )
            features.append(size_match)
        else:
            features.append(0.5)

        return np.array(features, dtype=np.float32)

    def _calculate_program_match_score(self, student: Dict, programs: List[Dict]) -> float:
        """Calculate how well university programs match student interests"""
        if not student.get('intended_major') or not programs:
            return 0.5

        intended_major = student['intended_major'].lower()
        field_of_study = (student.get('field_of_study') or '').lower()

        # Exact match
        for program in programs:
            if intended_major in program['name'].lower():
                return 1.0

        # Field match
        if field_of_study:
            for program in programs:
                if field_of_study in (program.get('field') or '').lower():
                    return 0.7

        # Alternative majors match
        alt_majors = student.get('alternative_majors', []) or []
        for alt_major in alt_majors:
            for program in programs:
                if alt_major.lower() in program['name'].lower():
                    return 0.6

        return 0.3  # Has programs but no match

    def _match_size_preference(self, preferred_size: str, total_students: int) -> float:
        """Check if university size matches student preference"""
        if preferred_size == 'Small' and total_students < 5000:
            return 1.0
        elif preferred_size == 'Medium' and 5000 <= total_students <= 15000:
            return 1.0
        elif preferred_size == 'Large' and total_students > 15000:
            return 1.0
        return 0.0

    def create_feature_vector(
        self,
        student: Dict,
        university: Dict,
        programs: List[Dict]
    ) -> np.ndarray:
        """
        Create complete feature vector for student-university pair

        Returns:
            numpy array of shape (total_features,)
        """
        student_features = self.extract_student_features(student)
        university_features = self.extract_university_features(university)
        interaction_features = self.extract_interaction_features(
            student, university, programs
        )

        # Concatenate all features
        full_features = np.concatenate([
            student_features,
            university_features,
            interaction_features
        ])

        return full_features

    def get_feature_names(self) -> List[str]:
        """Get names of all features for interpretability"""
        student_feature_names = [
            'student_gpa_norm', 'student_sat_total_norm', 'student_sat_math_norm',
            'student_sat_ebrw_norm', 'student_act_norm', 'student_class_percentile',
            'student_budget_norm', 'student_need_aid', 'student_career_focused',
            'student_research', 'student_sports', 'student_state_prefs',
            'student_country_prefs'
        ]

        university_feature_names = [
            'univ_acceptance_rate', 'univ_gpa_avg_norm', 'univ_sat_75th_norm',
            'univ_act_75th_norm', 'univ_cost_norm', 'univ_grad_rate',
            'univ_earnings_norm', 'univ_rank_norm', 'univ_size_norm',
            'univ_type_private', 'univ_type_public', 'univ_loc_urban',
            'univ_loc_suburban', 'univ_loc_rural'
        ]

        interaction_feature_names = [
            'fit_gpa_diff', 'fit_gpa_above', 'fit_sat_percentile',
            'fit_cost_ratio', 'fit_affordable', 'fit_location_match',
            'fit_location_type_match', 'fit_univ_type_match',
            'fit_program_match', 'fit_size_match'
        ]

        return student_feature_names + university_feature_names + interaction_feature_names
