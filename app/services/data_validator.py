"""
Data Validator Service
Validates and cleans university data before database insertion using Pydantic
"""

from pydantic import BaseModel, validator, Field
from typing import Optional
import re
import logging

logger = logging.getLogger(__name__)


class UniversityDataModel(BaseModel):
    """
    Data validation model for university records
    Ensures data meets quality standards before database insertion
    """
    name: str = Field(..., min_length=3, max_length=500)
    country: str = Field(..., min_length=2, max_length=2)
    state: Optional[str] = Field(None, max_length=100)
    city: Optional[str] = Field(None, max_length=100)
    website: Optional[str] = Field(None, max_length=500)
    description: Optional[str] = Field(None, max_length=2000)
    founded_year: Optional[int] = None
    phone: Optional[str] = Field(None, max_length=50)
    email: Optional[str] = Field(None, max_length=200)

    class Config:
        # Allow extra fields (for flexibility)
        extra = 'allow'
        # Remove None values
        str_strip_whitespace = True

    @validator('name')
    def name_must_be_valid(cls, v):
        """Validate university name"""
        if not v or len(v) < 3:
            raise ValueError('University name must be at least 3 characters')

        # Must contain at least some letters
        if not any(c.isalpha() for c in v):
            raise ValueError('University name must contain letters')

        # Remove excessive whitespace
        v = ' '.join(v.split())

        return v

    @validator('country')
    def country_must_be_iso_code(cls, v):
        """Validate country is 2-letter ISO code"""
        if not v or len(v) != 2:
            raise ValueError('Country must be 2-letter ISO code')

        return v.upper()

    @validator('website')
    def website_must_be_valid(cls, v):
        """Validate website URL"""
        if v:
            # Add protocol if missing
            if not v.startswith(('http://', 'https://')):
                v = 'https://' + v

            # Remove trailing slash
            v = v.rstrip('/')

            # Basic URL validation
            url_pattern = r'https?://[\w\-\.]+\.[a-z]{2,}'
            if not re.match(url_pattern, v, re.IGNORECASE):
                raise ValueError('Invalid website URL format')

        return v

    @validator('founded_year')
    def year_must_be_reasonable(cls, v):
        """Validate founded year is reasonable"""
        if v is not None:
            # Universities didn't exist before ~1000 AD
            if v < 800 or v > 2025:
                raise ValueError('Founded year must be between 800 and 2025')

        return v

    @validator('email')
    def email_must_be_valid(cls, v):
        """Validate email format"""
        if v:
            email_pattern = r'^[\w\.-]+@[\w\.-]+\.\w+$'
            if not re.match(email_pattern, v):
                raise ValueError('Invalid email format')

        return v.lower()

    @validator('description')
    def description_must_be_reasonable(cls, v):
        """Validate description length and content"""
        if v:
            # Remove excessive whitespace
            v = ' '.join(v.split())

            # Check minimum length
            if len(v) < 10:
                raise ValueError('Description too short (minimum 10 characters)')

            # Check for gibberish (should have some common words)
            if v.isdigit() or len(v.split()) < 3:
                raise ValueError('Description appears to be invalid')

        return v


class DataValidator:
    """
    Service for validating and cleaning university data
    """

    def __init__(self):
        self.logger = logging.getLogger(__name__)
        self.validation_stats = {
            'total_validated': 0,
            'passed': 0,
            'failed': 0,
            'errors': {}
        }

    def validate(self, raw_data: dict) -> Optional[dict]:
        """
        Validate raw university data

        Args:
            raw_data: Dictionary with university data

        Returns:
            Validated dictionary or None if validation fails
        """
        self.validation_stats['total_validated'] += 1

        try:
            # Normalize field names - handle both 'country' and 'country_code'
            data = raw_data.copy()
            if 'country_code' in data and 'country' not in data:
                data['country'] = data.pop('country_code')

            # Use Pydantic model for validation
            validated = UniversityDataModel(**data)

            # Convert back to dict, excluding None values
            result = validated.dict(exclude_none=True, by_alias=True)

            self.validation_stats['passed'] += 1
            return result

        except Exception as e:
            error_type = type(e).__name__
            error_msg = str(e)

            # Track error types
            if error_type not in self.validation_stats['errors']:
                self.validation_stats['errors'][error_type] = 0
            self.validation_stats['errors'][error_type] += 1

            self.validation_stats['failed'] += 1

            self.logger.debug(
                f"Validation failed for '{raw_data.get('name', 'Unknown')}': "
                f"{error_type} - {error_msg}"
            )

            return None

    def validate_batch(self, universities: list[dict]) -> list[dict]:
        """
        Validate a batch of universities

        Args:
            universities: List of university dictionaries

        Returns:
            List of validated universities (failures are excluded)
        """
        validated = []

        for uni in universities:
            result = self.validate(uni)
            if result:
                validated.append(result)

        return validated

    def get_stats(self) -> dict:
        """
        Get validation statistics

        Returns:
            Dictionary with validation stats
        """
        stats = self.validation_stats.copy()

        if stats['total_validated'] > 0:
            stats['success_rate'] = (stats['passed'] / stats['total_validated']) * 100
        else:
            stats['success_rate'] = 0.0

        return stats

    def log_stats(self):
        """Log validation statistics"""
        stats = self.get_stats()

        self.logger.info("=" * 80)
        self.logger.info("DATA VALIDATION STATISTICS")
        self.logger.info("=" * 80)
        self.logger.info(f"Total validated: {stats['total_validated']}")
        self.logger.info(f"Passed: {stats['passed']} ({stats['success_rate']:.1f}%)")
        self.logger.info(f"Failed: {stats['failed']}")

        if stats['errors']:
            self.logger.info("")
            self.logger.info("Error breakdown:")
            for error_type, count in sorted(
                stats['errors'].items(),
                key=lambda x: x[1],
                reverse=True
            ):
                self.logger.info(f"  {error_type}: {count}")

        self.logger.info("=" * 80)

    def reset_stats(self):
        """Reset validation statistics"""
        self.validation_stats = {
            'total_validated': 0,
            'passed': 0,
            'failed': 0,
            'errors': {}
        }


if __name__ == "__main__":
    # Test the validator
    logging.basicConfig(level=logging.INFO)

    validator = DataValidator()

    # Valid data
    valid_uni = {
        'name': 'University of Lagos',
        'country': 'NG',
        'city': 'Lagos',
        'website': 'www.unilag.edu.ng',
        'description': 'The University of Lagos is a federal university in Lagos, Nigeria.'
    }

    # Invalid data (missing name)
    invalid_uni1 = {
        'country': 'NG',
        'city': 'Lagos'
    }

    # Invalid data (bad URL)
    invalid_uni2 = {
        'name': 'Test University',
        'country': 'NG',
        'website': 'not-a-valid-url'
    }

    # Test validation
    print("Testing validation...")
    print("-" * 80)

    result = validator.validate(valid_uni)
    print(f"Valid uni: {'PASS' if result else 'FAIL'}")
    if result:
        print(f"  {result}")

    result = validator.validate(invalid_uni1)
    print(f"Invalid uni (no name): {'PASS' if result else 'FAIL'}")

    result = validator.validate(invalid_uni2)
    print(f"Invalid uni (bad URL): {'PASS' if result else 'FAIL'}")

    print("\n")
    validator.log_stats()
