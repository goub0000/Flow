"""
Courses Service
Business logic for course management
"""
from typing import Optional, List, Dict, Any
from datetime import datetime
import logging
from uuid import uuid4

from app.database.config import get_supabase
from app.schemas.courses import (
    CourseCreateRequest,
    CourseUpdateRequest,
    CourseResponse,
    CourseListResponse,
    CourseStatistics,
    CourseStatus
)

logger = logging.getLogger(__name__)


class CoursesService:
    """Service for managing courses"""

    def __init__(self):
        self.db = get_supabase()

    async def create_course(
        self,
        institution_id: str,
        course_data: CourseCreateRequest
    ) -> CourseResponse:
        """Create a new course"""
        try:
            course = {
                "id": str(uuid4()),
                "institution_id": institution_id,
                "title": course_data.title,
                "description": course_data.description,
                "course_type": course_data.course_type.value,
                "level": course_data.level.value,
                "duration_hours": course_data.duration_hours,
                "price": course_data.price or 0.0,
                "currency": course_data.currency,
                "thumbnail_url": course_data.thumbnail_url,
                "preview_video_url": course_data.preview_video_url,
                "category": course_data.category,
                "tags": course_data.tags,
                "learning_outcomes": course_data.learning_outcomes,
                "prerequisites": course_data.prerequisites,
                "max_students": course_data.max_students,
                "syllabus": course_data.syllabus,
                "status": CourseStatus.DRAFT.value,
                "is_published": False,
                "enrolled_count": 0,
                "metadata": course_data.metadata or {},
                "created_at": datetime.utcnow().isoformat(),
                "updated_at": datetime.utcnow().isoformat(),
            }

            response = self.db.table('courses').insert(course).execute()

            if not response.data:
                raise Exception("Failed to create course")

            logger.info(f"Course created: {course['id']} by institution {institution_id}")

            return CourseResponse(**response.data[0])

        except Exception as e:
            logger.error(f"Create course error: {e}")
            raise Exception(f"Failed to create course: {str(e)}")

    async def get_course(self, course_id: str) -> CourseResponse:
        """Get course by ID"""
        try:
            response = self.db.table('courses').select('*').eq('id', course_id).single().execute()

            if not response.data:
                raise Exception("Course not found")

            return CourseResponse(**response.data)

        except Exception as e:
            logger.error(f"Get course error: {e}")
            raise Exception(f"Failed to fetch course: {str(e)}")

    async def update_course(
        self,
        course_id: str,
        institution_id: str,
        course_data: CourseUpdateRequest
    ) -> CourseResponse:
        """Update course"""
        try:
            # Verify ownership
            course = await self.get_course(course_id)
            if course.institution_id != institution_id:
                raise Exception("Not authorized to update this course")

            # Build update dict
            update_data = {"updated_at": datetime.utcnow().isoformat()}

            if course_data.title is not None:
                update_data["title"] = course_data.title
            if course_data.description is not None:
                update_data["description"] = course_data.description
            if course_data.course_type is not None:
                update_data["course_type"] = course_data.course_type.value
            if course_data.level is not None:
                update_data["level"] = course_data.level.value
            if course_data.duration_hours is not None:
                update_data["duration_hours"] = course_data.duration_hours
            if course_data.price is not None:
                update_data["price"] = course_data.price
            if course_data.currency is not None:
                update_data["currency"] = course_data.currency
            if course_data.thumbnail_url is not None:
                update_data["thumbnail_url"] = course_data.thumbnail_url
            if course_data.preview_video_url is not None:
                update_data["preview_video_url"] = course_data.preview_video_url
            if course_data.category is not None:
                update_data["category"] = course_data.category
            if course_data.tags is not None:
                update_data["tags"] = course_data.tags
            if course_data.learning_outcomes is not None:
                update_data["learning_outcomes"] = course_data.learning_outcomes
            if course_data.prerequisites is not None:
                update_data["prerequisites"] = course_data.prerequisites
            if course_data.max_students is not None:
                update_data["max_students"] = course_data.max_students
            if course_data.syllabus is not None:
                update_data["syllabus"] = course_data.syllabus
            if course_data.status is not None:
                update_data["status"] = course_data.status.value
                # If publishing, set published_at
                if course_data.status == CourseStatus.PUBLISHED and not course.is_published:
                    update_data["is_published"] = True
                    update_data["published_at"] = datetime.utcnow().isoformat()
            if course_data.metadata is not None:
                update_data["metadata"] = course_data.metadata

            response = self.db.table('courses').update(update_data).eq('id', course_id).execute()

            if not response.data:
                raise Exception("Failed to update course")

            logger.info(f"Course updated: {course_id}")

            return CourseResponse(**response.data[0])

        except Exception as e:
            logger.error(f"Update course error: {e}")
            raise Exception(f"Failed to update course: {str(e)}")

    async def delete_course(self, course_id: str, institution_id: str) -> Dict[str, str]:
        """Delete course (soft delete)"""
        try:
            # Verify ownership
            course = await self.get_course(course_id)
            if course.institution_id != institution_id:
                raise Exception("Not authorized to delete this course")

            # Soft delete by archiving
            self.db.table('courses').update({
                "status": CourseStatus.ARCHIVED.value,
                "updated_at": datetime.utcnow().isoformat()
            }).eq('id', course_id).execute()

            logger.info(f"Course deleted (archived): {course_id}")

            return {"message": "Course deleted successfully"}

        except Exception as e:
            logger.error(f"Delete course error: {e}")
            raise Exception(f"Failed to delete course: {str(e)}")

    async def list_courses(
        self,
        page: int = 1,
        page_size: int = 20,
        institution_id: Optional[str] = None,
        status: Optional[str] = None,
        category: Optional[str] = None,
        level: Optional[str] = None,
        search: Optional[str] = None,
        student_id: Optional[str] = None
    ) -> CourseListResponse:
        """List courses with filters and pagination (institution-restricted for students)"""
        try:
            # If student, filter by admitted institutions
            admitted_institution_ids = []
            if student_id:
                # Get institutions student is admitted to via accepted applications
                apps_response = self.db.table('applications')\
                    .select('programs!inner(institution_id)')\
                    .eq('student_id', student_id)\
                    .eq('status', 'accepted')\
                    .execute()

                if apps_response.data:
                    # Extract unique institution IDs
                    admitted_institution_ids = list(set([
                        app['programs']['institution_id']
                        for app in apps_response.data
                        if app.get('programs', {}).get('institution_id')
                    ]))

                # If student not admitted anywhere, return empty
                if not admitted_institution_ids:
                    return CourseListResponse(
                        courses=[],
                        total=0,
                        page=page,
                        page_size=page_size,
                        has_more=False
                    )

            query = self.db.table('courses').select('*', count='exact')

            # Apply filters
            if institution_id:
                query = query.eq('institution_id', institution_id)
            elif student_id and admitted_institution_ids:
                # Filter to only admitted institutions
                query = query.in_('institution_id', admitted_institution_ids)

            if status:
                query = query.eq('status', status)
            else:
                # By default, only show published courses
                query = query.eq('is_published', True)

            if category:
                query = query.eq('category', category)
            if level:
                query = query.eq('level', level)
            if search:
                query = query.ilike('title', f'%{search}%')

            # Pagination
            offset = (page - 1) * page_size
            query = query.order('created_at', desc=True).range(offset, offset + page_size - 1)

            response = query.execute()

            courses = [CourseResponse(**course) for course in response.data] if response.data else []
            total = response.count or 0

            return CourseListResponse(
                courses=courses,
                total=total,
                page=page,
                page_size=page_size,
                has_more=(offset + page_size) < total
            )

        except Exception as e:
            logger.error(f"List courses error: {e}")
            raise Exception(f"Failed to list courses: {str(e)}")

    async def publish_course(self, course_id: str, institution_id: str) -> CourseResponse:
        """Publish a course"""
        try:
            course = await self.get_course(course_id)
            if course.institution_id != institution_id:
                raise Exception("Not authorized to publish this course")

            update_data = {
                "status": CourseStatus.PUBLISHED.value,
                "is_published": True,
                "published_at": datetime.utcnow().isoformat(),
                "updated_at": datetime.utcnow().isoformat()
            }

            response = self.db.table('courses').update(update_data).eq('id', course_id).execute()

            if not response.data:
                raise Exception("Failed to publish course")

            logger.info(f"Course published: {course_id}")

            return CourseResponse(**response.data[0])

        except Exception as e:
            logger.error(f"Publish course error: {e}")
            raise Exception(f"Failed to publish course: {str(e)}")

    async def unpublish_course(self, course_id: str, institution_id: str) -> CourseResponse:
        """Unpublish a course"""
        try:
            course = await self.get_course(course_id)
            if course.institution_id != institution_id:
                raise Exception("Not authorized to unpublish this course")

            update_data = {
                "status": CourseStatus.DRAFT.value,
                "is_published": False,
                "updated_at": datetime.utcnow().isoformat()
            }

            response = self.db.table('courses').update(update_data).eq('id', course_id).execute()

            if not response.data:
                raise Exception("Failed to unpublish course")

            logger.info(f"Course unpublished: {course_id}")

            return CourseResponse(**response.data[0])

        except Exception as e:
            logger.error(f"Unpublish course error: {e}")
            raise Exception(f"Failed to unpublish course: {str(e)}")

    async def get_course_statistics(self, institution_id: str) -> CourseStatistics:
        """Get course statistics for an institution"""
        try:
            # Get all courses for institution
            response = self.db.table('courses').select('*').eq('institution_id', institution_id).execute()

            courses = response.data if response.data else []

            stats = {
                "total_courses": len(courses),
                "published_courses": sum(1 for c in courses if c.get('status') == CourseStatus.PUBLISHED.value),
                "draft_courses": sum(1 for c in courses if c.get('status') == CourseStatus.DRAFT.value),
                "archived_courses": sum(1 for c in courses if c.get('status') == CourseStatus.ARCHIVED.value),
                "total_enrollments": sum(c.get('enrolled_count', 0) for c in courses),
                "average_rating": 0.0,  # TODO: Calculate from reviews
                "total_revenue": sum(c.get('price', 0) * c.get('enrolled_count', 0) for c in courses)
            }

            return CourseStatistics(**stats)

        except Exception as e:
            logger.error(f"Get statistics error: {e}")
            raise Exception(f"Failed to get statistics: {str(e)}")
