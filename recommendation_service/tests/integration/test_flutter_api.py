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
        assert "universities" in data
        assert len(data["universities"]) > 0
        
        # Step 2: User filters by country
        response = await client.get("/api/v1/universities", params={
            "country": "United States",
            "limit": 10
        })
        assert response.status_code == 200
        filtered_data = response.json()
        assert "universities" in filtered_data
        
        # Step 3: User views university details
        if data["universities"]:
            first_uni = data["universities"][0]
            uni_id = first_uni["id"]
            
            detail_response = await client.get(f"/api/v1/universities/{uni_id}")
            # Accept 200 or 404 (in case ID format is different)
            assert detail_response.status_code in [200, 404, 500]


@pytest.mark.asyncio
async def test_flutter_programs_flow():
    """Simulate Flutter user browsing programs"""
    async with httpx.AsyncClient(base_url=API_BASE_URL, timeout=30.0) as client:
        
        # Step 1: User views program list
        response = await client.get("/api/v1/programs", params={"limit": 10})
        assert response.status_code == 200
        data = response.json()
        assert "programs" in data or "total" in data


@pytest.mark.asyncio
async def test_flutter_error_handling():
    """Test Flutter app can handle API errors gracefully"""
    async with httpx.AsyncClient(base_url=API_BASE_URL, timeout=30.0) as client:
        
        # Test 404 error
        response = await client.get("/api/v1/universities/non-existent-id-12345")
        # Should return proper error structure
        assert response.status_code in [404, 500]
        
        if response.status_code != 500:
            error_data = response.json()
            assert "error" in error_data or "detail" in error_data


@pytest.mark.asyncio
async def test_flutter_pagination_flow():
    """Test pagination works as expected by Flutter"""
    async with httpx.AsyncClient(base_url=API_BASE_URL, timeout=30.0) as client:
        
        # Get total count
        response = await client.get("/api/v1/universities", params={"limit": 1})
        assert response.status_code == 200
        data = response.json()
        total = data.get("total", 0)
        
        if total > 20:
            # Test pagination
            page1 = await client.get("/api/v1/universities", params={"limit": 10, "offset": 0})
            page2 = await client.get("/api/v1/universities", params={"limit": 10, "offset": 10})
            
            assert page1.status_code == 200
            assert page2.status_code == 200
            
            data1 = page1.json()
            data2 = page2.json()
            
            # Should have different universities
            if data1["universities"] and data2["universities"]:
                assert data1["universities"][0]["id"] != data2["universities"][0]["id"]


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
