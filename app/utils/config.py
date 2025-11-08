"""
Cloud-Based Configuration Management
Reads configuration from Supabase instead of local .env files
Phase 2 Enhancement - Cloud Migration
"""

import os
from typing import Optional, Dict, Any
from functools import lru_cache
import logging
from pathlib import Path

logger = logging.getLogger(__name__)

# Load .env file for bootstrap credentials
try:
    from dotenv import load_dotenv
    # Try to find .env file in current directory or parent directories
    env_file = Path(__file__).parent.parent.parent / '.env'
    if env_file.exists():
        load_dotenv(env_file)
    else:
        load_dotenv()  # Try default location
except ImportError:
    pass  # dotenv not installed, will use system environment variables

# Bootstrap: Need initial Supabase credentials to connect
# These are the ONLY values that must be in environment
# All other config will be fetched from Supabase
_BOOTSTRAP_URL = os.environ.get("SUPABASE_URL")
_BOOTSTRAP_KEY = os.environ.get("SUPABASE_KEY")

# Cache for config values
_config_cache: Dict[str, str] = {}
_cache_initialized = False


def _initialize_config_cache():
    """Initialize configuration cache from Supabase"""
    global _config_cache, _cache_initialized

    if _cache_initialized:
        return

    try:
        from supabase import create_client

        if not _BOOTSTRAP_URL or not _BOOTSTRAP_KEY:
            logger.warning("Bootstrap credentials not found. Using environment variables only.")
            _cache_initialized = True
            return

        # Connect to Supabase
        supabase = create_client(_BOOTSTRAP_URL, _BOOTSTRAP_KEY)

        # Fetch all config
        response = supabase.table('app_config').select('key, value').execute()

        if response.data:
            for item in response.data:
                _config_cache[item['key']] = item['value']
            logger.info(f"Loaded {len(response.data)} configuration values from Supabase")

        _cache_initialized = True

    except Exception as e:
        logger.warning(f"Failed to load config from Supabase: {e}. Falling back to environment variables.")
        _cache_initialized = True


def get_config(key: str, default: Optional[str] = None, required: bool = False) -> Optional[str]:
    """
    Get configuration value from Supabase or fallback to environment

    Args:
        key: Configuration key (e.g., 'SUPABASE_URL')
        default: Default value if not found
        required: If True, raises ValueError if not found

    Returns:
        Configuration value or None

    Raises:
        ValueError: If required=True and value not found
    """
    # Initialize cache if needed
    if not _cache_initialized:
        _initialize_config_cache()

    # Try cache first (from Supabase)
    value = _config_cache.get(key)

    # Fallback to environment variable
    if value is None:
        value = os.environ.get(key)

    # Use default if still None
    if value is None:
        value = default

    # Check if required
    if required and value is None:
        raise ValueError(f"Required configuration key '{key}' not found")

    return value


def get_config_int(key: str, default: Optional[int] = None) -> Optional[int]:
    """Get configuration value as integer"""
    value = get_config(key, default=str(default) if default is not None else None)
    return int(value) if value is not None else None


def get_config_bool(key: str, default: bool = False) -> bool:
    """Get configuration value as boolean"""
    value = get_config(key, default=str(default))
    if value is None:
        return default
    return value.lower() in ('true', '1', 'yes', 'on')


def get_config_float(key: str, default: Optional[float] = None) -> Optional[float]:
    """Get configuration value as float"""
    value = get_config(key, default=str(default) if default is not None else None)
    return float(value) if value is not None else None


def reload_config():
    """Reload configuration from Supabase"""
    global _cache_initialized
    _cache_initialized = False
    _config_cache.clear()
    _initialize_config_cache()


def get_all_config() -> Dict[str, str]:
    """Get all configuration values (for debugging)"""
    if not _cache_initialized:
        _initialize_config_cache()
    return _config_cache.copy()


# Convenience functions for common config values
def get_supabase_url() -> str:
    """Get Supabase URL (bootstrap value)"""
    return _BOOTSTRAP_URL or get_config('SUPABASE_URL', required=True)


def get_supabase_key() -> str:
    """Get Supabase API key (bootstrap value)"""
    return _BOOTSTRAP_KEY or get_config('SUPABASE_KEY', required=True)


# Example usage
if __name__ == "__main__":
    from dotenv import load_dotenv

    # Load bootstrap credentials from .env
    load_dotenv()

    print("Configuration Test")
    print("=" * 80)

    # Test basic config
    url = get_config('SUPABASE_URL')
    print(f"SUPABASE_URL: {url[:20]}..." if url else "Not found")

    # Test with default
    test_value = get_config('TEST_KEY', default='default_value')
    print(f"TEST_KEY (with default): {test_value}")

    # Test integer
    timeout = get_config_int('REQUEST_TIMEOUT', default=30)
    print(f"REQUEST_TIMEOUT: {timeout}")

    # Test boolean
    cache_enabled = get_config_bool('CACHE_ENABLED', default=True)
    print(f"CACHE_ENABLED: {cache_enabled}")

    # Show all config
    print("\nAll configuration:")
    all_config = get_all_config()
    for key, value in all_config.items():
        # Hide sensitive values
        if 'KEY' in key or 'SECRET' in key or 'PASSWORD' in key:
            value = value[:5] + '...' if len(value) > 5 else '***'
        print(f"  {key}: {value}")
