"""
Courses API Endpoints
RESTful API for course management
"""
from fastapi import APIRouter, Depends, HTTPException, status, Query
from typing import Optional

from app.services.courses_service import CoursesService
from app.schemas.courses import (
    CourseCreateRequest,
    CourseUpdateRequest,
    CourseResponse,
    CourseListResponse,
    CourseStatistics
)
from app.utils.security import (
    get_current_user,
    get_optional_user,
    CurrentUser,
    require_institution,
    require_admin,
    UserRole
)

router = APIRouter()


# =============================================================================
# STATIC ROUTES FIRST - Must be defined before parameterized routes
# =============================================================================

@router.get("/courses/statistics/my-courses")
async def get_my_course_statistics(
    current_user: CurrentUser = Depends(require_institution)
) -> CourseStatistics:
    """
    Get course statistics for current institution

    **Requires:** Institution authentication

    **Returns:**
    - Course statistics including:
      - Total courses
      - Published/draft/archived counts
      - Total enrollments
      - Average rating
      - Total revenue
    """
    try:
        service = CoursesService()
        result = await service.get_course_statistics(current_user.id)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.get("/courses")
async def list_courses(
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
    institution_id: Optional[str] = None,
    course_status: Optional[str] = None,
    category: Optional[str] = None,
    level: Optional[str] = None,
    search: Optional[str] = None,
    current_user: Optional[CurrentUser] = Depends(get_optional_user)
) -> CourseListResponse:
    """
    List courses with filters and pagination

    **Institution-Restricted:** Students only see courses from institutions they're admitted to

    **Query Parameters:**
    - page: Page number (default: 1)
    - page_size: Items per page (default: 20, max: 100)
    - institution_id: Filter by institution
    - course_status: Filter by status (draft, published, archived)
    - category: Filter by category
    - level: Filter by level (beginner, intermediate, advanced, expert)
    - search: Search in course titles

    **Returns:**
    - Paginated list of courses
    """
    try:
        service = CoursesService()

        # Filter by student's admitted institutions
        student_id = None
        if current_user and current_user.role == UserRole.STUDENT:
            student_id = current_user.id

        result = await service.list_courses(
            page=page,
            page_size=page_size,
            institution_id=institution_id,
            status=course_status,
            category=category,
            level=level,
            search=search,
            student_id=student_id  # Only show courses from admitted institutions
        )
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.post("/courses", status_code=status.HTTP_201_CREATED)
async def create_course(
    course_data: CourseCreateRequest,
    current_user: CurrentUser = Depends(require_institution)
) -> CourseResponse:
    """
    Create a new course (Institution only)

    **Requires:** Institution authentication

    **Request Body:**
    - title: Course title
    - description: Course description
    - course_type: Type of course (video, text, interactive, live, hybrid)
    - level: Difficulty level (beginner, intermediate, advanced, expert)
    - duration_hours: Course duration in hours
    - price: Course price
    - currency: Currency code (USD, KES, etc.)
    - Other course details...

    **Returns:**
    - Created course data
    """
    try:
        service = CoursesService()
        result = await service.create_course(current_user.id, course_data)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


# =============================================================================
# PARAMETERIZED ROUTES - Must come after static routes
# =============================================================================

@router.get("/courses/{course_id}")
async def get_course(
    course_id: str,
    current_user: Optional[CurrentUser] = Depends(get_optional_user)
) -> CourseResponse:
    """
    Get course by ID

    **Path Parameters:**
    - course_id: Course ID

    **Returns:**
    - Course data
    """
    try:
        service = CoursesService()
        result = await service.get_course(course_id)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=str(e)
        )


@router.put("/courses/{course_id}")
async def update_course(
    course_id: str,
    course_data: CourseUpdateRequest,
    current_user: CurrentUser = Depends(require_institution)
) -> CourseResponse:
    """
    Update course (Institution only)

    **Requires:** Institution authentication (must own the course)

    **Path Parameters:**
    - course_id: Course ID

    **Request Body:**
    - Any course fields to update

    **Returns:**
    - Updated course data
    """
    try:
        service = CoursesService()
        result = await service.update_course(course_id, current_user.id, course_data)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.delete("/courses/{course_id}")
async def delete_course(
    course_id: str,
    current_user: CurrentUser = Depends(require_institution)
):
    """
    Delete course (Institution only)

    **Requires:** Institution authentication (must own the course)

    **Path Parameters:**
    - course_id: Course ID

    **Returns:**
    - Success message
    """
    try:
        service = CoursesService()
        result = await service.delete_course(course_id, current_user.id)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.post("/courses/{course_id}/publish")
async def publish_course(
    course_id: str,
    current_user: CurrentUser = Depends(require_institution)
) -> CourseResponse:
    """
    Publish a course (Institution only)

    **Requires:** Institution authentication (must own the course)

    **Path Parameters:**
    - course_id: Course ID

    **Returns:**
    - Updated course data
    """
    try:
        service = CoursesService()
        result = await service.publish_course(course_id, current_user.id)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.post("/courses/{course_id}/unpublish")
async def unpublish_course(
    course_id: str,
    current_user: CurrentUser = Depends(require_institution)
) -> CourseResponse:
    """
    Unpublish a course (Institution only)

    **Requires:** Institution authentication (must own the course)

    **Path Parameters:**
    - course_id: Course ID

    **Returns:**
    - Updated course data
    """
    try:
        service = CoursesService()
        result = await service.unpublish_course(course_id, current_user.id)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.get("/institutions/{institution_id}/courses")
async def get_institution_courses(
    institution_id: str,
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
    current_user: Optional[CurrentUser] = Depends(get_optional_user)
) -> CourseListResponse:
    """
    Get all courses for a specific institution

    **Path Parameters:**
    - institution_id: Institution ID

    **Query Parameters:**
    - page: Page number
    - page_size: Items per page

    **Returns:**
    - Paginated list of institution's courses
    """
    try:
        service = CoursesService()
        result = await service.list_courses(
            page=page,
            page_size=page_size,
            institution_id=institution_id
        )
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )
