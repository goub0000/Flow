"""
Program Enrichment Script
Enriches institutional programs with additional data from various sources
"""

import os
import argparse
import logging
from datetime import datetime
from dotenv import load_dotenv
from app.database.config import get_supabase
from app.services.program_enricher import ProgramEnricher

# Load environment variables
load_dotenv()

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('program_enrichment.log'),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)


def analyze_programs():
    """Analyze program data quality"""
    db = get_supabase()

    logger.info("Analyzing program data quality...")

    try:
        # Get all programs
        result = db.table('programs').select('*').execute()
        programs = result.data

        if not programs:
            logger.warning("No programs found in database")
            return

        total_programs = len(programs)

        # Count NULL/missing values
        fields_to_check = [
            'description',
            'requirements',
            'application_deadline',
            'start_date',
            'fee'
        ]

        null_counts = {field: 0 for field in fields_to_check}

        for program in programs:
            for field in fields_to_check:
                if not program.get(field):
                    null_counts[field] += 1

        # Print analysis
        print("\n" + "=" * 80)
        print("PROGRAM DATA QUALITY ANALYSIS")
        print("=" * 80)
        print(f"Total Programs: {total_programs}\n")

        print(f"{'Field':<30} {'NULL Count':<15} {'Percentage':<15}")
        print("-" * 80)

        for field in fields_to_check:
            count = null_counts[field]
            percentage = (count / total_programs * 100) if total_programs > 0 else 0
            print(f"{field:<30} {count:<15} {percentage:.1f}%")

        print("\n" + "=" * 80)

        # Recommendations
        high_null_fields = [f for f, c in null_counts.items() if (c / total_programs * 100) > 50]
        if high_null_fields:
            print("\nRecommendations:")
            print(f"  • Fields with >50% NULL values: {', '.join(high_null_fields)}")
            print(f"  • Run: python enrich_programs.py --limit 10 --dry-run")
            print(f"  • Then: python enrich_programs.py --limit 50")
        else:
            print("\nData quality looks good!")

    except Exception as e:
        logger.error(f"Error analyzing programs: {e}")


def enrich_programs(limit: int = None, dry_run: bool = False, institution_id: str = None):
    """
    Enrich programs with missing data

    Args:
        limit: Maximum number of programs to process
        dry_run: If True, don't update database
        institution_id: Optional institution ID to filter programs
    """
    db = get_supabase()
    enricher = ProgramEnricher(rate_limit_delay=2.0)

    logger.info(f"Starting program enrichment (dry_run={dry_run})...")

    try:
        # Query programs that need enrichment
        query = db.table('programs').select('*')

        if institution_id:
            query = query.eq('institution_id', institution_id)

        # Filter for programs with missing data
        # Note: Supabase doesn't support complex OR queries easily, so we get all and filter locally

        if limit:
            query = query.limit(limit)

        result = query.execute()
        programs = result.data

        if not programs:
            logger.warning("No programs found to enrich")
            return

        logger.info(f"Found {len(programs)} programs to process")

        # Get institution websites for context
        institution_websites = {}
        if programs:
            institution_ids = list(set(p['institution_id'] for p in programs))
            for inst_id in institution_ids:
                try:
                    uni_result = db.table('universities').select('website').eq('id', inst_id).execute()
                    if uni_result.data:
                        institution_websites[inst_id] = uni_result.data[0].get('website')
                except:
                    pass

        # Enrich each program
        enriched_count = 0
        for i, program in enumerate(programs, 1):
            logger.info(f"Processing program {i}/{len(programs)}: {program['name']}")

            institution_website = institution_websites.get(program['institution_id'])

            enriched_data = enricher.enrich_program(program, institution_website)

            if enriched_data:
                if dry_run:
                    logger.info(f"  [DRY RUN] Would update with: {list(enriched_data.keys())}")
                else:
                    try:
                        # Update program in database
                        update_result = db.table('programs').update(enriched_data).eq('id', program['id']).execute()

                        if update_result.data:
                            logger.info(f"  ✓ Updated program: {list(enriched_data.keys())}")

                            # Log enrichment activity
                            log_data = {
                                'program_id': program['id'],
                                'enrichment_type': 'automated_enrichment',
                                'data_source': 'program_enricher',
                                'fields_updated': list(enriched_data.keys()),
                                'success': True
                            }
                            db.table('program_enrichment_logs').insert(log_data).execute()

                            enriched_count += 1
                        else:
                            logger.warning(f"  ✗ Failed to update program")

                    except Exception as e:
                        logger.error(f"  ✗ Error updating program: {e}")

                        # Log failure
                        log_data = {
                            'program_id': program['id'],
                            'enrichment_type': 'automated_enrichment',
                            'data_source': 'program_enricher',
                            'fields_updated': [],
                            'success': False,
                            'error_message': str(e)
                        }
                        db.table('program_enrichment_logs').insert(log_data).execute()
            else:
                logger.info(f"  ○ No enrichment data found")

        # Print summary
        print("\n" + "=" * 80)
        print("ENRICHMENT SUMMARY")
        print("=" * 80)
        print(f"Programs processed: {len(programs)}")
        if not dry_run:
            print(f"Programs enriched: {enriched_count}")
        print("\nEnricher Statistics:")
        for key, value in enricher.get_stats().items():
            print(f"  {key}: {value}")
        print("=" * 80)

    except Exception as e:
        logger.error(f"Error during enrichment: {e}")


def main():
    parser = argparse.ArgumentParser(description='Program Data Enrichment Tool')

    parser.add_argument(
        '--analyze',
        action='store_true',
        help='Analyze program data quality without enriching'
    )

    parser.add_argument(
        '--limit',
        type=int,
        help='Maximum number of programs to process'
    )

    parser.add_argument(
        '--dry-run',
        action='store_true',
        help='Test mode - show what would be updated without actually updating'
    )

    parser.add_argument(
        '--institution-id',
        type=str,
        help='Filter by institution ID'
    )

    args = parser.parse_args()

    if args.analyze:
        analyze_programs()
    else:
        enrich_programs(
            limit=args.limit,
            dry_run=args.dry_run,
            institution_id=args.institution_id
        )


if __name__ == "__main__":
    main()
