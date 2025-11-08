"""
Automated Data Enrichment Script
Searches the web and automatically fills NULL values in university database

Usage:
    python auto_fill_missing_data.py --analyze                    # Show NULL statistics
    python auto_fill_missing_data.py --dry-run --limit 10        # Test on 10 universities
    python auto_fill_missing_data.py --limit 50                   # Fill 50 universities
    python auto_fill_missing_data.py --all                        # Fill all universities
"""
import os
import sys
import logging
import argparse
from pathlib import Path
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

# Add app to path
sys.path.insert(0, str(Path(__file__).parent))

from app.database.config import get_supabase
from app.enrichment.auto_fill_orchestrator import AutoFillOrchestrator

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.StreamHandler(),
        logging.FileHandler('auto_fill.log')
    ]
)
logger = logging.getLogger(__name__)


def analyze_null_values(orchestrator):
    """Analyze and display NULL value statistics"""
    logger.info("=" * 80)
    logger.info("NULL Value Analysis")
    logger.info("=" * 80)

    analysis = orchestrator.analyze_null_values()

    if not analysis:
        logger.info("No data found to analyze")
        return

    # Sort by null count (descending)
    sorted_fields = sorted(analysis.items(), key=lambda x: x[1]['null_count'], reverse=True)

    logger.info("")
    logger.info(f"{'Field':<30} {'NULL Count':<12} {'Percentage':<12} {'Priority':<10}")
    logger.info("-" * 80)

    for field, stats in sorted_fields:
        priority_label = {1: 'HIGH', 2: 'MEDIUM', 3: 'LOW'}[stats['priority']]
        logger.info(
            f"{field:<30} {stats['null_count']:<12} {stats['percentage']:<11.1f}% {priority_label:<10}"
        )

    # Summary
    total_nulls = sum(s['null_count'] for s in analysis.values())
    high_priority_nulls = sum(s['null_count'] for s in analysis.values() if s['priority'] == 1)

    logger.info("")
    logger.info("=" * 80)
    logger.info(f"Total NULL values: {total_nulls}")
    logger.info(f"High priority NULL values: {high_priority_nulls}")
    logger.info("=" * 80)

    # Recommendations
    logger.info("")
    logger.info("📋 Recommendations:")
    if high_priority_nulls > 1000:
        logger.info("  • High number of NULL values in critical fields")
        logger.info("  • Recommend starting with high-priority fields")
        logger.info("  • Run: python auto_fill_missing_data.py --limit 100 --priority-fields")
    elif total_nulls > 0:
        logger.info("  • Moderate NULL values found")
        logger.info("  • Run: python auto_fill_missing_data.py --limit 50")
    else:
        logger.info("  • Database is complete! Ready for ML training")
        logger.info("  • Run: python train_ml_models.py")


def main():
    parser = argparse.ArgumentParser(
        description="Automatically fill NULL values in university database by searching the web",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Analyze NULL values
  python auto_fill_missing_data.py --analyze

  # Test on 10 universities (no updates)
  python auto_fill_missing_data.py --dry-run --limit 10

  # Fill 50 universities
  python auto_fill_missing_data.py --limit 50

  # Fill all high-priority fields only
  python auto_fill_missing_data.py --priority-high --limit 100

  # Fill all universities (will take hours!)
  python auto_fill_missing_data.py --all

Priority Fields (filled first):
  HIGH: acceptance_rate, gpa_average, graduation_rate_4year, total_students, costs
  MEDIUM: location, test_scores, university_type
  LOW: website, logo, description
        """
    )

    parser.add_argument(
        '--analyze',
        action='store_true',
        help='Analyze and display NULL value statistics (no updates)'
    )

    parser.add_argument(
        '--limit',
        type=int,
        default=None,
        help='Maximum number of universities to process'
    )

    parser.add_argument(
        '--all',
        action='store_true',
        help='Process ALL universities (may take hours!)'
    )

    parser.add_argument(
        '--dry-run',
        action='store_true',
        help='Run without updating database (test mode)'
    )

    parser.add_argument(
        '--priority-high',
        action='store_true',
        help='Only fill high-priority fields (acceptance_rate, costs, etc.)'
    )

    parser.add_argument(
        '--rate-limit',
        type=float,
        default=3.0,
        help='Delay in seconds between web requests (default: 3.0)'
    )

    args = parser.parse_args()

    # Validate arguments
    if args.all and args.limit:
        parser.error("Cannot use --all and --limit together")

    if not any([args.analyze, args.limit, args.all]):
        parser.error("Must specify --analyze, --limit, or --all")

    try:
        # Connect to database
        logger.info("Connecting to Supabase...")
        db = get_supabase()
        logger.info("✅ Connected to Supabase")

        # Initialize orchestrator
        orchestrator = AutoFillOrchestrator(db, rate_limit_delay=args.rate_limit)

        # Run analysis mode
        if args.analyze:
            analyze_null_values(orchestrator)
            return

        # Determine priority fields
        priority_fields = None
        if args.priority_high:
            priority_fields = [
                'acceptance_rate', 'gpa_average', 'graduation_rate_4year',
                'total_students', 'tuition_out_state', 'total_cost'
            ]
            logger.info(f"Focusing on HIGH priority fields: {', '.join(priority_fields)}")

        # Determine limit
        limit = None if args.all else args.limit

        if args.all:
            logger.warning("⚠️  Processing ALL universities - this may take several hours!")
            response = input("Are you sure you want to continue? (yes/no): ")
            if response.lower() != 'yes':
                logger.info("Operation cancelled")
                return

        # Run enrichment
        logger.info("")
        stats = orchestrator.run_enrichment(
            limit=limit,
            priority_fields=priority_fields,
            dry_run=args.dry_run
        )

        # Save final report
        report_file = f"enrichment_report_{stats['start_time'].strftime('%Y%m%d_%H%M%S')}.txt"
        with open(report_file, 'w') as f:
            f.write("=" * 80 + "\n")
            f.write("Data Enrichment Report\n")
            f.write("=" * 80 + "\n")
            f.write(f"Start Time: {stats['start_time']}\n")
            f.write(f"End Time: {stats['end_time']}\n")
            f.write(f"Universities Processed: {stats['total_processed']}\n")
            f.write(f"Universities Updated: {stats['total_updated']}\n")
            f.write(f"Total Fields Filled: {sum(stats['fields_filled'].values())}\n")
            f.write(f"Errors: {stats['errors']}\n")
            f.write("\nFields Filled:\n")
            for field, count in sorted(stats['fields_filled'].items(), key=lambda x: x[1], reverse=True):
                f.write(f"  {field}: {count}\n")

        logger.info(f"📄 Report saved to: {report_file}")

        # Next steps
        logger.info("")
        logger.info("=" * 80)
        logger.info("Next Steps:")
        logger.info("=" * 80)

        if args.dry_run:
            logger.info("  • Dry run complete! Review the results above")
            logger.info("  • To actually update the database, run without --dry-run")
        else:
            logger.info("  • Database updated successfully!")
            logger.info("  • Run --analyze again to see remaining NULL values")
            logger.info("  • When data quality is good, train ML models:")
            logger.info("    python train_ml_models.py")

    except KeyboardInterrupt:
        logger.info("")
        logger.info("Operation cancelled by user")
        sys.exit(1)
    except Exception as e:
        logger.error(f"❌ Fatal error: {e}", exc_info=True)
        sys.exit(1)


if __name__ == "__main__":
    main()
