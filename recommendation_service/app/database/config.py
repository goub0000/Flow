"""
Cloud-Based Database Configuration
Uses Supabase instead of local SQLite
"""
from supabase import create_client, Client
import os
from typing import Optional

_supabase_client: Optional[Client] = None
_supabase_admin_client: Optional[Client] = None


def get_supabase() -> Client:
    """
    Get Supabase client instance (singleton pattern)

    Returns:
        Supabase client for database operations
    """
    global _supabase_client

    if _supabase_client is None:
        # Get credentials directly from environment variables
        # This avoids circular dependency with config.py
        url = os.environ.get('SUPABASE_URL')
        key = os.environ.get('SUPABASE_KEY')

        # Debug logging
        import logging
        logger = logging.getLogger(__name__)
        logger.info(f"SUPABASE_URL from env: {url[:30] if url else 'NOT SET'}...")
        logger.info(f"SUPABASE_KEY from env: {'SET' if key else 'NOT SET'}")

        if not url or not key:
            raise ValueError("SUPABASE_URL and SUPABASE_KEY environment variables are required")

        _supabase_client = create_client(url, key)

    return _supabase_client


def get_supabase_admin() -> Client:
    """
    Get Supabase admin client with service role key (bypasses RLS)

    Returns:
        Supabase admin client for privileged operations
    """
    global _supabase_admin_client

    if _supabase_admin_client is None:
        url = os.environ.get('SUPABASE_URL')
        # Try service role key (various env var names), fall back to SUPABASE_KEY
        service_role_key = (
            os.environ.get('SUPABASE_SERVICE_ROLE_KEY')
            or os.environ.get('SUPABASE_SERVICE_KEY')
            or os.environ.get('SUPABASE_KEY')
        )

        import logging
        logger = logging.getLogger(__name__)
        logger.info(f"Creating admin client with service role key: {'SET' if service_role_key else 'NOT SET'}")

        if not url or not service_role_key:
            raise ValueError("SUPABASE_URL and service role key are required for admin operations")

        _supabase_admin_client = create_client(url, service_role_key)

    return _supabase_admin_client


# Dependency for FastAPI endpoints
def get_db() -> Client:
    """
    FastAPI dependency to get database client

    Usage in endpoints:
        @app.get("/items/")
        async def get_items(db: Client = Depends(get_db)):
            result = db.table('items').select('*').execute()
            return result.data
    """
    return get_supabase()
