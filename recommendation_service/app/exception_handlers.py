"""
Exception Handlers for Custom Exceptions
Converts exceptions to proper HTTP responses with structured error messages
"""
import logging
from fastapi import Request, status
from fastapi.responses import JSONResponse
from fastapi.exceptions import RequestValidationError
from starlette.exceptions import HTTPException as StarletteHTTPException

from app.exceptions import BaseAPIException
from app.monitoring import capture_exception

logger = logging.getLogger(__name__)


async def custom_exception_handler(request: Request, exc: BaseAPIException) -> JSONResponse:
    """
    Handle custom API exceptions

    Args:
        request: The FastAPI request object
        exc: The custom exception

    Returns:
        JSONResponse with structured error
    """
    # Log the error
    logger.error(
        f"API Exception: {exc.error_code} - {exc.message}",
        extra={
            "path": request.url.path,
            "method": request.method,
            "status_code": exc.status_code,
            "error_code": exc.error_code,
            "details": exc.details
        }
    )

    # Capture in Sentry for monitoring (only for 500 errors)
    if exc.status_code >= 500:
        capture_exception(exc, context={
            "request": {
                "path": str(request.url.path),
                "method": request.method,
                "query_params": dict(request.query_params)
            }
        })

    # Return structured error response
    return JSONResponse(
        status_code=exc.status_code,
        content={
            "success": False,
            "error": {
                "code": exc.error_code,
                "message": exc.message,
                "status": exc.status_code,
                **exc.details
            },
            "path": str(request.url.path),
            "method": request.method
        }
    )


async def http_exception_handler(request: Request, exc: StarletteHTTPException) -> JSONResponse:
    """
    Handle standard HTTP exceptions

    Args:
        request: The FastAPI request object
        exc: The HTTP exception

    Returns:
        JSONResponse with structured error
    """
    # Map common status codes to user-friendly messages
    message_map = {
        400: "Bad request. Please check your input.",
        401: "Authentication required. Please login.",
        403: "You don't have permission to access this resource.",
        404: "Resource not found.",
        405: "Method not allowed for this endpoint.",
        422: "Invalid input data provided.",
        429: "Too many requests. Please try again later.",
        500: "Internal server error. Please try again later.",
        502: "Service temporarily unavailable. Please try again later.",
        503: "Service temporarily unavailable. Please try again later.",
    }

    message = exc.detail if exc.detail else message_map.get(exc.status_code, "An error occurred")

    logger.warning(
        f"HTTP Exception: {exc.status_code} - {message}",
        extra={
            "path": request.url.path,
            "method": request.method,
            "status_code": exc.status_code
        }
    )

    return JSONResponse(
        status_code=exc.status_code,
        content={
            "success": False,
            "error": {
                "code": f"HTTP_{exc.status_code}",
                "message": message,
                "status": exc.status_code
            },
            "path": str(request.url.path),
            "method": request.method
        }
    )


async def validation_exception_handler(request: Request, exc: RequestValidationError) -> JSONResponse:
    """
    Handle request validation errors (422)

    Args:
        request: The FastAPI request object
        exc: The validation exception

    Returns:
        JSONResponse with detailed validation errors
    """
    # Extract field-specific errors
    errors = []
    for error in exc.errors():
        field = ".".join(str(loc) for loc in error["loc"])
        errors.append({
            "field": field,
            "message": error["msg"],
            "type": error["type"]
        })

    logger.warning(
        f"Validation Error: {len(errors)} field(s) invalid",
        extra={
            "path": request.url.path,
            "method": request.method,
            "errors": errors
        }
    )

    return JSONResponse(
        status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
        content={
            "success": False,
            "error": {
                "code": "VALIDATION_ERROR",
                "message": "Input validation failed. Please check the provided data.",
                "status": 422,
                "validation_errors": errors
            },
            "path": str(request.url.path),
            "method": request.method
        }
    )


async def general_exception_handler(request: Request, exc: Exception) -> JSONResponse:
    """
    Handle unexpected exceptions

    Args:
        request: The FastAPI request object
        exc: The unexpected exception

    Returns:
        JSONResponse with generic error
    """
    # Log the full exception
    logger.error(
        f"Unhandled Exception: {type(exc).__name__} - {str(exc)}",
        exc_info=True,
        extra={
            "path": request.url.path,
            "method": request.method
        }
    )

    # Capture in Sentry
    capture_exception(exc, context={
        "request": {
            "path": str(request.url.path),
            "method": request.method,
            "query_params": dict(request.query_params)
        }
    })

    # Return generic error (don't expose internal details)
    return JSONResponse(
        status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
        content={
            "success": False,
            "error": {
                "code": "INTERNAL_SERVER_ERROR",
                "message": "An unexpected error occurred. Our team has been notified.",
                "status": 500
            },
            "path": str(request.url.path),
            "method": request.method
        }
    )


def register_exception_handlers(app):
    """
    Register all exception handlers with the FastAPI app

    Args:
        app: FastAPI application instance
    """
    # Custom exceptions
    app.add_exception_handler(BaseAPIException, custom_exception_handler)

    # Standard HTTP exceptions
    app.add_exception_handler(StarletteHTTPException, http_exception_handler)

    # Validation errors
    app.add_exception_handler(RequestValidationError, validation_exception_handler)

    # Catch-all for unexpected errors
    app.add_exception_handler(Exception, general_exception_handler)

    logger.info("Exception handlers registered successfully")
