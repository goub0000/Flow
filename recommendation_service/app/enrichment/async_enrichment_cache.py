"""
Async Enrichment Cache Manager
Field-level caching to reduce redundant API calls and web scraping
Provides 2-3x speedup for re-enrichment scenarios
"""
import logging
from typing import Dict, Optional, List, Any
from datetime import datetime, timedelta
from supabase import Client
import json

logger = logging.getLogger(__name__)


class AsyncEnrichmentCache:
    """
    Manages field-level caching for enriched university data

    Benefits:
    - Reduces redundant API calls (College Scorecard, Wikipedia)
    - Avoids re-scraping unchanged data
    - 2-3x faster re-enrichment
    - Configurable TTL per data source
    """

    # Cache TTL (Time To Live) by data source
    DEFAULT_TTL = {
        'college_scorecard': timedelta(days=30),  # College Scorecard updates annually
        'wikipedia': timedelta(days=7),           # Wikipedia changes more frequently
        'duckduckgo': timedelta(days=7),          # Search results can change
        'web_scraping': timedelta(days=7),        # Websites update regularly
        'default': timedelta(days=7)              # Fallback
    }

    def __init__(self, db: Client, enabled: bool = True):
        """
        Initialize cache manager

        Args:
            db: Supabase client
            enabled: If False, cache is disabled (bypass for testing)
        """
        self.db = db
        self.enabled = enabled
        self.stats = {
            'hits': 0,
            'misses': 0,
            'writes': 0,
            'errors': 0
        }

    def get_cached_fields(self, university_id: int, field_names: List[str] = None) -> Dict[str, Any]:
        """
        Get cached fields for a university

        Args:
            university_id: University ID
            field_names: Optional list of specific fields to retrieve (None = all fields)

        Returns:
            Dict mapping field names to cached values
        """
        if not self.enabled:
            return {}

        try:
            # Build query
            query = self.db.table('enrichment_cache')\
                .select('field_name, field_value, data_source, cached_at')\
                .eq('university_id', university_id)\
                .gte('expires_at', datetime.utcnow().isoformat())  # Only non-expired

            # Filter by specific fields if provided
            if field_names:
                query = query.in_('field_name', field_names)

            response = query.execute()

            cached_fields = {}
            for entry in response.data:
                field_name = entry['field_name']
                field_value = self._deserialize_value(entry['field_value'])

                if field_value is not None:
                    cached_fields[field_name] = field_value
                    self.stats['hits'] += 1

                    logger.debug(
                        f"Cache HIT: {field_name} for university {university_id} "
                        f"(source: {entry['data_source']}, age: "
                        f"{(datetime.utcnow() - datetime.fromisoformat(entry['cached_at'].replace('Z', '+00:00'))).days} days)"
                    )

            if cached_fields:
                logger.info(
                    f"Retrieved {len(cached_fields)} cached fields for university {university_id}"
                )

            return cached_fields

        except Exception as e:
            logger.error(f"Cache read error: {e}")
            self.stats['errors'] += 1
            return {}

    def cache_field(
        self,
        university_id: int,
        field_name: str,
        field_value: Any,
        data_source: str,
        ttl: Optional[timedelta] = None
    ) -> bool:
        """
        Cache a single field value

        Args:
            university_id: University ID
            field_name: Name of the field
            field_value: Value to cache
            data_source: Source of the data (college_scorecard, wikipedia, etc.)
            ttl: Optional custom TTL (uses default for source if not provided)

        Returns:
            True if cached successfully
        """
        if not self.enabled:
            return False

        try:
            # Calculate expiration
            if ttl is None:
                ttl = self.DEFAULT_TTL.get(data_source, self.DEFAULT_TTL['default'])

            expires_at = datetime.utcnow() + ttl

            # Serialize value
            serialized_value = self._serialize_value(field_value)

            # Upsert cache entry (replaces existing if present)
            self.db.table('enrichment_cache').upsert({
                'university_id': university_id,
                'field_name': field_name,
                'field_value': serialized_value,
                'data_source': data_source,
                'cached_at': datetime.utcnow().isoformat(),
                'expires_at': expires_at.isoformat(),
                'updated_at': datetime.utcnow().isoformat()
            }, on_conflict='university_id,field_name').execute()

            self.stats['writes'] += 1

            logger.debug(
                f"Cached {field_name}={field_value} for university {university_id} "
                f"(source: {data_source}, TTL: {ttl.days} days)"
            )

            return True

        except Exception as e:
            logger.error(f"Cache write error for {field_name}: {e}")
            self.stats['errors'] += 1
            return False

    def cache_multiple_fields(
        self,
        university_id: int,
        fields: Dict[str, Any],
        data_source: str,
        ttl: Optional[timedelta] = None
    ) -> int:
        """
        Cache multiple fields at once

        Args:
            university_id: University ID
            fields: Dict mapping field names to values
            data_source: Source of the data
            ttl: Optional custom TTL

        Returns:
            Number of fields successfully cached
        """
        if not self.enabled or not fields:
            return 0

        cached_count = 0
        for field_name, field_value in fields.items():
            if field_value is not None:  # Don't cache None values
                if self.cache_field(university_id, field_name, field_value, data_source, ttl):
                    cached_count += 1

        if cached_count > 0:
            logger.info(
                f"Cached {cached_count} fields for university {university_id} "
                f"(source: {data_source})"
            )

        return cached_count

    def invalidate_university(self, university_id: int) -> int:
        """
        Invalidate all cached fields for a university

        Args:
            university_id: University ID

        Returns:
            Number of entries deleted
        """
        if not self.enabled:
            return 0

        try:
            response = self.db.table('enrichment_cache')\
                .delete()\
                .eq('university_id', university_id)\
                .execute()

            deleted = len(response.data) if response.data else 0

            logger.info(f"Invalidated {deleted} cache entries for university {university_id}")
            return deleted

        except Exception as e:
            logger.error(f"Cache invalidation error: {e}")
            self.stats['errors'] += 1
            return 0

    def invalidate_field(self, field_name: str) -> int:
        """
        Invalidate a specific field across all universities

        Args:
            field_name: Name of the field

        Returns:
            Number of entries deleted
        """
        if not self.enabled:
            return 0

        try:
            response = self.db.table('enrichment_cache')\
                .delete()\
                .eq('field_name', field_name)\
                .execute()

            deleted = len(response.data) if response.data else 0

            logger.info(f"Invalidated {deleted} cache entries for field {field_name}")
            return deleted

        except Exception as e:
            logger.error(f"Cache invalidation error: {e}")
            self.stats['errors'] += 1
            return 0

    def cleanup_expired(self) -> int:
        """
        Remove expired cache entries

        Returns:
            Number of entries deleted
        """
        if not self.enabled:
            return 0

        try:
            response = self.db.table('enrichment_cache')\
                .delete()\
                .lt('expires_at', datetime.utcnow().isoformat())\
                .execute()

            deleted = len(response.data) if response.data else 0

            if deleted > 0:
                logger.info(f"Cleaned up {deleted} expired cache entries")

            return deleted

        except Exception as e:
            logger.error(f"Cache cleanup error: {e}")
            self.stats['errors'] += 1
            return 0

    def get_stats(self) -> Dict:
        """
        Get cache statistics

        Returns:
            Dict with cache hit/miss stats
        """
        total_requests = self.stats['hits'] + self.stats['misses']
        hit_rate = (self.stats['hits'] / total_requests * 100) if total_requests > 0 else 0

        return {
            'enabled': self.enabled,
            'hits': self.stats['hits'],
            'misses': self.stats['misses'],
            'writes': self.stats['writes'],
            'errors': self.stats['errors'],
            'hit_rate': round(hit_rate, 2),
            'total_requests': total_requests
        }

    def get_database_stats(self) -> Optional[Dict]:
        """
        Get cache statistics from database

        Returns:
            Dict with cache statistics or None if error
        """
        if not self.enabled:
            return None

        try:
            # Query cache table for stats
            response = self.db.table('enrichment_cache')\
                .select('data_source, field_name, expires_at')\
                .execute()

            entries = response.data
            total = len(entries)

            if total == 0:
                return {
                    'total_entries': 0,
                    'valid_entries': 0,
                    'expired_entries': 0,
                    'by_source': {},
                    'by_field': {}
                }

            # Calculate stats
            now = datetime.utcnow()
            valid = sum(1 for e in entries if datetime.fromisoformat(e['expires_at'].replace('Z', '+00:00')) >= now)
            expired = total - valid

            # Count by source
            by_source = {}
            for entry in entries:
                if datetime.fromisoformat(entry['expires_at'].replace('Z', '+00:00')) >= now:
                    source = entry['data_source']
                    by_source[source] = by_source.get(source, 0) + 1

            # Count by field
            by_field = {}
            for entry in entries:
                if datetime.fromisoformat(entry['expires_at'].replace('Z', '+00:00')) >= now:
                    field = entry['field_name']
                    by_field[field] = by_field.get(field, 0) + 1

            return {
                'total_entries': total,
                'valid_entries': valid,
                'expired_entries': expired,
                'by_source': by_source,
                'by_field': by_field
            }

        except Exception as e:
            logger.error(f"Database stats error: {e}")
            return None

    def _serialize_value(self, value: Any) -> str:
        """Serialize a value for storage"""
        if value is None:
            return None
        if isinstance(value, (str, int, float, bool)):
            return json.dumps(value)
        return json.dumps(value)

    def _deserialize_value(self, value: str) -> Any:
        """Deserialize a stored value"""
        if value is None:
            return None
        try:
            return json.loads(value)
        except:
            return value


if __name__ == "__main__":
    # Test the cache
    from app.database.config import get_supabase

    logging.basicConfig(level=logging.INFO)

    db = get_supabase()
    cache = AsyncEnrichmentCache(db)

    # Test caching fields
    print("\nTesting cache...")
    test_uni_id = 1

    # Cache some fields
    cache.cache_field(test_uni_id, 'acceptance_rate', 0.05, 'college_scorecard')
    cache.cache_field(test_uni_id, 'tuition_out_state', 52000.0, 'college_scorecard')
    cache.cache_field(test_uni_id, 'city', 'Stanford', 'web_scraping')

    # Retrieve cached fields
    cached = cache.get_cached_fields(test_uni_id)
    print(f"\nCached fields: {cached}")

    # Get stats
    stats = cache.get_stats()
    print(f"\nCache stats: {stats}")

    db_stats = cache.get_database_stats()
    print(f"\nDatabase stats: {db_stats}")
