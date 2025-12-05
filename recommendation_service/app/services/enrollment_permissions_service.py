"""
Enrollment Permissions Service
Manages which students can enroll in which courses
"""
from typing import Optional, List
from datetime import datetime
import logging
from uuid import uuid4

from app.database.config import get_supabase

logger = logging.getLogger(__name__)


class EnrollmentPermissionsService:
    """Service for managing enrollment permissions"""

    def __init__(self):
        self.db = get_supabase()

    async def check_enrollment_permission(
        self,
        student_id: str,
        course_id: str
    ) -> tuple[bool, Optional[str]]:
        """
        Check if student can enroll in a course

        Returns: (can_enroll: bool, reason: str if denied)
        """
        try:
            # Get course details
            course_response = self.db.table('courses').select('institution_id, is_published').eq('id', course_id).single().execute()

            if not course_response.data:
                return False, "Course not found"

            course = course_response.data
            institution_id = course['institution_id']

            if not course['is_published']:
                return False, "Course is not published"

            # Check if student has accepted application to this institution
            is_admitted = await self._check_student_admitted_to_institution(student_id, institution_id)

            if not is_admitted:
                return False, "Student not admitted to this institution"

            # Check if there's an explicit permission
            permission = await self._get_permission(student_id, course_id)

            if permission:
                if permission['status'] == 'approved':
                    # Check validity period
                    if permission.get('valid_until'):
                        valid_until = datetime.fromisoformat(permission['valid_until'].replace('Z', '+00:00'))
                        if datetime.utcnow() > valid_until:
                            return False, "Enrollment permission expired"
                    return True, None
                elif permission['status'] == 'denied':
                    return False, permission.get('denial_reason', 'Enrollment denied by institution')
                elif permission['status'] == 'revoked':
                    return False, "Enrollment permission was revoked"
                elif permission['status'] == 'pending':
                    return False, "Enrollment request pending approval"

            # No explicit permission - student must request access
            return False, "Request enrollment permission from institution"

        except Exception as e:
            logger.error(f"Check permission error: {e}")
            return False, f"Error checking permissions: {str(e)}"

    async def _check_student_admitted_to_institution(
        self,
        student_id: str,
        institution_id: str
    ) -> bool:
        """Check if student has accepted application to institution"""
        try:
            # Query applications directly - applications table has institution_id
            response = self.db.table('applications')\
                .select('id')\
                .eq('student_id', student_id)\
                .eq('institution_id', institution_id)\
                .eq('status', 'accepted')\
                .single()\
                .execute()

            return response.data is not None

        except Exception as e:
            # single() throws exception if no match or multiple matches
            logger.debug(f"Check admission: {e}")
            return False

    async def _get_permission(
        self,
        student_id: str,
        course_id: str
    ) -> Optional[dict]:
        """Get enrollment permission record"""
        try:
            response = self.db.table('enrollment_permissions')\
                .select('*')\
                .eq('student_id', student_id)\
                .eq('course_id', course_id)\
                .single()\
                .execute()

            return response.data if response.data else None

        except Exception:
            return None

    async def request_enrollment_permission(
        self,
        student_id: str,
        course_id: str,
        notes: Optional[str] = None
    ) -> dict:
        """Student requests permission to enroll"""
        try:
            # Get course institution
            course = self.db.table('courses').select('institution_id').eq('id', course_id).single().execute()

            if not course.data:
                raise Exception("Course not found")

            institution_id = course.data['institution_id']

            # Check if already enrolled
            existing_enrollment = self.db.table('enrollments')\
                .select('id')\
                .eq('student_id', student_id)\
                .eq('course_id', course_id)\
                .execute()

            if existing_enrollment.data:
                raise Exception("Already enrolled in this course")

            # Check for existing permission
            existing_permission = await self._get_permission(student_id, course_id)

            if existing_permission:
                if existing_permission['status'] == 'pending':
                    raise Exception("Permission request already pending")
                elif existing_permission['status'] == 'approved':
                    raise Exception("Permission already approved - you can enroll")

            # Create permission request
            permission = {
                "id": str(uuid4()),
                "student_id": student_id,
                "course_id": course_id,
                "institution_id": institution_id,
                "status": "pending",
                "granted_by": "student_request",
                "notes": notes,
                "created_at": datetime.utcnow().isoformat(),
                "updated_at": datetime.utcnow().isoformat(),
            }

            response = self.db.table('enrollment_permissions').insert(permission).execute()

            if not response.data:
                raise Exception("Failed to create permission request")

            logger.info(f"Student {student_id} requested enrollment permission for course {course_id}")

            return response.data[0]

        except Exception as e:
            logger.error(f"Request permission error: {e}")
            raise Exception(f"Failed to request permission: {str(e)}")

    async def grant_permission(
        self,
        student_id: str,
        course_id: str,
        institution_user_id: str,
        valid_until: Optional[datetime] = None,
        notes: Optional[str] = None
    ) -> dict:
        """Institution grants enrollment permission to student"""
        try:
            # Get course to verify institution
            course = self.db.table('courses').select('institution_id').eq('id', course_id).single().execute()

            if not course.data:
                raise Exception("Course not found")

            institution_id = course.data['institution_id']

            # Check if permission already exists
            existing = await self._get_permission(student_id, course_id)

            if existing:
                # Update existing permission
                update_data = {
                    "status": "approved",
                    "reviewed_at": datetime.utcnow().isoformat(),
                    "reviewed_by_user_id": institution_user_id,
                    "valid_until": valid_until.isoformat() if valid_until else None,
                    "notes": notes,
                    "updated_at": datetime.utcnow().isoformat(),
                }

                response = self.db.table('enrollment_permissions')\
                    .update(update_data)\
                    .eq('id', existing['id'])\
                    .execute()
            else:
                # Create new permission
                permission = {
                    "id": str(uuid4()),
                    "student_id": student_id,
                    "course_id": course_id,
                    "institution_id": institution_id,
                    "status": "approved",
                    "granted_by": "institution",
                    "granted_by_user_id": institution_user_id,
                    "reviewed_at": datetime.utcnow().isoformat(),
                    "reviewed_by_user_id": institution_user_id,
                    "valid_until": valid_until.isoformat() if valid_until else None,
                    "notes": notes,
                    "created_at": datetime.utcnow().isoformat(),
                    "updated_at": datetime.utcnow().isoformat(),
                }

                response = self.db.table('enrollment_permissions').insert(permission).execute()

            if not response.data:
                raise Exception("Failed to grant permission")

            logger.info(f"Institution user {institution_user_id} granted enrollment permission to student {student_id} for course {course_id}")

            return response.data[0]

        except Exception as e:
            logger.error(f"Grant permission error: {e}")
            raise Exception(f"Failed to grant permission: {str(e)}")

    async def deny_permission(
        self,
        permission_id: str,
        institution_user_id: str,
        denial_reason: str
    ) -> dict:
        """Institution denies enrollment permission request"""
        try:
            update_data = {
                "status": "denied",
                "reviewed_at": datetime.utcnow().isoformat(),
                "reviewed_by_user_id": institution_user_id,
                "denial_reason": denial_reason,
                "updated_at": datetime.utcnow().isoformat(),
            }

            response = self.db.table('enrollment_permissions')\
                .update(update_data)\
                .eq('id', permission_id)\
                .execute()

            if not response.data:
                raise Exception("Failed to deny permission")

            logger.info(f"Institution user {institution_user_id} denied permission {permission_id}")

            return response.data[0]

        except Exception as e:
            logger.error(f"Deny permission error: {e}")
            raise Exception(f"Failed to deny permission: {str(e)}")

    async def revoke_permission(
        self,
        permission_id: str,
        institution_user_id: str,
        reason: Optional[str] = None
    ) -> dict:
        """Institution revokes previously granted permission"""
        try:
            update_data = {
                "status": "revoked",
                "reviewed_at": datetime.utcnow().isoformat(),
                "reviewed_by_user_id": institution_user_id,
                "denial_reason": reason,
                "updated_at": datetime.utcnow().isoformat(),
            }

            response = self.db.table('enrollment_permissions')\
                .update(update_data)\
                .eq('id', permission_id)\
                .execute()

            if not response.data:
                raise Exception("Failed to revoke permission")

            logger.info(f"Institution user {institution_user_id} revoked permission {permission_id}")

            return response.data[0]

        except Exception as e:
            logger.error(f"Revoke permission error: {e}")
            raise Exception(f"Failed to revoke permission: {str(e)}")

    async def list_course_permission_requests(
        self,
        course_id: str,
        status: Optional[str] = None,
        page: int = 1,
        page_size: int = 20
    ) -> dict:
        """List permission requests for a course"""
        try:
            # First get permissions without join
            query = self.db.table('enrollment_permissions')\
                .select('*', count='exact')\
                .eq('course_id', course_id)

            if status:
                query = query.eq('status', status)

            offset = (page - 1) * page_size
            query = query.order('created_at', desc=True).range(offset, offset + page_size - 1)

            response = query.execute()

            permissions = response.data if response.data else []
            total = response.count or 0

            # Enrich with user data if we have permissions
            if permissions:
                student_ids = [p['student_id'] for p in permissions]
                users_response = self.db.table('users')\
                    .select('id, email, display_name')\
                    .in_('id', student_ids)\
                    .execute()

                users_map = {u['id']: u for u in (users_response.data or [])}

                for perm in permissions:
                    user_data = users_map.get(perm['student_id'], {})
                    perm['student'] = {
                        'email': user_data.get('email'),
                        'display_name': user_data.get('display_name')
                    }

            return {
                "permissions": permissions,
                "total": total,
                "page": page,
                "page_size": page_size,
                "has_more": (offset + page_size) < total
            }

        except Exception as e:
            logger.error(f"List permissions error: {e}")
            raise Exception(f"Failed to list permissions: {str(e)}")

    async def list_student_permissions(self, student_id: str) -> dict:
        """List all permissions for a student"""
        try:
            response = self.db.table('enrollment_permissions')\
                .select('*, courses!inner(title, institution_id)')\
                .eq('student_id', student_id)\
                .order('created_at', desc=True)\
                .execute()

            permissions = response.data if response.data else []

            return {
                "permissions": permissions,
                "total": len(permissions)
            }

        except Exception as e:
            logger.error(f"List student permissions error: {e}")
            raise Exception(f"Failed to list student permissions: {str(e)}")

    async def _get_permission_by_id(self, permission_id: str) -> Optional[dict]:
        """Get permission by ID"""
        try:
            response = self.db.table('enrollment_permissions')\
                .select('*')\
                .eq('id', permission_id)\
                .single()\
                .execute()

            return response.data if response.data else None

        except Exception:
            return None

    async def list_admitted_students(
        self,
        institution_id: str,
        course_id: Optional[str] = None
    ) -> dict:
        """
        List all students admitted to an institution
        Optionally include their permission status for a specific course
        """
        try:
            # Get all accepted applications directly for this institution
            # Applications table has institution_id directly, no need to join through programs
            response = self.db.table('applications')\
                .select('student_id')\
                .eq('institution_id', institution_id)\
                .eq('status', 'accepted')\
                .execute()

            if not response.data:
                return {"students": [], "total": 0}

            # Collect unique student IDs
            student_ids_for_institution = set()
            for app in response.data:
                if app.get('student_id'):
                    student_ids_for_institution.add(app['student_id'])

            if not student_ids_for_institution:
                return {"students": [], "total": 0}

            # Fetch user details separately
            users_response = self.db.table('users')\
                .select('id, email, display_name')\
                .in_('id', list(student_ids_for_institution))\
                .execute()

            students_map = {}
            for user in (users_response.data or []):
                students_map[user['id']] = {
                    "student_id": user['id'],
                    "email": user.get('email'),
                    "display_name": user.get('display_name'),
                    "permission": None
                }

            # If course_id provided, fetch permissions for this course
            if course_id and students_map:
                student_ids = list(students_map.keys())
                permissions_response = self.db.table('enrollment_permissions')\
                    .select('*')\
                    .eq('course_id', course_id)\
                    .in_('student_id', student_ids)\
                    .execute()

                if permissions_response.data:
                    for perm in permissions_response.data:
                        student_id = perm['student_id']
                        if student_id in students_map:
                            students_map[student_id]['permission'] = {
                                "id": perm['id'],
                                "status": perm['status'],
                                "granted_by": perm.get('granted_by'),
                                "notes": perm.get('notes'),
                                "created_at": perm.get('created_at'),
                                "reviewed_at": perm.get('reviewed_at')
                            }

            students_list = list(students_map.values())

            return {
                "students": students_list,
                "total": len(students_list)
            }

        except Exception as e:
            logger.error(f"List admitted students error: {e}")
            raise Exception(f"Failed to list admitted students: {str(e)}")
