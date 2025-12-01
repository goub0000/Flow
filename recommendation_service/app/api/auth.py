"""
Authentication API Endpoints
Handles user registration, login, logout, password management, and profile operations
Updated: 2025-11-27 - Enhanced error handling with structured error responses
"""
from fastapi import APIRouter, Depends, HTTPException, status, Body, UploadFile, File
from typing import Dict, Any
import logging
from datetime import datetime

from app.services.auth_service import (
    AuthService,
    SignUpRequest,
    SignInRequest,
    SignInResponse,
    ResetPasswordRequest,
    UpdatePasswordRequest,
    UpdateProfileRequest,
    SwitchRoleRequest
)
from app.utils.security import (
    get_current_user,
    CurrentUser,
    require_admin
)
from app.utils.exceptions import (
    AuthException,
    AuthErrorCode,
    parse_supabase_auth_error,
    create_error_response
)

logger = logging.getLogger(__name__)

router = APIRouter()


@router.post("/auth/register", status_code=status.HTTP_201_CREATED)
async def register(
    signup_data: SignUpRequest
) -> Dict[str, Any]:
    """
    Register a new user

    **Request Body:**
    - email: User's email address
    - password: User's password (min 8 characters)
    - display_name: User's display name
    - role: User's role (student, counselor, parent, institution, recommender)
    - phone_number: Optional phone number
    - profile_data: Optional additional profile data

    **Returns:**
    - user: Created user profile
    - message: Success message
    - requires_verification: Whether email verification is required

    **Error Responses:**
    - 409 EMAIL_ALREADY_EXISTS: Email is already registered
    - 400 INVALID_ROLE: Invalid role specified
    - 400 WEAK_PASSWORD: Password does not meet requirements
    - 400 REGISTRATION_FAILED: General registration failure
    """
    try:
        auth_service = AuthService()
        result = await auth_service.sign_up(signup_data)
        return result
    except AuthException as e:
        logger.warning(f"Registration failed for {signup_data.email}: {e.error_code.value}")
        raise e.to_http_exception()
    except Exception as e:
        logger.error(f"Unexpected registration error for {signup_data.email}: {e}")
        # Parse Supabase errors and convert to structured response
        auth_error = parse_supabase_auth_error(str(e))
        raise auth_error.to_http_exception()


@router.post("/auth/login")
async def login(
    signin_data: SignInRequest
) -> SignInResponse:
    """
    Sign in with email and password

    **Request Body:**
    - email: User's email
    - password: User's password

    **Returns:**
    - access_token: JWT access token
    - refresh_token: Refresh token for obtaining new access tokens
    - user: User profile data
    - expires_in: Token expiration time in seconds

    **Error Responses:**
    - 401 INVALID_CREDENTIALS: Invalid email or password
    - 404 EMAIL_NOT_FOUND: No account with this email
    - 403 EMAIL_NOT_VERIFIED: Email not verified
    - 403 ACCOUNT_DISABLED: Account has been disabled
    """
    try:
        auth_service = AuthService()
        result = await auth_service.sign_in(signin_data)
        return result
    except AuthException as e:
        logger.warning(f"Login failed for {signin_data.email}: {e.error_code.value}")
        raise e.to_http_exception()
    except Exception as e:
        logger.error(f"Unexpected login error for {signin_data.email}: {e}")
        auth_error = parse_supabase_auth_error(str(e))
        raise auth_error.to_http_exception()


@router.post("/auth/logout")
async def logout(
    current_user: CurrentUser = Depends(get_current_user)
) -> Dict[str, str]:
    """
    Sign out current user

    **Requires:** Authentication

    **Returns:**
    - message: Success message
    """
    try:
        auth_service = AuthService()
        # Pass the access token from current user context
        result = await auth_service.sign_out("")
        return result
    except AuthException as e:
        raise e.to_http_exception()
    except Exception as e:
        logger.error(f"Logout error for user {current_user.id}: {e}")
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=create_error_response(
                AuthErrorCode.INTERNAL_ERROR,
                "Failed to sign out. Please try again."
            )
        )


@router.post("/auth/refresh")
async def refresh_token(
    refresh_token: str = Body(..., embed=True)
) -> Dict[str, Any]:
    """
    Refresh access token using refresh token

    **Request Body:**
    - refresh_token: The refresh token obtained during login

    **Returns:**
    - access_token: New JWT access token
    - refresh_token: New refresh token
    - expires_in: Token expiration time in seconds

    **Error Responses:**
    - 401 REFRESH_TOKEN_INVALID: Refresh token is invalid
    - 401 REFRESH_TOKEN_EXPIRED: Refresh token has expired
    """
    try:
        auth_service = AuthService()
        result = await auth_service.refresh_token(refresh_token)
        return result
    except AuthException as e:
        raise e.to_http_exception()
    except Exception as e:
        logger.error(f"Token refresh error: {e}")
        auth_error = parse_supabase_auth_error(str(e))
        raise auth_error.to_http_exception()


@router.post("/auth/forgot-password")
async def forgot_password(
    reset_data: ResetPasswordRequest
) -> Dict[str, str]:
    """
    Request password reset email

    **Request Body:**
    - email: User's email address

    **Returns:**
    - message: Success message (email sent)

    **Error Responses:**
    - 400 PASSWORD_RESET_FAILED: Failed to send reset email
    - 404 EMAIL_NOT_FOUND: No account with this email (optional security consideration)
    """
    try:
        auth_service = AuthService()
        result = await auth_service.request_password_reset(reset_data.email)
        return result
    except AuthException as e:
        raise e.to_http_exception()
    except Exception as e:
        logger.error(f"Password reset request error for {reset_data.email}: {e}")
        # For security, we don't reveal if email exists or not
        # We return success message but log the actual error
        error_msg = str(e).lower()
        if "not found" in error_msg or "no user" in error_msg:
            # Return success to prevent email enumeration attacks
            return {"message": "If an account exists with this email, a password reset link will be sent."}
        auth_error = parse_supabase_auth_error(str(e))
        raise auth_error.to_http_exception()


@router.post("/auth/reset-password")
async def reset_password(
    token: str = Body(...),
    new_password: str = Body(...)
) -> Dict[str, str]:
    """
    Reset password using reset token

    **Request Body:**
    - token: Password reset token from email
    - new_password: New password (min 8 characters)

    **Returns:**
    - message: Success message

    **Error Responses:**
    - 400 TOKEN_INVALID: Reset token is invalid
    - 400 TOKEN_EXPIRED: Reset token has expired
    - 400 WEAK_PASSWORD: New password does not meet requirements
    """
    try:
        auth_service = AuthService()
        # In a real implementation, verify token and extract user_id
        # For now, this is a placeholder
        result = {"message": "Password reset feature requires additional implementation"}
        return result
    except AuthException as e:
        raise e.to_http_exception()
    except Exception as e:
        logger.error(f"Password reset error: {e}")
        auth_error = parse_supabase_auth_error(str(e))
        raise auth_error.to_http_exception()


@router.post("/auth/update-password")
async def update_password(
    update_data: UpdatePasswordRequest,
    current_user: CurrentUser = Depends(get_current_user)
) -> Dict[str, str]:
    """
    Update current user's password

    **Requires:** Authentication

    **Request Body:**
    - current_password: Current password for verification
    - new_password: New password (min 8 characters)

    **Returns:**
    - message: Success message

    **Error Responses:**
    - 400 CURRENT_PASSWORD_INCORRECT: Current password is wrong
    - 400 WEAK_PASSWORD: New password does not meet requirements
    - 400 PASSWORD_UPDATE_FAILED: Failed to update password
    """
    try:
        auth_service = AuthService()
        # TODO: Verify current password before updating
        result = await auth_service.update_password(current_user.id, update_data.new_password)
        return result
    except AuthException as e:
        raise e.to_http_exception()
    except Exception as e:
        logger.error(f"Password update error for user {current_user.id}: {e}")
        auth_error = parse_supabase_auth_error(str(e))
        raise auth_error.to_http_exception()


@router.get("/auth/verify-email")
async def verify_email(
    token: str
) -> Dict[str, str]:
    """
    Verify user email with token from email link

    **Query Parameters:**
    - token: Email verification token

    **Returns:**
    - message: Success message

    **Error Responses:**
    - 400 TOKEN_INVALID: Verification token is invalid
    - 400 TOKEN_EXPIRED: Verification token has expired
    """
    try:
        auth_service = AuthService()
        result = await auth_service.verify_email(token)
        return result
    except AuthException as e:
        raise e.to_http_exception()
    except Exception as e:
        logger.error(f"Email verification error: {e}")
        auth_error = parse_supabase_auth_error(str(e))
        raise auth_error.to_http_exception()


@router.get("/auth/me")
async def get_current_user_profile(
    current_user: CurrentUser = Depends(get_current_user)
) -> Dict[str, Any]:
    """
    Get current authenticated user's profile

    **Requires:** Authentication

    **Returns:**
    - User profile data including:
      - id, email, display_name
      - active_role, available_roles
      - profile information

    **Error Responses:**
    - 404 USER_NOT_FOUND: User profile not found
    """
    try:
        auth_service = AuthService()
        result = await auth_service.get_user_profile(current_user.id)
        return result
    except AuthException as e:
        raise e.to_http_exception()
    except Exception as e:
        logger.error(f"Get profile error for user {current_user.id}: {e}")
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=create_error_response(
                AuthErrorCode.USER_NOT_FOUND,
                "User profile not found."
            )
        )


@router.put("/auth/me")
async def update_current_user_profile(
    profile_data: UpdateProfileRequest,
    current_user: CurrentUser = Depends(get_current_user)
) -> Dict[str, Any]:
    """
    Update current user's profile

    **Requires:** Authentication

    **Request Body:**
    - display_name: Optional new display name
    - phone_number: Optional new phone number
    - avatar_url: Optional new avatar URL
    - bio: Optional bio/description

    **Returns:**
    - Updated user profile

    **Error Responses:**
    - 400 PROFILE_UPDATE_FAILED: Failed to update profile
    - 400 VALIDATION_ERROR: Invalid profile data
    """
    try:
        auth_service = AuthService()
        result = await auth_service.update_user_profile(current_user.id, profile_data)
        return result
    except AuthException as e:
        raise e.to_http_exception()
    except Exception as e:
        logger.error(f"Profile update error for user {current_user.id}: {e}")
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=create_error_response(
                AuthErrorCode.PROFILE_UPDATE_FAILED,
                "Failed to update profile. Please try again."
            )
        )


@router.patch("/auth/profile")
async def patch_profile(
    profile_data: UpdateProfileRequest,
    current_user: CurrentUser = Depends(get_current_user)
) -> Dict[str, Any]:
    """
    Update current user's profile (PATCH method alias for PUT /auth/me)

    **Requires:** Authentication

    **Request Body:**
    - display_name: Optional new display name
    - phone_number: Optional new phone number
    - avatar_url: Optional new avatar URL
    - bio: Optional bio/description

    **Returns:**
    - Updated user profile
    """
    # Delegate to the same logic as PUT /auth/me
    return await update_current_user_profile(profile_data, current_user)


@router.post("/auth/upload-photo")
async def upload_profile_photo(
    file: UploadFile = File(...),
    current_user: CurrentUser = Depends(get_current_user)
) -> Dict[str, Any]:
    """
    Upload profile photo to Supabase Storage

    **Requires:** Authentication

    **Request Body:**
    - file: Image file (multipart/form-data)

    **Returns:**
    - photo_url: Public URL of the uploaded photo
    - message: Success message

    **Error Responses:**
    - 400 INVALID_FILE_TYPE: File type not allowed
    - 400 FILE_TOO_LARGE: File exceeds size limit
    - 500 UPLOAD_FAILED: Failed to upload file
    """
    try:
        # Validate file type
        allowed_types = ['image/jpeg', 'image/png', 'image/gif', 'image/webp']
        if file.content_type not in allowed_types:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail={"error": "Invalid file type. Allowed: JPEG, PNG, GIF, WEBP"}
            )

        # Validate file size (5MB max)
        contents = await file.read()
        if len(contents) > 5 * 1024 * 1024:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail={"error": "File too large. Maximum size is 5MB"}
            )

        # Generate unique filename
        extension = file.filename.split('.')[-1] if file.filename else 'jpg'
        timestamp = int(datetime.now().timestamp() * 1000)
        file_path = f"{current_user.id}/avatar_{timestamp}.{extension}"

        # Upload to Supabase Storage using service role (bypasses RLS)
        auth_service = AuthService()
        storage = auth_service.db.storage.from_('user-profiles')

        storage.upload(
            file_path,
            contents,
            file_options={"content-type": file.content_type, "upsert": "true"}
        )

        # Get public URL
        public_url = storage.get_public_url(file_path)

        # Update user profile with new photo URL
        await auth_service.update_user_profile(
            current_user.id,
            UpdateProfileRequest(avatar_url=public_url)
        )

        logger.info(f"Profile photo uploaded for user {current_user.id}")

        return {
            "photo_url": public_url,
            "message": "Photo uploaded successfully"
        }

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Photo upload error for user {current_user.id}: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail={"error": f"Failed to upload photo: {str(e)}"}
        )


@router.post("/auth/switch-role")
async def switch_role(
    role_data: SwitchRoleRequest,
    current_user: CurrentUser = Depends(get_current_user)
) -> Dict[str, Any]:
    """
    Switch user's active role

    **Requires:** Authentication

    **Request Body:**
    - new_role: The role to switch to (must be in user's available_roles)

    **Returns:**
    - Updated user profile with new active_role

    **Error Responses:**
    - 400 ROLE_NOT_AVAILABLE: User does not have access to this role
    - 400 INVALID_ROLE: Invalid role specified
    """
    try:
        auth_service = AuthService()
        result = await auth_service.switch_role(current_user.id, role_data.new_role)
        return result
    except AuthException as e:
        raise e.to_http_exception()
    except Exception as e:
        logger.error(f"Role switch error for user {current_user.id}: {e}")
        error_msg = str(e).lower()
        if "does not have access" in error_msg or "not available" in error_msg:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=create_error_response(
                    AuthErrorCode.ROLE_NOT_AVAILABLE,
                    f"You do not have access to the role: {role_data.new_role}"
                )
            )
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=create_error_response(
                AuthErrorCode.INTERNAL_ERROR,
                "Failed to switch role. Please try again."
            )
        )


@router.delete("/auth/me")
async def delete_account(
    current_user: CurrentUser = Depends(get_current_user)
) -> Dict[str, str]:
    """
    Delete current user's account (soft delete)

    **Requires:** Authentication

    **Returns:**
    - message: Success message

    **Error Responses:**
    - 400 INTERNAL_ERROR: Failed to delete account
    """
    try:
        auth_service = AuthService()
        result = await auth_service.delete_user(current_user.id)
        return result
    except AuthException as e:
        raise e.to_http_exception()
    except Exception as e:
        logger.error(f"Account deletion error for user {current_user.id}: {e}")
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=create_error_response(
                AuthErrorCode.INTERNAL_ERROR,
                "Failed to delete account. Please try again or contact support."
            )
        )


# Admin endpoints
@router.post("/auth/users/{user_id}/add-role")
async def add_role_to_user(
    user_id: str,
    new_role: str = Body(..., embed=True),
    current_user: CurrentUser = Depends(require_admin)
) -> Dict[str, Any]:
    """
    Add a role to user's available roles (Admin only)

    **Requires:** Admin authentication

    **Path Parameters:**
    - user_id: Target user's ID

    **Request Body:**
    - new_role: Role to add

    **Returns:**
    - Updated user profile

    **Error Responses:**
    - 400 INVALID_ROLE: Invalid role specified
    - 404 USER_NOT_FOUND: User not found
    """
    try:
        auth_service = AuthService()
        result = await auth_service.add_role_to_user(user_id, new_role)
        return result
    except AuthException as e:
        raise e.to_http_exception()
    except Exception as e:
        logger.error(f"Add role error for user {user_id}: {e}")
        error_msg = str(e).lower()
        if "invalid role" in error_msg:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=create_error_response(
                    AuthErrorCode.INVALID_ROLE,
                    f"Invalid role: {new_role}"
                )
            )
        if "not found" in error_msg:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=create_error_response(
                    AuthErrorCode.USER_NOT_FOUND,
                    "User not found."
                )
            )
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=create_error_response(
                AuthErrorCode.INTERNAL_ERROR,
                "Failed to add role. Please try again."
            )
        )


@router.get("/auth/users/{user_id}")
async def get_user_by_id(
    user_id: str,
    current_user: CurrentUser = Depends(require_admin)
) -> Dict[str, Any]:
    """
    Get user profile by ID (Admin only)

    **Requires:** Admin authentication

    **Path Parameters:**
    - user_id: User's ID

    **Returns:**
    - User profile data

    **Error Responses:**
    - 404 USER_NOT_FOUND: User not found
    """
    try:
        auth_service = AuthService()
        result = await auth_service.get_user_profile(user_id)
        return result
    except AuthException as e:
        raise e.to_http_exception()
    except Exception as e:
        logger.error(f"Get user by ID error for {user_id}: {e}")
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=create_error_response(
                AuthErrorCode.USER_NOT_FOUND,
                "User not found."
            )
        )
