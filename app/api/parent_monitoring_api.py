"""
Parent Monitoring API Endpoints
RESTful API for parent monitoring and student activity tracking
"""
from typing import Optional, List
from fastapi import APIRouter, Depends, HTTPException, status, Query

from app.services.parent_monitoring_service import ParentMonitoringService
from app.schemas.parent_monitoring import (
    ParentStudentLinkCreateRequest,
    ParentStudentLinkResponse,
    ParentStudentLinkListResponse,
    LinkPermissionsUpdateRequest,
    StudentActivityListResponse,
    ProgressReportRequest,
    ProgressReportResponse,
    MultiStudentDashboardResponse
)
from app.utils.security import get_current_user, RoleChecker, UserRole, CurrentUser

router = APIRouter()


# Parent-Student Link Management
@router.post("/parent/links", status_code=status.HTTP_201_CREATED)
async def create_parent_student_link(
    link_data: ParentStudentLinkCreateRequest,
    current_user: CurrentUser = Depends(RoleChecker([UserRole.PARENT]))
) -> ParentStudentLinkResponse:
    """
    Create parent-student link (Parent only)

    **Requires:** Parent authentication

    **Request Body:**
    - student_id: Student's user ID
    - relationship: Relationship type (e.g., "father", "mother", "guardian")
    - can_view_grades: Permission to view grades (default: true)
    - can_view_activity: Permission to view activity (default: true)
    - can_view_messages: Permission to view messages (default: false)
    - can_receive_alerts: Permission to receive alerts (default: true)

    **Returns:**
    - Created link with PENDING status (awaits student approval)

    **Note:** Student will receive notification to approve the link
    """
    try:
        service = ParentMonitoringService()
        result = await service.create_parent_link(current_user.id, link_data)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.post("/parent/links/{link_id}/approve")
async def approve_parent_link(
    link_id: str,
    current_user: CurrentUser = Depends(RoleChecker([UserRole.STUDENT]))
) -> ParentStudentLinkResponse:
    """
    Approve parent link (Student only)

    **Requires:** Student authentication

    **Path Parameters:**
    - link_id: Link ID

    **Returns:**
    - Updated link with ACTIVE status
    """
    try:
        service = ParentMonitoringService()
        result = await service.approve_parent_link(link_id, current_user.id)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.post("/parent/links/{link_id}/revoke")
async def revoke_parent_link(
    link_id: str,
    current_user: CurrentUser = Depends(get_current_user)
):
    """
    Revoke parent-student link

    **Requires:** Authentication (parent or student involved in link)

    **Path Parameters:**
    - link_id: Link ID

    **Returns:**
    - Success status

    **Note:** Either parent or student can revoke the link
    """
    try:
        service = ParentMonitoringService()
        result = await service.revoke_parent_link(link_id, current_user.id)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.get("/parent/links")
async def list_parent_links(
    current_user: CurrentUser = Depends(get_current_user)
) -> ParentStudentLinkListResponse:
    """
    List parent-student links

    **Requires:** Authentication (parent or student)

    **Returns:**
    - List of links
    - Parents see all students they're linked to
    - Students see all parents linked to them
    """
    try:
        service = ParentMonitoringService()
        user_role = "parent" if "parent" in current_user.roles else "student"
        result = await service.list_parent_links(current_user.id, user_role)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


# Student Activity Monitoring
@router.get("/parent/students/{student_id}/activities")
async def list_student_activities(
    student_id: str,
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
    activity_type: Optional[str] = None,
    current_user: CurrentUser = Depends(RoleChecker([UserRole.PARENT]))
) -> StudentActivityListResponse:
    """
    List student activities (Parent only)

    **Requires:** Parent authentication with active link to student

    **Path Parameters:**
    - student_id: Student's user ID

    **Query Parameters:**
    - page: Page number (default: 1)
    - page_size: Items per page (default: 20, max: 100)
    - activity_type: Filter by activity type (optional)

    **Returns:**
    - Paginated list of student activities

    **Activity Types:**
    - login, course_enrollment, course_progress, assignment_submission,
    - grade_received, application_submitted, application_status_change,
    - counseling_session, achievement_earned, message_sent
    """
    try:
        service = ParentMonitoringService()
        result = await service.list_student_activities(current_user.id, student_id, page, page_size, activity_type)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=str(e)
        )


# Progress Reports
@router.post("/parent/progress-reports")
async def generate_progress_report(
    report_request: ProgressReportRequest,
    current_user: CurrentUser = Depends(RoleChecker([UserRole.PARENT]))
) -> ProgressReportResponse:
    """
    Generate comprehensive progress report (Parent only)

    **Requires:** Parent authentication with active link to student

    **Request Body:**
    - student_id: Student's user ID
    - report_period_start: Report start date (ISO format)
    - report_period_end: Report end date (ISO format)
    - include_courses: Include course progress (default: true)
    - include_applications: Include applications (default: true)
    - include_counseling: Include counseling sessions (default: true)
    - include_achievements: Include achievements (default: true)

    **Returns:**
    - Comprehensive progress report including:
      - Overall statistics (courses, applications, sessions, achievements)
      - Course progress summaries with grades
      - Application status updates
      - Counseling session summaries with ratings
      - Recent achievements
      - Activity summary by type
      - Total activities in period

    **Example:**
    ```json
    {
      "student_id": "uuid",
      "report_period_start": "2025-01-01T00:00:00Z",
      "report_period_end": "2025-01-31T23:59:59Z",
      "include_courses": true,
      "include_applications": true,
      "include_counseling": true,
      "include_achievements": true
    }
    ```
    """
    try:
        service = ParentMonitoringService()
        result = await service.generate_progress_report(current_user.id, report_request)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=str(e)
        )


# Dashboard
@router.get("/parent/dashboard")
async def get_parent_dashboard(
    current_user: CurrentUser = Depends(RoleChecker([UserRole.PARENT]))
) -> MultiStudentDashboardResponse:
    """
    Get parent dashboard with all linked students

    **Requires:** Parent authentication

    **Returns:**
    - Dashboard data for all linked students including:
      - Student activity status (active/inactive)
      - Course statistics (active, completed, at-risk courses)
      - Application statistics (total, pending, accepted, rejected)
      - Upcoming counseling sessions
      - Achievement counts
      - Unread alerts
      - Activity summary (last 30 days)
      - Study time tracking (if available)

    **Note:** Dashboard provides at-a-glance view of all children's progress
    """
    try:
        service = ParentMonitoringService()
        result = await service.get_parent_dashboard(current_user.id)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )
