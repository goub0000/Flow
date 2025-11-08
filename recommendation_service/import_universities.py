#!/usr/bin/env python
"""
CLI Tool for Importing Universities
Fetches real-time data from College Scorecard and other sources

Usage:
    python import_universities.py --source collegecard --limit 100
    python import_universities.py --source collegecard --state CA --limit 50
    python import_universities.py --source collegecard --all
"""
import argparse
import logging
import sys
from app.database.config import SessionLocal
from app.data_fetchers.college_scorecard import CollegeScorecardFetcher
from app.data_fetchers.qs_rankings import QSRankingsCSVImporter
from app.data_fetchers.data_normalizer import UniversityDataNormalizer
from app.data_fetchers.kaggle_downloader import KaggleDatasetDownloader

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)


def import_from_college_scorecard(
    limit: int = None,
    state: str = None,
    update_existing: bool = True
):
    """
    Import universities from College Scorecard API

    Args:
        limit: Maximum number of universities to import
        state: Filter by state code (e.g., 'CA', 'NY')
        update_existing: Update existing universities
    """
    logger.info("=" * 80)
    logger.info("IMPORTING UNIVERSITIES FROM COLLEGE SCORECARD")
    logger.info("=" * 80)

    # Initialize fetcher and normalizer
    fetcher = CollegeScorecardFetcher()
    normalizer = UniversityDataNormalizer()
    db = SessionLocal()

    try:
        # Fetch universities
        logger.info(f"Fetching universities (limit: {limit or 'all'}, state: {state or 'all'})")

        if state:
            raw_universities = fetcher.fetch_by_state(state, max_results=limit)
        else:
            filters = None
            raw_universities = fetcher.fetch_all_universities(
                max_results=limit,
                filters=filters
            )

        logger.info(f"Fetched {len(raw_universities)} universities from API")

        if not raw_universities:
            logger.warning("No universities found")
            return

        # Normalize data
        logger.info("Normalizing data...")
        normalized_universities = []
        for raw_uni in raw_universities:
            normalized = fetcher.normalize_university_data(raw_uni)
            if normalized:
                normalized_universities.append(normalized)

        logger.info(f"Normalized {len(normalized_universities)} universities")

        # Save to database
        logger.info("Saving to database...")
        stats = normalizer.batch_save_universities(
            db,
            normalized_universities,
            update_existing=update_existing
        )

        # Print statistics
        from app.models.university import University

        logger.info("=" * 80)
        logger.info("IMPORT STATISTICS")
        logger.info("=" * 80)
        logger.info(f"Added: {stats['added']}")
        logger.info(f"Updated: {stats['updated']}")
        logger.info(f"Skipped: {stats['skipped']}")
        logger.info(f"Failed: {stats['failed']}")
        logger.info(f"Total in database: {db.query(University).count()}")
        logger.info("=" * 80)

    except Exception as e:
        logger.error(f"Error during import: {e}", exc_info=True)
        db.rollback()
    finally:
        db.close()


def import_from_csv(
    csv_file_path: str,
    limit: int = None,
    update_existing: bool = True
):
    """
    Import universities from CSV file (e.g., QS Rankings)

    Args:
        csv_file_path: Path to CSV file
        limit: Maximum number of universities to import
        update_existing: Update existing universities
    """
    logger.info("=" * 80)
    logger.info("IMPORTING UNIVERSITIES FROM CSV")
    logger.info("=" * 80)
    logger.info(f"CSV File: {csv_file_path}")

    # Initialize importer and normalizer
    importer = QSRankingsCSVImporter()
    normalizer = UniversityDataNormalizer()
    db = SessionLocal()

    try:
        # Import from CSV
        logger.info(f"Reading CSV file...")
        raw_universities = importer.import_from_csv(csv_file_path, limit=limit)

        logger.info(f"Loaded {len(raw_universities)} universities from CSV")

        if not raw_universities:
            logger.warning("No universities found in CSV")
            return

        # Save to database
        logger.info("Saving to database...")
        stats = normalizer.batch_save_universities(
            db,
            raw_universities,
            update_existing=update_existing
        )

        # Print statistics
        from app.models.university import University

        logger.info("=" * 80)
        logger.info("IMPORT STATISTICS")
        logger.info("=" * 80)
        logger.info(f"Added: {stats['added']}")
        logger.info(f"Updated: {stats['updated']}")
        logger.info(f"Skipped: {stats['skipped']}")
        logger.info(f"Failed: {stats['failed']}")
        logger.info(f"Total in database: {db.query(University).count()}")
        logger.info("=" * 80)

    except FileNotFoundError as e:
        logger.error(f"CSV file not found: {e}")
        logger.error("Please ensure the CSV file exists at the specified path")
    except Exception as e:
        logger.error(f"Error during import: {e}", exc_info=True)
        db.rollback()
    finally:
        db.close()


def import_specific_universities(names: list):
    """
    Import specific universities by name

    Args:
        names: List of university names to search and import
    """
    logger.info("=" * 80)
    logger.info("IMPORTING SPECIFIC UNIVERSITIES")
    logger.info("=" * 80)

    fetcher = CollegeScorecardFetcher()
    normalizer = UniversityDataNormalizer()
    db = SessionLocal()

    try:
        for name in names:
            logger.info(f"Searching for: {name}")
            results = fetcher.search_by_name(name)

            if results:
                logger.info(f"Found {len(results)} matches")
                for result in results[:5]:  # Limit to top 5 matches
                    normalized = fetcher.normalize_university_data(result)
                    if normalized:
                        logger.info(f"  - {normalized['name']}")
                        normalizer.save_to_database(db, normalized)

                db.commit()
            else:
                logger.warning(f"No matches found for: {name}")

    except Exception as e:
        logger.error(f"Error during import: {e}", exc_info=True)
        db.rollback()
    finally:
        db.close()


def import_from_kaggle(
    dataset: str = 'qs-2025',
    limit: int = None,
    update_existing: bool = True,
    force_download: bool = False,
    auto_latest: bool = False
):
    """
    Download and import universities from Kaggle dataset

    Args:
        dataset: Dataset shortcut ('qs-2025', 'times-higher-ed', 'latest') or full Kaggle dataset name
        limit: Maximum number of universities to import
        update_existing: Update existing universities
        force_download: Force download even if files already exist
        auto_latest: Automatically find and download latest QS rankings
    """
    logger.info("=" * 80)
    logger.info("DOWNLOADING AND IMPORTING FROM KAGGLE")
    logger.info("=" * 80)

    try:
        # Initialize Kaggle downloader
        downloader = KaggleDatasetDownloader()

        # Download dataset
        if dataset == 'latest' or auto_latest:
            logger.info("Searching for latest QS Rankings...")
            csv_file = downloader.download_latest_qs_rankings(unzip=True, force=force_download)
        elif dataset == 'qs-2025':
            csv_file = downloader.download_qs_rankings_2025(force=force_download)
        else:
            # Generic download - will need to find CSV file
            download_path = downloader.download_dataset(dataset, unzip=True, force=force_download)
            csv_files = downloader.get_downloaded_files('*.csv')
            csv_file = csv_files[0] if csv_files else None

        if not csv_file:
            logger.error("No CSV file found after download")
            logger.error("Please check the dataset or download manually")
            return

        # Import from downloaded CSV
        logger.info(f"Importing from: {csv_file}")
        import_from_csv(
            csv_file_path=str(csv_file),
            limit=limit,
            update_existing=update_existing
        )

    except OSError as e:
        # Kaggle authentication error - already has detailed error message
        logger.error("Kaggle authentication failed. See error message above for setup instructions.")
    except Exception as e:
        logger.error(f"Error during Kaggle import: {e}", exc_info=True)


def show_stats():
    """Show database statistics"""
    from app.models.university import University
    from sqlalchemy import func

    db = SessionLocal()
    try:
        total = db.query(University).count()
        by_state = db.query(University.state, func.count(University.id)).group_by(University.state).all()
        by_type = db.query(University.university_type, func.count(University.id)).group_by(University.university_type).all()

        logger.info("=" * 80)
        logger.info("DATABASE STATISTICS")
        logger.info("=" * 80)
        logger.info(f"Total Universities: {total}")
        logger.info("")
        logger.info("By State:")
        for state, count in sorted(by_state, key=lambda x: x[1], reverse=True)[:10]:
            logger.info(f"  {state}: {count}")
        logger.info("")
        logger.info("By Type:")
        for uni_type, count in by_type:
            logger.info(f"  {uni_type}: {count}")
        logger.info("=" * 80)

    finally:
        db.close()


def main():
    parser = argparse.ArgumentParser(
        description="Import universities from various sources",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Import 100 universities from College Scorecard (US)
  python import_universities.py --source collegecard --limit 100

  # Import all universities from California
  python import_universities.py --source collegecard --state CA

  # Auto-download LATEST QS Rankings (auto-detects 2026, 2027, etc.)
  python import_universities.py --kaggle latest

  # Auto-download and import QS Rankings 2025 from Kaggle
  python import_universities.py --kaggle qs-2025

  # Auto-download and import limited number from Kaggle
  python import_universities.py --kaggle qs-2025 --limit 500

  # Import from manually downloaded CSV (Global - includes Europe)
  python import_universities.py --csv qs_rankings_2025.csv

  # Import specific universities by name
  python import_universities.py --names "Stanford University" "MIT"

  # Import all universities from College Scorecard (this will take a while!)
  python import_universities.py --source collegecard --all

  # Show database statistics
  python import_universities.py --stats
        """
    )

    parser.add_argument(
        '--source',
        choices=['collegecard'],
        default='collegecard',
        help='Data source to import from'
    )

    parser.add_argument(
        '--limit',
        type=int,
        help='Maximum number of universities to import'
    )

    parser.add_argument(
        '--state',
        type=str,
        help='Filter by US state code (e.g., CA, NY)'
    )

    parser.add_argument(
        '--all',
        action='store_true',
        help='Import all available universities (may take a long time)'
    )

    parser.add_argument(
        '--names',
        nargs='+',
        help='Import specific universities by name'
    )

    parser.add_argument(
        '--no-update',
        action='store_true',
        help='Skip updating existing universities'
    )

    parser.add_argument(
        '--stats',
        action='store_true',
        help='Show database statistics'
    )

    parser.add_argument(
        '--csv',
        type=str,
        help='Import from CSV file (e.g., QS Rankings, ETER data)'
    )

    parser.add_argument(
        '--kaggle',
        type=str,
        metavar='DATASET',
        help='Auto-download and import from Kaggle dataset (e.g., latest, qs-2025, times-higher-ed)'
    )

    parser.add_argument(
        '--force-download',
        action='store_true',
        help='Force download from Kaggle even if files already exist (only with --kaggle)'
    )

    args = parser.parse_args()

    # Show stats
    if args.stats:
        show_stats()
        return

    # Import from CSV
    if args.csv:
        import_from_csv(
            csv_file_path=args.csv,
            limit=args.limit,
            update_existing=not args.no_update
        )
        return

    # Import from Kaggle
    if args.kaggle:
        import_from_kaggle(
            dataset=args.kaggle,
            limit=args.limit,
            update_existing=not args.no_update,
            force_download=args.force_download
        )
        return

    # Import specific universities
    if args.names:
        import_specific_universities(args.names)
        return

    # Set limit
    limit = None if args.all else args.limit

    if limit is None and not args.all:
        logger.warning("No limit specified. Use --limit <number> or --all")
        logger.warning("Defaulting to 100 universities")
        limit = 100

    # Import from source
    if args.source == 'collegecard':
        import_from_college_scorecard(
            limit=limit,
            state=args.state,
            update_existing=not args.no_update
        )


if __name__ == "__main__":
    main()
