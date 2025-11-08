"""
Fallback Scraper with Multiple Extraction Strategies
Tries multiple methods to extract university data, falling back on failure
Phase 1 Enhancement
"""

from typing import Dict, Any, Optional
import logging
from app.data_fetchers.university_website_scraper import UniversityWebsiteScraper
from search_engine_helper import SearchEngineHelper
from app.utils.data_quality_tracker import DataQualityTracker

logger = logging.getLogger(__name__)


class FallbackScraper:
    """Scraper with multiple fallback strategies for robust data extraction"""

    def __init__(self, rate_limit: float = 5.0):
        self.rate_limit = rate_limit
        self.website_scraper = UniversityWebsiteScraper(rate_limit_delay=rate_limit)
        self.search_helper = SearchEngineHelper()
        self.quality_tracker = DataQualityTracker()
        self.stats = {
            'strategy_success': {
                'direct_website': 0,
                'search_engine': 0,
                'combined': 0,
                'failed': 0
            }
        }

    def scrape_university(
        self,
        uni_id: int,
        uni_name: str,
        country: str,
        website: Optional[str] = None,
        city: Optional[str] = None
    ) -> Dict[str, Any]:
        """
        Scrape university data using multiple fallback strategies

        Args:
            uni_id: University ID
            uni_name: University name
            country: Country code
            website: University website URL (optional)
            city: City name (optional)

        Returns:
            Dictionary with scraped data and quality metadata
        """
        logger.info(f"Scraping {uni_name} ({country}) with fallback strategies")

        extracted_data = {}
        strategy_used = []

        # Strategy 1: Direct website scraping (if website URL available)
        if website:
            logger.info(f"  Strategy 1: Direct website scraping ({website})")
            try:
                website_data = self.website_scraper.scrape_university(website, uni_name)
                if website_data and len(website_data) > 0:
                    logger.info(f"    ✓ Extracted {len(website_data)} fields from website")
                    self._merge_data(extracted_data, website_data, 'direct_website')
                    strategy_used.append('direct_website')
                else:
                    logger.info("    - No data from direct scraping")
            except Exception as e:
                logger.warning(f"    ✗ Direct scraping failed: {e}")

        # Strategy 2: Search engine fallback for missing fields
        missing_fields = self._get_missing_fields(extracted_data)
        if missing_fields:
            logger.info(f"  Strategy 2: Search engine fallback for {len(missing_fields)} fields")
            try:
                search_data = self._search_engine_extract(
                    uni_name, country, city, missing_fields
                )
                if search_data and len(search_data) > 0:
                    logger.info(f"    ✓ Extracted {len(search_data)} fields from search")
                    self._merge_data(extracted_data, search_data, 'search_engine')
                    strategy_used.append('search_engine')
                else:
                    logger.info("    - No data from search engine")
            except Exception as e:
                logger.warning(f"    ✗ Search engine failed: {e}")

        # Strategy 3: Field-specific specialized extraction for critical missing fields
        critical_missing = self._get_critical_missing_fields(extracted_data)
        if critical_missing:
            logger.info(f"  Strategy 3: Specialized extraction for {len(critical_missing)} critical fields")
            try:
                specialized_data = self._specialized_extract(
                    uni_name, country, website, critical_missing
                )
                if specialized_data and len(specialized_data) > 0:
                    logger.info(f"    ✓ Extracted {len(specialized_data)} critical fields")
                    self._merge_data(extracted_data, specialized_data, 'search_engine')
                    strategy_used.append('specialized')
            except Exception as e:
                logger.warning(f"    ✗ Specialized extraction failed: {e}")

        # Track statistics
        if not strategy_used:
            self.stats['strategy_success']['failed'] += 1
            logger.warning(f"  All strategies failed for {uni_name}")
        elif len(strategy_used) == 1:
            self.stats['strategy_success'][strategy_used[0]] += 1
        else:
            self.stats['strategy_success']['combined'] += 1

        # Add quality metadata
        result = {
            **extracted_data,
            **self.quality_tracker.get_tracking_metadata()
        }

        logger.info(f"  Final: Extracted {len(extracted_data)} fields using {strategy_used}")
        return result

    def _merge_data(
        self,
        target: Dict[str, Any],
        source: Dict[str, Any],
        source_name: str
    ):
        """
        Merge source data into target, tracking quality

        Args:
            target: Target dictionary to merge into
            source: Source dictionary with new data
            source_name: Name of the data source
        """
        for field_name, value in source.items():
            if field_name in ['website', 'name']:  # Skip metadata fields
                continue

            # Track with quality tracker
            self.quality_tracker.track_field(
                field_name=field_name,
                value=value,
                source=source_name
            )

            # Add to target
            target[field_name] = value

    def _get_missing_fields(self, data: Dict[str, Any]) -> list:
        """
        Get list of important fields that are missing

        Args:
            data: Current extracted data

        Returns:
            List of missing field names
        """
        important_fields = [
            'acceptance_rate',
            'tuition_out_state',
            'total_students',
            'graduation_rate_4year',
            'university_type',
            'location_type'
        ]

        return [field for field in important_fields if field not in data]

    def _get_critical_missing_fields(self, data: Dict[str, Any]) -> list:
        """
        Get list of critical fields that are still missing

        Args:
            data: Current extracted data

        Returns:
            List of critical missing field names
        """
        critical_fields = [
            'acceptance_rate',
            'tuition_out_state',
            'total_students'
        ]

        return [field for field in critical_fields if field not in data]

    def _search_engine_extract(
        self,
        uni_name: str,
        country: str,
        city: Optional[str],
        fields: list
    ) -> Dict[str, Any]:
        """
        Extract data using search engine for specific fields

        Args:
            uni_name: University name
            country: Country code
            city: City name (optional)
            fields: List of fields to extract

        Returns:
            Dictionary with extracted data
        """
        extracted = {}

        # Import field extractors
        from auto_fill_acceptance_rate import AcceptanceRateFiller
        from auto_fill_students import StudentsFiller
        from auto_fill_tuition import TuitionFiller
        from auto_fill_university_type import UniversityTypeFiller
        from auto_fill_location_type import LocationTypeFiller

        # Map fields to extractors
        extractors = {
            'acceptance_rate': AcceptanceRateFiller(),
            'total_students': StudentsFiller(),
            'tuition_out_state': TuitionFiller(),
            'university_type': UniversityTypeFiller(),
            'location_type': LocationTypeFiller()
        }

        for field in fields:
            if field in extractors:
                try:
                    filler = extractors[field]
                    # Call the appropriate extraction method
                    if field == 'acceptance_rate':
                        value = filler._find_acceptance_rate(uni_name, country)
                    elif field == 'total_students':
                        value = filler._find_total_students(uni_name, country)
                    elif field == 'tuition_out_state':
                        if country == 'US':
                            value = filler._find_tuition(uni_name, country)
                        else:
                            continue
                    elif field == 'university_type':
                        value = filler._find_university_type(uni_name, country)
                    elif field == 'location_type':
                        value = filler._find_location_type(uni_name, country, city)

                    if value is not None:
                        extracted[field] = value
                        logger.debug(f"    Extracted {field}: {value}")
                except Exception as e:
                    logger.debug(f"    Failed to extract {field}: {e}")

        return extracted

    def _specialized_extract(
        self,
        uni_name: str,
        country: str,
        website: Optional[str],
        fields: list
    ) -> Dict[str, Any]:
        """
        Specialized extraction with enhanced patterns for critical fields

        Args:
            uni_name: University name
            country: Country code
            website: University website
            fields: List of critical fields to extract

        Returns:
            Dictionary with extracted data
        """
        extracted = {}

        for field in fields:
            if field == 'acceptance_rate':
                # Try multiple search queries with different phrasings
                queries = [
                    f'"{uni_name}" acceptance rate {country}',
                    f'"{uni_name}" admission rate statistics',
                    f'"{uni_name}" how selective'
                ]
                for query in queries:
                    text = self.search_helper.search(query)
                    if text:
                        value = self._extract_acceptance_rate_enhanced(text)
                        if value:
                            extracted[field] = value
                            break

            elif field == 'total_students':
                # Try multiple search queries
                queries = [
                    f'"{uni_name}" total enrollment students',
                    f'"{uni_name}" student population size',
                    f'"{uni_name}" how many students'
                ]
                for query in queries:
                    text = self.search_helper.search(query)
                    if text:
                        value = self._extract_students_enhanced(text)
                        if value:
                            extracted[field] = value
                            break

        return extracted

    def _extract_acceptance_rate_enhanced(self, text: str) -> Optional[float]:
        """Enhanced acceptance rate extraction with multiple patterns"""
        import re

        patterns = [
            r'acceptance rate[:\s]+(\d+(?:\.\d+)?)\s*%',
            r'(\d+(?:\.\d+)?)\s*%\s+acceptance',
            r'admits?\s+(\d+(?:\.\d+)?)\s*%',
            r'(\d+(?:\.\d+)?)\s*%\s+admitted',
        ]

        for pattern in patterns:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                try:
                    rate = float(match.group(1))
                    if 1 <= rate <= 100:
                        return rate
                except (ValueError, IndexError):
                    continue

        return None

    def _extract_students_enhanced(self, text: str) -> Optional[int]:
        """Enhanced student enrollment extraction"""
        import re

        patterns = [
            r'(\d{1,3}(?:,\d{3})*)\s+(?:total\s+)?students?',
            r'enrollment[:\s]+(\d{1,3}(?:,\d{3})*)',
            r'student\s+population[:\s]+(\d{1,3}(?:,\d{3})*)',
        ]

        for pattern in patterns:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                try:
                    students = int(match.group(1).replace(',', ''))
                    if 100 <= students <= 1000000:
                        return students
                except (ValueError, IndexError):
                    continue

        return None

    def get_stats_summary(self) -> Dict[str, Any]:
        """Get summary statistics for scraping strategies"""
        total = sum(self.stats['strategy_success'].values())
        if total == 0:
            return self.stats

        return {
            'strategy_success': self.stats['strategy_success'],
            'success_rate': {
                strategy: (count / total * 100)
                for strategy, count in self.stats['strategy_success'].items()
            }
        }

    def log_stats(self):
        """Log statistics summary"""
        stats = self.get_stats_summary()

        logger.info("=" * 80)
        logger.info("FALLBACK SCRAPER STATISTICS")
        logger.info("=" * 80)
        logger.info("Strategy Success:")
        for strategy, count in stats['strategy_success'].items():
            rate = stats.get('success_rate', {}).get(strategy, 0)
            logger.info(f"  {strategy:20} : {count:4} ({rate:5.1f}%)")
        logger.info("=" * 80)
