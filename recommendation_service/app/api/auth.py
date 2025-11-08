"""
Authentication API Endpoints
Handles user registration, login, logout, password management, and profile operations
"""
from fastapi import APIRouter, Depends, HTTPException, status, Body
from typing import Dict, Any

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
    """
    try:
        auth_service = AuthService()
        result = await auth_service.sign_up(signup_data)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


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
    """
    try:
        auth_service = AuthService()
        result = await auth_service.sign_in(signin_data)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=str(e)
        )


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
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
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
    """
    try:
        auth_service = AuthService()
        result = await auth_service.refresh_token(refresh_token)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=str(e)
        )


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
    """
    try:
        auth_service = AuthService()
        result = await auth_service.request_password_reset(reset_data.email)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


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
    """
    try:
        auth_service = AuthService()
        # In a real implementation, verify token and extract user_id
        # For now, this is a placeholder
        result = {"message": "Password reset feature requires additional implementation"}
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


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
    """
    try:
        auth_service = AuthService()
        # TODO: Verify current password before updating
        result = await auth_service.update_password(current_user.id, update_data.new_password)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


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
    """
    try:
        auth_service = AuthService()
        result = await auth_service.verify_email(token)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


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
    """
    try:
        auth_service = AuthService()
        result = await auth_service.get_user_profile(current_user.id)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=str(e)
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
    """
    try:
        auth_service = AuthService()
        result = await auth_service.update_user_profile(current_user.id, profile_data)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
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
    """
    try:
        auth_service = AuthService()
        result = await auth_service.switch_role(current_user.id, role_data.new_role)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
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
    """
    try:
        auth_service = AuthService()
        result = await auth_service.delete_user(current_user.id)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
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
    """
    try:
        auth_service = AuthService()
        result = await auth_service.add_role_to_user(user_id, new_role)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
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
    """
    try:
        auth_service = AuthService()
        result = await auth_service.get_user_profile(user_id)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=str(e)
        )
