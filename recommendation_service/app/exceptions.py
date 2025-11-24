"""
Custom Exception Classes for Better Error Handling
Provides structured, user-friendly error messages
"""
from typing import Optional, Dict, Any
from fastapi import status


class BaseAPIException(Exception):
    """Base exception for all API errors"""

    def __init__(
        self,
        message: str,
        status_code: int = status.HTTP_400_BAD_REQUEST,
        error_code: Optional[str] = None,
        details: Optional[Dict[str, Any]] = None
    ):
        self.message = message
        self.status_code = status_code
        self.error_code = error_code or self.__class__.__name__
        self.details = details or {}
        super().__init__(self.message)

    def to_dict(self) -> Dict[str, Any]:
        """Convert exception to dictionary for JSON response"""
        return {
            "error": {
                "code": self.error_code,
                "message": self.message,
                "status_code": self.status_code,
                **self.details
            }
        }


# ========================================
# Validation Errors
# ========================================

class ValidationError(BaseAPIException):
    """Raised when input validation fails"""

    def __init__(self, message: str, field: Optional[str] = None, details: Optional[Dict] = None):
        super().__init__(
            message=message,
            status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
            error_code="VALIDATION_ERROR",
            details={"field": field, **(details or {})}
        )


class InvalidInputError(ValidationError):
    """Raised when input is invalid"""

    def __init__(self, field: str, message: str = "Invalid input provided"):
        super().__init__(
            message=f"{message} for field '{field}'",
            field=field,
            details={"error_type": "invalid_input"}
        )


class MissingFieldError(ValidationError):
    """Raised when required field is missing"""

    def __init__(self, field: str):
        super().__init__(
            message=f"Required field '{field}' is missing",
            field=field,
            details={"error_type": "missing_field"}
        )


# ========================================
# Resource Errors
# ========================================

class NotFoundError(BaseAPIException):
    """Raised when resource is not found"""

    def __init__(self, resource: str, identifier: Optional[str] = None):
        message = f"{resource} not found"
        if identifier:
            message += f" with ID: {identifier}"

        super().__init__(
            message=message,
            status_code=status.HTTP_404_NOT_FOUND,
            error_code="RESOURCE_NOT_FOUND",
            details={"resource": resource, "identifier": identifier}
        )


class ResourceAlreadyExistsError(BaseAPIException):
    """Raised when trying to create a resource that already exists"""

    def __init__(self, resource: str, identifier: Optional[str] = None):
        message = f"{resource} already exists"
        if identifier:
            message += f" with ID: {identifier}"

        super().__init__(
            message=message,
            status_code=status.HTTP_409_CONFLICT,
            error_code="RESOURCE_ALREADY_EXISTS",
            details={"resource": resource, "identifier": identifier}
        )


# ========================================
# Authentication & Authorization Errors
# ========================================

class UnauthorizedError(BaseAPIException):
    """Raised when authentication fails"""

    def __init__(self, message: str = "Authentication required"):
        super().__init__(
            message=message,
            status_code=status.HTTP_401_UNAUTHORIZED,
            error_code="UNAUTHORIZED",
            details={"authentication": "required"}
        )


class InvalidCredentialsError(UnauthorizedError):
    """Raised when credentials are invalid"""

    def __init__(self):
        super().__init__(
            message="Invalid email or password"
        )


class TokenExpiredError(UnauthorizedError):
    """Raised when authentication token has expired"""

    def __init__(self):
        super().__init__(
            message="Authentication token has expired. Please login again."
        )


class ForbiddenError(BaseAPIException):
    """Raised when user doesn't have permission"""

    def __init__(self, message: str = "You don't have permission to perform this action"):
        super().__init__(
            message=message,
            status_code=status.HTTP_403_FORBIDDEN,
            error_code="FORBIDDEN",
            details={"permission": "denied"}
        )


class InsufficientPermissionsError(ForbiddenError):
    """Raised when user lacks specific permission"""

    def __init__(self, required_role: str):
        super().__init__(
            message=f"This action requires '{required_role}' role"
        )


# ========================================
# Database Errors
# ========================================

class DatabaseError(BaseAPIException):
    """Raised when database operation fails"""

    def __init__(self, message: str = "Database operation failed", operation: Optional[str] = None):
        super().__init__(
            message=message,
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            error_code="DATABASE_ERROR",
            details={"operation": operation}
        )


class DatabaseConnectionError(DatabaseError):
    """Raised when cannot connect to database"""

    def __init__(self):
        super().__init__(
            message="Unable to connect to database. Please try again later.",
            operation="connect"
        )


class DatabaseQueryError(DatabaseError):
    """Raised when database query fails"""

    def __init__(self, query_type: str = "query"):
        super().__init__(
            message=f"Database {query_type} failed. Please try again.",
            operation=query_type
        )


# ========================================
# Business Logic Errors
# ========================================

class BusinessLogicError(BaseAPIException):
    """Raised when business logic validation fails"""

    def __init__(self, message: str, details: Optional[Dict] = None):
        super().__init__(
            message=message,
            status_code=status.HTTP_400_BAD_REQUEST,
            error_code="BUSINESS_LOGIC_ERROR",
            details=details or {}
        )


class InvalidOperationError(BusinessLogicError):
    """Raised when operation is not allowed in current state"""

    def __init__(self, operation: str, reason: str):
        super().__init__(
            message=f"Cannot {operation}: {reason}",
            details={"operation": operation, "reason": reason}
        )


class ProfileIncompleteError(BusinessLogicError):
    """Raised when user profile is incomplete"""

    def __init__(self, missing_fields: list):
        super().__init__(
            message="Please complete your profile before proceeding",
            details={
                "missing_fields": missing_fields,
                "action_required": "complete_profile"
            }
        )


class InsufficientDataError(BusinessLogicError):
    """Raised when not enough data to perform operation"""

    def __init__(self, operation: str, min_required: Optional[int] = None):
        message = f"Insufficient data to {operation}"
        if min_required:
            message += f". At least {min_required} items required."

        super().__init__(
            message=message,
            details={"operation": operation, "min_required": min_required}
        )


# ========================================
# External Service Errors
# ========================================

class ExternalServiceError(BaseAPIException):
    """Raised when external service fails"""

    def __init__(
        self,
        service_name: str,
        message: str = "External service is temporarily unavailable",
        status_code: int = status.HTTP_503_SERVICE_UNAVAILABLE
    ):
        super().__init__(
            message=f"{service_name}: {message}",
            status_code=status_code,
            error_code="EXTERNAL_SERVICE_ERROR",
            details={"service": service_name}
        )


class SupabaseError(ExternalServiceError):
    """Raised when Supabase operation fails"""

    def __init__(self, operation: str, details: Optional[str] = None):
        message = f"Database operation '{operation}' failed"
        if details:
            message += f": {details}"

        super().__init__(
            service_name="Supabase",
            message=message
        )


class APIClientError(ExternalServiceError):
    """Raised when external API call fails"""

    def __init__(self, api_name: str, status_code: int, message: Optional[str] = None):
        super().__init__(
            service_name=api_name,
            message=message or f"API returned status {status_code}",
            status_code=status.HTTP_502_BAD_GATEWAY
        )


# ========================================
# Rate Limiting Errors
# ========================================

class RateLimitError(BaseAPIException):
    """Raised when rate limit is exceeded"""

    def __init__(self, retry_after: Optional[int] = None):
        message = "Too many requests. Please try again later."
        if retry_after:
            message = f"Too many requests. Please try again in {retry_after} seconds."

        super().__init__(
            message=message,
            status_code=status.HTTP_429_TOO_MANY_REQUESTS,
            error_code="RATE_LIMIT_EXCEEDED",
            details={"retry_after": retry_after}
        )


# ========================================
# File & Upload Errors
# ========================================

class FileError(BaseAPIException):
    """Raised when file operation fails"""

    def __init__(self, message: str, file_name: Optional[str] = None):
        super().__init__(
            message=message,
            status_code=status.HTTP_400_BAD_REQUEST,
            error_code="FILE_ERROR",
            details={"file_name": file_name}
        )


class FileTooLargeError(FileError):
    """Raised when file exceeds size limit"""

    def __init__(self, max_size_mb: int, file_name: Optional[str] = None):
        super().__init__(
            message=f"File exceeds maximum size of {max_size_mb}MB",
            file_name=file_name
        )


class InvalidFileTypeError(FileError):
    """Raised when file type is not allowed"""

    def __init__(self, allowed_types: list, file_name: Optional[str] = None):
        super().__init__(
            message=f"Invalid file type. Allowed types: {', '.join(allowed_types)}",
            file_name=file_name
        )


# ========================================
# Recommendation Service Specific Errors
# ========================================

class RecommendationError(BaseAPIException):
    """Raised when recommendation generation fails"""

    def __init__(self, message: str, details: Optional[Dict] = None):
        super().__init__(
            message=message,
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            error_code="RECOMMENDATION_ERROR",
            details=details or {}
        )


class InsufficientProfileDataError(RecommendationError):
    """Raised when student profile lacks data for recommendations"""

    def __init__(self, missing_fields: list):
        super().__init__(
            message="Cannot generate recommendations: profile incomplete",
            details={
                "missing_fields": missing_fields,
                "action_required": "complete_profile_questionnaire"
            }
        )
        self.status_code = status.HTTP_400_BAD_REQUEST


class NoUniversitiesFoundError(RecommendationError):
    """Raised when no universities match criteria"""

    def __init__(self, filters: Optional[Dict] = None):
        super().__init__(
            message="No universities found matching your criteria. Try adjusting your preferences.",
            details={"applied_filters": filters}
        )
        self.status_code = status.HTTP_404_NOT_FOUND
