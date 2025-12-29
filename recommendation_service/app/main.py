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

# Initialize monitoring (Sentry)
from app.monitoring import init_sentry
sentry_enabled = init_sentry()
if sentry_enabled:
    logger.info("Sentry error tracking enabled")

# Database setup (Supabase)
from app.database.config import get_supabase

@asynccontextmanager
async def lifespan(app: FastAPI):
    """Lifecycle manager for startup and shutdown events"""
    logger.info("Starting Find Your Path Recommendation Service (Cloud-Based - v1.2.0)...")

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
    # University Recommendation Service for Flow EdTech Platform

    A comprehensive cloud-based EdTech API providing personalized university recommendations
    and complete student lifecycle management.

    ## 🎯 Core Features

    ### Authentication & Authorization
    - **JWT-based authentication** with role-based access control (RBAC)
    - Support for multiple roles: Student, Institution, Parent, Counselor, Admin
    - Secure token management and refresh capabilities

    ### University & Program Discovery
    - **17,000+ universities** from around the world
    - Advanced filtering by location, cost, programs, rankings
    - Full-text search across universities and programs
    - Detailed institution profiles with admissions data

    ### Smart Recommendations
    - **ML-powered recommendation engine** using LightGBM
    - Personalized matches based on academic profile, preferences, and budget
    - Safety/Match/Reach categorization
    - Continuous learning from user interactions

    ### Application Management
    - Track applications across multiple universities
    - Document upload and management
    - Status tracking and notifications
    - Deadline reminders

    ### Educational Platform
    - Course management and enrollment
    - Grade tracking and GPA calculation
    - Parent monitoring and progress reports
    - Achievement system and gamification

    ### Communication
    - Real-time messaging between students, counselors, and institutions
    - Notification system (email, push, in-app)
    - Meeting scheduling for counseling sessions
    - Recommendation letter requests

    ## 🔒 Security

    - Rate limiting on all endpoints
    - CORS configuration for cross-origin requests
    - Secure password hashing with bcrypt
    - Input validation and sanitization
    - SQL injection protection

    ## 📊 Monitoring

    - **Sentry integration** for error tracking
    - **Prometheus metrics** at `/metrics`
    - Health check endpoints at `/health`
    - Detailed logging and tracing

    ## 🚀 Performance

    - Cloud-based architecture with Supabase (PostgreSQL)
    - Redis caching for frequently accessed data
    - Optimized database queries with 50+ indexes
    - Async/await for non-blocking operations
    - Connection pooling for database efficiency

    ## 📖 Getting Started

    1. **Authentication**: Start with `/api/v1/auth/register` or `/api/v1/auth/login`
    2. **Profile Setup**: Complete your profile at `/api/v1/students/profile`
    3. **Get Recommendations**: Generate recommendations at `/api/v1/recommendations/generate`
    4. **Explore Universities**: Search universities at `/api/v1/universities`

    ## 📞 Support

    For API support or to report issues, please contact:
    - Email: support@flowedtech.com
    - Documentation: Visit `/docs` for interactive API testing

    ## 🔗 Related Resources

    - Interactive API Docs: `/docs` (Swagger UI)
    - Alternative Docs: `/redoc` (ReDoc)
    - OpenAPI Schema: `/openapi.json`
    - Health Check: `/health`
    - Metrics: `/metrics` (Prometheus)

    ---
    **Version**: 1.2.3 | **Environment**: Production | **Last Updated**: December 2025
    """,
    version="1.2.3",
    lifespan=lifespan,
    docs_url="/docs",
    redoc_url="/redoc",
    openapi_url="/openapi.json",
    contact={
        "name": "Flow EdTech Support Team",
        "email": "support@flowedtech.com",
        "url": "https://flowedtech.com/support"
    },
    license_info={
        "name": "Proprietary",
        "url": "https://flowedtech.com/terms"
    },
    terms_of_service="https://flowedtech.com/terms",
    openapi_tags=[
        {
            "name": "Authentication",
            "description": "User authentication, registration, and token management"
        },
        {
            "name": "Students",
            "description": "Student profile management and data"
        },
        {
            "name": "Universities",
            "description": "University search, filtering, and details"
        },
        {
            "name": "Recommendations",
            "description": "ML-powered personalized university recommendations"
        },
        {
            "name": "Applications",
            "description": "Application submission and tracking"
        },
        {
            "name": "Institutions",
            "description": "Institution management and administration"
        },
        {
            "name": "Courses",
            "description": "Course creation, management, and enrollment"
        },
        {
            "name": "Enrollments",
            "description": "Student enrollment and progress tracking"
        },
        {
            "name": "Messaging",
            "description": "Real-time messaging and conversations"
        },
        {
            "name": "Notifications",
            "description": "Notification management and delivery"
        },
        {
            "name": "Counseling",
            "description": "Counseling sessions and meetings"
        },
        {
            "name": "Parent Monitoring",
            "description": "Parent access to student progress and activities"
        },
        {
            "name": "Achievements",
            "description": "Gamification and achievement tracking"
        },
        {
            "name": "Grades",
            "description": "Grade management and GPA calculation"
        },
        {
            "name": "Monitoring",
            "description": "System health checks and monitoring"
        },
        {
            "name": "Admin",
            "description": "Administrative operations and management"
        }
    ]
)

# Configure CORS origins (middleware will be added after other middleware)
import os

# Get CORS origins from environment variable with production defaults
# In production, Railway will use these defaults or you can override via CORS_ORIGINS
allowed_origins = os.getenv(
    "CORS_ORIGINS",
    "https://web-production-bcafe.up.railway.app,https://web-production-51e34.up.railway.app,http://localhost:8080,http://localhost:3000,http://localhost:3001,http://localhost:5173"
).split(",")

# Strip whitespace from origins
allowed_origins = [origin.strip() for origin in allowed_origins]

logger.info(f"CORS configured with {len(allowed_origins)} allowed origins: {allowed_origins}")

# NOTE: CORS middleware is added AFTER all other middleware (see below)
# This ensures CORS headers are added to ALL responses, including error responses

# Add middleware for error handling, rate limiting, and security
from app.middleware import (
    limiter,
    ErrorHandlingMiddleware,
    SecurityHeadersMiddleware,
    log_security_headers_status
)
from slowapi.errors import RateLimitExceeded

# Import exception handlers
from app.exception_handlers import (
    custom_exception_handler,
    http_exception_handler,
    validation_exception_handler,
    general_exception_handler
)
from app.exceptions import BaseAPIException
from fastapi.exceptions import RequestValidationError
from starlette.exceptions import HTTPException as StarletteHTTPException

# Add rate limiting
app.state.limiter = limiter
app.add_exception_handler(RateLimitExceeded, http_exception_handler)

# Add error handlers (order matters - most specific first)
app.add_exception_handler(BaseAPIException, custom_exception_handler)
app.add_exception_handler(StarletteHTTPException, http_exception_handler)
app.add_exception_handler(RequestValidationError, validation_exception_handler)
app.add_exception_handler(Exception, general_exception_handler)

# Initialize Prometheus metrics
from app.monitoring import init_prometheus, create_metrics_middleware
prometheus_enabled = init_prometheus(app)
if prometheus_enabled:
    logger.info("Prometheus metrics enabled at /metrics")

# Add security headers middleware (MUST be added before other middleware)
app.add_middleware(SecurityHeadersMiddleware)
log_security_headers_status()

# Add metrics collection middleware
if prometheus_enabled:
    MetricsMiddleware = create_metrics_middleware()
    app.add_middleware(MetricsMiddleware)

# Add timing and logging middleware
app.add_middleware(ErrorHandlingMiddleware)

# Add CORS middleware LAST - this makes it the OUTERMOST middleware
# This ensures CORS headers are added to ALL responses, including error responses
# Critical for proper handling of preflight requests and error scenarios
app.add_middleware(
    CORSMiddleware,
    allow_origins=allowed_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
logger.info("CORS middleware added as outermost layer")

# Import and include routers
# NOTE: All APIs now migrated to Supabase (Cloud-Based)
from app.api import (
    universities, students, recommendations, monitoring, admin, programs,
    enrichment, ml_training, location_cleaning, auth, courses_api,
    applications, enrollments_api, messaging_api, notifications_api,
    counseling_api, parent_monitoring_api, achievements_api, system_monitoring_api,
    institutions_api, batch_enrichment_api, meetings, student_activities_api, grades,
    recommendation_letters, consent_api, institution_debug_api, course_content
)

app.include_router(auth.router, prefix="/api/v1", tags=["Authentication"])
app.include_router(consent_api.router, prefix="/api/v1", tags=["Consent"])
app.include_router(institutions_api.router, prefix="/api/v1", tags=["Institutions"])
app.include_router(institution_debug_api.router, prefix="/api/v1", tags=["Institution Debug"])
app.include_router(courses_api.router, prefix="/api/v1", tags=["Courses"])  # Re-enabled for compatibility
app.include_router(course_content.router, prefix="/api/v1/course-content", tags=["Course Content"])
app.include_router(applications.router, prefix="/api/v1", tags=["Applications"])
app.include_router(enrollments_api.router, prefix="/api/v1", tags=["Enrollments"])
app.include_router(messaging_api.router, prefix="/api/v1/messages", tags=["Messaging"])
app.include_router(notifications_api.router, prefix="/api/v1", tags=["Notifications"])
app.include_router(counseling_api.router, prefix="/api/v1", tags=["Counseling"])
app.include_router(parent_monitoring_api.router, prefix="/api/v1", tags=["Parent Monitoring"])
app.include_router(achievements_api.router, prefix="/api/v1", tags=["Achievements"])
app.include_router(meetings.router, prefix="/api/v1", tags=["Meetings"])
app.include_router(students.router, prefix="/api/v1", tags=["Students"])
app.include_router(student_activities_api.router, prefix="/api/v1", tags=["Student Activities"])
app.include_router(grades.router, prefix="/api/v1", tags=["Grades"])
app.include_router(recommendation_letters.router, prefix="/api/v1", tags=["Recommendation Letters"])
app.include_router(recommendations.router, prefix="/api/v1", tags=["Recommendations"])
app.include_router(universities.router, prefix="/api/v1", tags=["Universities"])
app.include_router(programs.router, prefix="/api/v1", tags=["Programs"])
app.include_router(enrichment.router, prefix="/api/v1", tags=["Enrichment"])
app.include_router(batch_enrichment_api.router, prefix="/api/v1/batch", tags=["Batch Processing"])
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
        "version": "1.2.0"
    }

@app.get("/health")
async def health_check():
    """Health check endpoint"""
    return {"status": "healthy"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("app.main:app", host="0.0.0.0", port=8000, reload=True)
