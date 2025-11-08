# API Test Suite

This directory contains automated tests for the Find Your Path API.

## Running Tests

### Run all tests
```bash
pytest
```

### Run specific test files
```bash
pytest tests/test_health_checks.py
```

### Run with coverage report
```bash
pytest --cov=app --cov-report=html
```

### Run only API tests
```bash
pytest -m api
```

### Run fast tests (exclude slow tests)
```bash
pytest -m "not slow"
```

## Test Structure

- `test_health_checks.py` - Health check and monitoring endpoint tests
- More test files can be added for each API module

## Test Markers

- `@pytest.mark.api` - API endpoint tests
- `@pytest.mark.unit` - Unit tests
- `@pytest.mark.integration` - Integration tests
- `@pytest.mark.slow` - Slow-running tests

## Writing Tests

Tests use:
- `pytest` for test framework
- `httpx.AsyncClient` for async API testing
- `pytest-asyncio` for async test support
- `pytest-cov` for coverage reports

Example test:
```python
@pytest.mark.api
@pytest.mark.asyncio
async def test_endpoint():
    async with AsyncClient(app=app, base_url="http://test") as client:
        response = await client.get("/endpoint")
        assert response.status_code == 200
```

## Coverage Reports

HTML coverage reports are generated in `htmlcov/` directory.
View by opening `htmlcov/index.html` in a browser.
