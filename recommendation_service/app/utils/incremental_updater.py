"""
Incremental Updater with Staleness Detection
Only updates universities/fields that have stale data
Phase 1 Enhancement
"""

from typing import Dict, Any, List, Optional
from datetime import datetime, timedelta
import logging
from app.database.supabase_client import get_supabase_client

logger = logging.getLogger(__name__)


class IncrementalUpdater:
    """Manages incremental updates based on data staleness"""

    # Staleness thresholds (days) for each field type
    STALENESS_THRESHOLDS = {
        # Rarely changing fields
        'website': 180,  # 6 months
        'logo_url': 730,  # 2 years
        'name': 9999,  # Almost never
        'country': 9999,  # Almost never
        'city': 365,  # 1 year
        'state': 365,  # 1 year

        # Annually changing fields
        'acceptance_rate': 365,  # 1 year
        'tuition_out_state': 365,  # 1 year
        'graduation_rate_4year': 365,  # 1 year
        'global_rank': 365,  # 1 year
        'national_rank': 365,  # 1 year

        # Periodically changing fields
        'total_students': 180,  # 6 months (semester changes)
        'university_type': 730,  # 2 years (rarely changes)
        'location_type': 730,  # 2 years

        # Occasionally changing fields
        'description': 90,  # 3 months
    }

    # Priority levels for universities (affects update frequency)
    PRIORITY_LEVELS = {
        'critical': 30,  # Top universities, update every 30 days
        'high': 90,  # Important universities, every 3 months
        'medium': 180,  # Standard universities, every 6 months
        'low': 365,  # Lesser-known universities, annually
    }

    def __init__(self):
        self.db_client = None
        self.stats = {
            'total_checked': 0,
            'stale': 0,
            'fresh': 0,
            'never_updated': 0,
            'fields_to_update': {}
        }

    def get_stale_universities(
        self,
        field_name: Optional[str] = None,
        limit: int = 100,
        country: Optional[str] = None,
        priority: Optional[str] = None
    ) -> List[Dict[str, Any]]:
        """
        Get universities with stale data for a specific field or overall

        Args:
            field_name: Specific field to check (e.g., 'acceptance_rate')
            limit: Maximum number of universities to return
            country: Optional country filter
            priority: Optional priority level filter

        Returns:
            List of university dictionaries with stale data
        """
        self.db_client = get_supabase_client()

        if field_name:
            return self._get_stale_for_field(field_name, limit, country)
        else:
            return self._get_stale_universities_overall(limit, country, priority)

    def _get_stale_for_field(
        self,
        field_name: str,
        limit: int,
        country: Optional[str] = None
    ) -> List[Dict[str, Any]]:
        """
        Get universities with stale data for a specific field

        Args:
            field_name: Field to check
            limit: Maximum universities to return
            country: Optional country filter

        Returns:
            List of universities with stale field data
        """
        threshold_days = self.STALENESS_THRESHOLDS.get(field_name, 90)
        logger.info(f"Checking for stale {field_name} (threshold: {threshold_days} days)")

        # Build query
        query = self.db_client.client.table('universities').select(
            'id, name, country, city, website, field_last_updated'
        )

        if country:
            query = query.eq('country', country)

        # Execute query
        result = query.limit(limit * 3).execute()  # Get more to filter
        universities = result.data

        # Filter for stale data
        stale_unis = []
        now = datetime.now()

        for uni in universities:
            is_stale = False

            # Check if field has ever been updated
            field_updates = uni.get('field_last_updated', {}) or {}

            if field_name not in field_updates:
                # Never updated
                is_stale = True
                self.stats['never_updated'] += 1
            else:
                # Check if update is stale
                last_updated_str = field_updates[field_name]
                last_updated = datetime.fromisoformat(last_updated_str.replace('Z', '+00:00'))
                age_days = (now - last_updated).days

                if age_days > threshold_days:
                    is_stale = True
                    logger.debug(f"{uni['name']}: {field_name} is {age_days} days old (stale)")

            if is_stale:
                stale_unis.append(uni)
                self.stats['stale'] += 1
            else:
                self.stats['fresh'] += 1

            self.stats['total_checked'] += 1

            if len(stale_unis) >= limit:
                break

        logger.info(f"Found {len(stale_unis)} universities with stale {field_name}")
        return stale_unis

    def _get_stale_universities_overall(
        self,
        limit: int,
        country: Optional[str] = None,
        priority: Optional[str] = None
    ) -> List[Dict[str, Any]]:
        """
        Get universities that haven't been updated in a while (overall staleness)

        Args:
            limit: Maximum universities to return
            country: Optional country filter
            priority: Optional priority level

        Returns:
            List of stale universities
        """
        # Determine threshold based on priority
        if priority:
            threshold_days = self.PRIORITY_LEVELS.get(priority, 180)
        else:
            threshold_days = 90  # Default 3 months

        logger.info(f"Checking for overall staleness (threshold: {threshold_days} days)")

        # Build query
        query = self.db_client.client.table('universities').select(
            'id, name, country, city, website, last_scraped_at'
        )

        if country:
            query = query.eq('country', country)

        # Execute query
        result = query.limit(limit * 3).execute()
        universities = result.data

        # Filter for stale data
        stale_unis = []
        now = datetime.now()

        for uni in universities:
            is_stale = False

            last_scraped = uni.get('last_scraped_at')

            if not last_scraped:
                # Never scraped
                is_stale = True
                self.stats['never_updated'] += 1
            else:
                # Check if scrape is stale
                last_scraped_dt = datetime.fromisoformat(last_scraped.replace('Z', '+00:00'))
                age_days = (now - last_scraped_dt).days

                if age_days > threshold_days:
                    is_stale = True
                    logger.debug(f"{uni['name']}: Last scraped {age_days} days ago (stale)")

            if is_stale:
                stale_unis.append(uni)
                self.stats['stale'] += 1
            else:
                self.stats['fresh'] += 1

            self.stats['total_checked'] += 1

            if len(stale_unis) >= limit:
                break

        logger.info(f"Found {len(stale_unis)} stale universities overall")
        return stale_unis

    def get_priority_for_university(
        self,
        uni_id: int,
        uni_name: str,
        rank: Optional[int] = None
    ) -> str:
        """
        Determine priority level for a university

        Args:
            uni_id: University ID
            uni_name: University name
            rank: Global/national rank if available

        Returns:
            Priority level ('critical', 'high', 'medium', 'low')
        """
        # Rank-based priority
        if rank:
            if rank <= 100:
                return 'critical'
            elif rank <= 500:
                return 'high'
            elif rank <= 2000:
                return 'medium'
            else:
                return 'low'

        # Name-based heuristics (simplified)
        important_keywords = [
            'harvard', 'stanford', 'mit', 'oxford', 'cambridge',
            'yale', 'princeton', 'columbia', 'berkeley', 'caltech'
        ]

        name_lower = uni_name.lower()
        for keyword in important_keywords:
            if keyword in name_lower:
                return 'critical'

        # Default to medium
        return 'medium'

    def should_update_field(
        self,
        field_name: str,
        last_updated: Optional[str] = None
    ) -> bool:
        """
        Check if a field should be updated based on staleness

        Args:
            field_name: Name of the field
            last_updated: ISO format timestamp of last update

        Returns:
            True if field should be updated
        """
        if not last_updated:
            return True  # Never updated

        threshold_days = self.STALENESS_THRESHOLDS.get(field_name, 90)
        last_updated_dt = datetime.fromisoformat(last_updated.replace('Z', '+00:00'))
        age_days = (datetime.now() - last_updated_dt).days

        return age_days > threshold_days

    def get_fields_to_update(
        self,
        uni: Dict[str, Any],
        all_fields: List[str]
    ) -> List[str]:
        """
        Get list of fields that need updating for a university

        Args:
            uni: University dictionary with field_last_updated
            all_fields: List of all possible fields to check

        Returns:
            List of field names that need updating
        """
        field_updates = uni.get('field_last_updated', {}) or {}
        fields_to_update = []

        for field_name in all_fields:
            last_updated = field_updates.get(field_name)
            if self.should_update_field(field_name, last_updated):
                fields_to_update.append(field_name)

                # Track stats
                if field_name not in self.stats['fields_to_update']:
                    self.stats['fields_to_update'][field_name] = 0
                self.stats['fields_to_update'][field_name] += 1

        return fields_to_update

    def get_update_schedule(
        self,
        total_universities: int,
        priority_distribution: Optional[Dict[str, float]] = None
    ) -> Dict[str, Any]:
        """
        Calculate update schedule based on staleness thresholds

        Args:
            total_universities: Total number of universities in DB
            priority_distribution: Optional dict with priority percentages

        Returns:
            Dictionary with update schedule information
        """
        if not priority_distribution:
            # Default distribution
            priority_distribution = {
                'critical': 0.05,  # 5% top universities
                'high': 0.15,  # 15% important universities
                'medium': 0.50,  # 50% standard universities
                'low': 0.30,  # 30% lesser-known universities
            }

        schedule = {}

        for priority, percentage in priority_distribution.items():
            count = int(total_universities * percentage)
            days = self.PRIORITY_LEVELS[priority]

            updates_per_day = count / days if days > 0 else count

            schedule[priority] = {
                'count': count,
                'update_frequency_days': days,
                'updates_per_day': round(updates_per_day, 2)
            }

        total_daily_updates = sum(s['updates_per_day'] for s in schedule.values())

        return {
            'priority_schedules': schedule,
            'total_daily_updates': round(total_daily_updates, 2),
            'total_universities': total_universities
        }

    def log_stats(self):
        """Log staleness check statistics"""
        logger.info("=" * 80)
        logger.info("INCREMENTAL UPDATE STATISTICS")
        logger.info("=" * 80)
        logger.info(f"Total checked:     {self.stats['total_checked']}")
        logger.info(f"Stale:             {self.stats['stale']}")
        logger.info(f"Fresh:             {self.stats['fresh']}")
        logger.info(f"Never updated:     {self.stats['never_updated']}")

        if self.stats['fields_to_update']:
            logger.info("\nFields needing updates:")
            for field, count in sorted(
                self.stats['fields_to_update'].items(),
                key=lambda x: x[1],
                reverse=True
            ):
                logger.info(f"  {field:30} : {count}")

        logger.info("=" * 80)

    def reset_stats(self):
        """Reset statistics"""
        self.stats = {
            'total_checked': 0,
            'stale': 0,
            'fresh': 0,
            'never_updated': 0,
            'fields_to_update': {}
        }
