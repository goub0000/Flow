"""
Pytest configuration for integration tests
"""
import pytest
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

def pytest_configure(config):
    """Configure pytest"""
    config.addinivalue_line(
        "markers", "integration: mark test as integration test"
    )
    config.addinivalue_line(
        "markers", "slow: mark test as slow running"
    )


@pytest.fixture(scope="session")
def api_base_url():
    """Get API base URL from environment"""
    return os.getenv("API_BASE_URL", "http://localhost:8000")


@pytest.fixture(scope="session")
def supabase_url():
    """Get Supabase URL from environment"""
    return os.getenv("SUPABASE_URL")


@pytest.fixture(scope="session")
def supabase_key():
    """Get Supabase anon key from environment"""
    return os.getenv("SUPABASE_ANON_KEY")
