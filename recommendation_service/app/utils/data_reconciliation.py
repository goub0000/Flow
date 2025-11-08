"""
Data Reconciliation System
Intelligently resolves conflicts when multiple sources provide different values
Phase 2 Enhancement
"""

from typing import Dict, Any, List, Tuple, Optional
from datetime import datetime
import logging

logger = logging.getLogger(__name__)


class DataReconciliator:
    """
    Resolves conflicting data from multiple sources using intelligent rules
    """

    # Source reliability rankings (higher = more reliable)
    SOURCE_RELIABILITY = {
        'college_scorecard_api': 100,  # Government data
        'direct_website': 90,  # Official source
        'the_rankings_api': 85,
        'qs_rankings_api': 85,
        'universities_list_api': 70,
        'wikipedia': 60,
        'search_engine': 50,
    }

    # Field-specific variance thresholds (how much difference is acceptable)
    VARIANCE_THRESHOLDS = {
        'acceptance_rate': 2.0,  # +/- 2 percentage points
        'tuition_out_state': 1000,  # +/- $1000
        'total_students': 500,  # +/- 500 students
        'graduation_rate_4year': 3.0,  # +/- 3 percentage points
    }

    def reconcile_field(
        self,
        field_name: str,
        values: List[Tuple[Any, str, Optional[float], Optional[datetime]]]
    ) -> Dict[str, Any]:
        """
        Reconcile conflicting values for a field

        Args:
            field_name: Name of the field
            values: List of (value, source, confidence, timestamp) tuples

        Returns:
            Dictionary with reconciliation result:
            {
                'final_value': chosen value,
                'source': source of chosen value,
                'confidence': confidence score,
                'reconciliation_method': how it was chosen,
                'all_values': all input values for transparency,
                'conflict_detected': whether values disagreed
            }
        """
        if not values:
            return self._empty_result()

        if len(values) == 1:
            return self._single_value_result(values[0])

        # Check if all values agree
        unique_values = set(v[0] for v in values)
        if len(unique_values) == 1:
            return self._consensus_result(values, field_name)

        # Conflict detected - apply reconciliation logic
        logger.info(f"Conflict detected for {field_name}: {unique_values}")
        return self._resolve_conflict(field_name, values)

    def _resolve_conflict(
        self,
        field_name: str,
        values: List[Tuple[Any, str, Optional[float], Optional[datetime]]]
    ) -> Dict[str, Any]:
        """
        Resolve conflicting values using multi-factor decision logic

        Priority:
        1. Confidence score (if significantly different)
        2. Source reliability
        3. Recency (for time-sensitive fields)
        4. Statistical consensus (for numeric fields)
        """
        # Strategy 1: High-confidence wins
        max_conf = max((v[2] or 0.0) for v in values)
        high_conf_values = [v for v in values if (v[2] or 0.0) >= max_conf - 0.05]

        if len(high_conf_values) == 1 and max_conf >= 0.85:
            return self._confidence_winner_result(high_conf_values[0], values, field_name)

        # Strategy 2: Check for statistical consensus (numeric fields)
        if self._is_numeric_field(field_name):
            consensus = self._check_numeric_consensus(field_name, values)
            if consensus:
                return consensus

        # Strategy 3: Source reliability
        best_source_value = max(
            values,
            key=lambda v: (
                self.SOURCE_RELIABILITY.get(v[1], 0),  # Source reliability
                v[2] or 0.0,  # Confidence
                (v[3].timestamp() if v[3] else 0)  # Recency
            )
        )

        return {
            'final_value': best_source_value[0],
            'source': best_source_value[1],
            'confidence': best_source_value[2] or 0.7,
            'timestamp': best_source_value[3],
            'reconciliation_method': 'source_reliability',
            'all_values': self._format_all_values(values),
            'conflict_detected': True,
            'resolution_details': f"Chose {best_source_value[1]} (reliability score: {self.SOURCE_RELIABILITY.get(best_source_value[1], 0)})"
        }

    def _check_numeric_consensus(
        self,
        field_name: str,
        values: List[Tuple[Any, str, Optional[float], Optional[datetime]]]
    ) -> Optional[Dict[str, Any]]:
        """Check if numeric values have statistical consensus"""
        try:
            numeric_values = [(float(v[0]), v[1], v[2], v[3]) for v in values]
        except (ValueError, TypeError):
            return None

        if len(numeric_values) < 2:
            return None

        # Calculate statistics
        nums = [v[0] for v in numeric_values]
        mean = sum(nums) / len(nums)
        threshold = self.VARIANCE_THRESHOLDS.get(field_name, mean * 0.1)  # 10% default

        # Check if most values cluster around mean
        clustered = [v for v in numeric_values if abs(v[0] - mean) <= threshold]

        if len(clustered) >= len(numeric_values) * 0.6:  # 60% consensus
            # Choose the most reliable value from the cluster
            best = max(
                clustered,
                key=lambda v: (
                    self.SOURCE_RELIABILITY.get(v[1], 0),
                    v[2] or 0.0
                )
            )

            return {
                'final_value': best[0],
                'source': best[1],
                'confidence': min((best[2] or 0.7) + 0.1, 1.0),  # Boost for consensus
                'timestamp': best[3],
                'reconciliation_method': 'statistical_consensus',
                'all_values': self._format_all_values(values),
                'conflict_detected': True,
                'resolution_details': f"Consensus around {best[0]} (mean: {mean:.2f}, threshold: {threshold})"
            }

        return None

    def _is_numeric_field(self, field_name: str) -> bool:
        """Check if field contains numeric data"""
        numeric_fields = [
            'acceptance_rate', 'tuition_out_state', 'total_students',
            'graduation_rate_4year', 'global_rank', 'national_rank'
        ]
        return field_name in numeric_fields

    def _empty_result(self) -> Dict[str, Any]:
        """Return result for no values"""
        return {
            'final_value': None,
            'source': None,
            'confidence': 0.0,
            'timestamp': None,
            'reconciliation_method': 'none',
            'all_values': [],
            'conflict_detected': False
        }

    def _single_value_result(
        self,
        value_tuple: Tuple[Any, str, Optional[float], Optional[datetime]]
    ) -> Dict[str, Any]:
        """Return result for single value"""
        return {
            'final_value': value_tuple[0],
            'source': value_tuple[1],
            'confidence': value_tuple[2] or 0.7,
            'timestamp': value_tuple[3],
            'reconciliation_method': 'single_source',
            'all_values': [self._format_value_tuple(value_tuple)],
            'conflict_detected': False
        }

    def _consensus_result(
        self,
        values: List[Tuple[Any, str, Optional[float], Optional[datetime]]],
        field_name: str
    ) -> Dict[str, Any]:
        """Return result when all sources agree"""
        # Choose highest reliability source from those that agree
        best = max(
            values,
            key=lambda v: (
                self.SOURCE_RELIABILITY.get(v[1], 0),
                v[2] or 0.0,
                (v[3].timestamp() if v[3] else 0)
            )
        )

        return {
            'final_value': best[0],
            'source': best[1],
            'confidence': min((best[2] or 0.7) + 0.15, 1.0),  # High boost for consensus
            'timestamp': best[3],
            'reconciliation_method': 'universal_consensus',
            'all_values': self._format_all_values(values),
            'conflict_detected': False,
            'resolution_details': f"All {len(values)} sources agree"
        }

    def _confidence_winner_result(
        self,
        winner: Tuple[Any, str, Optional[float], Optional[datetime]],
        all_values: List,
        field_name: str
    ) -> Dict[str, Any]:
        """Return result when high-confidence value wins"""
        return {
            'final_value': winner[0],
            'source': winner[1],
            'confidence': winner[2] or 0.9,
            'timestamp': winner[3],
            'reconciliation_method': 'high_confidence',
            'all_values': self._format_all_values(all_values),
            'conflict_detected': True,
            'resolution_details': f"High confidence ({winner[2]:.2f}) from {winner[1]}"
        }

    def _format_value_tuple(
        self,
        value_tuple: Tuple[Any, str, Optional[float], Optional[datetime]]
    ) -> Dict[str, Any]:
        """Format value tuple for output"""
        return {
            'value': value_tuple[0],
            'source': value_tuple[1],
            'confidence': value_tuple[2],
            'timestamp': value_tuple[3].isoformat() if value_tuple[3] else None
        }

    def _format_all_values(
        self,
        values: List[Tuple[Any, str, Optional[float], Optional[datetime]]]
    ) -> List[Dict[str, Any]]:
        """Format all values for output"""
        return [self._format_value_tuple(v) for v in values]

    def reconcile_university_data(
        self,
        field_data: Dict[str, List[Tuple[Any, str, Optional[float], Optional[datetime]]]]
    ) -> Dict[str, Dict[str, Any]]:
        """
        Reconcile all fields for a university

        Args:
            field_data: Dictionary mapping field names to lists of value tuples

        Returns:
            Dictionary mapping field names to reconciliation results
        """
        results = {}

        for field_name, values in field_data.items():
            results[field_name] = self.reconcile_field(field_name, values)

        # Log summary
        conflicts = sum(1 for r in results.values() if r['conflict_detected'])
        if conflicts > 0:
            logger.info(f"Resolved {conflicts} conflicts across {len(results)} fields")

        return results


def demonstrate_reconciliation():
    """Demonstrate reconciliation with example data"""
    reconciliator = DataReconciliator()

    # Example 1: Conflicting acceptance rates
    print("Example 1: Conflicting Acceptance Rates")
    print("-" * 60)
    values = [
        (15.0, 'direct_website', 0.90, datetime.now()),
        (14.5, 'search_engine', 0.60, datetime.now()),
        (15.2, 'qs_rankings_api', 0.85, datetime.now()),
    ]
    result = reconciliator.reconcile_field('acceptance_rate', values)
    print(f"Final value: {result['final_value']}%")
    print(f"Source: {result['source']}")
    print(f"Method: {result['reconciliation_method']}")
    print(f"Confidence: {result['confidence']:.2f}")
    print(f"Details: {result.get('resolution_details', 'N/A')}\n")

    # Example 2: Universal consensus
    print("Example 2: Universal Consensus")
    print("-" * 60)
    values = [
        ('Public', 'direct_website', 0.90, datetime.now()),
        ('Public', 'search_engine', 0.60, datetime.now()),
        ('Public', 'wikipedia', 0.70, datetime.now()),
    ]
    result = reconciliator.reconcile_field('university_type', values)
    print(f"Final value: {result['final_value']}")
    print(f"Method: {result['reconciliation_method']}")
    print(f"Confidence: {result['confidence']:.2f}")
    print(f"Details: {result.get('resolution_details', 'N/A')}\n")


if __name__ == "__main__":
    demonstrate_reconciliation()
