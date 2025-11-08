"""
Data Enrichment Module
Automated web search and data filling for NULL university fields
"""
from .web_search_enricher import WebSearchEnricher
from .field_scrapers import FieldSpecificScrapers
from .auto_fill_orchestrator import AutoFillOrchestrator

__all__ = [
    'WebSearchEnricher',
    'FieldSpecificScrapers',
    'AutoFillOrchestrator'
]
