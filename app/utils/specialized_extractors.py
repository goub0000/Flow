"""
Specialized Field Extractors
Enhanced extraction for specific challenging fields
Phase 2 Enhancement
"""

import re
from typing import Optional, Dict, Any
import logging

logger = logging.getLogger(__name__)


class AcceptanceRateExtractor:
    """
    Specialized extractor for acceptance rates

    Handles various formats:
    - "15% acceptance rate"
    - "Admission rate: 4.5%"
    - "Accepts 3.9% of applicants"
    - "Selectivity: 6.2%"
    """

    PATTERNS = [
        # Standard formats
        r'accept(?:ance|s)?\s+rate[:\s]+(\d+(?:\.\d+)?)\s*%',
        r'admission\s+rate[:\s]+(\d+(?:\.\d+)?)\s*%',
        r'(\d+(?:\.\d+)?)\s*%\s+accept(?:ance|ed)?',

        # Alternative phrasings
        r'selectivity[:\s]+(\d+(?:\.\d+)?)\s*%',
        r'acceptance[:\s]+(\d+(?:\.\d+)?)\s*%',
        r'admits?\s+(\d+(?:\.\d+)?)\s*%',

        # Verbose formats
        r'(\d+(?:\.\d+)?)\s*%\s+of\s+applicants?\s+(?:are\s+)?admit',
        r'admit(?:s|ted)?\s+(\d+(?:\.\d+)?)\s*%\s+of',

        # International formats
        r'offer\s+rate[:\s]+(\d+(?:\.\d+)?)\s*%',
    ]

    def extract(self, text: str) -> Optional[float]:
        """
        Extract acceptance rate from text

        Args:
            text: Text to search

        Returns:
            Acceptance rate percentage or None
        """
        text_lower = text.lower()

        for pattern in self.PATTERNS:
            matches = re.finditer(pattern, text_lower, re.IGNORECASE)
            for match in matches:
                try:
                    rate = float(match.group(1))
                    # Validation: 0.1% to 100%
                    if 0.1 <= rate <= 100:
                        logger.debug(f"Extracted acceptance rate: {rate}%")
                        return rate
                except ValueError:
                    continue

        return None


class TuitionExtractor:
    """
    Specialized extractor for tuition costs

    Handles:
    - Annual vs per semester
    - In-state vs out-of-state
    - Currency symbols
    - Thousands separators
    """

    OUT_OF_STATE_PATTERNS = [
        # Out-of-state specific
        r'out[\s-]+of[\s-]+state\s+tuition[:\s]+\$\s*([\d,]+)',
        r'non[\s-]+resident\s+tuition[:\s]+\$\s*([\d,]+)',
        r'tuition\s+\(out[\s-]+of[\s-]+state\)[:\s]+\$\s*([\d,]+)',
        r'international\s+tuition[:\s]+\$\s*([\d,]+)',

        # General tuition (usually means out-of-state)
        r'annual\s+tuition[:\s]+\$\s*([\d,]+)',
        r'tuition\s+and\s+fees[:\s]+\$\s*([\d,]+)',
        r'tuition[:\s]+\$\s*([\d,]+)\s+per\s+year',
    ]

    def extract(self, text: str) -> Optional[int]:
        """
        Extract out-of-state tuition from text

        Args:
            text: Text to search

        Returns:
            Annual tuition in dollars or None
        """
        for pattern in self.OUT_OF_STATE_PATTERNS:
            matches = re.finditer(pattern, text, re.IGNORECASE)
            for match in matches:
                try:
                    # Remove commas and convert
                    amount_str = match.group(1).replace(',', '')
                    amount = int(amount_str)

                    # Validation: $5,000 to $90,000 per year
                    if 5000 <= amount <= 90000:
                        logger.debug(f"Extracted tuition: ${amount:,}")
                        return amount

                    # If it's per semester, double it
                    if 'semester' in text[max(0, match.start()-50):match.end()+50].lower():
                        amount_annual = amount * 2
                        if 5000 <= amount_annual <= 90000:
                            logger.debug(f"Extracted semester tuition, annualized: ${amount_annual:,}")
                            return amount_annual

                except ValueError:
                    continue

        return None


class EnrollmentExtractor:
    """
    Specialized extractor for student enrollment

    Handles:
    - Total enrollment
    - Undergraduate vs graduate
    - Various number formats
    """

    PATTERNS = [
        # Total enrollment
        r'total\s+enrollment[:\s]+([\d,]+)',
        r'enrollment[:\s]+([\d,]+)\s+students?',
        r'([\d,]+)\s+students?\s+enrolled',

        # Student body size
        r'student\s+body[:\s]+([\d,]+)',
        r'([\d,]+)\s+students?\s+attend',

        # Specific phrases
        r'enrollment\s+of\s+([\d,]+)',
        r'serves?\s+([\d,]+)\s+students?',
    ]

    def extract(self, text: str) -> Optional[int]:
        """
        Extract total enrollment from text

        Args:
            text: Text to search

        Returns:
            Number of students or None
        """
        text_lower = text.lower()

        for pattern in self.PATTERNS:
            matches = re.finditer(pattern, text_lower, re.IGNORECASE)
            for match in matches:
                try:
                    # Remove commas and convert
                    count_str = match.group(1).replace(',', '')
                    count = int(count_str)

                    # Validation: 100 to 1,000,000 students
                    if 100 <= count <= 1000000:
                        logger.debug(f"Extracted enrollment: {count:,}")
                        return count

                except ValueError:
                    continue

        return None


class GraduationRateExtractor:
    """
    Specialized extractor for graduation rates

    Handles:
    - 4-year graduation rate
    - 6-year graduation rate
    - Overall graduation rate
    """

    FOUR_YEAR_PATTERNS = [
        r'4[\s-]+year\s+graduation\s+rate[:\s]+(\d+(?:\.\d+)?)\s*%',
        r'four[\s-]+year\s+graduation[:\s]+(\d+(?:\.\d+)?)\s*%',
        r'graduation\s+rate\s+\(4\s+years?\)[:\s]+(\d+(?:\.\d+)?)\s*%',
        r'(\d+(?:\.\d+)?)\s*%\s+graduate\s+in\s+4\s+years?',
    ]

    SIX_YEAR_PATTERNS = [
        r'6[\s-]+year\s+graduation\s+rate[:\s]+(\d+(?:\.\d+)?)\s*%',
        r'six[\s-]+year\s+graduation[:\s]+(\d+(?:\.\d+)?)\s*%',
        r'graduation\s+rate\s+\(6\s+years?\)[:\s]+(\d+(?:\.\d+)?)\s*%',
        r'(\d+(?:\.\d+)?)\s*%\s+graduate\s+in\s+6\s+years?',
    ]

    def extract_4year(self, text: str) -> Optional[float]:
        """
        Extract 4-year graduation rate

        Args:
            text: Text to search

        Returns:
            4-year graduation rate percentage or None
        """
        text_lower = text.lower()

        for pattern in self.FOUR_YEAR_PATTERNS:
            matches = re.finditer(pattern, text_lower, re.IGNORECASE)
            for match in matches:
                try:
                    rate = float(match.group(1))
                    # Validation: 5% to 100%
                    if 5 <= rate <= 100:
                        logger.debug(f"Extracted 4-year grad rate: {rate}%")
                        return rate
                except ValueError:
                    continue

        return None

    def extract_6year(self, text: str) -> Optional[float]:
        """
        Extract 6-year graduation rate

        Args:
            text: Text to search

        Returns:
            6-year graduation rate percentage or None
        """
        text_lower = text.lower()

        for pattern in self.SIX_YEAR_PATTERNS:
            matches = re.finditer(pattern, text_lower, re.IGNORECASE)
            for match in matches:
                try:
                    rate = float(match.group(1))
                    # Validation: 10% to 100%
                    if 10 <= rate <= 100:
                        logger.debug(f"Extracted 6-year grad rate: {rate}%")
                        return rate
                except ValueError:
                    continue

        return None


class UniversityTypeExtractor:
    """
    Specialized extractor for university type (public/private)
    """

    PUBLIC_INDICATORS = [
        'public university',
        'state university',
        'public institution',
        'publicly funded',
        'public research university',
        'public land-grant',
    ]

    PRIVATE_INDICATORS = [
        'private university',
        'private institution',
        'privately funded',
        'private research university',
        'private non-profit',
        'private college',
    ]

    def extract(self, text: str) -> Optional[str]:
        """
        Extract university type from text

        Args:
            text: Text to search

        Returns:
            'Public' or 'Private' or None
        """
        text_lower = text.lower()

        # Check for explicit mentions
        for indicator in self.PUBLIC_INDICATORS:
            if indicator in text_lower:
                logger.debug(f"Identified as Public (found: {indicator})")
                return 'Public'

        for indicator in self.PRIVATE_INDICATORS:
            if indicator in text_lower:
                logger.debug(f"Identified as Private (found: {indicator})")
                return 'Private'

        return None


class SpecializedExtractorSuite:
    """
    Suite of all specialized extractors

    Usage:
        suite = SpecializedExtractorSuite()
        data = suite.extract_all(text)
    """

    def __init__(self):
        self.acceptance_rate = AcceptanceRateExtractor()
        self.tuition = TuitionExtractor()
        self.enrollment = EnrollmentExtractor()
        self.graduation_rate = GraduationRateExtractor()
        self.university_type = UniversityTypeExtractor()

    def extract_all(self, text: str) -> Dict[str, Any]:
        """
        Extract all fields using specialized extractors

        Args:
            text: Text to extract from

        Returns:
            Dictionary with extracted fields
        """
        data = {}

        # Acceptance rate
        acceptance = self.acceptance_rate.extract(text)
        if acceptance:
            data['acceptance_rate'] = acceptance

        # Tuition
        tuition = self.tuition.extract(text)
        if tuition:
            data['tuition_out_state'] = tuition

        # Enrollment
        enrollment = self.enrollment.extract(text)
        if enrollment:
            data['total_students'] = enrollment

        # Graduation rates
        grad_4year = self.graduation_rate.extract_4year(text)
        if grad_4year:
            data['graduation_rate_4year'] = grad_4year

        # University type
        uni_type = self.university_type.extract(text)
        if uni_type:
            data['university_type'] = uni_type

        return data

    def extract_field(self, field_name: str, text: str) -> Optional[Any]:
        """
        Extract a specific field

        Args:
            field_name: Field to extract
            text: Text to extract from

        Returns:
            Extracted value or None
        """
        extractors = {
            'acceptance_rate': self.acceptance_rate.extract,
            'tuition_out_state': self.tuition.extract,
            'total_students': self.enrollment.extract,
            'graduation_rate_4year': self.graduation_rate.extract_4year,
            'university_type': self.university_type.extract,
        }

        extractor = extractors.get(field_name)
        if extractor:
            return extractor(text)

        return None


# Example usage
if __name__ == "__main__":
    # Test data
    test_text = """
    Stanford University is a private research university with an acceptance rate of 3.9%.
    The total enrollment is 17,249 students. Annual tuition and fees: $56,169.
    The 4-year graduation rate is 75% and the 6-year graduation rate is 94%.
    """

    suite = SpecializedExtractorSuite()
    extracted = suite.extract_all(test_text)

    print("Extracted data:")
    for field, value in extracted.items():
        print(f"  {field}: {value}")
