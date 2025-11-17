"""
Meeting API Endpoints
Handles parent-teacher/counselor meeting requests, approvals, and scheduling
"""
from fastapi import APIRouter, Depends, HTTPException, status, Query
from typing import Dict, Any, List, Optional

from app.services.meeting_service import MeetingService
from app.schemas.meeting import (
    MeetingRequest,
    MeetingUpdate,
    MeetingApproval,
    MeetingDecline,
    MeetingResponse,
    StaffAvailabilityCreate,
    StaffAvailabilityUpdate,
    StaffAvailabilityResponse,
    AvailableSlot,
    AvailableSlotsRequest,
    StaffListItem,
    MeetingStatistics
)
from app.utils.security import (
    get_current_user,
    CurrentUser
)

router = APIRouter()


# ==================== Parent Endpoints ====================

@router.post("/meetings/request", status_code=status.HTTP_201_CREATED)
async def request_meeting(
    meeting_data: MeetingRequest,
    current_user: CurrentUser = Depends(get_current_user)
) -> Dict[str, Any]:
    """
    Request a meeting with a teacher or counselor (Parent only)

    **Requires:** Parent authentication

    **Request Body:**
    - staff_id: ID of the teacher/counselor
    - student_id: ID of the student
    - staff_type: 'teacher' or 'counselor'
    - meeting_type: 'parent_teacher' or 'parent_counselor'
    - subject: Subject/topic of the meeting
    - scheduled_date: Optional preferred date/time
    - duration_minutes: Duration (15, 30, 45, 60, 90, 120)
    - meeting_mode: 'in_person', 'video_call', or 'phone_call'
    - meeting_link: Optional video call link
    - location: Optional location for in-person meetings
    - notes: Optional additional notes
    - parent_notes: Optional parent-specific notes

    **Returns:**
    - Meeting details with status 'pending'
    """
    try:
        # Verify user is a parent
        if current_user.role != 'parent':
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Only parents can request meetings"
            )

        service = MeetingService()
        result = await service.request_meeting(current_user.id, meeting_data)
        return result

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.get("/meetings/parent/{parent_id}")
async def get_parent_meetings(
    parent_id: str,
    status_filter: Optional[str] = Query(None, alias="status"),
    limit: int = Query(50, ge=1, le=100),
    offset: int = Query(0, ge=0),
    current_user: CurrentUser = Depends(get_current_user)
) -> List[Dict[str, Any]]:
    """
    Get all meetings for a parent

    **Requires:** Authentication (parent or admin)

    **Path Parameters:**
    - parent_id: Parent's user ID

    **Query Parameters:**
    - status: Optional filter by status (pending, approved, declined, cancelled, completed)
    - limit: Maximum number of results (1-100, default 50)
    - offset: Number of results to skip (default 0)

    **Returns:**
    - List of meeting records
    """
    try:
        # Verify user has permission (own data or admin)
        if current_user.id != parent_id and current_user.role != 'admin':
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="You can only view your own meetings"
            )

        service = MeetingService()
        result = await service.get_parent_meetings(parent_id, status_filter, limit, offset)
        return result

    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.put("/meetings/{meeting_id}/cancel")
async def cancel_meeting(
    meeting_id: str,
    cancellation_reason: Optional[str] = None,
    current_user: CurrentUser = Depends(get_current_user)
) -> Dict[str, Any]:
    """
    Cancel a meeting (Parent or Staff)

    **Requires:** Authentication (parent or staff involved in meeting)

    **Path Parameters:**
    - meeting_id: Meeting ID

    **Query Parameters:**
    - cancellation_reason: Optional reason for cancellation

    **Returns:**
    - Updated meeting details with status 'cancelled'
    """
    try:
        service = MeetingService()
        result = await service.cancel_meeting(meeting_id, current_user.id, cancellation_reason)
        return result

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


# ==================== Staff Endpoints (Teachers/Counselors) ====================

@router.get("/meetings/staff/{staff_id}")
async def get_staff_meetings(
    staff_id: str,
    status_filter: Optional[str] = Query(None, alias="status"),
    limit: int = Query(50, ge=1, le=100),
    offset: int = Query(0, ge=0),
    current_user: CurrentUser = Depends(get_current_user)
) -> List[Dict[str, Any]]:
    """
    Get all meetings for a staff member (Teacher/Counselor)

    **Requires:** Authentication (staff or admin)

    **Path Parameters:**
    - staff_id: Staff member's user ID

    **Query Parameters:**
    - status: Optional filter by status (pending, approved, declined, cancelled, completed)
    - limit: Maximum number of results (1-100, default 50)
    - offset: Number of results to skip (default 0)

    **Returns:**
    - List of meeting records
    """
    try:
        # Verify user has permission (own data or admin)
        if current_user.id != staff_id and current_user.role != 'admin':
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="You can only view your own meetings"
            )

        service = MeetingService()
        result = await service.get_staff_meetings(staff_id, status_filter, limit, offset)
        return result

    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.put("/meetings/{meeting_id}/approve")
async def approve_meeting(
    meeting_id: str,
    approval_data: MeetingApproval,
    current_user: CurrentUser = Depends(get_current_user)
) -> Dict[str, Any]:
    """
    Approve a meeting request and set scheduled time (Staff only)

    **Requires:** Teacher or Counselor authentication

    **Path Parameters:**
    - meeting_id: Meeting ID

    **Request Body:**
    - scheduled_date: Date and time for the meeting
    - duration_minutes: Duration (15, 30, 45, 60, 90, 120)
    - meeting_link: Optional video call link
    - location: Optional location for in-person meetings
    - staff_notes: Optional notes from staff

    **Returns:**
    - Updated meeting details with status 'approved'
    """
    try:
        # Verify user is staff
        if current_user.role not in ['teacher', 'counselor']:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Only teachers and counselors can approve meetings"
            )

        service = MeetingService()
        result = await service.approve_meeting(meeting_id, current_user.id, approval_data)
        return result

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.put("/meetings/{meeting_id}/decline")
async def decline_meeting(
    meeting_id: str,
    decline_data: MeetingDecline,
    current_user: CurrentUser = Depends(get_current_user)
) -> Dict[str, Any]:
    """
    Decline a meeting request (Staff only)

    **Requires:** Teacher or Counselor authentication

    **Path Parameters:**
    - meeting_id: Meeting ID

    **Request Body:**
    - staff_notes: Reason for declining

    **Returns:**
    - Updated meeting details with status 'declined'
    """
    try:
        # Verify user is staff
        if current_user.role not in ['teacher', 'counselor']:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Only teachers and counselors can decline meetings"
            )

        service = MeetingService()
        result = await service.decline_meeting(meeting_id, current_user.id, decline_data)
        return result

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.post("/staff/availability", status_code=status.HTTP_201_CREATED)
async def set_staff_availability(
    availability_data: StaffAvailabilityCreate,
    current_user: CurrentUser = Depends(get_current_user)
) -> Dict[str, Any]:
    """
    Set availability schedule (Staff only)

    **Requires:** Teacher or Counselor authentication

    **Request Body:**
    - day_of_week: 0=Sunday, 1=Monday, ..., 6=Saturday
    - start_time: Start time (HH:MM:SS format)
    - end_time: End time (HH:MM:SS format)

    **Returns:**
    - Created availability record
    """
    try:
        # Verify user is staff
        if current_user.role not in ['teacher', 'counselor']:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Only teachers and counselors can set availability"
            )

        service = MeetingService()
        result = await service.set_availability(current_user.id, availability_data)
        return result

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.get("/staff/{staff_id}/availability")
async def get_staff_availability(
    staff_id: str,
    current_user: CurrentUser = Depends(get_current_user)
) -> List[Dict[str, Any]]:
    """
    Get availability schedule for a staff member

    **Requires:** Authentication

    **Path Parameters:**
    - staff_id: Staff member's user ID

    **Returns:**
    - List of availability slots
    """
    try:
        service = MeetingService()
        result = await service.get_staff_availability(staff_id)
        return result

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.put("/staff/availability/{availability_id}")
async def update_staff_availability(
    availability_id: str,
    availability_data: StaffAvailabilityUpdate,
    current_user: CurrentUser = Depends(get_current_user)
) -> Dict[str, Any]:
    """
    Update availability schedule (Staff only)

    **Requires:** Teacher or Counselor authentication

    **Path Parameters:**
    - availability_id: Availability record ID

    **Request Body:**
    - start_time: Optional new start time
    - end_time: Optional new end time
    - is_active: Optional active status

    **Returns:**
    - Updated availability record
    """
    try:
        # Verify user is staff
        if current_user.role not in ['teacher', 'counselor']:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Only teachers and counselors can update availability"
            )

        service = MeetingService()
        result = await service.update_availability(availability_id, current_user.id, availability_data)
        return result

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.delete("/staff/availability/{availability_id}")
async def delete_staff_availability(
    availability_id: str,
    current_user: CurrentUser = Depends(get_current_user)
) -> Dict[str, str]:
    """
    Delete availability slot (Staff only)

    **Requires:** Teacher or Counselor authentication

    **Path Parameters:**
    - availability_id: Availability record ID

    **Returns:**
    - Success message
    """
    try:
        # Verify user is staff
        if current_user.role not in ['teacher', 'counselor']:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Only teachers and counselors can delete availability"
            )

        service = MeetingService()
        result = await service.delete_availability(availability_id, current_user.id)
        return result

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


# ==================== Common Endpoints ====================

@router.get("/meetings/{meeting_id}")
async def get_meeting(
    meeting_id: str,
    current_user: CurrentUser = Depends(get_current_user)
) -> Dict[str, Any]:
    """
    Get meeting details

    **Requires:** Authentication

    **Path Parameters:**
    - meeting_id: Meeting ID

    **Returns:**
    - Meeting details
    """
    try:
        service = MeetingService()
        result = await service.get_meeting(meeting_id, current_user.id)
        return result

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=str(e)
        )


@router.post("/meetings/available-slots")
async def get_available_slots(
    request_data: AvailableSlotsRequest,
    current_user: CurrentUser = Depends(get_current_user)
) -> List[AvailableSlot]:
    """
    Get available time slots for a staff member

    **Requires:** Authentication

    **Request Body:**
    - staff_id: Staff member's user ID
    - start_date: Start date for availability search
    - end_date: End date for availability search
    - duration_minutes: Desired meeting duration (15, 30, 45, 60, 90, 120)

    **Returns:**
    - List of available time slots
    """
    try:
        service = MeetingService()
        result = await service.get_available_slots(request_data)
        return result

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.get("/staff/list")
async def get_staff_list(
    role: Optional[str] = Query(None, regex="^(teacher|counselor)$"),
    current_user: CurrentUser = Depends(get_current_user)
) -> List[StaffListItem]:
    """
    List available teachers and counselors

    **Requires:** Authentication

    **Query Parameters:**
    - role: Optional filter by role ('teacher' or 'counselor')

    **Returns:**
    - List of staff members
    """
    try:
        service = MeetingService()
        result = await service.get_staff_list(role)
        return result

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.get("/meetings/statistics/me")
async def get_my_meeting_statistics(
    current_user: CurrentUser = Depends(get_current_user)
) -> MeetingStatistics:
    """
    Get meeting statistics for current user

    **Requires:** Authentication

    **Returns:**
    - Meeting statistics based on user role
    """
    try:
        service = MeetingService()
        result = await service.get_meeting_statistics(current_user.id, current_user.role)
        return result

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )
