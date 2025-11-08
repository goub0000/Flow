"""
Enrollments Service
Business logic for course enrollment management
"""
from typing import Optional, List, Dict, Any
from datetime import datetime
import logging
from uuid import uuid4

from app.database.config import get_supabase
from app.schemas.enrollments import (
    EnrollmentCreateRequest,
    EnrollmentResponse,
    EnrollmentListResponse,
    EnrollmentStatus
)

logger = logging.getLogger(__name__)


class EnrollmentsService:
    """Service for managing course enrollments"""

    def __init__(self):
        self.db = get_supabase()

    async def enroll_in_course(
        self,
        student_id: str,
        enrollment_data: EnrollmentCreateRequest
    ) -> EnrollmentResponse:
        """Enroll student in a course"""
        try:
            # Check if already enrolled
            existing = self.db.table('enrollments').select('*').eq('student_id', student_id).eq('course_id', enrollment_data.course_id).execute()

            if existing.data:
                raise Exception("Already enrolled in this course")

            # Check if course exists and is published
            course = self.db.table('courses').select('*').eq('id', enrollment_data.course_id).single().execute()

            if not course.data:
                raise Exception("Course not found")

            if not course.data.get('is_published'):
                raise Exception("Course is not available for enrollment")

            # Check max students limit
            max_students = course.data.get('max_students')
            enrolled_count = course.data.get('enrolled_count', 0)

            if max_students and enrolled_count >= max_students:
                raise Exception("Course is full")

            enrollment = {
                "id": str(uuid4()),
                "student_id": student_id,
                "course_id": enrollment_data.course_id,
                "status": EnrollmentStatus.ACTIVE.value,
                "enrolled_at": datetime.utcnow().isoformat(),
                "progress_percentage": 0.0,
                "metadata": enrollment_data.metadata or {},
                "created_at": datetime.utcnow().isoformat(),
                "updated_at": datetime.utcnow().isoformat(),
            }

            response = self.db.table('enrollments').insert(enrollment).execute()

            if not response.data:
                raise Exception("Failed to enroll in course")

            # Update course enrolled_count
            new_count = enrolled_count + 1
            self.db.table('courses').update({'enrolled_count': new_count}).eq('id', enrollment_data.course_id).execute()

            logger.info(f"Student {student_id} enrolled in course {enrollment_data.course_id}")

            return EnrollmentResponse(**response.data[0])

        except Exception as e:
            logger.error(f"Enroll error: {e}")
            raise Exception(f"Failed to enroll: {str(e)}")

    async def get_enrollment(self, enrollment_id: str) -> EnrollmentResponse:
        """Get enrollment by ID"""
        try:
            response = self.db.table('enrollments').select('*').eq('id', enrollment_id).single().execute()

            if not response.data:
                raise Exception("Enrollment not found")

            return EnrollmentResponse(**response.data)

        except Exception as e:
            logger.error(f"Get enrollment error: {e}")
            raise Exception(f"Failed to fetch enrollment: {str(e)}")

    async def drop_enrollment(self, enrollment_id: str, student_id: str) -> EnrollmentResponse:
        """Drop enrollment"""
        try:
            enrollment = await self.get_enrollment(enrollment_id)

            if enrollment.student_id != student_id:
                raise Exception("Not authorized to drop this enrollment")

            if enrollment.status == EnrollmentStatus.DROPPED.value:
                raise Exception("Enrollment already dropped")

            update_data = {
                "status": EnrollmentStatus.DROPPED.value,
                "updated_at": datetime.utcnow().isoformat()
            }

            response = self.db.table('enrollments').update(update_data).eq('id', enrollment_id).execute()

            if not response.data:
                raise Exception("Failed to drop enrollment")

            # Decrement course enrolled_count
            course = self.db.table('courses').select('enrolled_count').eq('id', enrollment.course_id).single().execute()

            if course.data:
                current_count = course.data.get('enrolled_count', 0)
                if current_count > 0:
                    self.db.table('courses').update({'enrolled_count': current_count - 1}).eq('id', enrollment.course_id).execute()

            logger.info(f"Enrollment dropped: {enrollment_id}")

            return EnrollmentResponse(**response.data[0])

        except Exception as e:
            logger.error(f"Drop enrollment error: {e}")
            raise Exception(f"Failed to drop enrollment: {str(e)}")

    async def update_progress(
        self,
        enrollment_id: str,
        student_id: str,
        progress_percentage: float
    ) -> EnrollmentResponse:
        """Update enrollment progress"""
        try:
            enrollment = await self.get_enrollment(enrollment_id)

            if enrollment.student_id != student_id:
                raise Exception("Not authorized to update this enrollment")

            update_data = {
                "progress_percentage": min(100.0, max(0.0, progress_percentage)),
                "updated_at": datetime.utcnow().isoformat()
            }

            # Mark as completed if 100%
            if progress_percentage >= 100.0:
                update_data["status"] = EnrollmentStatus.COMPLETED.value
                update_data["completed_at"] = datetime.utcnow().isoformat()

            response = self.db.table('enrollments').update(update_data).eq('id', enrollment_id).execute()

            if not response.data:
                raise Exception("Failed to update progress")

            logger.info(f"Enrollment progress updated: {enrollment_id} -> {progress_percentage}%")

            return EnrollmentResponse(**response.data[0])

        except Exception as e:
            logger.error(f"Update progress error: {e}")
            raise Exception(f"Failed to update progress: {str(e)}")

    async def list_student_enrollments(
        self,
        student_id: str,
        page: int = 1,
        page_size: int = 20,
        status: Optional[str] = None
    ) -> EnrollmentListResponse:
        """List enrollments for a student"""
        try:
            query = self.db.table('enrollments').select('*', count='exact').eq('student_id', student_id)

            if status:
                query = query.eq('status', status)

            offset = (page - 1) * page_size
            query = query.order('enrolled_at', desc=True).range(offset, offset + page_size - 1)

            response = query.execute()

            enrollments = [EnrollmentResponse(**e) for e in response.data] if response.data else []
            total = response.count or 0

            return EnrollmentListResponse(
                enrollments=enrollments,
                total=total,
                page=page,
                page_size=page_size,
                has_more=(offset + page_size) < total
            )

        except Exception as e:
            logger.error(f"List enrollments error: {e}")
            raise Exception(f"Failed to list enrollments: {str(e)}")

    async def list_course_enrollments(
        self,
        course_id: str,
        page: int = 1,
        page_size: int = 20,
        status: Optional[str] = None
    ) -> EnrollmentListResponse:
        """List enrollments for a course"""
        try:
            query = self.db.table('enrollments').select('*', count='exact').eq('course_id', course_id)

            if status:
                query = query.eq('status', status)

            offset = (page - 1) * page_size
            query = query.order('enrolled_at', desc=True).range(offset, offset + page_size - 1)

            response = query.execute()

            enrollments = [EnrollmentResponse(**e) for e in response.data] if response.data else []
            total = response.count or 0

            return EnrollmentListResponse(
                enrollments=enrollments,
                total=total,
                page=page,
                page_size=page_size,
                has_more=(offset + page_size) < total
            )

        except Exception as e:
            logger.error(f"List course enrollments error: {e}")
            raise Exception(f"Failed to list course enrollments: {str(e)}")
