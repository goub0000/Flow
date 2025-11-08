"""
Applications API Endpoints
RESTful API for managing student applications to programs/institutions
"""
from fastapi import APIRouter, Depends, HTTPException, status, Query
from typing import Optional

from app.services.applications_service import ApplicationsService
from app.schemas.applications import (
    ApplicationCreateRequest,
    ApplicationUpdateRequest,
    ApplicationStatusUpdateRequest,
    ApplicationResponse,
    ApplicationListResponse,
    ApplicationStatistics
)
from app.utils.security import (
    get_current_user,
    CurrentUser,
    require_student,
    require_institution,
    UserRole
)

router = APIRouter()


@router.post("/applications", status_code=status.HTTP_201_CREATED)
async def create_application(
    application_data: ApplicationCreateRequest,
    current_user: CurrentUser = Depends(require_student)
) -> ApplicationResponse:
    """
    Create new application (Student only)

    **Requires:** Student authentication

    **Request Body:**
    - institution_id: Target institution
    - program_id: Program to apply to
    - application_type: Type of application
    - personal_info: Personal information
    - academic_info: Academic records
    - documents: Supporting documents
    - essay: Personal statement
    - references: Reference letters

    **Returns:**
    - Created application data
    """
    try:
        service = ApplicationsService()
        result = await service.create_application(current_user.id, application_data)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.get("/applications/{application_id}")
async def get_application(
    application_id: str,
    current_user: CurrentUser = Depends(get_current_user)
) -> ApplicationResponse:
    """
    Get application by ID

    **Path Parameters:**
    - application_id: Application ID

    **Returns:**
    - Application data
    """
    try:
        service = ApplicationsService()
        result = await service.get_application(application_id)

        # Check authorization
        if result.student_id != current_user.id and result.institution_id != current_user.id:
            if current_user.role not in [UserRole.ADMIN_SUPER, UserRole.ADMIN_CONTENT]:
                raise HTTPException(
                    status_code=status.HTTP_403_FORBIDDEN,
                    detail="Not authorized to view this application"
                )

        return result
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=str(e)
        )


@router.put("/applications/{application_id}")
async def update_application(
    application_id: str,
    application_data: ApplicationUpdateRequest,
    current_user: CurrentUser = Depends(require_student)
) -> ApplicationResponse:
    """
    Update application (Student only, before submission)

    **Requires:** Student authentication (must own application)

    **Path Parameters:**
    - application_id: Application ID

    **Request Body:**
    - Any application fields to update

    **Returns:**
    - Updated application data
    """
    try:
        service = ApplicationsService()
        result = await service.update_application(application_id, current_user.id, application_data)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.post("/applications/{application_id}/submit")
async def submit_application(
    application_id: str,
    current_user: CurrentUser = Depends(require_student)
) -> ApplicationResponse:
    """
    Submit application for review

    **Requires:** Student authentication (must own application)

    **Path Parameters:**
    - application_id: Application ID

    **Returns:**
    - Updated application with submitted status
    """
    try:
        service = ApplicationsService()
        result = await service.submit_application(application_id, current_user.id)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.post("/applications/{application_id}/withdraw")
async def withdraw_application(
    application_id: str,
    current_user: CurrentUser = Depends(require_student)
) -> ApplicationResponse:
    """
    Withdraw application

    **Requires:** Student authentication (must own application)

    **Path Parameters:**
    - application_id: Application ID

    **Returns:**
    - Updated application with withdrawn status
    """
    try:
        service = ApplicationsService()
        result = await service.withdraw_application(application_id, current_user.id)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.put("/applications/{application_id}/status")
async def update_application_status(
    application_id: str,
    status_data: ApplicationStatusUpdateRequest,
    current_user: CurrentUser = Depends(require_institution)
) -> ApplicationResponse:
    """
    Update application status (Institution only)

    **Requires:** Institution authentication (must be target institution)

    **Path Parameters:**
    - application_id: Application ID

    **Request Body:**
    - status: New status (under_review, accepted, rejected, waitlisted)
    - reviewer_notes: Optional notes
    - decision_date: Optional decision date

    **Returns:**
    - Updated application with new status
    """
    try:
        service = ApplicationsService()
        result = await service.update_application_status(application_id, current_user.id, status_data)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.delete("/applications/{application_id}")
async def delete_application(
    application_id: str,
    current_user: CurrentUser = Depends(require_student)
):
    """
    Delete application (Student only, before submission)

    **Requires:** Student authentication (must own application)

    **Path Parameters:**
    - application_id: Application ID

    **Returns:**
    - Success message
    """
    try:
        service = ApplicationsService()
        result = await service.delete_application(application_id, current_user.id)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.get("/students/me/applications")
async def get_my_applications(
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
    status: Optional[str] = None,
    current_user: CurrentUser = Depends(require_student)
) -> ApplicationListResponse:
    """
    Get current student's applications

    **Requires:** Student authentication

    **Query Parameters:**
    - page: Page number (default: 1)
    - page_size: Items per page (default: 20, max: 100)
    - status: Filter by status

    **Returns:**
    - Paginated list of applications
    """
    try:
        service = ApplicationsService()
        result = await service.list_student_applications(current_user.id, page, page_size, status)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.get("/institutions/me/applications")
async def get_institution_applications(
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
    status: Optional[str] = None,
    program_id: Optional[str] = None,
    current_user: CurrentUser = Depends(require_institution)
) -> ApplicationListResponse:
    """
    Get applications for current institution

    **Requires:** Institution authentication

    **Query Parameters:**
    - page: Page number (default: 1)
    - page_size: Items per page (default: 20, max: 100)
    - status: Filter by status
    - program_id: Filter by program

    **Returns:**
    - Paginated list of applications received by institution
    """
    try:
        service = ApplicationsService()
        result = await service.list_institution_applications(
            current_user.id, page, page_size, status, program_id
        )
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.get("/institutions/me/applications/statistics")
async def get_application_statistics(
    current_user: CurrentUser = Depends(require_institution)
) -> ApplicationStatistics:
    """
    Get application statistics for current institution

    **Requires:** Institution authentication

    **Returns:**
    - Application statistics including:
      - Total applications
      - Applications by status
      - Acceptance rate
    """
    try:
        service = ApplicationsService()
        result = await service.get_institution_statistics(current_user.id)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )
