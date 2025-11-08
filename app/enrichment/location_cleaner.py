"""
Location Data Cleaner - Fixes country codes and state values
Converts ISO country codes to full names and cleans state data
"""
import logging
from typing import Dict, Optional, List
from supabase import Client

logger = logging.getLogger(__name__)


class LocationCleaner:
    """
    Cleans and normalizes country and state data in universities table
    """

    # ISO 3166-1 alpha-2 country codes to full names
    COUNTRY_CODE_MAP = {
        'US': 'United States',
        'GB': 'United Kingdom',
        'DE': 'Germany',
        'KR': 'South Korea',
        'IT': 'Italy',
        'RU': 'Russia',
        'ES': 'Spain',
        'MY': 'Malaysia',
        'FR': 'France',
        'IN': 'India',
        'CA': 'Canada',
        'AU': 'Australia',
        'JP': 'Japan',
        'TW': 'Taiwan',
        'AE': 'United Arab Emirates',
        'FI': 'Finland',
        'AT': 'Austria',
        'TR': 'Turkey',
        'GH': 'Ghana',
        'CH': 'Switzerland',
        'NL': 'Netherlands',
        'PT': 'Portugal',
        'BE': 'Belgium',
        'SE': 'Sweden',
        'PE': 'Peru',
        'NZ': 'New Zealand',
        'SA': 'Saudi Arabia',
        'ID': 'Indonesia',
        'CN': 'China',
        'SG': 'Singapore',
        'HK': 'Hong Kong',
        'DK': 'Denmark',
        'NO': 'Norway',
        'PL': 'Poland',
        'BR': 'Brazil',
        'MX': 'Mexico',
        'AR': 'Argentina',
        'CL': 'Chile',
        'CO': 'Colombia',
        'ZA': 'South Africa',
        'EG': 'Egypt',
        'NG': 'Nigeria',
        'KE': 'Kenya',
        'TH': 'Thailand',
        'VN': 'Vietnam',
        'PH': 'Philippines',
        'PK': 'Pakistan',
        'BD': 'Bangladesh',
        'IL': 'Israel',
        'IR': 'Iran',
        'IQ': 'Iraq',
        'JO': 'Jordan',
        'LB': 'Lebanon',
        'CZ': 'Czech Republic',
        'HU': 'Hungary',
        'RO': 'Romania',
        'GR': 'Greece',
        'IE': 'Ireland',
        'XX': None,  # Placeholder for unknown - will be set to NULL
    }

    # US state codes to full names
    US_STATE_MAP = {
        'AL': 'Alabama', 'AK': 'Alaska', 'AZ': 'Arizona', 'AR': 'Arkansas',
        'CA': 'California', 'CO': 'Colorado', 'CT': 'Connecticut', 'DE': 'Delaware',
        'FL': 'Florida', 'GA': 'Georgia', 'HI': 'Hawaii', 'ID': 'Idaho',
        'IL': 'Illinois', 'IN': 'Indiana', 'IA': 'Iowa', 'KS': 'Kansas',
        'KY': 'Kentucky', 'LA': 'Louisiana', 'ME': 'Maine', 'MD': 'Maryland',
        'MA': 'Massachusetts', 'MI': 'Michigan', 'MN': 'Minnesota', 'MS': 'Mississippi',
        'MO': 'Missouri', 'MT': 'Montana', 'NE': 'Nebraska', 'NV': 'Nevada',
        'NH': 'New Hampshire', 'NJ': 'New Jersey', 'NM': 'New Mexico', 'NY': 'New York',
        'NC': 'North Carolina', 'ND': 'North Dakota', 'OH': 'Ohio', 'OK': 'Oklahoma',
        'OR': 'Oregon', 'PA': 'Pennsylvania', 'RI': 'Rhode Island', 'SC': 'South Carolina',
        'SD': 'South Dakota', 'TN': 'Tennessee', 'TX': 'Texas', 'UT': 'Utah',
        'VT': 'Vermont', 'VA': 'Virginia', 'WA': 'Washington', 'WV': 'West Virginia',
        'WI': 'Wisconsin', 'WY': 'Wyoming', 'DC': 'District of Columbia',
        'PR': 'Puerto Rico', 'VI': 'Virgin Islands', 'GU': 'Guam', 'AS': 'American Samoa',
    }

    # Canadian province/territory codes to full names
    CANADIAN_PROVINCE_MAP = {
        'AB': 'Alberta', 'BC': 'British Columbia', 'MB': 'Manitoba', 'NB': 'New Brunswick',
        'NL': 'Newfoundland and Labrador', 'NS': 'Nova Scotia', 'NT': 'Northwest Territories',
        'NU': 'Nunavut', 'ON': 'Ontario', 'PE': 'Prince Edward Island', 'QC': 'Quebec',
        'SK': 'Saskatchewan', 'YT': 'Yukon',
    }

    # Common invalid state values (scraped text fragments)
    INVALID_STATE_VALUES = {
        'the', 'the united', 'each', 'our', 'achieved', 'penn', 'oslo and the',
        'europe to be founded by the', 'and oldest institution of higher education of the',
        'families through rx kids the', 'located in the vibrant city of paris',
        'the city of lund in the swedish', 'the east flanders', 'the ashanti',
    }

    def __init__(self, db: Client):
        self.db = db

    def clean_country(self, country_code: Optional[str]) -> Optional[str]:
        """
        Convert 2-letter ISO country code to full country name

        Args:
            country_code: 2-letter ISO code or existing country name

        Returns:
            Full country name or None
        """
        if not country_code:
            return None

        country_code = country_code.strip()

        # If it's a 2-letter code, convert it
        if len(country_code) == 2:
            country_upper = country_code.upper()
            return self.COUNTRY_CODE_MAP.get(country_upper, country_code)

        # Already a full name (like "Portugal")
        return country_code

    def clean_state(self, state: Optional[str], country: Optional[str]) -> Optional[str]:
        """
        Clean and normalize state/province values

        Args:
            state: Raw state value
            country: Country name (to determine which mapping to use)

        Returns:
            Cleaned state name or None
        """
        if not state:
            return None

        state_clean = state.strip()
        state_lower = state_clean.lower()

        # Remove invalid/nonsensical values
        if state_lower in self.INVALID_STATE_VALUES:
            return None

        # Remove fragments that are too short or too long
        if len(state_clean) < 2 or len(state_clean) > 50:
            return None

        # For United States, convert state codes to full names
        if country == 'United States':
            state_upper = state_clean.upper()
            if state_upper in self.US_STATE_MAP:
                return self.US_STATE_MAP[state_upper]
            # If already a full state name, keep it
            if state_clean in self.US_STATE_MAP.values():
                return state_clean
            # Unknown value for US - set to NULL
            return None

        # For Canada, convert province codes to full names
        if country == 'Canada':
            state_upper = state_clean.upper()
            if state_upper in self.CANADIAN_PROVINCE_MAP:
                return self.CANADIAN_PROVINCE_MAP[state_upper]
            # If already a full province name, keep it
            if state_clean in self.CANADIAN_PROVINCE_MAP.values():
                return state_clean

        # For other countries, validate state name
        # Keep if it looks like a valid state/province/region name
        # (capitalized, doesn't contain weird characters)
        if state_clean[0].isupper() and state_clean.replace(' ', '').replace('-', '').isalpha():
            return state_clean

        return None

    def clean_all_locations(self, batch_size: int = 100) -> Dict:
        """
        Clean all country and state values in the universities table

        Args:
            batch_size: Number of universities to process at once

        Returns:
            Statistics about the cleaning operation
        """
        logger.info("Starting location data cleaning...")

        stats = {
            'total_processed': 0,
            'countries_updated': 0,
            'states_updated': 0,
            'states_nullified': 0,
            'errors': 0,
        }

        # Get all universities
        offset = 0
        while True:
            response = self.db.table('universities').select(
                'id', 'name', 'country', 'state'
            ).range(offset, offset + batch_size - 1).execute()

            universities = response.data
            if not universities:
                break

            logger.info(f"Processing batch: {offset} to {offset + len(universities)}")

            for uni in universities:
                try:
                    uni_id = uni['id']
                    old_country = uni.get('country')
                    old_state = uni.get('state')

                    # Clean country
                    new_country = self.clean_country(old_country)

                    # Clean state (needs cleaned country for context)
                    new_state = self.clean_state(old_state, new_country)

                    # Track changes
                    country_changed = new_country != old_country
                    state_changed = new_state != old_state

                    # Update if anything changed
                    if country_changed or state_changed:
                        update_data = {}
                        if country_changed:
                            update_data['country'] = new_country
                            stats['countries_updated'] += 1
                            logger.debug(f"{uni['name']}: country '{old_country}' -> '{new_country}'")

                        if state_changed:
                            update_data['state'] = new_state
                            if old_state and not new_state:
                                stats['states_nullified'] += 1
                                logger.debug(f"{uni['name']}: invalid state '{old_state}' -> NULL")
                            else:
                                stats['states_updated'] += 1
                                logger.debug(f"{uni['name']}: state '{old_state}' -> '{new_state}'")

                        # Update database
                        self.db.table('universities').update(update_data).eq('id', uni_id).execute()

                    stats['total_processed'] += 1

                except Exception as e:
                    logger.error(f"Error processing university {uni.get('name')}: {e}")
                    stats['errors'] += 1

            offset += batch_size

            # Log progress
            if stats['total_processed'] % 500 == 0:
                logger.info(f"Progress: {stats['total_processed']} processed, "
                          f"{stats['countries_updated']} countries updated, "
                          f"{stats['states_updated']} states updated")

        logger.info(f"Location cleaning complete! Processed {stats['total_processed']} universities")
        logger.info(f"Countries updated: {stats['countries_updated']}")
        logger.info(f"States updated: {stats['states_updated']}")
        logger.info(f"States nullified (invalid): {stats['states_nullified']}")
        logger.info(f"Errors: {stats['errors']}")

        return stats

    def preview_changes(self, limit: int = 20) -> List[Dict]:
        """
        Preview what changes would be made without actually updating

        Args:
            limit: Number of universities to preview

        Returns:
            List of dictionaries showing before/after changes
        """
        response = self.db.table('universities').select(
            'id', 'name', 'country', 'state'
        ).limit(limit).execute()

        universities = response.data
        preview = []

        for uni in universities:
            old_country = uni.get('country')
            old_state = uni.get('state')

            new_country = self.clean_country(old_country)
            new_state = self.clean_state(old_state, new_country)

            if new_country != old_country or new_state != old_state:
                preview.append({
                    'name': uni['name'],
                    'country_before': old_country,
                    'country_after': new_country,
                    'state_before': old_state,
                    'state_after': new_state,
                })

        return preview
