"""
Cloud-Based Database Configuration
Uses Supabase instead of local SQLite
"""
from supabase import create_client, Client
from app.utils.config import get_config
from typing import Optional

_supabase_client: Optional[Client] = None


def get_supabase() -> Client:
    """
    Get Supabase client instance (singleton pattern)

    Returns:
        Supabase client for database operations
    """
    global _supabase_client

    if _supabase_client is None:
        url = get_config('SUPABASE_URL', required=True)
        key = get_config('SUPABASE_KEY', required=True)
        _supabase_client = create_client(url, key)

    return _supabase_client


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
