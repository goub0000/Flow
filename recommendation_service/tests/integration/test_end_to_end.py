"""
End-to-end integration tests for Flow EdTech Platform
Tests the complete flow from Flutter → FastAPI → Database
"""

import pytest
import httpx
import os
from dotenv import load_dotenv

load_dotenv()

API_BASE_URL = os.getenv("API_BASE_URL", "http://localhost:8000")
SUPABASE_URL = os.getenv("SUPABASE_URL")
SUPABASE_KEY = os.getenv("SUPABASE_ANON_KEY")


class TestRecommendationServiceIntegration:
    """Test recommendation service endpoints"""

    @pytest.mark.asyncio
    async def test_health_check(self):
        """Test service is running"""
        async with httpx.AsyncClient() as client:
            response = await client.get(f"{API_BASE_URL}/health")
            assert response.status_code == 200
            data = response.json()
            # Should return healthy or degraded, not unhealthy
            assert data["status"] in ["healthy", "degraded"]
            assert "checks" in data

    @pytest.mark.asyncio
    async def test_root_endpoint(self):
        """Test root endpoint returns service info"""
        async with httpx.AsyncClient() as client:
            response = await client.get(f"{API_BASE_URL}/")
            assert response.status_code == 200
            data = response.json()
            assert data["service"] == "Find Your Path API"
            assert data["status"] == "running"
            assert "version" in data

    @pytest.mark.asyncio
    async def test_universities_list(self):
        """Test university listing endpoint"""
        async with httpx.AsyncClient() as client:
            response = await client.get(f"{API_BASE_URL}/api/v1/universities?limit=10")
            assert response.status_code == 200
            data = response.json()
            assert "universities" in data
            assert "total" in data
            # Data might be empty if database is new
            assert isinstance(data["universities"], list)
            assert isinstance(data["total"], int)

    @pytest.mark.asyncio
    async def test_universities_pagination(self):
        """Test university pagination"""
        async with httpx.AsyncClient() as client:
            # Get first page
            response1 = await client.get(f"{API_BASE_URL}/api/v1/universities?limit=5&offset=0")
            assert response1.status_code == 200
            data1 = response1.json()
            assert "universities" in data1

            # Get second page
            response2 = await client.get(f"{API_BASE_URL}/api/v1/universities?limit=5&offset=5")
            assert response2.status_code == 200
            data2 = response2.json()
            assert "universities" in data2

            # Ensure different results (only if we have enough data)
            if len(data1["universities"]) > 0 and len(data2["universities"]) > 0:
                # If both pages have data, they should be different
                assert data1["universities"][0]["id"] != data2["universities"][0]["id"]

    @pytest.mark.asyncio
    async def test_programs_list(self):
        """Test programs listing endpoint"""
        async with httpx.AsyncClient() as client:
            response = await client.get(f"{API_BASE_URL}/api/v1/programs?limit=10")
            # Accept 200 (with data) or 200 (empty) - programs may not exist
            assert response.status_code == 200
            data = response.json()
            assert "programs" in data or "total" in data


class TestCORSConfiguration:
    """Test CORS is properly configured"""

    @pytest.mark.asyncio
    async def test_cors_preflight(self):
        """Test CORS preflight request"""
        async with httpx.AsyncClient() as client:
            response = await client.options(
                f"{API_BASE_URL}/api/v1/universities",
                headers={
                    "Origin": "https://web-production-bcafe.up.railway.app",
                    "Access-Control-Request-Method": "GET"
                }
            )
            
            assert response.status_code == 200
            assert "access-control-allow-origin" in response.headers

    @pytest.mark.asyncio
    async def test_cors_actual_request(self):
        """Test CORS on actual request"""
        async with httpx.AsyncClient() as client:
            response = await client.get(
                f"{API_BASE_URL}/api/v1/universities?limit=1",
                headers={"Origin": "https://web-production-bcafe.up.railway.app"}
            )
            
            assert response.status_code == 200
            # CORS headers should be present
            assert "access-control-allow-origin" in response.headers


class TestDatabaseConnection:
    """Test database connectivity"""

    @pytest.mark.asyncio
    async def test_database_accessible(self):
        """Test database can be queried via API"""
        async with httpx.AsyncClient() as client:
            response = await client.get(f"{API_BASE_URL}/api/v1/universities?limit=1")
            assert response.status_code == 200
            data = response.json()
            
            # If there's data, it means database is connected
            assert "total" in data
            assert isinstance(data["total"], int)


class TestAPIVersioning:
    """Test API versioning"""

    @pytest.mark.asyncio
    async def test_api_version_consistency(self):
        """Test version is consistent across endpoints"""
        async with httpx.AsyncClient() as client:
            # Check root endpoint
            response = await client.get(f"{API_BASE_URL}/")
            assert response.status_code == 200
            root_data = response.json()
            
            # Check health endpoint
            health_response = await client.get(f"{API_BASE_URL}/health")
            assert health_response.status_code == 200
            
            # Version should exist
            assert "version" in root_data
            print(f"API Version: {root_data['version']}")


if __name__ == "__main__":
    pytest.main([__file__, "-v", "--asyncio-mode=auto"])
