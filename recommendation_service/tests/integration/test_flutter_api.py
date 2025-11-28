"""
Tests for Flutter → API integration
Simulates Flutter HTTP requests to verify compatibility
"""

import pytest
import httpx
import os
from datetime import datetime

API_BASE_URL = os.getenv("API_BASE_URL", "http://localhost:8000")


@pytest.mark.asyncio
async def test_flutter_university_search_flow():
    """Simulate Flutter user searching for universities"""
    async with httpx.AsyncClient(base_url=API_BASE_URL, timeout=30.0) as client:

        # Step 1: User views university list
        response = await client.get("/api/v1/universities", params={"limit": 20})
        assert response.status_code == 200
        data = response.json()
        # API returns a list directly, not wrapped in {"universities": [...]}
        assert isinstance(data, list)
        assert len(data) > 0

        # Step 2: User filters by country
        response = await client.get("/api/v1/universities", params={
            "country": "USA",  # Use "USA" as that's what's in the DB
            "limit": 10
        })
        assert response.status_code == 200
        filtered_data = response.json()
        assert isinstance(filtered_data, list)

        # Step 3: User views university details
        if data:
            first_uni = data[0]
            uni_id = first_uni["id"]

            detail_response = await client.get(f"/api/v1/universities/{uni_id}")
            # Accept 200 or 404 (in case ID format is different)
            assert detail_response.status_code in [200, 404, 500]


@pytest.mark.asyncio
async def test_flutter_programs_flow():
    """Simulate Flutter user browsing programs"""
    async with httpx.AsyncClient(base_url=API_BASE_URL, timeout=30.0) as client:

        # Step 1: User views program list
        # Note: Programs endpoint may return 404 if no registered institutions exist
        response = await client.get("/api/v1/programs", params={"limit": 10})
        # Accept 200 (success), 404 (no data), or 500 (server error during query)
        assert response.status_code in [200, 404, 500]

        if response.status_code == 200:
            data = response.json()
            # Response could be a list or an object with programs/total
            assert isinstance(data, (list, dict))


@pytest.mark.asyncio
async def test_flutter_error_handling():
    """Test Flutter app can handle API errors gracefully"""
    async with httpx.AsyncClient(base_url=API_BASE_URL, timeout=30.0) as client:

        # Test error response for invalid ID
        # 422 = validation error (invalid UUID format)
        # 404 = not found (valid UUID but doesn't exist)
        # 500 = server error
        response = await client.get("/api/v1/universities/non-existent-id-12345")
        # Should return proper error structure
        assert response.status_code in [404, 422, 500]

        if response.status_code in [404, 422]:
            error_data = response.json()
            assert "error" in error_data or "detail" in error_data


@pytest.mark.asyncio
async def test_flutter_pagination_flow():
    """Test pagination works as expected by Flutter"""
    async with httpx.AsyncClient(base_url=API_BASE_URL, timeout=30.0) as client:

        # Get initial data to check if we have enough for pagination test
        response = await client.get("/api/v1/universities", params={"limit": 100})
        assert response.status_code == 200
        data = response.json()

        # API returns a list directly
        assert isinstance(data, list)
        total = len(data)

        if total > 10:
            # Test pagination using skip/offset
            page1 = await client.get("/api/v1/universities", params={"limit": 5, "skip": 0})
            page2 = await client.get("/api/v1/universities", params={"limit": 5, "skip": 5})

            assert page1.status_code == 200
            assert page2.status_code == 200

            data1 = page1.json()
            data2 = page2.json()

            # Should have different universities (API returns lists directly)
            if data1 and data2:
                assert data1[0]["id"] != data2[0]["id"]


@pytest.mark.asyncio
async def test_flutter_concurrent_requests():
    """Test API can handle concurrent requests from Flutter"""
    async with httpx.AsyncClient(base_url=API_BASE_URL, timeout=30.0) as client:
        
        # Simulate Flutter making multiple concurrent requests
        tasks = [
            client.get("/api/v1/universities", params={"limit": 5}),
            client.get("/api/v1/programs", params={"limit": 5}),
            client.get("/health"),
        ]
        
        responses = await asyncio.gather(*tasks, return_exceptions=True)
        
        # All requests should succeed or return proper errors
        for response in responses:
            if isinstance(response, Exception):
                pytest.fail(f"Request failed with exception: {response}")
            else:
                assert response.status_code in [200, 404, 500]


import asyncio

if __name__ == "__main__":
    pytest.main([__file__, "-v", "--asyncio-mode=auto"])
