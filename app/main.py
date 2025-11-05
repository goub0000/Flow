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
allowed_origins = os.environ.get("ALLOWED_ORIGINS", "http://localhost:8080,http://127.0.0.1:8080").split(",")

app.add_middleware(
    CORSMiddleware,
    allow_origins=allowed_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Import and include routers
# NOTE: All APIs now migrated to Supabase (Cloud-Based)
from app.api import universities, students, recommendations, monitoring, admin, programs, enrichment

app.include_router(students.router, prefix="/api/v1", tags=["Students"])
app.include_router(recommendations.router, prefix="/api/v1", tags=["Recommendations"])
app.include_router(universities.router, prefix="/api/v1", tags=["Universities"])
app.include_router(programs.router, prefix="/api/v1", tags=["Programs"])
app.include_router(enrichment.router, prefix="/api/v1", tags=["Enrichment"])
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
