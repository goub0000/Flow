"""
Program Enrichment Service
Automatically enriches program data by fetching information from various sources

Data Sources:
1. University websites (course catalogs, program pages)
2. Open APIs (if available)
3. Web scraping fallback
"""

import logging
import requests
import re
from typing import Dict, Optional, Any, List
from time import sleep
from bs4 import BeautifulSoup
from datetime import datetime, timedelta
from decimal import Decimal

logger = logging.getLogger(__name__)


class ProgramEnricher:
    """
    Enriches institutional program data from various online sources
    """

    def __init__(self, rate_limit_delay: float = 2.0):
        self.rate_limit_delay = rate_limit_delay
        self.stats = {
            'total_processed': 0,
            'description_filled': 0,
            'requirements_filled': 0,
            'fee_filled': 0,
            'deadline_filled': 0,
            'failed': 0,
            'website_scrape_success': 0,
            'api_success': 0
        }

        # HTTP session for reusing connections
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'FlowApp-ProgramEnricher/1.0 (Educational Project; Python/requests)'
        })

    def enrich_program(self, program: Dict[str, Any], institution_website: Optional[str] = None) -> Dict[str, Any]:
        """
        Enrich a single program with data from various sources

        Args:
            program: Program dictionary with basic info
            institution_website: Optional institution website URL

        Returns:
            Enriched program dictionary
        """
        self.stats['total_processed'] += 1
        logger.info(f"Enriching program: {program.get('name')} at {program.get('institution_name')}")

        enriched_data = {}

        try:
            # Try to enrich from institution website if available
            if institution_website:
                website_data = self._enrich_from_website(program, institution_website)
                if website_data:
                    enriched_data.update(website_data)
                    self.stats['website_scrape_success'] += 1

            # Try to enrich from common education APIs
            api_data = self._enrich_from_apis(program)
            if api_data:
                enriched_data.update(api_data)
                self.stats['api_success'] += 1

            # Generate synthetic enrichment data (for demo/testing purposes)
            # In production, remove this and only use real data sources
            synthetic_data = self._generate_synthetic_enrichment(program)
            enriched_data.update(synthetic_data)

            # Update stats
            if enriched_data.get('description'):
                self.stats['description_filled'] += 1
            if enriched_data.get('requirements'):
                self.stats['requirements_filled'] += 1
            if enriched_data.get('fee'):
                self.stats['fee_filled'] += 1
            if enriched_data.get('application_deadline'):
                self.stats['deadline_filled'] += 1

            # Rate limiting
            sleep(self.rate_limit_delay)

            return enriched_data

        except Exception as e:
            logger.error(f"Error enriching program {program.get('name')}: {e}")
            self.stats['failed'] += 1
            return {}

    def _enrich_from_website(self, program: Dict[str, Any], website: str) -> Dict[str, Any]:
        """
        Scrape program data from institution website
        """
        try:
            # Try common program page patterns
            program_name_slug = program['name'].lower().replace(' ', '-').replace("'", '')
            possible_urls = [
                f"{website}/programs/{program_name_slug}",
                f"{website}/courses/{program_name_slug}",
                f"{website}/academics/{program_name_slug}",
                f"{website}/programs",  # General programs page
            ]

            for url in possible_urls:
                try:
                    response = self.session.get(url, timeout=10)
                    if response.status_code == 200:
                        soup = BeautifulSoup(response.text, 'html.parser')
                        return self._extract_program_data(soup, program)
                except:
                    continue

        except Exception as e:
            logger.debug(f"Website enrichment failed for {program['name']}: {e}")

        return {}

    def _extract_program_data(self, soup: BeautifulSoup, program: Dict[str, Any]) -> Dict[str, Any]:
        """
        Extract program data from HTML
        """
        data = {}

        # Try to extract description
        description_keywords = ['description', 'overview', 'about']
        for keyword in description_keywords:
            desc_elem = soup.find(['div', 'p', 'section'], class_=re.compile(keyword, re.I))
            if desc_elem:
                data['description'] = desc_elem.get_text(strip=True)[:500]
                break

        # Try to extract requirements
        req_elem = soup.find(['div', 'ul', 'section'], class_=re.compile('requirement|admission', re.I))
        if req_elem:
            requirements = []
            for li in req_elem.find_all('li')[:10]:
                req_text = li.get_text(strip=True)
                if req_text:
                    requirements.append(req_text)
            if requirements:
                data['requirements'] = requirements

        # Try to extract fees
        fee_patterns = [
            r'\$\s*([\d,]+\.?\d*)',
            r'([\d,]+\.?\d*)\s*USD',
            r'Fee:?\s*\$?([\d,]+\.?\d*)'
        ]
        text = soup.get_text()
        for pattern in fee_patterns:
            match = re.search(pattern, text, re.I)
            if match:
                try:
                    fee_str = match.group(1).replace(',', '')
                    data['fee'] = float(fee_str)
                    break
                except:
                    continue

        return data

    def _enrich_from_apis(self, program: Dict[str, Any]) -> Dict[str, Any]:
        """
        Try to enrich from education APIs
        (Placeholder for future API integrations)
        """
        # Future: Integrate with education APIs like:
        # - Open Education API
        # - College Scorecard (for US universities)
        # - National databases

        return {}

    def _generate_synthetic_enrichment(self, program: Dict[str, Any]) -> Dict[str, Any]:
        """
        Generate synthetic/example data for testing
        REMOVE THIS IN PRODUCTION - Use only real data sources
        """
        data = {}

        # Generate description if missing
        if not program.get('description'):
            category = program.get('category', 'General')
            level = program.get('level', 'undergraduate')
            templates = [
                f"Comprehensive {level} program in {category} covering essential topics and modern practices.",
                f"Professional {level} course in {category} designed to prepare students for industry careers.",
                f"Rigorous {level} curriculum in {category} with hands-on learning and practical applications.",
            ]
            data['description'] = templates[hash(program['name']) % len(templates)]

        # Generate requirements if missing
        if not program.get('requirements') or not program['requirements']:
            level = program.get('level', 'undergraduate')
            if level == 'certificate':
                data['requirements'] = [
                    "Basic computer skills",
                    "High school diploma or equivalent"
                ]
            elif level == 'diploma':
                data['requirements'] = [
                    "High school diploma with relevant subjects",
                    "Minimum GPA of 2.5",
                    "English proficiency"
                ]
            elif level == 'undergraduate':
                data['requirements'] = [
                    "High school diploma with strong academics",
                    "Minimum GPA of 3.0",
                    "English proficiency test",
                    "Personal statement"
                ]
            elif level in ['postgraduate', 'doctoral']:
                data['requirements'] = [
                    "Bachelor's degree in relevant field",
                    "Minimum GPA of 3.5",
                    "GRE/GMAT scores (if applicable)",
                    "Letters of recommendation",
                    "Research proposal (for doctoral programs)"
                ]

        # Generate application deadline if missing
        if not program.get('application_deadline'):
            # Set deadline 2-3 months from now
            months_ahead = 2 + (hash(program['name']) % 2)
            data['application_deadline'] = (datetime.now() + timedelta(days=30 * months_ahead)).isoformat()

        # Generate start date if missing
        if not program.get('start_date'):
            # Set start date 3-4 months from now
            months_ahead = 3 + (hash(program['name']) % 2)
            data['start_date'] = (datetime.now() + timedelta(days=30 * months_ahead)).isoformat()

        return data

    def enrich_multiple_programs(
        self,
        programs: List[Dict[str, Any]],
        institution_website: Optional[str] = None
    ) -> List[Dict[str, Any]]:
        """
        Enrich multiple programs

        Args:
            programs: List of program dictionaries
            institution_website: Optional institution website

        Returns:
            List of enriched program dictionaries
        """
        enriched_programs = []

        for program in programs:
            enriched_data = self.enrich_program(program, institution_website)
            enriched_program = {**program, **enriched_data}
            enriched_programs.append(enriched_program)

        return enriched_programs

    def get_stats(self) -> Dict[str, Any]:
        """Get enrichment statistics"""
        return self.stats.copy()

    def reset_stats(self):
        """Reset statistics"""
        for key in self.stats:
            self.stats[key] = 0


# Example usage
if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)

    enricher = ProgramEnricher(rate_limit_delay=1.0)

    # Example program
    sample_program = {
        'id': '123e4567-e89b-12d3-a456-426614174000',
        'institution_id': '123e4567-e89b-12d3-a456-426614174001',
        'institution_name': 'University of Ghana',
        'name': 'Bachelor of Computer Science',
        'category': 'Technology',
        'level': 'undergraduate',
        'duration_days': 1460,
        'fee': 5000,
        'currency': 'USD',
        'max_students': 100,
        'enrolled_students': 75
    }

    enriched = enricher.enrich_program(sample_program)
    print("Enriched program data:")
    print(enriched)
    print("\nStatistics:")
    print(enricher.get_stats())
