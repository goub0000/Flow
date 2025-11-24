"""
Prometheus Metrics Configuration
Exposes application metrics for monitoring and alerting
"""
import os
import logging
from typing import Callable
from fastapi import FastAPI
from prometheus_client import Counter, Histogram, Gauge, Info

logger = logging.getLogger(__name__)

# ========================================
# Custom Application Metrics
# ========================================

# Recommendation metrics
recommendations_generated = Counter(
    'recommendations_generated_total',
    'Total number of recommendations generated',
    ['user_type', 'category']
)

recommendation_generation_time = Histogram(
    'recommendation_generation_seconds',
    'Time spent generating recommendations',
    buckets=[0.1, 0.5, 1.0, 2.0, 5.0, 10.0, 30.0, 60.0]
)

# Database metrics
database_queries = Counter(
    'database_queries_total',
    'Total number of database queries',
    ['table', 'operation']
)

database_query_duration = Histogram(
    'database_query_duration_seconds',
    'Time spent on database queries',
    ['table', 'operation'],
    buckets=[0.001, 0.01, 0.05, 0.1, 0.5, 1.0, 5.0]
)

# Cache metrics
cache_hits = Counter(
    'cache_hits_total',
    'Total number of cache hits',
    ['cache_type']
)

cache_misses = Counter(
    'cache_misses_total',
    'Total number of cache misses',
    ['cache_type']
)

# API metrics
api_requests = Counter(
    'api_requests_total',
    'Total API requests',
    ['method', 'endpoint', 'status']
)

api_latency = Histogram(
    'api_request_duration_seconds',
    'API request latency',
    ['method', 'endpoint'],
    buckets=[0.01, 0.05, 0.1, 0.5, 1.0, 2.0, 5.0, 10.0]
)

# Error metrics
errors_total = Counter(
    'errors_total',
    'Total number of errors',
    ['error_type', 'endpoint']
)

# Business metrics
active_users = Gauge(
    'active_users',
    'Number of currently active users'
)

student_profiles_created = Counter(
    'student_profiles_created_total',
    'Total student profiles created'
)

applications_submitted = Counter(
    'applications_submitted_total',
    'Total applications submitted',
    ['application_status']
)

# System info
app_info = Info('app', 'Application information')


def init_prometheus(app: FastAPI) -> bool:
    """
    Initialize Prometheus metrics for FastAPI application

    Args:
        app: FastAPI application instance

    Returns:
        bool: True if successful, False otherwise
    """
    try:
        from prometheus_fastapi_instrumentator import Instrumentator

        # Set application info
        app_info.info({
            'version': app.version,
            'environment': os.getenv('ENVIRONMENT', 'development'),
            'service': 'recommendation-service'
        })

        # Initialize instrumentator with custom configuration
        instrumentator = Instrumentator(
            should_group_status_codes=True,
            should_ignore_untemplated=True,
            should_respect_env_var=True,
            should_instrument_requests_inprogress=True,
            excluded_handlers=[
                "/health",
                "/health/live",
                "/health/ready",
                "/metrics",
                "/docs",
                "/redoc",
                "/openapi.json"
            ],
            env_var_name="ENABLE_METRICS",
            inprogress_name="http_requests_inprogress",
            inprogress_labels=True,
        )

        # Add default metrics
        instrumentator.instrument(app)

        # Expose metrics endpoint
        instrumentator.expose(
            app,
            endpoint="/metrics",
            include_in_schema=False,
            tags=["monitoring"]
        )

        logger.info("Prometheus metrics initialized and exposed at /metrics")
        return True

    except ImportError:
        logger.error(
            "prometheus-fastapi-instrumentator not installed. "
            "Install with: pip install prometheus-fastapi-instrumentator"
        )
        return False
    except Exception as e:
        logger.error(f"Failed to initialize Prometheus metrics: {e}")
        return False


# ========================================
# Helper Functions for Metric Recording
# ========================================

def record_recommendation_generated(user_type: str, category: str, duration: float):
    """Record a recommendation generation event"""
    try:
        recommendations_generated.labels(user_type=user_type, category=category).inc()
        recommendation_generation_time.observe(duration)
    except Exception as e:
        logger.error(f"Failed to record recommendation metric: {e}")


def record_database_query(table: str, operation: str, duration: float):
    """Record a database query"""
    try:
        database_queries.labels(table=table, operation=operation).inc()
        database_query_duration.labels(table=table, operation=operation).observe(duration)
    except Exception as e:
        logger.error(f"Failed to record database metric: {e}")


def record_cache_access(cache_type: str, hit: bool):
    """Record a cache access"""
    try:
        if hit:
            cache_hits.labels(cache_type=cache_type).inc()
        else:
            cache_misses.labels(cache_type=cache_type).inc()
    except Exception as e:
        logger.error(f"Failed to record cache metric: {e}")


def record_api_request(method: str, endpoint: str, status: int, duration: float):
    """Record an API request"""
    try:
        api_requests.labels(method=method, endpoint=endpoint, status=status).inc()
        api_latency.labels(method=method, endpoint=endpoint).observe(duration)
    except Exception as e:
        logger.error(f"Failed to record API metric: {e}")


def record_error(error_type: str, endpoint: str):
    """Record an error"""
    try:
        errors_total.labels(error_type=error_type, endpoint=endpoint).inc()
    except Exception as e:
        logger.error(f"Failed to record error metric: {e}")


def update_active_users(count: int):
    """Update active users count"""
    try:
        active_users.set(count)
    except Exception as e:
        logger.error(f"Failed to update active users metric: {e}")


def record_student_profile_created():
    """Record student profile creation"""
    try:
        student_profiles_created.inc()
    except Exception as e:
        logger.error(f"Failed to record student profile metric: {e}")


def record_application_submitted(status: str):
    """Record application submission"""
    try:
        applications_submitted.labels(application_status=status).inc()
    except Exception as e:
        logger.error(f"Failed to record application metric: {e}")


# ========================================
# Middleware for Automatic Metric Collection
# ========================================

def create_metrics_middleware() -> Callable:
    """
    Create middleware to automatically collect metrics for all requests

    Returns:
        Middleware callable
    """
    import time
    from starlette.middleware.base import BaseHTTPMiddleware
    from starlette.requests import Request

    class MetricsMiddleware(BaseHTTPMiddleware):
        async def dispatch(self, request: Request, call_next):
            start_time = time.time()

            # Process request
            response = await call_next(request)

            # Calculate duration
            duration = time.time() - start_time

            # Record metrics
            try:
                method = request.method
                path = request.url.path
                status = response.status_code

                # Skip metrics endpoint itself
                if path != "/metrics":
                    record_api_request(method, path, status, duration)

            except Exception as e:
                logger.error(f"Error recording request metrics: {e}")

            return response

    return MetricsMiddleware
