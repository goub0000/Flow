"""
Custom Exception Classes for Authentication and Authorization
Provides structured error responses with error codes, messages, and suggestions
"""
from typing import Optional, Dict, Any
from enum import Enum
from fastapi import HTTPException, status


class AuthErrorCode(str, Enum):
    """Enum for authentication error codes"""
    # Registration errors
    EMAIL_ALREADY_EXISTS = "EMAIL_ALREADY_EXISTS"
    INVALID_ROLE = "INVALID_ROLE"
    WEAK_PASSWORD = "WEAK_PASSWORD"
    INVALID_EMAIL_FORMAT = "INVALID_EMAIL_FORMAT"
    REGISTRATION_FAILED = "REGISTRATION_FAILED"

    # Login errors
    INVALID_CREDENTIALS = "INVALID_CREDENTIALS"
    EMAIL_NOT_FOUND = "EMAIL_NOT_FOUND"
    INCORRECT_PASSWORD = "INCORRECT_PASSWORD"
    ACCOUNT_DISABLED = "ACCOUNT_DISABLED"
    EMAIL_NOT_VERIFIED = "EMAIL_NOT_VERIFIED"
    LOGIN_FAILED = "LOGIN_FAILED"

    # Token errors
    TOKEN_EXPIRED = "TOKEN_EXPIRED"
    TOKEN_INVALID = "TOKEN_INVALID"
    TOKEN_MISSING = "TOKEN_MISSING"
    REFRESH_TOKEN_INVALID = "REFRESH_TOKEN_INVALID"
    REFRESH_TOKEN_EXPIRED = "REFRESH_TOKEN_EXPIRED"

    # Password reset errors
    PASSWORD_RESET_FAILED = "PASSWORD_RESET_FAILED"
    PASSWORD_UPDATE_FAILED = "PASSWORD_UPDATE_FAILED"
    CURRENT_PASSWORD_INCORRECT = "CURRENT_PASSWORD_INCORRECT"

    # Profile errors
    USER_NOT_FOUND = "USER_NOT_FOUND"
    PROFILE_UPDATE_FAILED = "PROFILE_UPDATE_FAILED"
    ROLE_NOT_AVAILABLE = "ROLE_NOT_AVAILABLE"

    # Authorization errors
    UNAUTHORIZED = "UNAUTHORIZED"
    FORBIDDEN = "FORBIDDEN"
    INSUFFICIENT_PERMISSIONS = "INSUFFICIENT_PERMISSIONS"

    # General errors
    INTERNAL_ERROR = "INTERNAL_ERROR"
    SUPABASE_ERROR = "SUPABASE_ERROR"
    VALIDATION_ERROR = "VALIDATION_ERROR"


# Mapping of error codes to user-friendly suggestions
ERROR_SUGGESTIONS: Dict[AuthErrorCode, str] = {
    AuthErrorCode.EMAIL_ALREADY_EXISTS: "Please log in to your existing account or use the 'Forgot Password' option to reset your password.",
    AuthErrorCode.INVALID_ROLE: "Please select a valid role from the available options.",
    AuthErrorCode.WEAK_PASSWORD: "Please use a password with at least 8 characters, including uppercase, lowercase, numbers, and special characters.",
    AuthErrorCode.INVALID_EMAIL_FORMAT: "Please enter a valid email address (e.g., user@example.com).",
    AuthErrorCode.REGISTRATION_FAILED: "Please check your information and try again. If the problem persists, contact support.",

    AuthErrorCode.INVALID_CREDENTIALS: "Please check your email and password, then try again.",
    AuthErrorCode.EMAIL_NOT_FOUND: "No account found with this email. Please check your email or create a new account.",
    AuthErrorCode.INCORRECT_PASSWORD: "The password you entered is incorrect. Please try again or use 'Forgot Password' to reset it.",
    AuthErrorCode.ACCOUNT_DISABLED: "Your account has been disabled. Please contact support for assistance.",
    AuthErrorCode.EMAIL_NOT_VERIFIED: "Please verify your email address before logging in. Check your inbox for the verification link.",
    AuthErrorCode.LOGIN_FAILED: "Unable to log in. Please try again later.",

    AuthErrorCode.TOKEN_EXPIRED: "Your session has expired. Please log in again.",
    AuthErrorCode.TOKEN_INVALID: "Your session is invalid. Please log in again.",
    AuthErrorCode.TOKEN_MISSING: "Authentication required. Please log in to continue.",
    AuthErrorCode.REFRESH_TOKEN_INVALID: "Your session cannot be refreshed. Please log in again.",
    AuthErrorCode.REFRESH_TOKEN_EXPIRED: "Your session has expired. Please log in again.",

    AuthErrorCode.PASSWORD_RESET_FAILED: "Unable to send password reset email. Please check your email address and try again.",
    AuthErrorCode.PASSWORD_UPDATE_FAILED: "Unable to update password. Please try again.",
    AuthErrorCode.CURRENT_PASSWORD_INCORRECT: "The current password you entered is incorrect.",

    AuthErrorCode.USER_NOT_FOUND: "User profile not found. Please contact support.",
    AuthErrorCode.PROFILE_UPDATE_FAILED: "Unable to update profile. Please try again.",
    AuthErrorCode.ROLE_NOT_AVAILABLE: "You do not have access to this role. Contact an administrator to request access.",

    AuthErrorCode.UNAUTHORIZED: "Please log in to access this resource.",
    AuthErrorCode.FORBIDDEN: "You do not have permission to access this resource.",
    AuthErrorCode.INSUFFICIENT_PERMISSIONS: "You do not have the required permissions for this action.",

    AuthErrorCode.INTERNAL_ERROR: "An unexpected error occurred. Please try again later or contact support.",
    AuthErrorCode.SUPABASE_ERROR: "A database error occurred. Please try again later.",
    AuthErrorCode.VALIDATION_ERROR: "Please check your input and try again.",
}


class AuthException(Exception):
    """
    Custom exception for authentication errors
    Provides structured error information for API responses
    """

    def __init__(
        self,
        error_code: AuthErrorCode,
        message: str,
        suggestion: Optional[str] = None,
        details: Optional[Dict[str, Any]] = None,
        status_code: int = status.HTTP_400_BAD_REQUEST
    ):
        self.error_code = error_code
        self.message = message
        self.suggestion = suggestion or ERROR_SUGGESTIONS.get(error_code, "Please try again or contact support.")
        self.details = details or {}
        self.status_code = status_code
        super().__init__(self.message)

    def to_dict(self) -> Dict[str, Any]:
        """Convert exception to dictionary for API response"""
        response = {
            "detail": self.message,
            "error_code": self.error_code.value,
            "suggestion": self.suggestion
        }
        if self.details:
            response["details"] = self.details
        return response

    def to_http_exception(self) -> HTTPException:
        """Convert to FastAPI HTTPException"""
        return HTTPException(
            status_code=self.status_code,
            detail=self.to_dict()
        )


def parse_supabase_auth_error(error_message: str) -> AuthException:
    """
    Parse Supabase auth error messages and return appropriate AuthException

    Args:
        error_message: The error message from Supabase

    Returns:
        AuthException with appropriate error code and message
    """
    error_lower = error_message.lower()

    # Email already exists
    if any(term in error_lower for term in ["already", "duplicate", "exists", "registered"]):
        return AuthException(
            error_code=AuthErrorCode.EMAIL_ALREADY_EXISTS,
            message="This email address is already registered.",
            status_code=status.HTTP_409_CONFLICT
        )

    # Invalid credentials / authentication failed
    if any(term in error_lower for term in ["invalid login", "invalid credentials", "invalid email or password"]):
        return AuthException(
            error_code=AuthErrorCode.INVALID_CREDENTIALS,
            message="Invalid email or password.",
            status_code=status.HTTP_401_UNAUTHORIZED
        )

    # Email not found
    if "user not found" in error_lower or "no user" in error_lower:
        return AuthException(
            error_code=AuthErrorCode.EMAIL_NOT_FOUND,
            message="No account found with this email address.",
            status_code=status.HTTP_404_NOT_FOUND
        )

    # Password too weak
    if "password" in error_lower and any(term in error_lower for term in ["weak", "short", "simple", "least"]):
        return AuthException(
            error_code=AuthErrorCode.WEAK_PASSWORD,
            message="Password does not meet security requirements. It must be at least 8 characters long.",
            status_code=status.HTTP_400_BAD_REQUEST
        )

    # Email not verified
    if "not confirmed" in error_lower or "verify" in error_lower or "confirmation" in error_lower:
        return AuthException(
            error_code=AuthErrorCode.EMAIL_NOT_VERIFIED,
            message="Please verify your email address before logging in.",
            status_code=status.HTTP_403_FORBIDDEN
        )

    # Token expired
    if "expired" in error_lower and "token" in error_lower:
        return AuthException(
            error_code=AuthErrorCode.TOKEN_EXPIRED,
            message="Your authentication token has expired.",
            status_code=status.HTTP_401_UNAUTHORIZED
        )

    # Invalid token
    if "invalid" in error_lower and "token" in error_lower:
        return AuthException(
            error_code=AuthErrorCode.TOKEN_INVALID,
            message="Invalid authentication token.",
            status_code=status.HTTP_401_UNAUTHORIZED
        )

    # Refresh token errors
    if "refresh" in error_lower:
        if "expired" in error_lower:
            return AuthException(
                error_code=AuthErrorCode.REFRESH_TOKEN_EXPIRED,
                message="Your refresh token has expired. Please log in again.",
                status_code=status.HTTP_401_UNAUTHORIZED
            )
        return AuthException(
            error_code=AuthErrorCode.REFRESH_TOKEN_INVALID,
            message="Invalid refresh token. Please log in again.",
            status_code=status.HTTP_401_UNAUTHORIZED
        )

    # Rate limiting
    if "rate" in error_lower or "too many" in error_lower:
        return AuthException(
            error_code=AuthErrorCode.SUPABASE_ERROR,
            message="Too many requests. Please wait a moment and try again.",
            suggestion="Please wait a few minutes before trying again.",
            status_code=status.HTTP_429_TOO_MANY_REQUESTS
        )

    # Account disabled/banned
    if "disabled" in error_lower or "banned" in error_lower or "blocked" in error_lower:
        return AuthException(
            error_code=AuthErrorCode.ACCOUNT_DISABLED,
            message="This account has been disabled.",
            status_code=status.HTTP_403_FORBIDDEN
        )

    # Invalid email format
    if "email" in error_lower and any(term in error_lower for term in ["invalid", "format", "valid"]):
        return AuthException(
            error_code=AuthErrorCode.INVALID_EMAIL_FORMAT,
            message="Please enter a valid email address.",
            status_code=status.HTTP_400_BAD_REQUEST
        )

    # Default: return generic Supabase error
    return AuthException(
        error_code=AuthErrorCode.SUPABASE_ERROR,
        message=f"Authentication error: {error_message}",
        status_code=status.HTTP_400_BAD_REQUEST
    )


def create_error_response(
    error_code: AuthErrorCode,
    message: str,
    suggestion: Optional[str] = None,
    details: Optional[Dict[str, Any]] = None
) -> Dict[str, Any]:
    """
    Create a standardized error response dictionary

    Args:
        error_code: The error code enum value
        message: Human-readable error message
        suggestion: Optional suggestion for resolving the error
        details: Optional additional details

    Returns:
        Dictionary with structured error response
    """
    response = {
        "detail": message,
        "error_code": error_code.value,
        "suggestion": suggestion or ERROR_SUGGESTIONS.get(error_code, "Please try again or contact support.")
    }
    if details:
        response["details"] = details
    return response
