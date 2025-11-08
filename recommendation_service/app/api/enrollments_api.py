"""
Enrollments API Endpoints
RESTful API for managing course enrollments
"""
from fastapi import APIRouter, Depends, HTTPException, status, Query, Body
from typing import Optional

from app.services.enrollments_service import EnrollmentsService
from app.schemas.enrollments import (
    EnrollmentCreateRequest,
    EnrollmentResponse,
    EnrollmentListResponse
)
from app.utils.security import get_current_user, require_student, CurrentUser

router = APIRouter()


@router.post("/enrollments", status_code=status.HTTP_201_CREATED)
async def enroll_in_course(
    enrollment_data: EnrollmentCreateRequest,
    current_user: CurrentUser = Depends(require_student)
) -> EnrollmentResponse:
    """
    Enroll in a course (Student only)

    **Requires:** Student authentication

    **Request Body:**
    - course_id: ID of the course to enroll in
    - metadata: Optional additional data

    **Returns:**
    - Created enrollment data
    """
    try:
        service = EnrollmentsService()
        result = await service.enroll_in_course(current_user.id, enrollment_data)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.get("/enrollments/{enrollment_id}")
async def get_enrollment(
    enrollment_id: str,
    current_user: CurrentUser = Depends(get_current_user)
) -> EnrollmentResponse:
    """
    Get enrollment by ID

    **Path Parameters:**
    - enrollment_id: Enrollment ID

    **Returns:**
    - Enrollment data
    """
    try:
        service = EnrollmentsService()
        result = await service.get_enrollment(enrollment_id)

        # Check authorization
        if result.student_id != current_user.id:
            # TODO: Check if user is the course instructor
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Not authorized to view this enrollment"
            )

        return result
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=str(e)
        )


@router.post("/enrollments/{enrollment_id}/drop")
async def drop_enrollment(
    enrollment_id: str,
    current_user: CurrentUser = Depends(require_student)
) -> EnrollmentResponse:
    """
    Drop enrollment (Student only)

    **Requires:** Student authentication (must own enrollment)

    **Path Parameters:**
    - enrollment_id: Enrollment ID

    **Returns:**
    - Updated enrollment with dropped status
    """
    try:
        service = EnrollmentsService()
        result = await service.drop_enrollment(enrollment_id, current_user.id)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.put("/enrollments/{enrollment_id}/progress")
async def update_enrollment_progress(
    enrollment_id: str,
    progress_percentage: float = Body(..., embed=True, ge=0, le=100),
    current_user: CurrentUser = Depends(require_student)
) -> EnrollmentResponse:
    """
    Update enrollment progress (Student only)

    **Requires:** Student authentication (must own enrollment)

    **Path Parameters:**
    - enrollment_id: Enrollment ID

    **Request Body:**
    - progress_percentage: Progress percentage (0-100)

    **Returns:**
    - Updated enrollment with new progress
    """
    try:
        service = EnrollmentsService()
        result = await service.update_progress(enrollment_id, current_user.id, progress_percentage)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.get("/students/me/enrollments")
async def get_my_enrollments(
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
    status: Optional[str] = None,
    current_user: CurrentUser = Depends(require_student)
) -> EnrollmentListResponse:
    """
    Get current student's enrollments

    **Requires:** Student authentication

    **Query Parameters:**
    - page: Page number (default: 1)
    - page_size: Items per page (default: 20, max: 100)
    - status: Filter by status (active, completed, dropped, suspended)

    **Returns:**
    - Paginated list of enrollments
    """
    try:
        service = EnrollmentsService()
        result = await service.list_student_enrollments(current_user.id, page, page_size, status)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.get("/courses/{course_id}/enrollments")
async def get_course_enrollments(
    course_id: str,
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
    status: Optional[str] = None,
    current_user: CurrentUser = Depends(get_current_user)
) -> EnrollmentListResponse:
    """
    Get enrollments for a course

    **Query Parameters:**
    - page: Page number (default: 1)
    - page_size: Items per page (default: 20, max: 100)
    - status: Filter by status

    **Returns:**
    - Paginated list of enrollments for the course
    """
    try:
        service = EnrollmentsService()
        # TODO: Check if user is the course instructor/institution
        result = await service.list_course_enrollments(course_id, page, page_size, status)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )
