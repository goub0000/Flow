"""
Find Your Path - University Recommendation Service
Main FastAPI Application
"""
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager
import logging

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Database setup
from app.database.config import Base, engine, SessionLocal

# Import models and seed data
from app.models import university
from app.database import seed_data

@asynccontextmanager
async def lifespan(app: FastAPI):
    """Lifecycle manager for startup and shutdown events"""
    logger.info("Starting Find Your Path Recommendation Service...")

    # Create database tables
    Base.metadata.create_all(bind=engine)
    logger.info("Database tables created")

    # Load seed data
    try:
        seed_data.load_seed_data()
        logger.info("Seed data loaded successfully")
    except Exception as e:
        logger.warning(f"Seed data loading skipped: {e}")

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
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:8080", "http://127.0.0.1:8080"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Import and include routers
from app.api import students, recommendations, universities

app.include_router(students.router, prefix="/api/v1", tags=["Students"])
app.include_router(recommendations.router, prefix="/api/v1", tags=["Recommendations"])
app.include_router(universities.router, prefix="/api/v1", tags=["Universities"])

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

# Dependency to get database session
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("app.main:app", host="0.0.0.0", port=8000, reload=True)
