"""
Test Health Check Endpoints
"""
import pytest
from httpx import AsyncClient
from app.main import app


@pytest.mark.api
@pytest.mark.asyncio
async def test_root_endpoint():
    """Test root endpoint"""
    async with AsyncClient(app=app, base_url="http://test") as client:
        response = await client.get("/")
        assert response.status_code == 200
        data = response.json()
        assert data["service"] == "Find Your Path API"
        assert data["status"] == "running"


@pytest.mark.api
@pytest.mark.asyncio
async def test_health_check():
    """Test health check endpoint"""
    async with AsyncClient(app=app, base_url="http://test") as client:
        response = await client.get("/health")
        assert response.status_code == 200
        data = response.json()
        assert "status" in data
        assert data["status"] in ["healthy", "degraded", "unhealthy"]
        assert "timestamp" in data
        assert "version" in data
        assert "checks" in data


@pytest.mark.api
@pytest.mark.asyncio
async def test_liveness_check():
    """Test liveness check endpoint"""
    async with AsyncClient(app=app, base_url="http://test") as client:
        response = await client.get("/health/live")
        assert response.status_code == 200
        data = response.json()
        assert data["status"] == "alive"


@pytest.mark.api
@pytest.mark.asyncio
async def test_readiness_check():
    """Test readiness check endpoint"""
    async with AsyncClient(app=app, base_url="http://test") as client:
        response = await client.get("/health/ready")
        # May be 200 or 503 depending on database connection
        assert response.status_code in [200, 503]


@pytest.mark.api
@pytest.mark.asyncio
async def test_api_info():
    """Test API info endpoint"""
    async with AsyncClient(app=app, base_url="http://test") as client:
        response = await client.get("/info")
        assert response.status_code == 200
        data = response.json()
        assert data["name"] == "Find Your Path API"
        assert "version" in data
        assert "features" in data
        assert isinstance(data["features"], list)
        assert len(data["features"]) > 0


@pytest.mark.api
@pytest.mark.asyncio
async def test_swagger_docs():
    """Test that Swagger documentation is accessible"""
    async with AsyncClient(app=app, base_url="http://test") as client:
        response = await client.get("/docs")
        assert response.status_code == 200


@pytest.mark.api
@pytest.mark.asyncio
async def test_openapi_schema():
    """Test that OpenAPI schema is accessible"""
    async with AsyncClient(app=app, base_url="http://test") as client:
        response = await client.get("/openapi.json")
        assert response.status_code == 200
        data = response.json()
        assert "openapi" in data
        assert data["info"]["title"] == "Find Your Path API"
