"""
Authentication Service - Supabase Auth Integration
Handles user registration, login, logout, password reset, and profile management
"""
from typing import Optional, Dict, Any, List
from datetime import datetime
import logging
from pydantic import BaseModel, EmailStr

from app.database.config import get_supabase
from app.utils.security import UserRole

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
        """
        try:
            # Validate role
            if signup_data.role not in UserRole.all_roles():
                raise ValueError(f"Invalid role: {signup_data.role}")

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
                raise Exception("Failed to create auth user")

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

            return {
                "user": profile_response.data[0] if profile_response.data else user_profile,
                "message": "Registration successful. Please check your email to verify your account.",
                "requires_verification": True
            }

        except Exception as e:
            logger.error(f"Sign up error: {e}")
            raise Exception(f"Registration failed: {str(e)}")

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
                raise Exception("Invalid credentials")

            # Fetch user profile
            user_response = self.db.table('users').select('*').eq('id', auth_response.user.id).single().execute()

            if not user_response.data:
                raise Exception("User profile not found")

            # Update last login timestamp
            self.db.table('users').update({
                "last_login_at": datetime.utcnow().isoformat()
            }).eq('id', auth_response.user.id).execute()

            logger.info(f"User signed in: {signin_data.email}")

            return SignInResponse(
                access_token=auth_response.session.access_token,
                refresh_token=auth_response.session.refresh_token,
                user=user_response.data,
                expires_in=auth_response.session.expires_in or 3600
            )

        except Exception as e:
            logger.error(f"Sign in error: {e}")
            raise Exception(f"Login failed: {str(e)}")

    async def sign_out(self, access_token: str) -> Dict[str, str]:
        """
        Sign out user and invalidate token
        """
        try:
            self.db.auth.sign_out()

            logger.info("User signed out successfully")

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
                raise Exception("Failed to refresh token")

            return {
                "access_token": auth_response.session.access_token,
                "refresh_token": auth_response.session.refresh_token,
                "expires_in": auth_response.session.expires_in or 3600
            }

        except Exception as e:
            logger.error(f"Refresh token error: {e}")
            raise Exception(f"Token refresh failed: {str(e)}")

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
                raise Exception("User not found")

            return response.data

        except Exception as e:
            logger.error(f"Get profile error: {e}")
            raise Exception(f"Failed to fetch user profile: {str(e)}")

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
                update_data["avatar_url"] = profile_data.avatar_url

            if profile_data.bio is not None:
                update_data["bio"] = profile_data.bio

            # Update in database
            response = self.db.table('users').update(update_data).eq('id', user_id).execute()

            if not response.data:
                raise Exception("Failed to update profile")

            logger.info(f"Profile updated for user: {user_id}")

            return response.data[0]

        except Exception as e:
            logger.error(f"Update profile error: {e}")
            raise Exception(f"Profile update failed: {str(e)}")

    async def switch_role(self, user_id: str, new_role: str) -> Dict[str, Any]:
        """
        Switch user's active role (if they have multiple roles)
        """
        try:
            # Fetch user's available roles
            user_response = self.db.table('users').select('available_roles').eq('id', user_id).single().execute()

            if not user_response.data:
                raise Exception("User not found")

            available_roles = user_response.data.get('available_roles', [])

            if new_role not in available_roles:
                raise Exception(f"User does not have access to role: {new_role}")

            # Update active role
            response = self.db.table('users').update({
                "active_role": new_role,
                "updated_at": datetime.utcnow().isoformat()
            }).eq('id', user_id).execute()

            logger.info(f"User {user_id} switched to role: {new_role}")

            return response.data[0]

        except Exception as e:
            logger.error(f"Switch role error: {e}")
            raise Exception(f"Role switch failed: {str(e)}")

    async def add_role_to_user(self, user_id: str, new_role: str) -> Dict[str, Any]:
        """
        Add a new role to user's available roles (admin operation)
        """
        try:
            if new_role not in UserRole.all_roles():
                raise ValueError(f"Invalid role: {new_role}")

            # Fetch current roles
            user_response = self.db.table('users').select('available_roles').eq('id', user_id).single().execute()

            if not user_response.data:
                raise Exception("User not found")

            available_roles = user_response.data.get('available_roles', [])

            if new_role in available_roles:
                return {"message": "User already has this role"}

            # Add new role
            available_roles.append(new_role)

            response = self.db.table('users').update({
                "available_roles": available_roles,
                "updated_at": datetime.utcnow().isoformat()
            }).eq('id', user_id).execute()

            logger.info(f"Role {new_role} added to user: {user_id}")

            return response.data[0]

        except Exception as e:
            logger.error(f"Add role error: {e}")
            raise Exception(f"Failed to add role: {str(e)}")

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
