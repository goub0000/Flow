"""
Verify Phase 1 Database Migration
Checks if all tracking columns were added successfully
"""

import logging
from app.database.supabase_client import get_supabase_client

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)


def verify_migration():
    """Verify that Phase 1 columns exist"""
    logger.info("=" * 80)
    logger.info("PHASE 1 MIGRATION VERIFICATION")
    logger.info("=" * 80)

    db_client = get_supabase_client()
    logger.info("Connected to database\n")

    # Try to query the new columns
    try:
        result = db_client.client.table('universities').select(
            'id, name, data_sources, data_confidence, last_scraped_at, field_last_updated'
        ).limit(1).execute()

        logger.info("✓ All Phase 1 columns exist!")
        logger.info("\nNew columns added:")
        logger.info("  - data_sources (JSONB)")
        logger.info("  - data_confidence (JSONB)")
        logger.info("  - last_scraped_at (TIMESTAMP)")
        logger.info("  - field_last_updated (JSONB)")

        if result.data:
            logger.info(f"\nSample record: {result.data[0]['name']}")
            logger.info(f"  data_sources: {result.data[0].get('data_sources', {})}")
            logger.info(f"  data_confidence: {result.data[0].get('data_confidence', {})}")
            logger.info(f"  last_scraped_at: {result.data[0].get('last_scraped_at', 'NULL')}")

        logger.info("\n" + "=" * 80)
        logger.info("MIGRATION VERIFIED SUCCESSFULLY!")
        logger.info("=" * 80)
        logger.info("\nYou can now run:")
        logger.info("  python smart_update_runner.py --limit 10")
        logger.info("=" * 80)

        return True

    except Exception as e:
        logger.error(f"✗ Migration verification failed: {e}")
        logger.error("\nPlease ensure the migration SQL was executed in Supabase SQL Editor")
        return False


if __name__ == "__main__":
    verify_migration()
