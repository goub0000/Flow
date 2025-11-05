"""
Auto-Fill Logo URLs
Extracts university logos from their websites
"""

import logging
import requests
import re
from bs4 import BeautifulSoup
from typing import Optional
from time import sleep
import random
from urllib.parse import urljoin
from app.database.supabase_client import get_supabase_client

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)


class LogoFiller:
    """Extract university logos from websites"""

    def __init__(self, rate_limit: float = 2.0):
        self.rate_limit = rate_limit
        self.db_client = None
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
        })
        self.stats = {'total': 0, 'filled': 0, 'failed': 0, 'skipped': 0}

    def run(self, limit: int = 100):
        logger.info("=" * 80)
        logger.info("AUTO-FILL LOGO URLs")
        logger.info("=" * 80)

        self.db_client = get_supabase_client()
        logger.info("Connected to database\n")

        # Get universities with website but no logo
        result = self.db_client.client.table('universities').select(
            'id, name, website'
        ).is_('logo_url', 'null').not_.is_('website', 'null').limit(limit).execute()

        universities = result.data
        if not universities:
            logger.info("No universities need logos!")
            return

        logger.info(f"Found {len(universities)} universities without logos\n")

        for i, uni in enumerate(universities, 1):
            logger.info(f"[{i}/{len(universities)}] {uni['name']}")

            try:
                logo = self._extract_logo(uni['website'], uni['name'])

                if logo:
                    self.db_client.client.table('universities').update(
                        {'logo_url': logo}
                    ).eq('id', uni['id']).execute()

                    logger.info(f"  ✓ Found: {logo}")
                    self.stats['filled'] += 1
                else:
                    logger.info(f"  - Not found")
                    self.stats['skipped'] += 1

                self.stats['total'] += 1
                sleep(self.rate_limit + random.uniform(-0.5, 0.5))

            except Exception as e:
                logger.error(f"  ✗ Error: {e}")
                self.stats['failed'] += 1

        self._print_summary()

    def _extract_logo(self, website_url: str, uni_name: str) -> Optional[str]:
        """Extract logo from university website"""
        try:
            response = self.session.get(website_url, timeout=10, allow_redirects=True)
            if response.status_code >= 400:
                return None

            soup = BeautifulSoup(response.text, 'html.parser')

            # Strategy 1: Common logo class names
            logo_classes = ['logo', 'header-logo', 'site-logo', 'brand-logo', 'navbar-brand', 'site-branding']
            for cls in logo_classes:
                img = soup.find('img', class_=re.compile(cls, re.I))
                if img and img.get('src'):
                    return urljoin(website_url, img['src'])

            # Strategy 2: Logo in link rel
            link = soup.find('link', rel=re.compile('icon|logo|apple-touch-icon', re.I))
            if link and link.get('href'):
                href = link['href']
                # Skip tiny icons
                if '16x16' not in href and '32x32' not in href:
                    return urljoin(website_url, href)

            # Strategy 3: Image with "logo" in src or alt
            imgs = soup.find_all('img', src=re.compile('logo', re.I))
            if imgs:
                return urljoin(website_url, imgs[0]['src'])

            imgs = soup.find_all('img', alt=re.compile('logo', re.I))
            if imgs:
                return urljoin(website_url, imgs[0]['src'])

            # Strategy 4: Header/nav images
            header = soup.find(['header', 'nav'])
            if header:
                img = header.find('img')
                if img and img.get('src'):
                    return urljoin(website_url, img['src'])

            return None

        except Exception as e:
            logger.debug(f"Logo extraction failed: {e}")
            return None

    def _print_summary(self):
        logger.info("\n" + "=" * 80)
        logger.info("SUMMARY")
        logger.info("=" * 80)
        logger.info(f"Total processed:  {self.stats['total']}")
        logger.info(f"Logos filled:     {self.stats['filled']}")
        logger.info(f"Skipped:          {self.stats['skipped']}")
        logger.info(f"Failed:           {self.stats['failed']}")

        if self.stats['total'] > 0:
            rate = (self.stats['filled'] / self.stats['total']) * 100
            logger.info(f"Success rate:     {rate:.1f}%")
        logger.info("=" * 80)


def main():
    import argparse
    parser = argparse.ArgumentParser(description='Auto-fill university logos')
    parser.add_argument('--limit', type=int, default=100, help='Number to process')
    args = parser.parse_args()

    filler = LogoFiller()
    filler.run(limit=args.limit)


if __name__ == "__main__":
    main()
