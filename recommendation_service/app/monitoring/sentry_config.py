"""
Sentry Configuration for Error Tracking and Performance Monitoring
"""
import os
import logging
from typing import Optional

logger = logging.getLogger(__name__)


def init_sentry():
    """Initialize Sentry SDK for error tracking"""
    sentry_dsn = os.getenv("SENTRY_DSN")
    environment = os.getenv("ENVIRONMENT", "development")

    if not sentry_dsn:
        logger.warning("SENTRY_DSN not configured - Sentry monitoring disabled")
        return False

    try:
        import sentry_sdk
        from sentry_sdk.integrations.fastapi import FastApiIntegration
        from sentry_sdk.integrations.logging import LoggingIntegration

        # Configure Sentry with FastAPI integration
        sentry_sdk.init(
            dsn=sentry_dsn,
            environment=environment,

            # Performance monitoring
            traces_sample_rate=float(os.getenv("SENTRY_TRACES_SAMPLE_RATE", "0.1")),

            # Profiling (helps identify slow operations)
            profiles_sample_rate=float(os.getenv("SENTRY_PROFILES_SAMPLE_RATE", "0.1")),

            # Integrations
            integrations=[
                FastApiIntegration(
                    transaction_style="url",  # Group transactions by URL path
                ),
                LoggingIntegration(
                    level=logging.INFO,  # Capture info and above as breadcrumbs
                    event_level=logging.ERROR  # Send errors and above to Sentry
                ),
            ],

            # Additional configuration
            send_default_pii=False,  # Don't send personally identifiable information
            attach_stacktrace=True,
            max_breadcrumbs=50,

            # Filter out certain errors
            before_send=before_send_filter,
        )

        logger.info(f"Sentry monitoring initialized for environment: {environment}")
        return True

    except ImportError:
        logger.error("sentry-sdk not installed. Install with: pip install sentry-sdk[fastapi]")
        return False
    except Exception as e:
        logger.error(f"Failed to initialize Sentry: {e}")
        return False


def before_send_filter(event, hint):
    """
    Filter events before sending to Sentry
    Useful for excluding certain errors or adding context
    """
    # Exclude certain exceptions
    if "exc_info" in hint:
        exc_type, exc_value, tb = hint["exc_info"]

        # Don't send 404 errors to Sentry
        if "404" in str(exc_value):
            return None

        # Don't send rate limit errors (they're expected)
        if "RateLimitExceeded" in str(exc_type):
            return None

    return event


def capture_exception(error: Exception, context: Optional[dict] = None):
    """
    Manually capture an exception and send to Sentry

    Args:
        error: The exception to capture
        context: Additional context to attach to the error
    """
    try:
        import sentry_sdk

        if context:
            with sentry_sdk.push_scope() as scope:
                for key, value in context.items():
                    scope.set_context(key, value)
                sentry_sdk.capture_exception(error)
        else:
            sentry_sdk.capture_exception(error)

    except ImportError:
        logger.warning("Sentry not available - exception not captured")
    except Exception as e:
        logger.error(f"Failed to capture exception in Sentry: {e}")


def capture_message(message: str, level: str = "info", context: Optional[dict] = None):
    """
    Capture a message and send to Sentry

    Args:
        message: The message to capture
        level: Severity level (debug, info, warning, error, fatal)
        context: Additional context to attach
    """
    try:
        import sentry_sdk

        if context:
            with sentry_sdk.push_scope() as scope:
                for key, value in context.items():
                    scope.set_context(key, value)
                sentry_sdk.capture_message(message, level)
        else:
            sentry_sdk.capture_message(message, level)

    except ImportError:
        logger.warning("Sentry not available - message not captured")
    except Exception as e:
        logger.error(f"Failed to capture message in Sentry: {e}")


def set_user_context(user_id: str, email: Optional[str] = None, username: Optional[str] = None):
    """
    Set user context for error tracking

    Args:
        user_id: User identifier
        email: User email (optional)
        username: Username (optional)
    """
    try:
        import sentry_sdk

        sentry_sdk.set_user({
            "id": user_id,
            "email": email,
            "username": username
        })

    except ImportError:
        pass
    except Exception as e:
        logger.error(f"Failed to set user context in Sentry: {e}")


def add_breadcrumb(message: str, category: str = "default", level: str = "info", data: Optional[dict] = None):
    """
    Add a breadcrumb to track user actions leading up to an error

    Args:
        message: Breadcrumb message
        category: Category (e.g., "auth", "database", "api")
        level: Severity level
        data: Additional data
    """
    try:
        import sentry_sdk

        sentry_sdk.add_breadcrumb(
            message=message,
            category=category,
            level=level,
            data=data or {}
        )

    except ImportError:
        pass
    except Exception as e:
        logger.error(f"Failed to add breadcrumb in Sentry: {e}")
