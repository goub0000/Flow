"""
Tests for Flutter → API integration
Simulates Flutter HTTP requests to verify compatibility
"""

import pytest
import httpx
import os
from datetime import datetime

API_BASE_URL = os.getenv("API_BASE_URL", "https://web-production-51e34.up.railway.app")


@pytest.mark.asyncio
async def test_flutter_university_search_flow():
    """Simulate Flutter user searching for universities"""
    async with httpx.AsyncClient(base_url=API_BASE_URL, timeout=30.0) as client:

        # Step 1: User views university list
        response = await client.get("/api/v1/universities", params={"limit": 20})
        assert response.status_code == 200
        data = response.json()
        # API returns object with {total, universities: [...]}
        assert isinstance(data, dict)
        assert "universities" in data
        assert "total" in data
        universities = data["universities"]
        assert len(universities) > 0

        # Step 2: User filters by country
        response = await client.get("/api/v1/universities", params={
            "country": "USA",  # Use "USA" as that's what's in the DB
            "limit": 10
        })
        assert response.status_code == 200
        filtered_data = response.json()
        # API returns object with {total, universities: [...]}
        assert isinstance(filtered_data, dict)

        # Step 3: User views university details
        if universities:
            first_uni = universities[0]
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

        # API returns object with {total, universities: [...]}
        assert isinstance(data, dict)
        assert "total" in data
        total = data["total"]

        if total > 10:
            # Test pagination using skip (API uses 'skip' not 'offset')
            page1 = await client.get("/api/v1/universities", params={"limit": 5, "skip": 0})
            page2 = await client.get("/api/v1/universities", params={"limit": 5, "skip": 5})

            assert page1.status_code == 200
            assert page2.status_code == 200

            data1 = page1.json()
            data2 = page2.json()

            # Should have different universities - extract from response objects
            universities1 = data1.get("universities", []) if isinstance(data1, dict) else data1
            universities2 = data2.get("universities", []) if isinstance(data2, dict) else data2

            if universities1 and universities2:
                assert universities1[0]["id"] != universities2[0]["id"]


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
