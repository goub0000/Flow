"""
Find Your Path - University Recommendation Service
Main FastAPI Application - Cloud-Based (Supabase)
"""
# Load environment variables from .env file
from dotenv import load_dotenv
load_dotenv()

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager
import logging

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Database setup (Supabase)
from app.database.config import get_supabase

@asynccontextmanager
async def lifespan(app: FastAPI):
    """Lifecycle manager for startup and shutdown events"""
    logger.info("Starting Find Your Path Recommendation Service (Cloud-Based - v1.0.1)...")

    # Test Supabase connection
    try:
        db = get_supabase()
        response = db.table('universities').select('id', count='exact').limit(1).execute()
        logger.info(f"Connected to Supabase successfully! ({response.count} universities)")
    except Exception as e:
        logger.error(f"Failed to connect to Supabase: {e}")

    yield

    logger.info("Shutting down Find Your Path Recommendation Service...")

# Create FastAPI app
app = FastAPI(
    title="Find Your Path API",
    description="""
    **University Recommendation Service for Flow EdTech Platform**

    A comprehensive EdTech API providing:
    - JWT Authentication with Role-Based Access Control
    - University & Program Management
    - Application Tracking
    - Real-time Messaging & Notifications
    - Counseling Sessions
    - Parent Monitoring
    - Achievements & Gamification
    - ML-powered Recommendations

    **Features:**
    - Rate limiting for API protection
    - Comprehensive error handling
    - Health checks & monitoring
    - Supabase (PostgreSQL) backend
    - Real-time capabilities

    **Documentation:** Visit `/docs` for interactive API documentation
    """,
    version="1.0.0",
    lifespan=lifespan,
    docs_url="/docs",
    redoc_url="/redoc",
    openapi_url="/openapi.json"
)

# Configure CORS
# Allow multiple origins for development and production
import os
allowed_origins_env = os.environ.get("ALLOWED_ORIGINS", "")

# Base localhost origins for development
# Generate localhost origins for common Flutter web ports (8080-8100)
localhost_origins = []
for port in range(8080, 8101):
    localhost_origins.append(f"http://localhost:{port}")
    localhost_origins.append(f"http://127.0.0.1:{port}")

# Add common development ports
localhost_origins.extend([
    "http://localhost:3000",
    "http://localhost:3001",
    "http://127.0.0.1:3000",
    "http://127.0.0.1:3001",
])

if allowed_origins_env:
    # Production: Use configured origins + localhost for testing
    configured_origins = allowed_origins_env.split(",")
    allowed_origins = list(set(configured_origins + localhost_origins))
else:
    # Development: Use localhost origins only
    allowed_origins = localhost_origins

logger.info(f"CORS configured with {len(allowed_origins)} allowed origins")

app.add_middleware(
    CORSMiddleware,
    allow_origins=allowed_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Add middleware for error handling and rate limiting
from app.middleware import (
    limiter,
    http_exception_handler,
    validation_exception_handler,
    general_exception_handler,
    ErrorHandlingMiddleware
)
from fastapi.exceptions import RequestValidationError
from starlette.exceptions import HTTPException as StarletteHTTPException
from slowapi.errors import RateLimitExceeded

# Add rate limiting
app.state.limiter = limiter
app.add_exception_handler(RateLimitExceeded, http_exception_handler)

# Add error handlers
app.add_exception_handler(StarletteHTTPException, http_exception_handler)
app.add_exception_handler(RequestValidationError, validation_exception_handler)
app.add_exception_handler(Exception, general_exception_handler)

# Add timing and logging middleware
app.add_middleware(ErrorHandlingMiddleware)

# Import and include routers
# NOTE: All APIs now migrated to Supabase (Cloud-Based)
from app.api import (
    universities, students, recommendations, monitoring, admin, programs,
    enrichment, ml_training, location_cleaning, auth,
    applications_api, messaging_api, notifications_api,
    counseling_api, parent_monitoring_api, achievements_api, system_monitoring_api,
    test_debug  # TEMPORARY - DEBUG
)

app.include_router(auth.router, prefix="/api/v1", tags=["Authentication"])
app.include_router(applications_api.router, prefix="/api/v1", tags=["Applications"])
app.include_router(test_debug.router, prefix="/api/v1", tags=["Debug"])  # TEMPORARY
app.include_router(messaging_api.router, prefix="/api/v1", tags=["Messaging"])
app.include_router(notifications_api.router, prefix="/api/v1", tags=["Notifications"])
app.include_router(counseling_api.router, prefix="/api/v1", tags=["Counseling"])
app.include_router(parent_monitoring_api.router, prefix="/api/v1", tags=["Parent Monitoring"])
app.include_router(achievements_api.router, prefix="/api/v1", tags=["Achievements"])
app.include_router(students.router, prefix="/api/v1", tags=["Students"])
app.include_router(recommendations.router, prefix="/api/v1", tags=["Recommendations"])
app.include_router(universities.router, prefix="/api/v1", tags=["Universities"])
app.include_router(programs.router, prefix="/api/v1", tags=["Programs"])
app.include_router(enrichment.router, prefix="/api/v1", tags=["Enrichment"])
app.include_router(ml_training.router, prefix="/api/v1", tags=["ML Training"])
app.include_router(location_cleaning.router, prefix="/api/v1", tags=["Location Cleaning"])
app.include_router(monitoring.router, prefix="/api/v1", tags=["Monitoring"])
app.include_router(admin.router, prefix="/api/v1", tags=["Admin"])

# System monitoring and health checks (no /api/v1 prefix for standard health endpoints)
app.include_router(system_monitoring_api.router, tags=["System"])

@app.get("/")
async def root():
    """Health check endpoint"""
    return {
        "service": "Find Your Path API",
        "status": "running",
        "version": "1.0.0"
    }

@app.get("/health")
async def health_check():
    """Health check endpoint"""
    return {"status": "healthy"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("app.main:app", host="0.0.0.0", port=8000, reload=True)
