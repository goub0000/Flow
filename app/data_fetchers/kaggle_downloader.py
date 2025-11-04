r"""
Kaggle Dataset Downloader
Automatically downloads datasets from Kaggle using the Kaggle API

Authentication:
    Option 1: Place kaggle.json in ~/.kaggle/ (or C:\Users\<username>\.kaggle\ on Windows)
    Option 2: Set environment variables KAGGLE_USERNAME and KAGGLE_KEY

Get your API credentials:
    1. Go to https://www.kaggle.com/account
    2. Scroll to "API" section
    3. Click "Create New API Token"
    4. Download kaggle.json file
"""
import os
import logging
import shutil
from pathlib import Path
from typing import Optional, Dict
from kaggle.api.kaggle_api_extended import KaggleApi

logger = logging.getLogger(__name__)


class KaggleDatasetDownloader:
    """
    Downloads datasets from Kaggle using official Kaggle API
    """

    # Known datasets for university data
    DATASETS = {
        'qs-2025': 'melissamonfared/qs-world-university-rankings-2025',
        'qs-2017-2022': 'padhmam/qs-world-university-rankings-2017-2022',
        'the-2016-2025': 'raymondtoo/the-world-university-rankings-2016-2024',
    }

    # Dataset patterns for searching latest versions
    DATASET_PATTERNS = {
        'qs': 'qs-world-university-rankings',
        'times': 'times-higher-education',
    }

    def __init__(self, download_dir: Optional[str] = None):
        """
        Initialize Kaggle downloader

        Args:
            download_dir: Directory to download files to (defaults to recommendation_service/data)

        Raises:
            OSError: If Kaggle authentication fails
        """
        # Set default download directory
        if download_dir is None:
            # Get the recommendation_service directory
            current_dir = Path(__file__).parent.parent.parent
            self.download_dir = current_dir / 'data'
        else:
            self.download_dir = Path(download_dir)

        # Create download directory if it doesn't exist
        self.download_dir.mkdir(parents=True, exist_ok=True)

        # Initialize Kaggle API
        self.api = KaggleApi()

        try:
            self.api.authenticate()
            logger.info("Successfully authenticated with Kaggle API")
        except Exception as e:
            error_msg = (
                "\n" + "="*80 + "\n"
                "ERROR: Kaggle authentication failed!\n"
                + "="*80 + "\n"
                "To fix this, you have two options:\n\n"
                "Option 1: Using kaggle.json file (Recommended)\n"
                "  1. Go to https://www.kaggle.com/account\n"
                "  2. Scroll to 'API' section\n"
                "  3. Click 'Create New API Token'\n"
                "  4. Download kaggle.json file\n"
                "  5. Place it at:\n"
                r"     - Windows: C:\Users\<YourUsername>\.kaggle\kaggle.json" + "\n"
                "     - Mac/Linux: ~/.kaggle/kaggle.json\n\n"
                "Option 2: Using environment variables\n"
                "  1. Get your username and API key from Kaggle\n"
                "  2. Add to .env file:\n"
                "     KAGGLE_USERNAME=your_username\n"
                "     KAGGLE_KEY=your_api_key\n"
                + "="*80 + "\n"
                f"Original error: {e}\n"
                + "="*80 + "\n"
            )
            logger.error(error_msg)
            raise OSError(error_msg)

    def download_dataset(
        self,
        dataset_name: str,
        unzip: bool = True,
        force: bool = False
    ) -> Path:
        """
        Download a dataset from Kaggle

        Args:
            dataset_name: Kaggle dataset name (e.g., 'user/dataset-name')
                         or shortcut name (e.g., 'qs-2025')
            unzip: Whether to unzip downloaded files
            force: Force download even if files already exist

        Returns:
            Path to downloaded/extracted directory

        Raises:
            Exception: If download fails
        """
        # Resolve dataset name from shortcuts
        if dataset_name in self.DATASETS:
            full_dataset_name = self.DATASETS[dataset_name]
            logger.info(f"Using dataset shortcut: {dataset_name} → {full_dataset_name}")
        else:
            full_dataset_name = dataset_name

        logger.info("=" * 80)
        logger.info(f"DOWNLOADING DATASET FROM KAGGLE")
        logger.info("=" * 80)
        logger.info(f"Dataset: {full_dataset_name}")
        logger.info(f"Download directory: {self.download_dir}")

        try:
            # Download dataset
            logger.info("Starting download...")
            self.api.dataset_download_files(
                full_dataset_name,
                path=str(self.download_dir),
                unzip=unzip,
                force=force,
                quiet=False
            )

            logger.info("Download completed successfully!")
            logger.info("=" * 80)

            return self.download_dir

        except Exception as e:
            logger.error(f"Failed to download dataset: {e}")
            raise

    def list_dataset_files(self, dataset_name: str) -> list:
        """
        List files in a Kaggle dataset without downloading

        Args:
            dataset_name: Kaggle dataset name or shortcut

        Returns:
            List of file names in the dataset
        """
        # Resolve dataset name
        if dataset_name in self.DATASETS:
            full_dataset_name = self.DATASETS[dataset_name]
        else:
            full_dataset_name = dataset_name

        try:
            files = self.api.dataset_list_files(full_dataset_name)
            return [f.name for f in files]
        except Exception as e:
            logger.error(f"Failed to list dataset files: {e}")
            return []

    def download_qs_rankings_2025(self, force: bool = False) -> Optional[Path]:
        """
        Download QS World University Rankings 2025 dataset

        Args:
            force: Force download even if already exists

        Returns:
            Path to downloaded CSV file, or None if not found
        """
        logger.info("Downloading QS World University Rankings 2025...")

        # Download dataset
        download_path = self.download_dataset('qs-2025', unzip=True, force=force)

        # Find the CSV file
        csv_files = list(download_path.glob('*.csv'))

        if csv_files:
            csv_file = csv_files[0]
            logger.info(f"Found CSV file: {csv_file.name}")
            return csv_file
        else:
            logger.warning("No CSV files found in downloaded dataset")
            # List what we got
            all_files = list(download_path.glob('*'))
            logger.info(f"Downloaded files: {[f.name for f in all_files]}")
            return None

    def download_the_rankings(self, force: bool = False) -> Optional[Path]:
        """
        Download THE World University Rankings 2016-2025 dataset

        Args:
            force: Force download even if already exists

        Returns:
            Path to downloaded CSV file, or None if not found
        """
        logger.info("Downloading THE World University Rankings...")

        # Download dataset
        download_path = self.download_dataset('the-2016-2025', unzip=True, force=force)

        # Find THE-specific CSV file
        # Look for files with "THE" in the name, excluding "QS" files
        csv_files = list(download_path.glob('*.csv'))

        # Filter for THE rankings files (exclude QS files)
        the_files = [f for f in csv_files if 'THE' in f.name and 'QS' not in f.name]

        if the_files:
            csv_file = the_files[0]
            logger.info(f"Found CSV file: {csv_file.name}")
            return csv_file
        elif csv_files:
            # Try to find any non-QS World University Rankings file
            non_qs_files = [f for f in csv_files if 'QS' not in f.name]
            if non_qs_files:
                csv_file = non_qs_files[0]
                logger.info(f"Found CSV file: {csv_file.name}")
                return csv_file
            # Last resort: use first CSV
            csv_file = csv_files[0]
            logger.info(f"Found CSV file: {csv_file.name}")
            return csv_file
        else:
            logger.warning("No CSV files found in downloaded dataset")
            # List what we got
            all_files = list(download_path.glob('*'))
            logger.info(f"Downloaded files: {[f.name for f in all_files]}")
            return None

    def get_downloaded_files(self, pattern: str = "*.csv") -> list:
        """
        Get list of downloaded files matching pattern

        Args:
            pattern: Glob pattern (e.g., '*.csv', '*.xlsx')

        Returns:
            List of matching file paths
        """
        return list(self.download_dir.glob(pattern))

    def cleanup_downloads(self):
        """Remove all downloaded files"""
        if self.download_dir.exists():
            shutil.rmtree(self.download_dir)
            self.download_dir.mkdir(parents=True, exist_ok=True)
            logger.info("Cleaned up download directory")

    def search_datasets(self, search_term: str, max_results: int = 20) -> list:
        """
        Search for datasets on Kaggle

        Args:
            search_term: Search query
            max_results: Maximum number of results to return

        Returns:
            List of dataset references
        """
        try:
            logger.info(f"Searching Kaggle for: {search_term}")
            datasets = self.api.dataset_list(search=search_term, max_size=max_results)
            return [dataset.ref for dataset in datasets]
        except Exception as e:
            logger.error(f"Failed to search datasets: {e}")
            return []

    def find_latest_qs_rankings(self, start_year: int = None) -> Optional[str]:
        """
        Find the latest QS World University Rankings dataset

        Args:
            start_year: Year to start searching from (defaults to current year + 1)

        Returns:
            Dataset reference for latest QS rankings, or None if not found
        """
        import datetime

        if start_year is None:
            # Start with next year (rankings are usually released for next year)
            start_year = datetime.datetime.now().year + 1

        logger.info("=" * 80)
        logger.info("SEARCHING FOR LATEST QS RANKINGS")
        logger.info("=" * 80)

        # Try years in descending order (2027, 2026, 2025, etc.)
        for year in range(start_year, start_year - 10, -1):
            logger.info(f"Checking for QS Rankings {year}...")

            # Search for datasets containing the year
            search_term = f"qs world university rankings {year}"
            datasets = self.search_datasets(search_term, max_results=10)

            # Look for dataset with year in the name
            for dataset_ref in datasets:
                if str(year) in dataset_ref.lower() and 'qs' in dataset_ref.lower():
                    logger.info(f"✓ Found QS Rankings {year}: {dataset_ref}")
                    logger.info("=" * 80)
                    return dataset_ref

            logger.info(f"  QS Rankings {year} not found")

        logger.warning("Could not find any recent QS Rankings datasets")
        logger.info("=" * 80)
        return None

    def download_latest_qs_rankings(self, unzip: bool = True, force: bool = False) -> Optional[Path]:
        """
        Automatically find and download the latest QS Rankings

        Args:
            unzip: Whether to unzip downloaded files
            force: Force download even if files already exist

        Returns:
            Path to downloaded CSV file, or None if not found
        """
        # First, try to find the latest dataset
        latest_dataset = self.find_latest_qs_rankings()

        if latest_dataset:
            logger.info(f"Downloading latest QS Rankings: {latest_dataset}")
            download_path = self.download_dataset(latest_dataset, unzip=unzip, force=force)

            # Find the CSV file
            csv_files = list(download_path.glob('*.csv'))
            if csv_files:
                csv_file = csv_files[0]
                logger.info(f"Found CSV file: {csv_file.name}")
                return csv_file
            else:
                logger.warning("No CSV files found in downloaded dataset")
                return None
        else:
            # Fallback to known dataset
            logger.info("Falling back to known QS Rankings 2025 dataset")
            return self.download_qs_rankings_2025(force=force)


def main():
    """Example usage"""
    logging.basicConfig(level=logging.INFO)

    downloader = KaggleDatasetDownloader()

    # List available files in QS 2025 dataset
    print("\nListing files in QS Rankings 2025 dataset:")
    files = downloader.list_dataset_files('qs-2025')
    for f in files:
        print(f"  - {f}")

    # Download QS Rankings 2025
    print("\nDownloading QS Rankings 2025...")
    csv_file = downloader.download_qs_rankings_2025()

    if csv_file:
        print(f"\n✓ Successfully downloaded: {csv_file}")
        print(f"  Size: {csv_file.stat().st_size / 1024:.2f} KB")
        print(f"\nYou can now import with:")
        print(f"  python import_universities.py --csv \"{csv_file}\"")
    else:
        print("\n✗ Failed to find CSV file")


if __name__ == "__main__":
    main()
