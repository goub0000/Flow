"""
Data fetchers for university information from various sources
"""
from .college_scorecard import CollegeScorecardFetcher
from .data_normalizer import UniversityDataNormalizer

__all__ = ['CollegeScorecardFetcher', 'UniversityDataNormalizer']
