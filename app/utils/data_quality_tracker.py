"""
Data Quality Tracker
Tracks data sources, confidence scores, and update timestamps for university data
Phase 1 Enhancement
"""

from typing import Dict, Any, Optional
from datetime import datetime
import logging

logger = logging.getLogger(__name__)


class DataQualityTracker:
    """Tracks data quality metrics for university information"""

    # Source priority scores (higher = more reliable)
    SOURCE_PRIORITY = {
        'direct_website': 10,
        'college_scorecard_api': 9,
        'qs_rankings_api': 8,
        'the_rankings_api': 8,
        'universities_list_api': 7,
        'wikipedia': 6,
        'search_engine': 5,
    }

    # Base confidence scores by source type
    BASE_CONFIDENCE = {
        'direct_website': 0.85,
        'college_scorecard_api': 0.95,
        'qs_rankings_api': 0.90,
        'the_rankings_api': 0.90,
        'universities_list_api': 0.80,
        'wikipedia': 0.70,
        'search_engine': 0.60,
    }

    def __init__(self):
        self.tracked_data = {
            'data_sources': {},
            'data_confidence': {},
            'field_last_updated': {},
        }

    def track_field(
        self,
        field_name: str,
        value: Any,
        source: str,
        confidence: Optional[float] = None
    ) -> Dict[str, Any]:
        """
        Track a field update with source and confidence

        Args:
            field_name: Name of the field (e.g., 'acceptance_rate')
            value: The value being set
            source: Source of the data (e.g., 'direct_website')
            confidence: Optional manual confidence score (0-1)

        Returns:
            Dictionary with field value and tracking metadata
        """
        # Calculate confidence if not provided
        if confidence is None:
            confidence = self._calculate_confidence(field_name, source, value)

        # Track the update
        self.tracked_data['data_sources'][field_name] = source
        self.tracked_data['data_confidence'][field_name] = confidence
        self.tracked_data['field_last_updated'][field_name] = datetime.now().isoformat()

        logger.debug(
            f"Tracked {field_name}={value} from {source} "
            f"(confidence: {confidence:.2f})"
        )

        return {
            field_name: value,
            'source': source,
            'confidence': confidence,
            'updated_at': self.tracked_data['field_last_updated'][field_name]
        }

    def _calculate_confidence(
        self,
        field_name: str,
        source: str,
        value: Any
    ) -> float:
        """
        Calculate confidence score for a field value

        Args:
            field_name: Name of the field
            source: Source of the data
            value: The value

        Returns:
            Confidence score between 0 and 1
        """
        # Start with base confidence for the source
        base_conf = self.BASE_CONFIDENCE.get(source, 0.5)

        # Adjust based on field-specific factors
        if field_name in ['acceptance_rate', 'tuition_out_state', 'graduation_rate_4year']:
            # Numeric fields from official sources are highly reliable
            if source in ['direct_website', 'college_scorecard_api']:
                base_conf = min(base_conf + 0.05, 1.0)

        elif field_name in ['website', 'name', 'city', 'country']:
            # Basic identifying fields are generally reliable
            base_conf = min(base_conf + 0.10, 1.0)

        elif field_name in ['university_type', 'location_type']:
            # Categorical fields from search might be less reliable
            if source == 'search_engine':
                base_conf = max(base_conf - 0.15, 0.0)

        # Check for value plausibility
        if not self._is_value_plausible(field_name, value):
            logger.warning(f"Implausible value for {field_name}: {value}")
            base_conf = max(base_conf - 0.20, 0.0)

        return round(base_conf, 2)

    def _is_value_plausible(self, field_name: str, value: Any) -> bool:
        """
        Check if value is plausible for the field

        Args:
            field_name: Name of the field
            value: The value to check

        Returns:
            True if value seems plausible
        """
        if value is None:
            return False

        # Field-specific plausibility checks
        if field_name == 'acceptance_rate':
            return isinstance(value, (int, float)) and 0.1 <= value <= 100

        elif field_name == 'tuition_out_state':
            return isinstance(value, (int, float)) and 1000 <= value <= 100000

        elif field_name == 'total_students':
            return isinstance(value, (int, float)) and 50 <= value <= 1000000

        elif field_name == 'graduation_rate_4year':
            return isinstance(value, (int, float)) and 5 <= value <= 100

        elif field_name == 'website':
            return isinstance(value, str) and ('http://' in value or 'https://' in value)

        elif field_name in ['university_type', 'location_type']:
            return isinstance(value, str) and len(value) > 0

        # Default: assume plausible
        return True

    def should_update_field(
        self,
        field_name: str,
        new_source: str,
        new_confidence: Optional[float] = None,
        existing_source: Optional[str] = None,
        existing_confidence: Optional[float] = None
    ) -> bool:
        """
        Determine if a field should be updated based on source priority

        Args:
            field_name: Name of the field
            new_source: Source of new data
            new_confidence: Confidence of new data
            existing_source: Current source (if any)
            existing_confidence: Current confidence (if any)

        Returns:
            True if field should be updated
        """
        # If no existing data, always update
        if existing_source is None:
            return True

        # Calculate new confidence if not provided
        if new_confidence is None:
            new_confidence = self.BASE_CONFIDENCE.get(new_source, 0.5)

        # Calculate existing confidence if not provided
        if existing_confidence is None:
            existing_confidence = self.BASE_CONFIDENCE.get(existing_source, 0.5)

        # Get source priorities
        new_priority = self.SOURCE_PRIORITY.get(new_source, 0)
        existing_priority = self.SOURCE_PRIORITY.get(existing_source, 0)

        # Decision logic:
        # 1. If new confidence is significantly higher (>0.15), update
        if new_confidence > existing_confidence + 0.15:
            logger.info(
                f"Updating {field_name}: new confidence {new_confidence:.2f} > "
                f"existing {existing_confidence:.2f}"
            )
            return True

        # 2. If similar confidence, prefer higher priority source
        if abs(new_confidence - existing_confidence) <= 0.15:
            if new_priority > existing_priority:
                logger.info(
                    f"Updating {field_name}: {new_source} (priority {new_priority}) > "
                    f"{existing_source} (priority {existing_priority})"
                )
                return True

        # 3. Otherwise, keep existing value
        logger.debug(
            f"Keeping existing {field_name} from {existing_source} "
            f"(confidence: {existing_confidence:.2f})"
        )
        return False

    def get_tracking_metadata(self) -> Dict[str, Any]:
        """
        Get all tracking metadata for database update

        Returns:
            Dictionary with data_sources, data_confidence, field_last_updated
        """
        return {
            'data_sources': self.tracked_data['data_sources'],
            'data_confidence': self.tracked_data['data_confidence'],
            'field_last_updated': self.tracked_data['field_last_updated'],
            'last_scraped_at': datetime.now().isoformat()
        }

    def merge_with_existing(
        self,
        existing_sources: Optional[Dict[str, str]] = None,
        existing_confidence: Optional[Dict[str, float]] = None,
        existing_timestamps: Optional[Dict[str, str]] = None
    ) -> Dict[str, Any]:
        """
        Merge new tracking data with existing data from database

        Args:
            existing_sources: Existing data_sources from DB
            existing_confidence: Existing data_confidence from DB
            existing_timestamps: Existing field_last_updated from DB

        Returns:
            Merged tracking metadata
        """
        merged_sources = existing_sources.copy() if existing_sources else {}
        merged_confidence = existing_confidence.copy() if existing_confidence else {}
        merged_timestamps = existing_timestamps.copy() if existing_timestamps else {}

        # Merge new data
        merged_sources.update(self.tracked_data['data_sources'])
        merged_confidence.update(self.tracked_data['data_confidence'])
        merged_timestamps.update(self.tracked_data['field_last_updated'])

        return {
            'data_sources': merged_sources,
            'data_confidence': merged_confidence,
            'field_last_updated': merged_timestamps,
            'last_scraped_at': datetime.now().isoformat()
        }

    def get_field_metadata(self, field_name: str) -> Dict[str, Any]:
        """
        Get metadata for a specific field

        Args:
            field_name: Name of the field

        Returns:
            Dictionary with source, confidence, updated_at
        """
        return {
            'source': self.tracked_data['data_sources'].get(field_name),
            'confidence': self.tracked_data['data_confidence'].get(field_name),
            'updated_at': self.tracked_data['field_last_updated'].get(field_name)
        }

    def log_tracking_summary(self):
        """Log summary of tracked fields"""
        if not self.tracked_data['data_sources']:
            logger.info("No fields tracked")
            return

        logger.info("=" * 60)
        logger.info("DATA QUALITY TRACKING SUMMARY")
        logger.info("=" * 60)
        for field_name in self.tracked_data['data_sources']:
            metadata = self.get_field_metadata(field_name)
            logger.info(
                f"{field_name:25} | Source: {metadata['source']:20} | "
                f"Confidence: {metadata['confidence']:.2f}"
            )
        logger.info("=" * 60)
