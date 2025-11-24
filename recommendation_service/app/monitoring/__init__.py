"""
Monitoring Module
Provides comprehensive monitoring with Sentry and Prometheus
"""
from .sentry_config import (
    init_sentry,
    capture_exception,
    capture_message,
    set_user_context,
    add_breadcrumb
)

from .prometheus_config import (
    init_prometheus,
    create_metrics_middleware,
    record_recommendation_generated,
    record_database_query,
    record_cache_access,
    record_api_request,
    record_error,
    update_active_users,
    record_student_profile_created,
    record_application_submitted
)

__all__ = [
    # Sentry
    'init_sentry',
    'capture_exception',
    'capture_message',
    'set_user_context',
    'add_breadcrumb',
    # Prometheus
    'init_prometheus',
    'create_metrics_middleware',
    'record_recommendation_generated',
    'record_database_query',
    'record_cache_access',
    'record_api_request',
    'record_error',
    'update_active_users',
    'record_student_profile_created',
    'record_application_submitted',
]
