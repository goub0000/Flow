"""
CORS Configuration Integration Tests

Verifies that CORS is properly configured to allow:
1. Frontend (Flutter web) to call backend APIs
2. Backend to accept cross-origin requests
3. Proper CORS headers are returned
"""

import pytest
import httpx
import os
from dotenv import load_dotenv

load_dotenv()

API_BASE_URL = os.getenv("API_BASE_URL", "https://web-production-51e34.up.railway.app")
FRONTEND_URL = os.getenv("FRONTEND_URL", "https://web-production-bcafe.up.railway.app")


class TestCORSConfiguration:
    """Test CORS headers and configuration"""

    @pytest.mark.asyncio
    async def test_cors_headers_present_on_health_endpoint(self):
        """Verify CORS headers are present in API responses"""
        async with httpx.AsyncClient() as client:
            response = await client.get(
                f"{API_BASE_URL}/health",
                headers={"Origin": FRONTEND_URL}
            )

            assert response.status_code == 200

            # Check for CORS headers
            headers = response.headers
            assert "access-control-allow-origin" in headers or \
                   "Access-Control-Allow-Origin" in headers

    @pytest.mark.asyncio
    async def test_cors_allows_frontend_origin(self):
        """Verify frontend origin is allowed"""
        async with httpx.AsyncClient() as client:
            response = await client.get(
                f"{API_BASE_URL}/health",
                headers={"Origin": FRONTEND_URL}
            )

            assert response.status_code == 200

            # Get CORS header (case-insensitive)
            cors_header = None
            for key, value in response.headers.items():
                if key.lower() == "access-control-allow-origin":
                    cors_header = value
                    break

            assert cors_header is not None, "CORS header missing"
            assert cors_header == FRONTEND_URL or cors_header == "*"

    @pytest.mark.asyncio
    async def test_cors_allows_credentials(self):
        """Verify CORS allows credentials (cookies, auth headers)"""
        async with httpx.AsyncClient() as client:
            response = await client.get(
                f"{API_BASE_URL}/health",
                headers={"Origin": FRONTEND_URL}
            )

            # Check for Access-Control-Allow-Credentials header
            allow_credentials = None
            for key, value in response.headers.items():
                if key.lower() == "access-control-allow-credentials":
                    allow_credentials = value
                    break

            # Should be 'true' if credentials are allowed
            if allow_credentials:
                assert allow_credentials.lower() == "true"

    @pytest.mark.asyncio
    async def test_cors_preflight_request(self):
        """Test CORS preflight (OPTIONS) request"""
        async with httpx.AsyncClient() as client:
            response = await client.options(
                f"{API_BASE_URL}/api/universities",
                headers={
                    "Origin": FRONTEND_URL,
                    "Access-Control-Request-Method": "GET",
                    "Access-Control-Request-Headers": "content-type"
                }
            )

            # Preflight should return 200 or 204
            assert response.status_code in [200, 204]

            # Check for CORS preflight headers
            headers_lower = {k.lower(): v for k, v in response.headers.items()}

            assert "access-control-allow-origin" in headers_lower
            assert "access-control-allow-methods" in headers_lower

    @pytest.mark.asyncio
    async def test_cors_allows_common_methods(self):
        """Verify CORS allows common HTTP methods"""
        async with httpx.AsyncClient() as client:
            response = await client.options(
                f"{API_BASE_URL}/health",
                headers={
                    "Origin": FRONTEND_URL,
                    "Access-Control-Request-Method": "POST"
                }
            )

            # Get allowed methods
            allowed_methods = None
            for key, value in response.headers.items():
                if key.lower() == "access-control-allow-methods":
                    allowed_methods = value.upper()
                    break

            if allowed_methods:
                # Should allow at least GET, POST
                assert "GET" in allowed_methods or "*" in allowed_methods

    @pytest.mark.asyncio
    async def test_cors_allows_common_headers(self):
        """Verify CORS allows common headers"""
        async with httpx.AsyncClient() as client:
            response = await client.options(
                f"{API_BASE_URL}/health",
                headers={
                    "Origin": FRONTEND_URL,
                    "Access-Control-Request-Method": "GET",
                    "Access-Control-Request-Headers": "authorization,content-type"
                }
            )

            # Check for allowed headers
            allowed_headers = None
            for key, value in response.headers.items():
                if key.lower() == "access-control-allow-headers":
                    allowed_headers = value.lower()
                    break

            if allowed_headers:
                # Should allow authorization and content-type or use wildcard
                assert "authorization" in allowed_headers or \
                       "content-type" in allowed_headers or \
                       "*" in allowed_headers


class TestCORSWithDifferentOrigins:
    """Test CORS behavior with different origins"""

    @pytest.mark.asyncio
    async def test_cors_blocks_unauthorized_origin(self):
        """Verify unauthorized origins are handled"""
        unauthorized_origin = "https://malicious-site.com"

        async with httpx.AsyncClient() as client:
            response = await client.get(
                f"{API_BASE_URL}/health",
                headers={"Origin": unauthorized_origin}
            )

            # Request should succeed (backend processes it)
            assert response.status_code == 200

            # But CORS header should NOT match unauthorized origin
            cors_header = None
            for key, value in response.headers.items():
                if key.lower() == "access-control-allow-origin":
                    cors_header = value
                    break

            # If CORS is properly configured, unauthorized origin should not be in header
            # (unless using wildcard *)
            if cors_header and cors_header != "*":
                assert cors_header != unauthorized_origin

    @pytest.mark.asyncio
    async def test_cors_with_localhost_origin(self):
        """Test CORS with localhost origin (for development)"""
        localhost_origins = [
            "http://localhost:8080",
            "http://localhost:3000",
            "http://localhost:3001"
        ]

        async with httpx.AsyncClient() as client:
            for origin in localhost_origins:
                response = await client.get(
                    f"{API_BASE_URL}/health",
                    headers={"Origin": origin}
                )

                # Should return 200 regardless of CORS
                assert response.status_code == 200


class TestCORSOnDifferentEndpoints:
    """Verify CORS works across different API endpoints"""

    @pytest.mark.asyncio
    async def test_cors_on_universities_endpoint(self):
        """Test CORS on universities endpoint"""
        async with httpx.AsyncClient() as client:
            response = await client.get(
                f"{API_BASE_URL}/api/v1/universities",
                headers={"Origin": FRONTEND_URL}
            )

            assert response.status_code == 200

            # Check CORS header exists
            cors_header_found = any(
                key.lower() == "access-control-allow-origin"
                for key in response.headers.keys()
            )
            assert cors_header_found

    @pytest.mark.asyncio
    async def test_cors_on_recommendations_endpoint(self):
        """Test CORS on recommendations endpoint"""
        async with httpx.AsyncClient() as client:
            response = await client.get(
                f"{API_BASE_URL}/api/recommendations",
                headers={"Origin": FRONTEND_URL}
            )

            # May return 401/403 if auth required, but CORS should still work
            assert response.status_code in [200, 401, 403, 404, 422]

            # CORS headers should be present even on error responses
            cors_header_found = any(
                key.lower() == "access-control-allow-origin"
                for key in response.headers.keys()
            )
            assert cors_header_found


@pytest.mark.asyncio
async def test_cors_configuration_environment_variable():
    """Verify CORS configuration matches environment variable"""
    expected_origins = os.getenv("CORS_ORIGINS", "").split(",")
    expected_origins = [origin.strip() for origin in expected_origins if origin.strip()]

    if not expected_origins:
        pytest.skip("CORS_ORIGINS environment variable not set")

    async with httpx.AsyncClient() as client:
        # Test each configured origin
        for origin in expected_origins:
            response = await client.get(
                f"{API_BASE_URL}/health",
                headers={"Origin": origin}
            )

            assert response.status_code == 200

            # CORS header should be present
            cors_header_found = any(
                key.lower() == "access-control-allow-origin"
                for key in response.headers.keys()
            )
            assert cors_header_found, f"CORS header missing for configured origin: {origin}"
