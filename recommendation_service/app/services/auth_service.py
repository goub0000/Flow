"""
Authentication Service - Supabase Auth Integration
Handles user registration, login, logout, password reset, and profile management
Updated: 2025-11-27 - Enhanced error handling with structured error responses
"""
from typing import Optional, Dict, Any, List
from datetime import datetime
import logging
from pydantic import BaseModel, EmailStr
from fastapi import status

from app.database.config import get_supabase
from app.utils.security import UserRole
from app.utils.activity_logger import log_activity_sync, ActivityType
from app.utils.exceptions import (
    AuthException,
    AuthErrorCode,
    parse_supabase_auth_error
)

logger = logging.getLogger(__name__)


# Request/Response Models
class SignUpRequest(BaseModel):
    email: EmailStr
    password: str
    display_name: str
    role: str = UserRole.STUDENT
    phone_number: Optional[str] = None
    profile_data: Optional[Dict[str, Any]] = {}


class SignInRequest(BaseModel):
    email: EmailStr
    password: str


class SignInResponse(BaseModel):
    access_token: str
    refresh_token: str
    user: Dict[str, Any]
    expires_in: int


class ResetPasswordRequest(BaseModel):
    email: EmailStr


class UpdatePasswordRequest(BaseModel):
    current_password: str
    new_password: str


class UpdateProfileRequest(BaseModel):
    display_name: Optional[str] = None
    phone_number: Optional[str] = None
    avatar_url: Optional[str] = None
    bio: Optional[str] = None
    metadata: Optional[Dict[str, Any]] = None


class SwitchRoleRequest(BaseModel):
    new_role: str


class AuthService:
    """
    Service for handling authentication operations with Supabase
    """

    def __init__(self):
        self.db = get_supabase()

    async def sign_up(self, signup_data: SignUpRequest) -> Dict[str, Any]:
        """
        Register a new user
        Creates auth user and user profile in database

        SECURITY: Admin roles cannot be created through public registration.
        Admin accounts must be created directly in the database by a system administrator.
        """
        try:
            # SECURITY: Block admin role registration through public API
            # Admin accounts should only be created directly in the database
            role_lower = signup_data.role.lower()
            if 'admin' in role_lower:
                logger.warning(f"Attempted admin registration blocked for email: {signup_data.email}")
                raise AuthException(
                    error_code=AuthErrorCode.INVALID_ROLE,
                    message="Admin accounts cannot be created through registration. Please contact a system administrator.",
                    status_code=status.HTTP_403_FORBIDDEN
                )

            # Only allow standard user roles through public registration
            allowed_public_roles = [
                UserRole.STUDENT,
                UserRole.COUNSELOR,
                UserRole.PARENT,
                UserRole.INSTITUTION,
                UserRole.RECOMMENDER,
            ]

            # Validate role is in allowed public roles
            if signup_data.role not in allowed_public_roles:
                raise AuthException(
                    error_code=AuthErrorCode.INVALID_ROLE,
                    message=f"Invalid role: {signup_data.role}. Valid roles are: student, counselor, parent, institution, recommender",
                    status_code=status.HTTP_400_BAD_REQUEST
                )

            # 1. Create auth user with Supabase Auth
            auth_response = self.db.auth.sign_up({
                "email": signup_data.email,
                "password": signup_data.password,
                "options": {
                    "data": {
                        "display_name": signup_data.display_name,
                        "role": signup_data.role
                    }
                }
            })

            if not auth_response.user:
                raise AuthException(
                    error_code=AuthErrorCode.REGISTRATION_FAILED,
                    message="Failed to create user account. Please try again.",
                    status_code=status.HTTP_400_BAD_REQUEST
                )

            user_id = auth_response.user.id

            # 2. Create user profile in users table
            user_profile = {
                "id": user_id,
                "email": signup_data.email,
                "display_name": signup_data.display_name,
                "active_role": signup_data.role,
                "available_roles": [signup_data.role],
                "phone_number": signup_data.phone_number,
                "email_verified": False,
                "profile_completed": False,
                "onboarding_completed": False,
                "preferences": signup_data.profile_data or {},
                "created_at": datetime.utcnow().isoformat(),
                "updated_at": datetime.utcnow().isoformat(),
            }

            profile_response = self.db.table('users').insert(user_profile).execute()

            logger.info(f"User registered successfully: {signup_data.email} (Role: {signup_data.role})")

            # Log activity
            log_activity_sync(
                action_type=ActivityType.USER_REGISTRATION,
                description=f"New user registered: {signup_data.display_name} ({signup_data.role})",
                user_id=user_id,
                user_name=signup_data.display_name,
                user_email=signup_data.email,
                user_role=signup_data.role,
                metadata={
                    "role": signup_data.role,
                    "email_verified": False
                }
            )

            return {
                "user": profile_response.data[0] if profile_response.data else user_profile,
                "message": "Registration successful. Please check your email to verify your account.",
                "requires_verification": True
            }

        except AuthException:
            # Re-raise our custom exceptions
            raise
        except Exception as e:
            error_message = str(e).lower()
            logger.error(f"Sign up error: {e}")

            # Check if error is due to duplicate email
            if "already" in error_message or "duplicate" in error_message or "exists" in error_message or "registered" in error_message:
                raise AuthException(
                    error_code=AuthErrorCode.EMAIL_ALREADY_EXISTS,
                    message="This email address is already registered.",
                    status_code=status.HTTP_409_CONFLICT
                )

            # Check for weak password
            if "password" in error_message and any(term in error_message for term in ["weak", "short", "simple", "least"]):
                raise AuthException(
                    error_code=AuthErrorCode.WEAK_PASSWORD,
                    message="Password does not meet security requirements. It must be at least 8 characters long.",
                    status_code=status.HTTP_400_BAD_REQUEST
                )

            # Check for invalid email format
            if "email" in error_message and any(term in error_message for term in ["invalid", "format", "valid"]):
                raise AuthException(
                    error_code=AuthErrorCode.INVALID_EMAIL_FORMAT,
                    message="Please enter a valid email address.",
                    status_code=status.HTTP_400_BAD_REQUEST
                )

            # Parse other Supabase errors
            raise parse_supabase_auth_error(str(e))

    async def sign_in(self, signin_data: SignInRequest) -> SignInResponse:
        """
        Sign in user with email and password
        Returns access token, refresh token, and user data
        """
        try:
            # Sign in with Supabase Auth
            auth_response = self.db.auth.sign_in_with_password({
                "email": signin_data.email,
                "password": signin_data.password
            })

            if not auth_response.user or not auth_response.session:
                raise AuthException(
                    error_code=AuthErrorCode.INVALID_CREDENTIALS,
                    message="Invalid email or password.",
                    status_code=status.HTTP_401_UNAUTHORIZED
                )

            # Fetch user profile
            user_response = self.db.table('users').select('*').eq('id', auth_response.user.id).execute()

            # If user profile doesn't exist, create it (handles orphaned auth users)
            if not user_response.data or len(user_response.data) == 0:
                logger.warning(f"User profile not found for {auth_response.user.id}, creating...")

                # Get role from user metadata or default to 'student'
                user_metadata = auth_response.user.user_metadata or {}
                role = user_metadata.get('role', 'student')
                display_name = user_metadata.get('display_name', auth_response.user.email.split('@')[0])

                # Create user profile
                new_profile = {
                    "id": auth_response.user.id,
                    "email": auth_response.user.email,
                    "display_name": display_name,
                    "active_role": role,
                    "available_roles": [role],
                    "phone_number": None,
                    "email_verified": auth_response.user.email_confirmed_at is not None,
                    "profile_completed": False,
                    "onboarding_completed": False,
                    "preferences": {},
                    "created_at": auth_response.user.created_at if isinstance(auth_response.user.created_at, str) else (auth_response.user.created_at.isoformat() if auth_response.user.created_at else datetime.utcnow().isoformat()),
                    "updated_at": datetime.utcnow().isoformat(),
                }

                profile_response = self.db.table('users').insert(new_profile).execute()
                user_data = profile_response.data[0] if profile_response.data else new_profile
            else:
                user_data = user_response.data[0]

            # Check if account is disabled
            if user_data.get('is_active') is False:
                raise AuthException(
                    error_code=AuthErrorCode.ACCOUNT_DISABLED,
                    message="This account has been disabled.",
                    status_code=status.HTTP_403_FORBIDDEN
                )

            # Update last login timestamp
            self.db.table('users').update({
                "last_login_at": datetime.utcnow().isoformat()
            }).eq('id', auth_response.user.id).execute()

            logger.info(f"User signed in: {signin_data.email}")

            # Log activity
            log_activity_sync(
                action_type=ActivityType.USER_LOGIN,
                description=f"User logged in: {user_data.get('display_name', 'Unknown')}",
                user_id=auth_response.user.id,
                user_name=user_data.get('display_name'),
                user_email=signin_data.email,
                user_role=user_data.get('active_role'),
                metadata={
                    "email_verified": user_data.get('email_verified', False)
                }
            )

            return SignInResponse(
                access_token=auth_response.session.access_token,
                refresh_token=auth_response.session.refresh_token,
                user=user_data,
                expires_in=auth_response.session.expires_in or 3600
            )

        except AuthException:
            # Re-raise our custom exceptions
            raise
        except Exception as e:
            error_message = str(e).lower()
            logger.error(f"Sign in error: {e}")

            # Check for invalid credentials
            if any(term in error_message for term in ["invalid", "credentials", "password", "email"]):
                raise AuthException(
                    error_code=AuthErrorCode.INVALID_CREDENTIALS,
                    message="Invalid email or password.",
                    status_code=status.HTTP_401_UNAUTHORIZED
                )

            # Check for email not verified
            if "not confirmed" in error_message or "verify" in error_message:
                raise AuthException(
                    error_code=AuthErrorCode.EMAIL_NOT_VERIFIED,
                    message="Please verify your email address before logging in.",
                    status_code=status.HTTP_403_FORBIDDEN
                )

            # Parse other Supabase errors
            raise parse_supabase_auth_error(str(e))

    async def sign_out(self, access_token: str) -> Dict[str, str]:
        """
        Sign out user and invalidate token
        """
        try:
            # Get current user before signing out
            auth_user = self.db.auth.get_user()
            user_id = auth_user.user.id if auth_user and auth_user.user else None

            self.db.auth.sign_out()

            logger.info("User signed out successfully")

            # Log activity if we have user info
            if user_id:
                try:
                    user_response = self.db.table('users').select('display_name, email, active_role').eq('id', user_id).single().execute()
                    if user_response.data:
                        log_activity_sync(
                            action_type=ActivityType.USER_LOGOUT,
                            description=f"User logged out: {user_response.data.get('display_name', 'Unknown')}",
                            user_id=user_id,
                            user_name=user_response.data.get('display_name'),
                            user_email=user_response.data.get('email'),
                            user_role=user_response.data.get('active_role')
                        )
                except Exception as log_error:
                    logger.warning(f"Failed to log logout activity: {log_error}")

            return {"message": "Signed out successfully"}

        except Exception as e:
            logger.error(f"Sign out error: {e}")
            raise Exception(f"Sign out failed: {str(e)}")

    async def refresh_token(self, refresh_token: str) -> Dict[str, Any]:
        """
        Refresh access token using refresh token
        """
        try:
            auth_response = self.db.auth.refresh_session(refresh_token)

            if not auth_response.session:
                raise AuthException(
                    error_code=AuthErrorCode.REFRESH_TOKEN_INVALID,
                    message="Invalid refresh token. Please log in again.",
                    status_code=status.HTTP_401_UNAUTHORIZED
                )

            return {
                "access_token": auth_response.session.access_token,
                "refresh_token": auth_response.session.refresh_token,
                "expires_in": auth_response.session.expires_in or 3600
            }

        except AuthException:
            raise
        except Exception as e:
            error_message = str(e).lower()
            logger.error(f"Refresh token error: {e}")

            if "expired" in error_message:
                raise AuthException(
                    error_code=AuthErrorCode.REFRESH_TOKEN_EXPIRED,
                    message="Your refresh token has expired. Please log in again.",
                    status_code=status.HTTP_401_UNAUTHORIZED
                )

            raise AuthException(
                error_code=AuthErrorCode.REFRESH_TOKEN_INVALID,
                message="Invalid refresh token. Please log in again.",
                status_code=status.HTTP_401_UNAUTHORIZED
            )

    async def request_password_reset(self, email: str) -> Dict[str, str]:
        """
        Send password reset email
        """
        try:
            self.db.auth.reset_password_for_email(email, {
                "redirect_to": "https://yourapp.com/reset-password"  # Update with actual URL
            })

            logger.info(f"Password reset email sent to: {email}")

            return {"message": "Password reset email sent. Please check your inbox."}

        except Exception as e:
            logger.error(f"Password reset request error: {e}")
            raise Exception(f"Password reset request failed: {str(e)}")

    async def update_password(self, user_id: str, new_password: str) -> Dict[str, str]:
        """
        Update user password
        """
        try:
            self.db.auth.update_user({
                "password": new_password
            })

            logger.info(f"Password updated for user: {user_id}")

            # Log activity
            try:
                user_response = self.db.table('users').select('display_name, email, active_role').eq('id', user_id).single().execute()
                if user_response.data:
                    log_activity_sync(
                        action_type=ActivityType.USER_PASSWORD_CHANGED,
                        description=f"Password changed for: {user_response.data.get('display_name', 'Unknown')}",
                        user_id=user_id,
                        user_name=user_response.data.get('display_name'),
                        user_email=user_response.data.get('email'),
                        user_role=user_response.data.get('active_role')
                    )
            except Exception as log_error:
                logger.warning(f"Failed to log password change activity: {log_error}")

            return {"message": "Password updated successfully"}

        except Exception as e:
            logger.error(f"Password update error: {e}")
            raise Exception(f"Password update failed: {str(e)}")

    async def verify_email(self, token: str) -> Dict[str, str]:
        """
        Verify user email with token
        """
        try:
            # Supabase handles email verification automatically
            # This endpoint is for confirming verification status
            auth_user = self.db.auth.get_user()

            if auth_user and auth_user.user:
                # Update email_verified in users table
                self.db.table('users').update({
                    "email_verified": True,
                    "updated_at": datetime.utcnow().isoformat()
                }).eq('id', auth_user.user.id).execute()

                logger.info(f"Email verified for user: {auth_user.user.id}")

                return {"message": "Email verified successfully"}

            raise Exception("Invalid verification token")

        except Exception as e:
            logger.error(f"Email verification error: {e}")
            raise Exception(f"Email verification failed: {str(e)}")

    async def get_user_profile(self, user_id: str) -> Dict[str, Any]:
        """
        Get user profile by ID
        """
        try:
            response = self.db.table('users').select('*').eq('id', user_id).single().execute()

            if not response.data:
                raise AuthException(
                    error_code=AuthErrorCode.USER_NOT_FOUND,
                    message="User profile not found.",
                    status_code=status.HTTP_404_NOT_FOUND
                )

            return response.data

        except AuthException:
            raise
        except Exception as e:
            logger.error(f"Get profile error: {e}")
            raise AuthException(
                error_code=AuthErrorCode.USER_NOT_FOUND,
                message="Failed to fetch user profile.",
                status_code=status.HTTP_404_NOT_FOUND
            )

    async def update_user_profile(self, user_id: str, profile_data: UpdateProfileRequest) -> Dict[str, Any]:
        """
        Update user profile information
        """
        try:
            # Build update dict with only provided fields
            update_data = {
                "updated_at": datetime.utcnow().isoformat()
            }

            if profile_data.display_name is not None:
                update_data["display_name"] = profile_data.display_name

            if profile_data.phone_number is not None:
                update_data["phone_number"] = profile_data.phone_number

            if profile_data.avatar_url is not None:
                update_data["photo_url"] = profile_data.avatar_url

            # Update metadata JSONB column with role-specific data
            if profile_data.metadata is not None:
                update_data["metadata"] = profile_data.metadata

            # Update in database
            response = self.db.table('users').update(update_data).eq('id', user_id).execute()

            if not response.data:
                raise AuthException(
                    error_code=AuthErrorCode.PROFILE_UPDATE_FAILED,
                    message="Failed to update profile.",
                    status_code=status.HTTP_400_BAD_REQUEST
                )

            logger.info(f"Profile updated for user: {user_id}")

            return response.data[0]

        except AuthException:
            raise
        except Exception as e:
            logger.error(f"Update profile error: {e}")
            raise AuthException(
                error_code=AuthErrorCode.PROFILE_UPDATE_FAILED,
                message="Failed to update profile. Please try again.",
                status_code=status.HTTP_400_BAD_REQUEST
            )

    async def switch_role(self, user_id: str, new_role: str) -> Dict[str, Any]:
        """
        Switch user's active role (if they have multiple roles)
        """
        try:
            # Fetch user's available roles
            user_response = self.db.table('users').select('available_roles, active_role, display_name, email').eq('id', user_id).single().execute()

            if not user_response.data:
                raise AuthException(
                    error_code=AuthErrorCode.USER_NOT_FOUND,
                    message="User not found.",
                    status_code=status.HTTP_404_NOT_FOUND
                )

            available_roles = user_response.data.get('available_roles', [])
            old_role = user_response.data.get('active_role')

            if new_role not in available_roles:
                raise AuthException(
                    error_code=AuthErrorCode.ROLE_NOT_AVAILABLE,
                    message=f"You do not have access to role: {new_role}. Your available roles are: {', '.join(available_roles)}",
                    status_code=status.HTTP_400_BAD_REQUEST
                )

            # Update active role
            response = self.db.table('users').update({
                "active_role": new_role,
                "updated_at": datetime.utcnow().isoformat()
            }).eq('id', user_id).execute()

            logger.info(f"User {user_id} switched to role: {new_role}")

            # Log activity
            log_activity_sync(
                action_type=ActivityType.USER_ROLE_CHANGED,
                description=f"User {user_response.data.get('display_name', 'Unknown')} switched role from {old_role} to {new_role}",
                user_id=user_id,
                user_name=user_response.data.get('display_name'),
                user_email=user_response.data.get('email'),
                user_role=new_role,
                metadata={
                    "old_role": old_role,
                    "new_role": new_role
                }
            )

            return response.data[0]

        except AuthException:
            raise
        except Exception as e:
            logger.error(f"Switch role error: {e}")
            raise AuthException(
                error_code=AuthErrorCode.INTERNAL_ERROR,
                message="Failed to switch role. Please try again.",
                status_code=status.HTTP_400_BAD_REQUEST
            )

    async def add_role_to_user(self, user_id: str, new_role: str) -> Dict[str, Any]:
        """
        Add a new role to user's available roles (admin operation)
        """
        try:
            if new_role not in UserRole.all_roles():
                raise AuthException(
                    error_code=AuthErrorCode.INVALID_ROLE,
                    message=f"Invalid role: {new_role}. Valid roles are: {', '.join(UserRole.all_roles())}",
                    status_code=status.HTTP_400_BAD_REQUEST
                )

            # Fetch current roles
            user_response = self.db.table('users').select('available_roles').eq('id', user_id).single().execute()

            if not user_response.data:
                raise AuthException(
                    error_code=AuthErrorCode.USER_NOT_FOUND,
                    message="User not found.",
                    status_code=status.HTTP_404_NOT_FOUND
                )

            available_roles = user_response.data.get('available_roles', [])

            if new_role in available_roles:
                return {"message": "User already has this role", "available_roles": available_roles}

            # Add new role
            available_roles.append(new_role)

            response = self.db.table('users').update({
                "available_roles": available_roles,
                "updated_at": datetime.utcnow().isoformat()
            }).eq('id', user_id).execute()

            logger.info(f"Role {new_role} added to user: {user_id}")

            return response.data[0]

        except AuthException:
            raise
        except Exception as e:
            logger.error(f"Add role error: {e}")
            raise AuthException(
                error_code=AuthErrorCode.INTERNAL_ERROR,
                message="Failed to add role. Please try again.",
                status_code=status.HTTP_400_BAD_REQUEST
            )

    async def delete_user(self, user_id: str) -> Dict[str, str]:
        """
        Delete user account (soft delete - mark as deleted)
        """
        try:
            # Soft delete by updating status
            self.db.table('users').update({
                "is_active": False,
                "deleted_at": datetime.utcnow().isoformat(),
                "updated_at": datetime.utcnow().isoformat()
            }).eq('id', user_id).execute()

            logger.info(f"User deleted: {user_id}")

            return {"message": "Account deleted successfully"}

        except Exception as e:
            logger.error(f"Delete user error: {e}")
            raise Exception(f"Account deletion failed: {str(e)}")
