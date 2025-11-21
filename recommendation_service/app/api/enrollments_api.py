"""
Enrollments API Endpoints
RESTful API for managing course enrollments
"""
from fastapi import APIRouter, Depends, HTTPException, status, Query, Body
from typing import Optional

from app.services.enrollments_service import EnrollmentsService
from app.services.enrollment_permissions_service import EnrollmentPermissionsService
from app.schemas.enrollments import (
    EnrollmentCreateRequest,
    EnrollmentResponse,
    EnrollmentListResponse
)
from app.utils.security import get_current_user, require_student, require_institution, CurrentUser

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
    enrollment_status: Optional[str] = Query(None, alias="status"),
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
        result = await service.list_student_enrollments(current_user.id, page, page_size, enrollment_status)
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
    enrollment_status: Optional[str] = Query(None, alias="status"),
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
        result = await service.list_course_enrollments(course_id, page, page_size, enrollment_status)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


# ============================================================
# ENROLLMENT PERMISSIONS ENDPOINTS
# ============================================================

@router.post("/enrollments/request-permission", status_code=status.HTTP_201_CREATED)
async def request_enrollment_permission(
    course_id: str = Body(..., embed=True),
    notes: Optional[str] = Body(None, embed=True),
    current_user: CurrentUser = Depends(require_student)
):
    """
    Request permission to enroll in a course (Student only)

    **Requires:** Student authentication

    **Request Body:**
    - course_id: ID of the course
    - notes: Optional message to institution

    **Returns:**
    - Created permission request
    """
    try:
        service = EnrollmentPermissionsService()
        result = await service.request_enrollment_permission(
            current_user.id,
            course_id,
            notes
        )
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.post("/enrollments/grant-permission", status_code=status.HTTP_201_CREATED)
async def grant_enrollment_permission(
    student_id: str = Body(...),
    course_id: str = Body(...),
    notes: Optional[str] = Body(None),
    current_user: CurrentUser = Depends(require_institution)
):
    """
    Grant enrollment permission to a student (Institution only)

    **Requires:** Institution authentication

    **Request Body:**
    - student_id: ID of the student
    - course_id: ID of the course
    - notes: Optional notes

    **Returns:**
    - Created/updated permission
    """
    try:
        service = EnrollmentPermissionsService()
        result = await service.grant_permission(
            student_id,
            course_id,
            current_user.id,
            notes=notes
        )
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.post("/enrollments/permissions/{permission_id}/approve")
async def approve_permission_request(
    permission_id: str,
    notes: Optional[str] = Body(None, embed=True),
    current_user: CurrentUser = Depends(require_institution)
):
    """
    Approve enrollment permission request (Institution only)

    **Requires:** Institution authentication

    **Path Parameters:**
    - permission_id: Permission request ID

    **Returns:**
    - Updated permission
    """
    try:
        service = EnrollmentPermissionsService()

        # Get the permission to extract student_id and course_id
        permission = await service._get_permission_by_id(permission_id)
        if not permission:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Permission request not found"
            )

        result = await service.grant_permission(
            permission['student_id'],
            permission['course_id'],
            current_user.id,
            notes=notes
        )
        return result
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.post("/enrollments/permissions/{permission_id}/deny")
async def deny_permission_request(
    permission_id: str,
    denial_reason: str = Body(..., embed=True),
    current_user: CurrentUser = Depends(require_institution)
):
    """
    Deny enrollment permission request (Institution only)

    **Requires:** Institution authentication

    **Path Parameters:**
    - permission_id: Permission request ID

    **Request Body:**
    - denial_reason: Reason for denial

    **Returns:**
    - Updated permission
    """
    try:
        service = EnrollmentPermissionsService()
        result = await service.deny_permission(
            permission_id,
            current_user.id,
            denial_reason
        )
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.post("/enrollments/permissions/{permission_id}/revoke")
async def revoke_permission(
    permission_id: str,
    reason: Optional[str] = Body(None, embed=True),
    current_user: CurrentUser = Depends(require_institution)
):
    """
    Revoke enrollment permission (Institution only)

    **Requires:** Institution authentication

    **Path Parameters:**
    - permission_id: Permission ID

    **Request Body:**
    - reason: Optional reason for revocation

    **Returns:**
    - Updated permission
    """
    try:
        service = EnrollmentPermissionsService()
        result = await service.revoke_permission(
            permission_id,
            current_user.id,
            reason
        )
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.get("/courses/{course_id}/permissions")
async def get_course_permission_requests(
    course_id: str,
    permission_status: Optional[str] = Query(None, alias="status"),
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
    current_user: CurrentUser = Depends(require_institution)
):
    """
    Get permission requests for a course (Institution only)

    **Requires:** Institution authentication

    **Path Parameters:**
    - course_id: Course ID

    **Query Parameters:**
    - status: Filter by status (pending, approved, denied, revoked)
    - page: Page number
    - page_size: Items per page

    **Returns:**
    - Paginated list of permission requests
    """
    try:
        service = EnrollmentPermissionsService()
        result = await service.list_course_permission_requests(
            course_id,
            permission_status,
            page,
            page_size
        )
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.get("/students/me/enrollment-permissions")
async def get_my_permissions(
    current_user: CurrentUser = Depends(require_student)
):
    """
    Get current student's enrollment permissions

    **Requires:** Student authentication

    **Returns:**
    - List of enrollment permissions
    """
    try:
        service = EnrollmentPermissionsService()
        result = await service.list_student_permissions(current_user.id)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.get("/institutions/me/admitted-students")
async def get_admitted_students(
    course_id: Optional[str] = Query(None),
    current_user: CurrentUser = Depends(require_institution)
):
    """
    Get all students admitted to current institution (Institution only)

    **Requires:** Institution authentication

    **Query Parameters:**
    - course_id: Optional course ID to include permission status for

    **Returns:**
    - List of admitted students with optional permission status
    """
    try:
        service = EnrollmentPermissionsService()
        result = await service.list_admitted_students(
            current_user.id,
            course_id
        )
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )
