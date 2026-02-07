"""
System Monitoring API
Enhanced health checks, metrics, and system status endpoints
"""
from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel
from typing import Dict, Any, Optional
from datetime import datetime
import sys
import os
import psutil
import logging

from app.database.config import get_supabase, get_supabase_admin
from app.utils.security import RoleChecker, UserRole, CurrentUser
from app.cache.redis_cache import cache

router = APIRouter()
logger = logging.getLogger(__name__)


class HealthStatus(BaseModel):
    """Health check response"""
    status: str  # "healthy", "degraded", "unhealthy"
    timestamp: str
    version: str
    environment: str
    checks: Dict[str, Any]


class SystemMetrics(BaseModel):
    """System resource metrics"""
    cpu_percent: float
    memory_percent: float
    memory_used_mb: float
    memory_total_mb: float
    disk_percent: float
    disk_used_gb: float
    disk_total_gb: float
    process_memory_mb: float
    uptime_seconds: float


class DetailedHealth(BaseModel):
    """Detailed system health"""
    status: str
    timestamp: str
    version: str
    python_version: str
    environment: str
    database: Dict[str, Any]
    system: SystemMetrics
    api_stats: Dict[str, Any]


@router.get("/health", response_model=HealthStatus, tags=["System"])
async def health_check():
    """
    Quick health check endpoint

    **Returns:**
    - status: healthy/degraded/unhealthy
    - timestamp: Current server time
    - version: API version
    - checks: Status of key services

    **Note:** This is a lightweight check for load balancers/monitoring
    """
    checks = {}
    overall_status = "healthy"

    # Check database connection
    try:
        db = get_supabase_admin()  # Use admin client for data access
        db.table('users').select('id').limit(1).execute()
        checks["database"] = "connected"
    except Exception as e:
        checks["database"] = f"error: {str(e)[:50]}"
        overall_status = "degraded"

    # Check system resources
    try:
        memory_percent = psutil.virtual_memory().percent
        if memory_percent > 90:
            checks["memory"] = f"high: {memory_percent}%"
            overall_status = "degraded"
        else:
            checks["memory"] = "ok"
    except:
        checks["memory"] = "unknown"

    # Check Redis cache
    try:
        cache_health = cache.health_check()
        checks["cache"] = cache_health.get("status", "unknown")
        if cache_health.get("status") == "unhealthy":
            overall_status = "degraded"
    except Exception as e:
        checks["cache"] = "error"
        logger.warning(f"Cache health check failed: {e}")

    return HealthStatus(
        status=overall_status,
        timestamp=datetime.utcnow().isoformat(),
        version="1.0.0",
        environment=os.environ.get("ENVIRONMENT", "development"),
        checks=checks
    )


@router.get("/health/ready", tags=["System"])
async def readiness_check():
    """
    Readiness check for Kubernetes/orchestration

    **Returns:**
    - 200 if ready to accept traffic
    - 503 if not ready

    **Note:** Used by load balancers to determine if pod is ready
    """
    try:
        # Check critical services
        db = get_supabase_admin()  # Use admin client for data access
        db.table('users').select('id').limit(1).execute()

        return {"status": "ready", "timestamp": datetime.utcnow().isoformat()}
    except Exception as e:
        logger.error(f"Readiness check failed: {e}")
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="Service not ready"
        )


@router.get("/health/live", tags=["System"])
async def liveness_check():
    """
    Liveness check for Kubernetes/orchestration

    **Returns:**
    - 200 if server is alive
    - 503 if server should be restarted

    **Note:** Used by orchestrators to determine if pod needs restart
    """
    # Simple check - if we can respond, we're alive
    return {"status": "alive", "timestamp": datetime.utcnow().isoformat()}


@router.get("/metrics", response_model=SystemMetrics, tags=["System"])
async def get_system_metrics(
    current_user: CurrentUser = Depends(RoleChecker([UserRole.ADMIN_SUPER]))
):
    """
    Get system resource metrics (Admin only)

    **Requires:** Super Admin authentication

    **Returns:**
    - CPU usage percentage
    - Memory usage (percent, used, total)
    - Disk usage (percent, used, total)
    - Process memory usage
    - Server uptime

    **Note:** Useful for monitoring and capacity planning
    """
    try:
        process = psutil.Process()
        memory = psutil.virtual_memory()
        disk = psutil.disk_usage('/')

        return SystemMetrics(
            cpu_percent=psutil.cpu_percent(interval=0.1),
            memory_percent=memory.percent,
            memory_used_mb=memory.used / (1024 ** 2),
            memory_total_mb=memory.total / (1024 ** 2),
            disk_percent=disk.percent,
            disk_used_gb=disk.used / (1024 ** 3),
            disk_total_gb=disk.total / (1024 ** 3),
            process_memory_mb=process.memory_info().rss / (1024 ** 2),
            uptime_seconds=psutil.boot_time()
        )
    except Exception as e:
        logger.error(f"Metrics error: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to retrieve metrics"
        )


@router.get("/health/detailed", response_model=DetailedHealth, tags=["System"])
async def detailed_health_check(
    current_user: CurrentUser = Depends(RoleChecker([UserRole.ADMIN_SUPER]))
):
    """
    Comprehensive health and diagnostics (Admin only)

    **Requires:** Super Admin authentication

    **Returns:**
    - Overall status
    - Database connection details
    - System resource metrics
    - API statistics
    - Environment information

    **Note:** For troubleshooting and monitoring dashboards
    """
    overall_status = "healthy"
    database_info = {}
    api_stats = {}

    # Database check
    try:
        db = get_supabase_admin()  # Use admin client for data access

        # Test connection
        start_time = datetime.utcnow()
        db.table('users').select('id').limit(1).execute()
        query_time = (datetime.utcnow() - start_time).total_seconds() * 1000

        database_info = {
            "status": "connected",
            "type": "Supabase (PostgreSQL)",
            "query_time_ms": round(query_time, 2)
        }
    except Exception as e:
        database_info = {
            "status": "error",
            "error": str(e)[:100]
        }
        overall_status = "unhealthy"

    # Get system metrics
    try:
        metrics = await get_system_metrics(current_user)
        system = metrics
    except:
        system = None
        overall_status = "degraded"

    # API stats (could be enhanced with actual request counts)
    api_stats = {
        "total_endpoints": 70,  # Approximate count
        "version": "1.0.0",
        "features": [
            "Authentication",
            "Courses",
            "Applications",
            "Enrollments",
            "Messaging",
            "Notifications",
            "Counseling",
            "Parent Monitoring",
            "Achievements"
        ]
    }

    return DetailedHealth(
        status=overall_status,
        timestamp=datetime.utcnow().isoformat(),
        version="1.0.0",
        python_version=f"{sys.version_info.major}.{sys.version_info.minor}.{sys.version_info.micro}",
        environment=os.environ.get("ENVIRONMENT", "development"),
        database=database_info,
        system=system,
        api_stats=api_stats
    )


@router.get("/info", tags=["System"])
async def get_api_info():
    """
    Get public API information

    **Returns:**
    - API version
    - Available features
    - Documentation link
    - Status page

    **Note:** Public endpoint with basic API information
    """
    return {
        "name": "Find Your Path API",
        "version": "1.0.0",
        "description": "University Recommendation Service for Flow EdTech Platform",
        "features": [
            "JWT Authentication with RBAC",
            "University & Program Management",
            "Course Management & Enrollment",
            "Application Tracking",
            "Real-time Messaging",
            "Push Notifications",
            "Counseling Sessions",
            "Parent Monitoring",
            "Achievements & Gamification",
            "Student Recommendations (ML-powered)"
        ],
        "documentation": "/docs",
        "health_check": "/health",
        "environment": os.environ.get("ENVIRONMENT", "development"),
        "support": "https://github.com/goub0000/Flow"
    }
