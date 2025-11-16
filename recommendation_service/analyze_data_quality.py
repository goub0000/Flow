"""
Analyze Data Quality - Check NULL values in university database
"""

import logging
from app.database.supabase_client import get_supabase_client

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)


def analyze_data_quality():
    """Analyze data quality and identify fields with NULL values"""

    logger.info("Connecting to Supabase...")
    client = get_supabase_client()

    # Get total count
    total_result = client.client.table('universities').select('id', count='exact').execute()
    total_count = total_result.count

    logger.info(f"Total universities in database: {total_count}")
    logger.info("")

    # Analyze each field
    fields = [
        'name',
        'country',
        'state',
        'city',
        'website',
        'description',
        'phone',
        'email',
        'logo_url',
        'type',
        'student_count',
        'address'
    ]

    logger.info("=" * 80)
    logger.info("DATA QUALITY ANALYSIS")
    logger.info("=" * 80)
    logger.info("")

    quality_report = {}

    for field in fields:
        # Count non-null values
        result = client.client.table('universities').select(field, count='exact').not_.is_(field, 'null').execute()
        non_null_count = result.count
        null_count = total_count - non_null_count
        null_percentage = (null_count / total_count) * 100

        quality_report[field] = {
            'non_null': non_null_count,
            'null': null_count,
            'null_percentage': null_percentage
        }

        # Status indicator
        if null_percentage < 20:
            status = "✓ GOOD"
        elif null_percentage < 50:
            status = "⚠ MEDIUM"
        else:
            status = "✗ POOR"

        logger.info(f"{field:20} | {status:10} | {non_null_count:6}/{total_count:6} filled ({100-null_percentage:.1f}%) | {null_count:6} NULL ({null_percentage:.1f}%)")

    logger.info("")
    logger.info("=" * 80)

    # Identify priority fields for enrichment
    priority_fields = []
    for field, stats in quality_report.items():
        if stats['null_percentage'] > 50 and field not in ['name', 'country']:  # Skip required fields
            priority_fields.append((field, stats['null_percentage']))

    priority_fields.sort(key=lambda x: x[1], reverse=True)

    logger.info("PRIORITY FIELDS FOR ENRICHMENT (>50% NULL):")
    logger.info("-" * 80)
    for field, percentage in priority_fields:
        logger.info(f"  {field:20} | {percentage:.1f}% NULL")

    logger.info("")
    logger.info("=" * 80)

    # Sample universities with missing data
    logger.info("SAMPLE UNIVERSITIES WITH MISSING DATA:")
    logger.info("-" * 80)

    sample = client.client.table('universities').select('id, name, country, website, description, email, phone').is_('website', 'null').limit(10).execute()

    if sample.data:
        for uni in sample.data:
            logger.info(f"\nID: {uni['id']}")
            logger.info(f"  Name: {uni['name']}")
            logger.info(f"  Country: {uni['country']}")
            logger.info(f"  Website: {uni.get('website', 'NULL')}")
            logger.info(f"  Description: {'NULL' if not uni.get('description') else uni['description'][:50] + '...'}")
            logger.info(f"  Email: {uni.get('email', 'NULL')}")
            logger.info(f"  Phone: {uni.get('phone', 'NULL')}")

    logger.info("")
    logger.info("=" * 80)
    logger.info("Analysis complete!")


if __name__ == "__main__":
    analyze_data_quality()
