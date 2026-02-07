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

from app.database.config import get_supabase, get_supabase_admin

logger = logging.getLogger(__name__)

# Security scheme
security = HTTPBearer()

# JWT Configuration
SUPABASE_JWT_SECRET = os.environ.get("SUPABASE_JWT_SECRET", "")
ALGORITHM = "HS256"

# CRITICAL: Validate JWT secret at startup
def _validate_jwt_secret():
    """
    Validate JWT secret configuration at startup.
    Logs warnings if secret is missing or insecure.
    """
    if not SUPABASE_JWT_SECRET:
        logger.warning(
            "WARNING: SUPABASE_JWT_SECRET environment variable is not set. "
            "JWT authentication will not function properly. "
            "Set SUPABASE_JWT_SECRET in your environment for production use."
        )
        return

    if len(SUPABASE_JWT_SECRET) < 32:
        logger.warning(
            f"WARNING: SUPABASE_JWT_SECRET is too short ({len(SUPABASE_JWT_SECRET)} characters). "
            "For security, JWT secrets should be at least 32 characters long. "
            "Consider using a stronger, randomly generated secret."
        )
        return

    logger.info("JWT secret validation passed - authentication is properly configured")

# Run validation at module import
_validate_jwt_secret()

# User roles
class UserRole:
    STUDENT = "student"
    COUNSELOR = "counselor"
    PARENT = "parent"
    INSTITUTION = "institution"
    RECOMMENDER = "recommender"
    # Admin roles - support both naming conventions (snake_case and camelCase)
    ADMIN_SUPER = "admin_super"
    ADMIN_CONTENT = "admin_content"
    ADMIN_SUPPORT = "admin_support"
    ADMIN_REGIONAL = "admin_regional"
    ADMIN_FINANCE = "admin_finance"
    ADMIN_ANALYTICS = "admin_analytics"
    # Frontend naming convention (for compatibility)
    SUPER_ADMIN = "superadmin"
    REGIONAL_ADMIN = "regionaladmin"
    CONTENT_ADMIN = "contentadmin"
    SUPPORT_ADMIN = "supportadmin"
    FINANCE_ADMIN = "financeadmin"
    ANALYTICS_ADMIN = "analyticsadmin"

    @classmethod
    def all_roles(cls) -> List[str]:
        return [
            cls.STUDENT,
            cls.COUNSELOR,
            cls.PARENT,
            cls.INSTITUTION,
            cls.RECOMMENDER,
            # Snake_case admin roles
            cls.ADMIN_SUPER,
            cls.ADMIN_CONTENT,
            cls.ADMIN_SUPPORT,
            cls.ADMIN_REGIONAL,
            cls.ADMIN_FINANCE,
            cls.ADMIN_ANALYTICS,
            # Frontend naming convention (camelCase without separator)
            cls.SUPER_ADMIN,
            cls.REGIONAL_ADMIN,
            cls.CONTENT_ADMIN,
            cls.SUPPORT_ADMIN,
            cls.FINANCE_ADMIN,
            cls.ANALYTICS_ADMIN,
        ]

    @classmethod
    def admin_roles(cls) -> List[str]:
        return [
            cls.ADMIN_SUPER, cls.ADMIN_CONTENT, cls.ADMIN_SUPPORT,
            cls.ADMIN_REGIONAL, cls.ADMIN_FINANCE, cls.ADMIN_ANALYTICS,
            cls.SUPER_ADMIN, cls.REGIONAL_ADMIN, cls.CONTENT_ADMIN,
            cls.SUPPORT_ADMIN, cls.FINANCE_ADMIN, cls.ANALYTICS_ADMIN,
        ]

    @classmethod
    def normalize_role(cls, role: str) -> str:
        """Normalize role name to a consistent format"""
        role_lower = role.lower().strip()
        # Map frontend naming to standard format
        role_mapping = {
            "superadmin": "superadmin",
            "admin_super": "superadmin",
            "regionaladmin": "regionaladmin",
            "admin_regional": "regionaladmin",
            "contentadmin": "contentadmin",
            "admin_content": "contentadmin",
            "supportadmin": "supportadmin",
            "admin_support": "supportadmin",
            "financeadmin": "financeadmin",
            "admin_finance": "financeadmin",
            "analyticsadmin": "analyticsadmin",
            "admin_analytics": "analyticsadmin",
        }
        return role_mapping.get(role_lower, role_lower)


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
    admin_role: Optional[str] = None
    regional_scope: Optional[str] = None
    is_regional_admin: bool = False


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

    # Fetch user from database (use admin client to bypass RLS)
    try:
        db = get_supabase_admin()
        response = db.table('users').select('*').eq('id', token_data.sub).single().execute()

        if not response.data:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="User not found"
            )

        user_data = response.data
        user_role = user_data.get('active_role', UserRole.STUDENT)

        # Build base user
        current_user = CurrentUser(
            id=user_data['id'],
            email=user_data['email'],
            role=user_role,
            display_name=user_data.get('display_name'),
            available_roles=user_data.get('available_roles', [])
        )

        # If user has an admin role, fetch admin-specific fields
        normalized = UserRole.normalize_role(user_role)
        if normalized in [UserRole.normalize_role(r) for r in UserRole.admin_roles()]:
            try:
                admin_resp = db.table('admin_users').select(
                    'admin_role, regional_scope'
                ).eq('id', user_data['id']).single().execute()

                if admin_resp.data:
                    admin_role = admin_resp.data.get('admin_role')
                    regional_scope = admin_resp.data.get('regional_scope')
                    current_user.admin_role = admin_role
                    current_user.regional_scope = regional_scope
                    current_user.is_regional_admin = (
                        admin_role in ('regionaladmin', 'admin_regional')
                        and regional_scope is not None
                    )
            except Exception as admin_err:
                logger.warning(f"Could not fetch admin_users record: {admin_err}")

        return current_user

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

        db = get_supabase_admin()
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
require_super_admin = RoleChecker([UserRole.ADMIN_SUPER, UserRole.SUPER_ADMIN])

# Role-specific admin checkers (super admin always included)
_super = [UserRole.ADMIN_SUPER, UserRole.SUPER_ADMIN]

require_senior_admin = RoleChecker(
    _super + [UserRole.ADMIN_REGIONAL, UserRole.REGIONAL_ADMIN]
)

require_content_admin = RoleChecker(
    _super + [UserRole.ADMIN_CONTENT, UserRole.CONTENT_ADMIN]
)
require_finance_admin = RoleChecker(
    _super + [UserRole.ADMIN_FINANCE, UserRole.FINANCE_ADMIN]
)
require_support_admin = RoleChecker(
    _super + [UserRole.ADMIN_SUPPORT, UserRole.SUPPORT_ADMIN]
)
require_analytics_admin = RoleChecker(
    _super + [UserRole.ADMIN_ANALYTICS, UserRole.ANALYTICS_ADMIN]
)


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


def apply_regional_filter(query, current_user: CurrentUser, region_column: str = 'location'):
    """
    Filter query results by the admin's regional scope.
    Only applies if the current user is a regional admin with a specific region set.
    Super admins and admins with 'global' scope see all records.
    """
    if current_user.is_regional_admin and current_user.regional_scope:
        # 'global' or 'Global' means no regional filtering - see all records
        if current_user.regional_scope.lower() == 'global':
            return query
        query = query.ilike(region_column, f'%{current_user.regional_scope}%')
    return query


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
