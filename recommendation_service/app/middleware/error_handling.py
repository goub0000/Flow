"""
Error Handling Middleware
Provides consistent error responses and logging
"""
from fastapi import Request, status
from fastapi.responses import JSONResponse
from fastapi.exceptions import RequestValidationError
from starlette.exceptions import HTTPException as StarletteHTTPException
import logging
import traceback
from typing import Union
import time

logger = logging.getLogger(__name__)


async def http_exception_handler(request: Request, exc: StarletteHTTPException) -> JSONResponse:
    """Handle HTTP exceptions with consistent format"""
    logger.warning(
        f"HTTP {exc.status_code}: {request.method} {request.url.path} - {exc.detail}"
    )

    return JSONResponse(
        status_code=exc.status_code,
        content={
            "error": {
                "code": exc.status_code,
                "message": exc.detail,
                "path": str(request.url.path),
                "method": request.method,
            }
        },
    )


async def validation_exception_handler(request: Request, exc: RequestValidationError) -> JSONResponse:
    """Handle validation errors with detailed information"""
    errors = []
    for error in exc.errors():
        errors.append({
            "field": " -> ".join([str(loc) for loc in error["loc"]]),
            "message": error["msg"],
            "type": error["type"],
        })

    logger.warning(
        f"Validation Error: {request.method} {request.url.path} - {len(errors)} errors"
    )

    return JSONResponse(
        status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
        content={
            "error": {
                "code": 422,
                "message": "Validation error",
                "details": errors,
                "path": str(request.url.path),
                "method": request.method,
            }
        },
    )


async def general_exception_handler(request: Request, exc: Exception) -> JSONResponse:
    """Handle unexpected exceptions"""
    error_id = f"{int(time.time())}-{id(exc)}"

    logger.error(
        f"Unhandled Exception [{error_id}]: {request.method} {request.url.path}\n"
        f"Error: {str(exc)}\n"
        f"Traceback: {traceback.format_exc()}"
    )

    # In production, don't expose internal error details
    return JSONResponse(
        status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
        content={
            "error": {
                "code": 500,
                "message": "Internal server error",
                "error_id": error_id,  # For support/debugging
                "path": str(request.url.path),
                "method": request.method,
            }
        },
    )


class ErrorHandlingMiddleware:
    """Middleware for request/response logging and timing"""

    def __init__(self, app):
        self.app = app

    async def __call__(self, scope, receive, send):
        if scope["type"] != "http":
            await self.app(scope, receive, send)
            return

        request_start_time = time.time()

        async def send_wrapper(message):
            if message["type"] == "http.response.start":
                process_time = time.time() - request_start_time
                # Log slow requests
                if process_time > 1.0:  # More than 1 second
                    logger.warning(
                        f"Slow request: {scope['method']} {scope['path']} - {process_time:.2f}s"
                    )

            await send(message)

        await self.app(scope, receive, send_wrapper)
