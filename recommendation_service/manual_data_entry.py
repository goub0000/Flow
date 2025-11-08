"""
Manual University Data Entry Tool
Interactively fill in missing university data (city, state, website)
"""

import logging
from app.database.supabase_client import get_supabase_client
from typing import Optional

logging.basicConfig(level=logging.INFO, format='%(message)s')
logger = logging.getLogger(__name__)


class ManualDataEntry:
    """Interactive tool for manual data entry"""

    def __init__(self):
        self.db_client = None
        self.stats = {
            'total_updated': 0,
            'city_added': 0,
            'state_added': 0,
            'website_added': 0,
            'skipped': 0
        }

    def run(self, limit: int = 50):
        """Run the manual data entry session"""
        logger.info("=" * 80)
        logger.info("MANUAL UNIVERSITY DATA ENTRY")
        logger.info("=" * 80)
        logger.info("")

        # Connect to database
        logger.info("Connecting to Supabase...")
        self.db_client = get_supabase_client()
        logger.info("Connected successfully!")
        logger.info("")

        # Get universities with missing data
        logger.info(f"Fetching universities with missing data (limit: {limit})...")
        universities = self._get_universities_with_missing_data(limit)

        if not universities:
            logger.info("No universities found with missing data!")
            return

        logger.info(f"Found {len(universities)} universities with missing data")
        logger.info("")
        logger.info("=" * 80)
        logger.info("INSTRUCTIONS:")
        logger.info("  - Enter data for each field (or press Enter to skip)")
        logger.info("  - Type 'quit' at any time to exit")
        logger.info("  - Type 'skip' to skip to next university")
        logger.info("=" * 80)
        logger.info("")

        # Process each university
        for i, uni in enumerate(universities, 1):
            logger.info(f"\n[{i}/{len(universities)}] Processing university:")
            logger.info("=" * 80)

            if not self._process_university(uni):
                logger.info("\nExiting...")
                break

        # Print summary
        self._print_summary()

    def _get_universities_with_missing_data(self, limit: int):
        """Get universities with NULL values in key fields"""
        result = self.db_client.client.table('universities').select(
            'id, name, country, city, state, website'
        ).or_(
            'website.is.null,city.is.null,state.is.null'
        ).limit(limit).execute()

        return result.data

    def _process_university(self, uni: dict) -> bool:
        """
        Process a single university
        Returns False if user wants to quit
        """
        logger.info(f"Name:    {uni['name']}")
        logger.info(f"Country: {uni['country']}")
        logger.info(f"Current data:")
        logger.info(f"  City:    {uni.get('city') or 'NULL'}")
        logger.info(f"  State:   {uni.get('state') or 'NULL'}")
        logger.info(f"  Website: {uni.get('website') or 'NULL'}")
        logger.info("")

        # Collect updates
        updates = {}

        # City
        if not uni.get('city'):
            city = self._get_input("Enter city (or Enter to skip): ")
            if city == 'quit':
                return False
            if city == 'skip':
                self.stats['skipped'] += 1
                return True
            if city:
                updates['city'] = city
                self.stats['city_added'] += 1

        # State
        if not uni.get('state'):
            state = self._get_input("Enter state/region (or Enter to skip): ")
            if state == 'quit':
                return False
            if state == 'skip':
                self.stats['skipped'] += 1
                return True
            if state:
                updates['state'] = state
                self.stats['state_added'] += 1

        # Website
        if not uni.get('website'):
            website = self._get_input("Enter website URL (or Enter to skip): ")
            if website == 'quit':
                return False
            if website == 'skip':
                self.stats['skipped'] += 1
                return True
            if website:
                # Add https:// if not present
                if website and not website.startswith('http'):
                    website = f"https://{website}"
                updates['website'] = website
                self.stats['website_added'] += 1

        # Save updates
        if updates:
            self._save_updates(uni['id'], updates)
            logger.info(f"\n✓ Saved: {', '.join(updates.keys())}")
            self.stats['total_updated'] += 1
        else:
            logger.info("\n- No changes made")

        return True

    def _get_input(self, prompt: str) -> str:
        """Get user input"""
        try:
            value = input(prompt).strip()
            return value
        except (KeyboardInterrupt, EOFError):
            return 'quit'

    def _save_updates(self, uni_id: int, updates: dict):
        """Save updates to database"""
        try:
            self.db_client.client.table('universities').update(updates).eq(
                'id', uni_id
            ).execute()
        except Exception as e:
            logger.error(f"Failed to save updates: {e}")

    def _print_summary(self):
        """Print summary statistics"""
        logger.info("\n")
        logger.info("=" * 80)
        logger.info("SESSION SUMMARY")
        logger.info("=" * 80)
        logger.info(f"Universities updated: {self.stats['total_updated']}")
        logger.info(f"Cities added:         {self.stats['city_added']}")
        logger.info(f"States added:         {self.stats['state_added']}")
        logger.info(f"Websites added:       {self.stats['website_added']}")
        logger.info(f"Skipped:              {self.stats['skipped']}")
        logger.info("=" * 80)


def main():
    """Main entry point"""
    import argparse

    parser = argparse.ArgumentParser(
        description='Manual data entry tool for universities'
    )
    parser.add_argument(
        '--limit',
        type=int,
        default=50,
        help='Number of universities to process (default: 50)'
    )

    args = parser.parse_args()

    entry_tool = ManualDataEntry()
    entry_tool.run(limit=args.limit)


if __name__ == "__main__":
    main()
