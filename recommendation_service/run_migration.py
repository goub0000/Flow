"""
Database Migration Runner
Applies SQL migrations to Supabase database
"""

import logging
from pathlib import Path
from app.database.supabase_client import get_supabase_client

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)


def run_migration(migration_file: str):
    """
    Run a SQL migration file

    Args:
        migration_file: Path to .sql migration file
    """
    logger.info(f"Running migration: {migration_file}")

    # Read migration SQL
    migration_path = Path(migration_file)
    if not migration_path.exists():
        logger.error(f"Migration file not found: {migration_file}")
        return False

    with open(migration_path, 'r') as f:
        sql = f.read()

    # Get database client
    db_client = get_supabase_client()

    # Note: Supabase Python client doesn't support raw SQL execution directly
    # We need to use the PostgREST API or execute via psycopg2
    # For now, let's provide instructions for manual execution

    logger.info("=" * 80)
    logger.info("MIGRATION SQL")
    logger.info("=" * 80)
    logger.info("\nPlease execute the following SQL in your Supabase SQL Editor:")
    logger.info("\n" + sql)
    logger.info("\n" + "=" * 80)
    logger.info("\nOr run via psql:")
    logger.info(f"psql <your-connection-string> -f {migration_file}")
    logger.info("=" * 80)

    return True


def main():
    import argparse

    parser = argparse.ArgumentParser(description='Run database migrations')
    parser.add_argument('migration', type=str, help='Path to migration SQL file')

    args = parser.parse_args()

    success = run_migration(args.migration)
    if success:
        logger.info("Migration ready to execute!")
    else:
        logger.error("Migration failed!")


if __name__ == "__main__":
    # Auto-run the latest migration
    migration_file = "migrations/create_student_activities_table.sql"
    run_migration(migration_file)
