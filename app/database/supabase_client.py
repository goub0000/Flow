"""
Supabase Client Configuration
Handles connection to Supabase PostgreSQL database
"""
import os
import logging
from typing import Optional, Dict, Any, List
from supabase import create_client, Client
from dotenv import load_dotenv

load_dotenv()
logger = logging.getLogger(__name__)


class SupabaseClient:
    """Wrapper for Supabase client with Find Your Path specific methods"""

    _instance: Optional['SupabaseClient'] = None
    _client: Optional[Client] = None

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
        return cls._instance

    def __init__(self):
        """Initialize Supabase client (singleton pattern)"""
        if self._client is None:
            self._initialize_client()

    def _initialize_client(self):
        """Create Supabase client connection"""
        supabase_url = os.getenv('SUPABASE_URL')
        supabase_key = os.getenv('SUPABASE_SERVICE_KEY') or os.getenv('SUPABASE_ANON_KEY')

        if not supabase_url or not supabase_key:
            raise ValueError(
                "Missing Supabase credentials. Please set SUPABASE_URL and "
                "SUPABASE_SERVICE_KEY (or SUPABASE_ANON_KEY) in your .env file.\n"
                "See SUPABASE_SETUP.md for setup instructions."
            )

        try:
            self._client = create_client(supabase_url, supabase_key)
            logger.info("Successfully connected to Supabase")
        except Exception as e:
            logger.error(f"Failed to connect to Supabase: {e}")
            raise

    @property
    def client(self) -> Client:
        """Get the Supabase client instance"""
        if self._client is None:
            self._initialize_client()
        return self._client

    # ==================== University Methods ====================

    def insert_university(self, university_data: Dict[str, Any]) -> Optional[Dict]:
        """
        Insert a single university

        Args:
            university_data: University data dictionary

        Returns:
            Inserted university record or None if failed
        """
        try:
            response = self.client.table('universities').insert(university_data).execute()
            if response.data:
                return response.data[0]
            return None
        except Exception as e:
            logger.error(f"Error inserting university: {e}")
            return None

    def upsert_university(self, university_data: Dict[str, Any]) -> Optional[Dict]:
        """
        Insert or update university (based on name and country)

        Args:
            university_data: University data dictionary

        Returns:
            Upserted university record or None if failed
        """
        try:
            # Check if exists
            existing = self.client.table('universities').select('*').eq(
                'name', university_data['name']
            ).eq(
                'country', university_data.get('country', 'USA')
            ).execute()

            if existing.data:
                # Update existing
                university_id = existing.data[0]['id']
                response = self.client.table('universities').update(
                    university_data
                ).eq('id', university_id).execute()

                if response.data:
                    logger.debug(f"Updated: {university_data['name']}")
                    return response.data[0]
            else:
                # Insert new
                response = self.client.table('universities').insert(university_data).execute()
                if response.data:
                    logger.debug(f"Inserted: {university_data['name']}")
                    return response.data[0]

            return None

        except Exception as e:
            logger.error(f"Error upserting university {university_data.get('name')}: {e}")
            return None

    def batch_upsert_universities(
        self,
        universities_data: List[Dict[str, Any]],
        batch_size: int = 100
    ) -> Dict[str, int]:
        """
        Batch insert/update universities

        Args:
            universities_data: List of university data dictionaries
            batch_size: Number of records to process at once

        Returns:
            Statistics dict with added, updated, failed counts
        """
        stats = {'added': 0, 'updated': 0, 'failed': 0, 'skipped': 0}

        for i in range(0, len(universities_data), batch_size):
            batch = universities_data[i:i + batch_size]

            for uni_data in batch:
                result = self.upsert_university(uni_data)

                if result:
                    # Check if it was an update or insert based on created_at vs updated_at
                    if result.get('created_at') == result.get('updated_at'):
                        stats['added'] += 1
                    else:
                        stats['updated'] += 1
                else:
                    stats['failed'] += 1

            logger.info(f"Processed batch {i//batch_size + 1}: {len(batch)} universities")

        logger.info(f"Batch upsert completed: {stats}")
        return stats

    def get_universities(
        self,
        country: Optional[str] = None,
        limit: int = 100,
        offset: int = 0
    ) -> List[Dict]:
        """
        Get universities with optional filtering

        Args:
            country: Filter by country code
            limit: Maximum number of results
            offset: Number of results to skip

        Returns:
            List of university records
        """
        try:
            query = self.client.table('universities').select('*')

            if country:
                query = query.eq('country', country)

            query = query.range(offset, offset + limit - 1)
            response = query.execute()

            return response.data if response.data else []

        except Exception as e:
            logger.error(f"Error fetching universities: {e}")
            return []

    def get_university_count(self, country: Optional[str] = None) -> int:
        """
        Get total count of universities

        Args:
            country: Optional country filter

        Returns:
            Number of universities
        """
        try:
            query = self.client.table('universities').select('id', count='exact')

            if country:
                query = query.eq('country', country)

            response = query.execute()
            return response.count if response.count else 0

        except Exception as e:
            logger.error(f"Error counting universities: {e}")
            return 0

    # ==================== Student Profile Methods ====================

    def insert_student_profile(self, profile_data: Dict[str, Any]) -> Optional[Dict]:
        """Insert student profile"""
        try:
            response = self.client.table('student_profiles').insert(profile_data).execute()
            return response.data[0] if response.data else None
        except Exception as e:
            logger.error(f"Error inserting student profile: {e}")
            return None

    def get_student_profile(self, user_id: str) -> Optional[Dict]:
        """Get student profile by user_id"""
        try:
            response = self.client.table('student_profiles').select('*').eq(
                'user_id', user_id
            ).execute()
            return response.data[0] if response.data else None
        except Exception as e:
            logger.error(f"Error fetching student profile: {e}")
            return None

    # ==================== Recommendation Methods ====================

    def insert_recommendation(self, recommendation_data: Dict[str, Any]) -> Optional[Dict]:
        """Insert recommendation"""
        try:
            response = self.client.table('recommendations').insert(recommendation_data).execute()
            return response.data[0] if response.data else None
        except Exception as e:
            logger.error(f"Error inserting recommendation: {e}")
            return None

    def get_recommendations_for_student(self, student_id: int, limit: int = 20) -> List[Dict]:
        """Get recommendations for a student"""
        try:
            response = self.client.table('recommendations').select(
                '*, university:universities(*)'
            ).eq('student_id', student_id).order(
                'match_score', desc=True
            ).limit(limit).execute()

            return response.data if response.data else []
        except Exception as e:
            logger.error(f"Error fetching recommendations: {e}")
            return []

    # ==================== Utility Methods ====================

    def test_connection(self) -> bool:
        """
        Test Supabase connection

        Returns:
            True if connection successful
        """
        try:
            # Try to fetch one university
            response = self.client.table('universities').select('id').limit(1).execute()
            logger.info("Supabase connection test successful")
            return True
        except Exception as e:
            logger.error(f"Supabase connection test failed: {e}")
            return False

    def get_table_count(self, table_name: str) -> int:
        """Get count of records in a table"""
        try:
            response = self.client.table(table_name).select('id', count='exact').execute()
            return response.count if response.count else 0
        except Exception as e:
            logger.error(f"Error counting {table_name}: {e}")
            return 0


# Singleton instance
def get_supabase_client() -> SupabaseClient:
    """Get or create Supabase client instance"""
    return SupabaseClient()
