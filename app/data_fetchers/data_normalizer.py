"""
Data Normalizer for University Information
Handles validation, cleaning, and normalization of data from multiple sources
"""
import logging
from typing import Dict, Any, Optional, List
from sqlalchemy.orm import Session
from app.models.university import University, Program

logger = logging.getLogger(__name__)


class UniversityDataNormalizer:
    """Normalizes and validates university data for database insertion"""

    @staticmethod
    def validate_university_data(data: Dict[str, Any]) -> bool:
        """
        Validate required fields for university data

        Args:
            data: University data dictionary

        Returns:
            True if valid, False otherwise
        """
        required_fields = ['name', 'country']

        for field in required_fields:
            if not data.get(field):
                logger.warning(f"Missing required field: {field} for {data.get('name', 'Unknown')}")
                return False

        return True

    @staticmethod
    def clean_float(value: Any) -> Optional[float]:
        """Safely convert value to float"""
        if value is None:
            return None
        try:
            return float(value)
        except (ValueError, TypeError):
            return None

    @staticmethod
    def clean_int(value: Any) -> Optional[int]:
        """Safely convert value to integer"""
        if value is None:
            return None
        try:
            return int(value)
        except (ValueError, TypeError):
            return None

    @staticmethod
    def clean_string(value: Any, max_length: Optional[int] = None) -> Optional[str]:
        """Safely convert value to string and truncate if needed"""
        if value is None:
            return None
        try:
            string_val = str(value).strip()
            if max_length and len(string_val) > max_length:
                string_val = string_val[:max_length]
            return string_val if string_val else None
        except (ValueError, TypeError):
            return None

    def normalize_university(self, raw_data: Dict[str, Any]) -> Optional[Dict[str, Any]]:
        """
        Normalize and clean university data

        Args:
            raw_data: Raw university data from any source

        Returns:
            Normalized data dict or None if invalid
        """
        if not self.validate_university_data(raw_data):
            return None

        normalized = {
            # Basic info
            'name': self.clean_string(raw_data.get('name'), 255),
            'country': self.clean_string(raw_data.get('country'), 100),
            'state': self.clean_string(raw_data.get('state'), 100),
            'city': self.clean_string(raw_data.get('city'), 100),
            'website': self.clean_string(raw_data.get('website'), 255),
            'logo_url': self.clean_string(raw_data.get('logo_url'), 500),
            'description': self.clean_string(raw_data.get('description')),
            'university_type': self.clean_string(raw_data.get('university_type'), 50),
            'location_type': self.clean_string(raw_data.get('location_type'), 50),

            # Student body
            'total_students': self.clean_int(raw_data.get('total_students')),

            # Rankings
            'global_rank': self.clean_int(raw_data.get('global_rank')),
            'national_rank': self.clean_int(raw_data.get('national_rank')),

            # Admissions
            'acceptance_rate': self.clean_float(raw_data.get('acceptance_rate')),
            'gpa_average': self.clean_float(raw_data.get('gpa_average')),
            'sat_math_25th': self.clean_int(raw_data.get('sat_math_25th')),
            'sat_math_75th': self.clean_int(raw_data.get('sat_math_75th')),
            'sat_ebrw_25th': self.clean_int(raw_data.get('sat_ebrw_25th')),
            'sat_ebrw_75th': self.clean_int(raw_data.get('sat_ebrw_75th')),
            'act_composite_25th': self.clean_int(raw_data.get('act_composite_25th')),
            'act_composite_75th': self.clean_int(raw_data.get('act_composite_75th')),

            # Financial
            'tuition_out_state': self.clean_float(raw_data.get('tuition_out_state')),
            'total_cost': self.clean_float(raw_data.get('total_cost')),

            # Outcomes
            'graduation_rate_4year': self.clean_float(raw_data.get('graduation_rate_4year')),
            'median_earnings_10year': self.clean_float(raw_data.get('median_earnings_10year')),
        }

        # Remove None values
        return {k: v for k, v in normalized.items() if v is not None}

    def save_to_database(
        self,
        db: Session,
        university_data: Dict[str, Any],
        programs_data: Optional[List[Dict[str, Any]]] = None,
        update_existing: bool = True
    ) -> Optional[University]:
        """
        Save university to database

        Args:
            db: Database session
            university_data: Normalized university data
            programs_data: Optional list of programs
            update_existing: If True, update existing universities by name

        Returns:
            University object or None if failed
        """
        try:
            # Check if university exists
            existing = db.query(University).filter(
                University.name == university_data['name'],
                University.country == university_data.get('country', 'USA')
            ).first()

            if existing:
                if update_existing:
                    # Update existing
                    for key, value in university_data.items():
                        setattr(existing, key, value)
                    db.flush()
                    logger.info(f"Updated: {university_data['name']}")
                    return existing
                else:
                    logger.info(f"Skipped (exists): {university_data['name']}")
                    return existing
            else:
                # Create new
                university = University(**university_data)
                db.add(university)
                db.flush()

                # Add programs if provided
                if programs_data:
                    for program_data in programs_data:
                        program = Program(university_id=university.id, **program_data)
                        db.add(program)

                logger.info(f"Added: {university_data['name']}")
                return university

        except Exception as e:
            logger.error(f"Error saving university {university_data.get('name')}: {e}")
            return None

    def batch_save_universities(
        self,
        db: Session,
        universities_data: List[Dict[str, Any]],
        update_existing: bool = True,
        commit_batch_size: int = 50
    ) -> Dict[str, int]:
        """
        Save multiple universities in batches

        Args:
            db: Database session
            universities_data: List of normalized university data
            update_existing: If True, update existing universities
            commit_batch_size: Number of records to commit at once

        Returns:
            Dict with statistics (added, updated, failed)
        """
        stats = {'added': 0, 'updated': 0, 'skipped': 0, 'failed': 0}

        for i, uni_data in enumerate(universities_data):
            # Normalize data
            normalized = self.normalize_university(uni_data)
            if not normalized:
                stats['failed'] += 1
                continue

            # Save to database
            university = self.save_to_database(db, normalized, update_existing=update_existing)

            if university:
                if university.id:
                    stats['updated'] += 1
                else:
                    stats['added'] += 1
            else:
                stats['failed'] += 1

            # Commit in batches
            if (i + 1) % commit_batch_size == 0:
                try:
                    db.commit()
                    logger.info(f"Committed batch of {commit_batch_size} (total processed: {i + 1})")
                except Exception as e:
                    logger.error(f"Error committing batch: {e}")
                    db.rollback()
                    stats['failed'] += commit_batch_size

        # Final commit
        try:
            db.commit()
            logger.info("Final commit completed")
        except Exception as e:
            logger.error(f"Error in final commit: {e}")
            db.rollback()

        logger.info(f"Import completed: {stats}")
        return stats
