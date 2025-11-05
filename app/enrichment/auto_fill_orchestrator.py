"""
Auto-Fill Orchestrator
Intelligently manages the data enrichment process for universities with NULL values
"""
import logging
from typing import Dict, List, Tuple, Optional
from supabase import Client
import time
from datetime import datetime

logger = logging.getLogger(__name__)


class AutoFillOrchestrator:
    """
    Orchestrates the automated filling of NULL university data
    """

    # Fields that can be auto-filled
    FILLABLE_FIELDS = [
        'city', 'state', 'website', 'logo_url', 'description',
        'university_type', 'location_type', 'total_students',
        'acceptance_rate', 'gpa_average',
        'sat_math_25th', 'sat_math_75th',
        'sat_ebrw_25th', 'sat_ebrw_75th',
        'act_composite_25th', 'act_composite_75th',
        'tuition_out_state', 'total_cost',
        'graduation_rate_4year'
    ]

    def __init__(self, db: Client, rate_limit_delay: float = 3.0):
        self.db = db
        self.rate_limit_delay = rate_limit_delay
        self.stats = {
            'total_processed': 0,
            'total_updated': 0,
            'fields_filled': {},
            'errors': 0,
            'start_time': None,
            'end_time': None
        }

    def analyze_null_values(self) -> Dict:
        """
        Analyze database to identify NULL values

        Returns:
            Dict with statistics about NULL values per field
        """
        logger.info("Analyzing NULL values in database...")

        # Get all universities
        response = self.db.table('universities').select('*').execute()
        universities = response.data

        if not universities:
            logger.warning("No universities found in database")
            return {}

        null_stats = {field: 0 for field in self.FILLABLE_FIELDS}
        total_universities = len(universities)

        for university in universities:
            for field in self.FILLABLE_FIELDS:
                if not university.get(field):
                    null_stats[field] += 1

        # Calculate percentages
        analysis = {}
        for field, null_count in null_stats.items():
            percentage = (null_count / total_universities) * 100
            analysis[field] = {
                'null_count': null_count,
                'percentage': round(percentage, 2),
                'priority': self._get_field_priority(field)
            }

        logger.info(f"Analysis complete: {total_universities} universities")
        return analysis

    def _get_field_priority(self, field: str) -> int:
        """
        Assign priority to fields (1=highest, 3=lowest)
        Critical fields for ML should be filled first
        """
        high_priority = [
            'acceptance_rate', 'gpa_average', 'graduation_rate_4year',
            'total_students', 'tuition_out_state', 'total_cost'
        ]
        medium_priority = [
            'city', 'state', 'location_type', 'university_type',
            'sat_math_25th', 'sat_math_75th', 'act_composite_25th', 'act_composite_75th'
        ]

        if field in high_priority:
            return 1
        elif field in medium_priority:
            return 2
        else:
            return 3

    def get_universities_to_enrich(self, limit: int = None, priority_fields: List[str] = None) -> List[Dict]:
        """
        Get list of universities that need enrichment

        Args:
            limit: Maximum number of universities to return
            priority_fields: Only consider universities with NULLs in these fields

        Returns:
            List of university dicts sorted by enrichment priority
        """
        logger.info(f"Finding universities to enrich (limit={limit})...")

        # Get all universities
        response = self.db.table('universities').select('*').execute()
        universities = response.data

        if not universities:
            return []

        # Score each university by number of missing critical fields
        scored_universities = []

        for university in universities:
            missing_count = 0
            missing_critical = 0

            for field in self.FILLABLE_FIELDS:
                if not university.get(field):
                    missing_count += 1
                    priority = self._get_field_priority(field)
                    if priority == 1:
                        missing_critical += 1

                    # If priority_fields specified, only count those
                    if priority_fields and field in priority_fields:
                        missing_critical += 1

            # Score: missing_critical * 100 + missing_total
            score = missing_critical * 100 + missing_count

            if score > 0:  # Has at least one missing field
                scored_universities.append((university, score, missing_count))

        # Sort by score (descending)
        scored_universities.sort(key=lambda x: x[1], reverse=True)

        # Apply limit
        if limit:
            scored_universities = scored_universities[:limit]

        result = [item[0] for item in scored_universities]
        logger.info(f"Found {len(result)} universities needing enrichment")

        return result

    def enrich_university(
        self,
        university: Dict,
        web_enricher,
        field_scrapers
    ) -> Tuple[Dict, int]:
        """
        Enrich a single university with missing data

        Args:
            university: University dict from database
            web_enricher: WebSearchEnricher instance
            field_scrapers: FieldSpecificScrapers instance

        Returns:
            Tuple of (enriched_data dict, fields_filled count)
        """
        logger.info(f"Enriching: {university['name']}")

        enriched_data = {}
        fields_filled = 0

        try:
            # Step 1: General web search (Wikipedia, DuckDuckGo, etc.)
            general_data = web_enricher.enrich_university(university)
            for field, value in general_data.items():
                if value and not university.get(field):
                    enriched_data[field] = value
                    fields_filled += 1

            # Add delay to respect rate limits
            time.sleep(self.rate_limit_delay)

            # Step 2: Field-specific targeted scraping for high-priority fields
            website = enriched_data.get('website') or university.get('website')

            # Acceptance rate (high priority)
            if not university.get('acceptance_rate') and 'acceptance_rate' not in enriched_data:
                rate = field_scrapers.find_acceptance_rate(university['name'], website)
                if rate:
                    enriched_data['acceptance_rate'] = rate
                    fields_filled += 1
                time.sleep(self.rate_limit_delay)

            # Tuition costs (high priority)
            if not university.get('tuition_out_state') and 'tuition_out_state' not in enriched_data:
                costs = field_scrapers.find_tuition_costs(university['name'], website)
                for field, value in costs.items():
                    if value and not university.get(field):
                        enriched_data[field] = value
                        fields_filled += 1
                time.sleep(self.rate_limit_delay)

            # Test scores (medium priority)
            if not university.get('sat_math_25th') and 'sat_math_25th' not in enriched_data:
                scores = field_scrapers.find_test_scores(university['name'], website)
                for field, value in scores.items():
                    if value and not university.get(field):
                        enriched_data[field] = value
                        fields_filled += 1
                time.sleep(self.rate_limit_delay)

            # Graduation rate (high priority)
            if not university.get('graduation_rate_4year') and 'graduation_rate_4year' not in enriched_data:
                rate = field_scrapers.find_graduation_rate(university['name'])
                if rate:
                    enriched_data['graduation_rate_4year'] = rate
                    fields_filled += 1
                time.sleep(self.rate_limit_delay)

            # Student count (high priority)
            if not university.get('total_students') and 'total_students' not in enriched_data:
                count = field_scrapers.find_student_count(university['name'], website)
                if count:
                    enriched_data['total_students'] = count
                    fields_filled += 1
                time.sleep(self.rate_limit_delay)

            # Location details (medium priority)
            if not university.get('city') or not university.get('state'):
                location = field_scrapers.find_location_details(university['name'])
                for field, value in location.items():
                    if value and not university.get(field):
                        enriched_data[field] = value
                        fields_filled += 1

            # University type (medium priority)
            if not university.get('university_type') and 'university_type' not in enriched_data:
                univ_type = field_scrapers.find_university_type(university['name'])
                if univ_type:
                    enriched_data['university_type'] = univ_type
                    fields_filled += 1

            # GPA average (high priority)
            if not university.get('gpa_average') and 'gpa_average' not in enriched_data:
                gpa = field_scrapers.find_gpa_average(university['name'])
                if gpa:
                    enriched_data['gpa_average'] = gpa
                    fields_filled += 1

            logger.info(f"✅ Filled {fields_filled} fields for {university['name']}")

        except Exception as e:
            logger.error(f"❌ Error enriching {university['name']}: {e}")
            self.stats['errors'] += 1

        return enriched_data, fields_filled

    def update_university(self, university_id: int, enriched_data: Dict) -> bool:
        """
        Update university in database with enriched data

        Args:
            university_id: University ID
            enriched_data: Dict of fields to update

        Returns:
            True if successful, False otherwise
        """
        if not enriched_data:
            return False

        try:
            # Add updated_at timestamp
            enriched_data['updated_at'] = datetime.utcnow().isoformat()

            # Update in Supabase
            self.db.table('universities').update(enriched_data).eq('id', university_id).execute()

            logger.debug(f"Updated university {university_id} in database")
            return True

        except Exception as e:
            logger.error(f"Failed to update university {university_id}: {e}")
            return False

    def run_enrichment(
        self,
        limit: int = None,
        priority_fields: List[str] = None,
        dry_run: bool = False
    ) -> Dict:
        """
        Run the complete enrichment process

        Args:
            limit: Maximum number of universities to process
            priority_fields: Only enrich specific fields
            dry_run: If True, don't update database (just show what would be done)

        Returns:
            Dict with statistics
        """
        from .web_search_enricher import WebSearchEnricher
        from .field_scrapers import FieldSpecificScrapers

        logger.info("=" * 80)
        logger.info("Starting Automated Data Enrichment")
        logger.info("=" * 80)

        self.stats['start_time'] = datetime.utcnow()

        # Initialize enrichers
        web_enricher = WebSearchEnricher(rate_limit_delay=self.rate_limit_delay)
        field_scrapers = FieldSpecificScrapers()

        # Get universities to enrich
        universities = self.get_universities_to_enrich(limit, priority_fields)

        if not universities:
            logger.info("No universities need enrichment!")
            return self.stats

        logger.info(f"Processing {len(universities)} universities...")
        if dry_run:
            logger.info("🔍 DRY RUN MODE - No database updates will be made")

        # Process each university
        for i, university in enumerate(universities, 1):
            logger.info("")
            logger.info(f"[{i}/{len(universities)}] Processing: {university['name']}")
            logger.info("-" * 80)

            # Enrich
            enriched_data, fields_filled = self.enrich_university(
                university, web_enricher, field_scrapers
            )

            # Update database (unless dry run)
            if enriched_data and not dry_run:
                success = self.update_university(university['id'], enriched_data)
                if success:
                    self.stats['total_updated'] += 1

            # Update stats
            self.stats['total_processed'] += 1

            for field in enriched_data.keys():
                if field not in self.stats['fields_filled']:
                    self.stats['fields_filled'][field] = 0
                self.stats['fields_filled'][field] += 1

            # Progress update
            if i % 10 == 0:
                logger.info("")
                logger.info(f"Progress: {i}/{len(universities)} processed")
                logger.info(f"Total fields filled: {sum(self.stats['fields_filled'].values())}")

        self.stats['end_time'] = datetime.utcnow()
        duration = (self.stats['end_time'] - self.stats['start_time']).total_seconds()

        # Final report
        logger.info("")
        logger.info("=" * 80)
        logger.info("Enrichment Complete!")
        logger.info("=" * 80)
        logger.info(f"Universities processed: {self.stats['total_processed']}")
        logger.info(f"Universities updated: {self.stats['total_updated']}")
        logger.info(f"Total fields filled: {sum(self.stats['fields_filled'].values())}")
        logger.info(f"Errors encountered: {self.stats['errors']}")
        logger.info(f"Duration: {duration:.1f} seconds ({duration/60:.1f} minutes)")
        logger.info("")
        logger.info("Fields filled breakdown:")
        for field, count in sorted(self.stats['fields_filled'].items(), key=lambda x: x[1], reverse=True):
            logger.info(f"  {field}: {count}")

        return self.stats
