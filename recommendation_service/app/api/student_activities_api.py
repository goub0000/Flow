"""
Student Activities API Endpoints
RESTful API for student activity feed
"""
from fastapi import APIRouter, Depends, HTTPException, status, Query
from typing import Optional, List
from datetime import datetime

from app.services.student_activities_service import StudentActivitiesService
from app.schemas.activity import (
    StudentActivityFeedResponse,
    StudentActivityFilterRequest,
    StudentActivityType
)
from app.utils.security import (
    get_current_user,
    CurrentUser,
    require_student
)
from app.database.config import get_db
from supabase import Client

router = APIRouter()


@router.get("/students/me/activities", response_model=StudentActivityFeedResponse)
async def get_my_activities(
    page: int = Query(default=1, ge=1, description="Page number"),
    limit: int = Query(default=10, ge=1, le=100, description="Items per page"),
    activity_types: Optional[str] = Query(
        default=None,
        description="Comma-separated activity types to filter (e.g., 'application_submitted,achievement_earned')"
    ),
    start_date: Optional[datetime] = Query(
        default=None,
        description="Filter activities after this date (ISO 8601 format)"
    ),
    end_date: Optional[datetime] = Query(
        default=None,
        description="Filter activities before this date (ISO 8601 format)"
    ),
    current_user: CurrentUser = Depends(get_current_user),
    db: Client = Depends(get_db)
) -> StudentActivityFeedResponse:
    """
    Get activity feed for the current student

    **Requires:** Student authentication

    **Query Parameters:**
    - page: Page number (default: 1)
    - limit: Items per page (default: 10, max: 100)
    - activity_types: Comma-separated activity types to filter
      (application_submitted, application_status_changed, achievement_earned,
       payment_made, message_received, course_completed, meeting_scheduled, meeting_completed)
    - start_date: Filter activities after this date
    - end_date: Filter activities before this date

    **Returns:**
    - activities: List of student activities
    - total_count: Total number of activities
    - page: Current page number
    - limit: Items per page
    - has_more: Whether more pages are available

    **Example Response:**
    ```json
    {
      "activities": [
        {
          "id": "app_submit_123",
          "timestamp": "2025-11-15T10:30:00Z",
          "type": "application_submitted",
          "title": "Application Submitted",
          "description": "You submitted an application to MIT",
          "icon": "📝",
          "related_entity_id": "123",
          "metadata": {
            "institution_name": "MIT",
            "program_name": "Computer Science",
            "status": "submitted"
          }
        }
      ],
      "total_count": 25,
      "page": 1,
      "limit": 10,
      "has_more": true
    }
    ```
    """
    try:
        # Verify user has student role for their own activities
        # Allow students and also parents/counselors who might be checking on behalf of students
        allowed_roles = ['student', 'parent', 'counselor', 'admin_super', 'admin_content', 'admin_support']
        if current_user.role not in allowed_roles:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail=f"Access denied. Your role '{current_user.role}' cannot access student activities. Allowed roles: {allowed_roles}"
            )

        # Parse activity types filter
        activity_types_list: Optional[List[StudentActivityType]] = None
        if activity_types:
            try:
                activity_types_list = [
                    StudentActivityType(t.strip())
                    for t in activity_types.split(',')
                ]
            except ValueError as e:
                raise HTTPException(
                    status_code=status.HTTP_400_BAD_REQUEST,
                    detail=f"Invalid activity type in filter: {e}"
                )

        # Create filter request
        filters = StudentActivityFilterRequest(
            page=page,
            limit=limit,
            activity_types=activity_types_list,
            start_date=start_date,
            end_date=end_date
        )

        # Get activities from service
        service = StudentActivitiesService()
        result = await service.get_student_activities(
            student_id=current_user.id,
            filters=filters,
            db=db
        )

        return result

    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error fetching activities: {str(e)}"
        )


@router.get("/students/{student_id}/activities", response_model=StudentActivityFeedResponse)
async def get_student_activities(
    student_id: str,
    page: int = Query(default=1, ge=1, description="Page number"),
    limit: int = Query(default=10, ge=1, le=100, description="Items per page"),
    activity_types: Optional[str] = Query(default=None, description="Comma-separated activity types"),
    start_date: Optional[datetime] = Query(default=None, description="Filter after date"),
    end_date: Optional[datetime] = Query(default=None, description="Filter before date"),
    current_user: CurrentUser = Depends(get_current_user),
    db: Client = Depends(get_db)
) -> StudentActivityFeedResponse:
    """
    Get activity feed for a specific student

    **Requires:** Authentication (student can view own activities, parents/counselors can view their students)

    **Path Parameters:**
    - student_id: Student's user ID

    **Query Parameters:**
    - Same as /students/me/activities

    **Returns:**
    - Student activity feed response
    """
    try:
        # Resolve the student_id - it could be auth user_id OR internal student_profiles.id
        # First check if it matches current user's auth id directly
        is_own_profile = (current_user.id == student_id)

        # If not a direct match, check if student_id is an internal profile id
        # that belongs to the current user
        if not is_own_profile:
            profile_check = db.table('student_profiles').select('user_id').eq('id', student_id).execute()
            if profile_check.data and len(profile_check.data) > 0:
                profile_user_id = profile_check.data[0].get('user_id')
                is_own_profile = (profile_user_id == current_user.id)

        # Authorization check
        # Student can only view their own activities
        if current_user.role == 'student' and not is_own_profile:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="You can only view your own activities"
            )

        # Parents and counselors should be able to view their students
        # (This would require additional logic to verify relationship)
        # For now, we'll allow admins, parents, and counselors
        allowed_roles = ['admin_super', 'admin_content', 'parent', 'counselor']
        if current_user.role not in allowed_roles and not is_own_profile:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Not authorized to view this student's activities"
            )

        # Parse activity types filter
        activity_types_list: Optional[List[StudentActivityType]] = None
        if activity_types:
            try:
                activity_types_list = [
                    StudentActivityType(t.strip())
                    for t in activity_types.split(',')
                ]
            except ValueError as e:
                raise HTTPException(
                    status_code=status.HTTP_400_BAD_REQUEST,
                    detail=f"Invalid activity type in filter: {e}"
                )

        # Create filter request
        filters = StudentActivityFilterRequest(
            page=page,
            limit=limit,
            activity_types=activity_types_list,
            start_date=start_date,
            end_date=end_date
        )

        # Get activities from service
        service = StudentActivitiesService()
        result = await service.get_student_activities(
            student_id=student_id,
            filters=filters,
            db=db
        )

        return result

    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error fetching student activities: {str(e)}"
        )
