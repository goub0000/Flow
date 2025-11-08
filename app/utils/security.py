"""
Security utilities for authentication and authorization
Includes JWT token verification, role-based access control, and dependencies
"""
from typing import Optional, List
from fastapi import Depends, HTTPException, status, Header
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
import os
from datetime import datetime, timedelta
from jose import JWTError, jwt
from pydantic import BaseModel
import logging

from app.database.config import get_supabase

logger = logging.getLogger(__name__)

# Security scheme
security = HTTPBearer()

# JWT Configuration
SUPABASE_JWT_SECRET = os.environ.get("SUPABASE_JWT_SECRET", "")
ALGORITHM = "HS256"

# User roles
class UserRole:
    STUDENT = "student"
    COUNSELOR = "counselor"
    PARENT = "parent"
    INSTITUTION = "institution"
    RECOMMENDER = "recommender"
    ADMIN_SUPER = "admin_super"
    ADMIN_CONTENT = "admin_content"
    ADMIN_SUPPORT = "admin_support"

    @classmethod
    def all_roles(cls) -> List[str]:
        return [
            cls.STUDENT,
            cls.COUNSELOR,
            cls.PARENT,
            cls.INSTITUTION,
            cls.RECOMMENDER,
            cls.ADMIN_SUPER,
            cls.ADMIN_CONTENT,
            cls.ADMIN_SUPPORT,
        ]

    @classmethod
    def admin_roles(cls) -> List[str]:
        return [cls.ADMIN_SUPER, cls.ADMIN_CONTENT, cls.ADMIN_SUPPORT]


# Token payload model
class TokenPayload(BaseModel):
    sub: str  # user_id
    email: Optional[str] = None
    role: Optional[str] = None
    exp: Optional[int] = None


# Current user model
class CurrentUser(BaseModel):
    id: str
    email: str
    role: str
    display_name: Optional[str] = None
    available_roles: List[str] = []


async def verify_supabase_token(token: str) -> TokenPayload:
    """
    Verify Supabase JWT token
    """
    try:
        # Decode and verify JWT token
        payload = jwt.decode(
            token,
            SUPABASE_JWT_SECRET,
            algorithms=[ALGORITHM],
            options={"verify_aud": False}  # Supabase tokens don't have aud claim
        )

        token_data = TokenPayload(
            sub=payload.get("sub"),
            email=payload.get("email"),
            role=payload.get("role"),
            exp=payload.get("exp")
        )

        # Check if token is expired
        if token_data.exp:
            exp_datetime = datetime.fromtimestamp(token_data.exp)
            if exp_datetime < datetime.now():
                raise HTTPException(
                    status_code=status.HTTP_401_UNAUTHORIZED,
                    detail="Token has expired",
                    headers={"WWW-Authenticate": "Bearer"},
                )

        return token_data

    except JWTError as e:
        logger.error(f"JWT verification error: {e}")
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Could not validate credentials",
            headers={"WWW-Authenticate": "Bearer"},
        )


async def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security)
) -> CurrentUser:
    """
    Dependency to get the current authenticated user
    """
    token = credentials.credentials

    # Verify token
    token_data = await verify_supabase_token(token)

    if not token_data.sub:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid authentication credentials",
            headers={"WWW-Authenticate": "Bearer"},
        )

    # Fetch user from database
    try:
        db = get_supabase()
        response = db.table('users').select('*').eq('id', token_data.sub).single().execute()

        if not response.data:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="User not found"
            )

        user_data = response.data

        return CurrentUser(
            id=user_data['id'],
            email=user_data['email'],
            role=user_data.get('active_role', UserRole.STUDENT),
            display_name=user_data.get('display_name'),
            available_roles=user_data.get('available_roles', [])
        )

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error fetching user: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Error fetching user data"
        )


async def get_optional_user(
    authorization: Optional[str] = Header(None)
) -> Optional[CurrentUser]:
    """
    Dependency to get the current user if authenticated, None otherwise
    Useful for endpoints that work with or without authentication
    """
    if not authorization or not authorization.startswith("Bearer "):
        return None

    try:
        token = authorization.replace("Bearer ", "")
        token_data = await verify_supabase_token(token)

        if not token_data.sub:
            return None

        db = get_supabase()
        response = db.table('users').select('*').eq('id', token_data.sub).single().execute()

        if not response.data:
            return None

        user_data = response.data

        return CurrentUser(
            id=user_data['id'],
            email=user_data['email'],
            role=user_data.get('active_role', UserRole.STUDENT),
            display_name=user_data.get('display_name'),
            available_roles=user_data.get('available_roles', [])
        )

    except Exception as e:
        logger.warning(f"Optional auth failed: {e}")
        return None


class RoleChecker:
    """
    Dependency to check if user has required role(s)
    """
    def __init__(self, allowed_roles: List[str]):
        self.allowed_roles = allowed_roles

    def __call__(self, current_user: CurrentUser = Depends(get_current_user)) -> CurrentUser:
        if current_user.role not in self.allowed_roles:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail=f"User role '{current_user.role}' is not authorized. Required roles: {self.allowed_roles}"
            )
        return current_user


# Common role dependencies
require_student = RoleChecker([UserRole.STUDENT])
require_counselor = RoleChecker([UserRole.COUNSELOR])
require_parent = RoleChecker([UserRole.PARENT])
require_institution = RoleChecker([UserRole.INSTITUTION])
require_recommender = RoleChecker([UserRole.RECOMMENDER])
require_admin = RoleChecker(UserRole.admin_roles())
require_super_admin = RoleChecker([UserRole.ADMIN_SUPER])


def check_user_owns_resource(user_id: str, resource_user_id: str):
    """
    Check if user owns the resource
    """
    if user_id != resource_user_id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not authorized to access this resource"
        )


def check_user_can_access_student(current_user: CurrentUser, student_id: str):
    """
    Check if user can access student data
    - Students can access their own data
    - Counselors can access assigned students
    - Parents can access their children
    - Admins can access all
    """
    # Admins have full access
    if current_user.role in UserRole.admin_roles():
        return

    # Students can access their own data
    if current_user.role == UserRole.STUDENT and current_user.id == student_id:
        return

    # Counselors and parents need additional checks (implemented in specific endpoints)
    # For now, deny access
    raise HTTPException(
        status_code=status.HTTP_403_FORBIDDEN,
        detail="Not authorized to access this student's data"
    )


# API Key authentication (for system-to-system communication)
async def verify_api_key(x_api_key: str = Header(...)) -> bool:
    """
    Verify API key for system-to-system authentication
    """
    expected_api_key = os.environ.get("SYSTEM_API_KEY", "")

    if not expected_api_key:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="API key not configured"
        )

    if x_api_key != expected_api_key:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid API key"
        )

    return True
