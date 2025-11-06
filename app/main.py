"""
Find Your Path - University Recommendation Service
Main FastAPI Application - Cloud-Based (Supabase)
"""
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
    logger.info("Starting Find Your Path Recommendation Service (Cloud-Based)...")

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
    description="University Recommendation Service for Flow EdTech Platform",
    version="1.0.0",
    lifespan=lifespan
)

# Configure CORS
# Allow multiple origins for development and production
import os
allowed_origins_env = os.environ.get("ALLOWED_ORIGINS", "")
if allowed_origins_env:
    allowed_origins = allowed_origins_env.split(",")
else:
    # Development: Allow all localhost/127.0.0.1 ports
    allowed_origins = ["*"]

app.add_middleware(
    CORSMiddleware,
    allow_origins=allowed_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Import and include routers
# NOTE: All APIs now migrated to Supabase (Cloud-Based)
from app.api import (
    universities, students, recommendations, monitoring, admin, programs,
    enrichment, ml_training, location_cleaning, auth, courses_api,
    applications_api, enrollments_api, messaging_api, notifications_api,
    counseling_api, parent_monitoring_api, achievements_api
)

app.include_router(auth.router, prefix="/api/v1", tags=["Authentication"])
app.include_router(courses_api.router, prefix="/api/v1", tags=["Courses"])
app.include_router(applications_api.router, prefix="/api/v1", tags=["Applications"])
app.include_router(enrollments_api.router, prefix="/api/v1", tags=["Enrollments"])
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
