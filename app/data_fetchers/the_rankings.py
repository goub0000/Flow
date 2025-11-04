"""
THE World University Rankings CSV Importer
Imports university data from THE (Times Higher Education) Rankings CSV files

Data source: https://www.kaggle.com/datasets/raymondtoo/the-world-university-rankings-2016-2024
Or official: https://www.timeshighereducation.com/world-university-rankings

CSV Format (THE 2016-2025):
- university_name, country, rank, scores_overall, scores_teaching,
  scores_research, scores_citations, scores_industry_income,
  scores_international_outlook, etc.
"""
import csv
import logging
from typing import List, Dict, Any, Optional
import os

logger = logging.getLogger(__name__)


class THERankingsCSVImporter:
    """
    Imports university data from THE World University Rankings CSV files
    """

    # Country code mapping (ISO 3166-1 alpha-2)
    COUNTRY_CODES = {
        'United States of America': 'US',
        'United States': 'US',
        'USA': 'US',
        'United Kingdom': 'GB',
        'UK': 'GB',
        'Canada': 'CA',
        'Australia': 'AU',
        'Germany': 'DE',
        'France': 'FR',
        'Netherlands': 'NL',
        'Switzerland': 'CH',
        'Sweden': 'SE',
        'Denmark': 'DK',
        'Norway': 'NO',
        'Finland': 'FI',
        'Belgium': 'BE',
        'Austria': 'AT',
        'Italy': 'IT',
        'Spain': 'ES',
        'Portugal': 'PT',
        'Ireland': 'IE',
        'Japan': 'JP',
        'China': 'CN',
        'South Korea': 'KR',
        'Republic of Korea': 'KR',
        'Singapore': 'SG',
        'Hong Kong SAR': 'HK',
        'Hong Kong': 'HK',
        'Taiwan': 'TW',
        'India': 'IN',
        'Brazil': 'BR',
        'Mexico': 'MX',
        'Argentina': 'AR',
        'Chile': 'CL',
        'Colombia': 'CO',
        'New Zealand': 'NZ',
        'South Africa': 'ZA',
        'Russia': 'RU',
        'Russian Federation': 'RU',
        'Poland': 'PL',
        'Czech Republic': 'CZ',
        'Greece': 'GR',
        'Turkey': 'TR',
        'Israel': 'IL',
        'Malaysia': 'MY',
        'Thailand': 'TH',
        'Indonesia': 'ID',
        'Philippines': 'PH',
        'Pakistan': 'PK',
        'Egypt': 'EG',
        'Saudi Arabia': 'SA',
        'United Arab Emirates': 'AE',
        'Iran': 'IR',
    }

    @staticmethod
    def clean_rank(rank_str: str) -> Optional[int]:
        """
        Clean rank string (e.g., '1', '2', '101-125', '501-600', '601+', '=125')
        Returns the first/lower rank number
        """
        if not rank_str or rank_str in ['NR', 'Reporter', '-']:
            return None

        try:
            # Remove '=' prefix
            rank_str = rank_str.replace('=', '').strip()

            # Handle ranges (e.g., '101-125', '501-600')
            if '-' in rank_str or '–' in rank_str:  # Regular dash or en-dash
                separator = '-' if '-' in rank_str else '–'
                return int(rank_str.split(separator)[0])

            # Handle '601+' format
            if '+' in rank_str:
                return int(rank_str.replace('+', ''))

            return int(rank_str)
        except (ValueError, AttributeError):
            return None

    @staticmethod
    def clean_score(score_str: str) -> Optional[float]:
        """Clean score string to float"""
        if not score_str or score_str in ['N/A', 'NR', '-', '', 'n/a']:
            return None
        try:
            return float(score_str)
        except (ValueError, AttributeError):
            return None

    @staticmethod
    def get_country_code(country_name: str) -> str:
        """Get ISO country code from country name"""
        if not country_name:
            return 'XX'
        return THERankingsCSVImporter.COUNTRY_CODES.get(country_name.strip(), 'XX')

    def parse_csv(self, csv_file_path: str) -> List[Dict[str, Any]]:
        """
        Parse THE Rankings CSV file

        Args:
            csv_file_path: Path to CSV file

        Returns:
            List of university dictionaries
        """
        if not os.path.exists(csv_file_path):
            raise FileNotFoundError(f"CSV file not found: {csv_file_path}")

        universities = []

        # Try different encodings for international character support
        encodings = ['utf-8', 'latin-1', 'cp1252', 'iso-8859-1']

        for encoding in encodings:
            try:
                with open(csv_file_path, 'r', encoding=encoding) as csvfile:
                    # Try to detect delimiter
                    sample = csvfile.read(1024)
                    csvfile.seek(0)
                    delimiter = ',' if ',' in sample else ';'

                    reader = csv.DictReader(csvfile, delimiter=delimiter)

                    for row_num, row in enumerate(reader, start=1):
                        try:
                            university = self.normalize_the_data(row)
                            if university:
                                universities.append(university)
                        except Exception as e:
                            logger.warning(f"Error parsing row {row_num}: {e}")
                            continue

                logger.info(f"Successfully parsed {len(universities)} universities from CSV (encoding: {encoding})")
                return universities

            except UnicodeDecodeError:
                if encoding == encodings[-1]:  # Last encoding failed
                    logger.error(f"Error reading CSV file with all encodings: {encodings}")
                    raise
                else:
                    logger.debug(f"Encoding {encoding} failed, trying next...")
                    universities = []  # Reset for next attempt
                    continue
            except Exception as e:
                logger.error(f"Error reading CSV file: {e}")
                raise

    def normalize_the_data(self, row: Dict[str, str]) -> Optional[Dict[str, Any]]:
        """
        Normalize THE data to our database schema

        Args:
            row: CSV row dictionary

        Returns:
            Normalized university dictionary
        """
        # THE CSV columns may vary, try common column names
        university_name = (
            row.get('university_name') or
            row.get('name') or
            row.get('institution') or
            row.get('Institution Name') or
            row.get('University')
        )

        country_name = (
            row.get('country') or
            row.get('location') or
            row.get('Location') or
            row.get('Country')
        )

        if not university_name or not country_name:
            return None

        # Extract rank
        rank_str = (
            row.get('rank') or
            row.get('Rank') or
            row.get('world_rank') or
            row.get('World Rank')
        )
        global_rank = self.clean_rank(rank_str)

        # Extract scores
        overall_score = self.clean_score(
            row.get('scores_overall') or
            row.get('overall_score') or
            row.get('Overall Score')
        )

        # Get country code
        country_code = self.get_country_code(country_name.strip())

        normalized = {
            'name': university_name.strip(),
            'country': country_code,
            'description': f"{university_name} is a higher education institution in {country_name}.",

            # Rankings
            'global_rank': global_rank,
        }

        # Remove None values
        return {k: v for k, v in normalized.items() if v is not None}

    def import_from_csv(
        self,
        csv_file_path: str,
        limit: Optional[int] = None
    ) -> List[Dict[str, Any]]:
        """
        Import universities from THE CSV file

        Args:
            csv_file_path: Path to CSV file
            limit: Maximum number to import

        Returns:
            List of normalized university dictionaries
        """
        logger.info(f"Importing from CSV: {csv_file_path}")

        universities = self.parse_csv(csv_file_path)

        if limit:
            universities = universities[:limit]
            logger.info(f"Limited to first {limit} universities")

        return universities


if __name__ == "__main__":
    # Example usage
    logging.basicConfig(level=logging.INFO)

    importer = THERankingsCSVImporter()

    # Test with a sample file (if it exists)
    csv_path = "the_rankings_2025.csv"
    if os.path.exists(csv_path):
        universities = importer.import_from_csv(csv_path, limit=10)
        for uni in universities:
            print(f"{uni.get('global_rank', 'NR')}. {uni['name']} ({uni['country']})")
    else:
        print(f"CSV file not found: {csv_path}")
        print("Download from: https://www.kaggle.com/datasets/raymondtoo/the-world-university-rankings-2016-2024")
