"""
Counseling API Endpoints
RESTful API for counseling sessions and bookings
"""
from typing import Optional
from fastapi import APIRouter, Depends, HTTPException, status, Query, Body

from app.services.counseling_service import CounselingService
from app.schemas.counseling import (
    CounselingSessionCreateRequest,
    CounselingSessionUpdateRequest,
    CounselingSessionResponse,
    CounselingSessionListResponse,
    SessionNotesCreateRequest,
    SessionNotesUpdateRequest,
    SessionNotesResponse,
    CounselorAvailabilityCreateRequest,
    CounselorAvailabilityResponse,
    CounselorAvailabilityListResponse,
    SessionFeedbackRequest,
    CounselingStats,
    CounselorStats
)
from app.utils.security import get_current_user, RoleChecker, UserRole, CurrentUser

router = APIRouter()


@router.post("/counseling/sessions", status_code=status.HTTP_201_CREATED)
async def create_counseling_session(
    session_data: CounselingSessionCreateRequest,
    current_user: CurrentUser = Depends(get_current_user)
) -> CounselingSessionResponse:
    """
    Create a counseling session booking

    **Requires:** Student or Counselor authentication

    **Request Body:**
    - counselor_id: ID of the counselor
    - student_id: Optional (for counselor creating on behalf of student)
    - session_type: Type of session (academic, career, personal, etc.)
    - session_mode: Delivery mode (video, audio, chat, in_person)
    - scheduled_start: Session start time (ISO datetime)
    - scheduled_end: Session end time (ISO datetime)
    - topic: Optional session topic
    - description: Optional description

    **Returns:**
    - Created session data with scheduling details
    """
    try:
        service = CounselingService()
        # Determine user role from roles array
        user_role = current_user.role if current_user.role in ["counselor", "student"] else (
            "counselor" if "counselor" in current_user.available_roles else "student"
        )
        result = await service.create_session(current_user.id, user_role, session_data)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.get("/counseling/sessions/{session_id}")
async def get_counseling_session(
    session_id: str,
    current_user: CurrentUser = Depends(get_current_user)
) -> CounselingSessionResponse:
    """
    Get counseling session by ID

    **Requires:** Authentication (student, counselor, or admin)

    **Path Parameters:**
    - session_id: Session ID

    **Returns:**
    - Session data including scheduling, status, and feedback
    """
    try:
        service = CounselingService()
        result = await service.get_session(session_id, current_user.id)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=str(e)
        )


@router.put("/counseling/sessions/{session_id}")
async def update_counseling_session(
    session_id: str,
    update_data: CounselingSessionUpdateRequest,
    current_user: CurrentUser = Depends(get_current_user)
) -> CounselingSessionResponse:
    """
    Update a counseling session

    **Requires:** Authentication (student or counselor involved in session)

    **Path Parameters:**
    - session_id: Session ID

    **Request Body:**
    - scheduled_start: Optional new start time
    - scheduled_end: Optional new end time
    - topic: Optional new topic
    - description: Optional new description
    - session_mode: Optional new mode

    **Returns:**
    - Updated session data
    """
    try:
        service = CounselingService()
        result = await service.update_session(session_id, current_user.id, update_data)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.post("/counseling/sessions/{session_id}/cancel")
async def cancel_counseling_session(
    session_id: str,
    reason: Optional[str] = Body(None, embed=True),
    current_user: CurrentUser = Depends(get_current_user)
) -> CounselingSessionResponse:
    """
    Cancel a counseling session

    **Requires:** Authentication (student or counselor involved in session)

    **Path Parameters:**
    - session_id: Session ID

    **Request Body:**
    - reason: Optional cancellation reason

    **Returns:**
    - Updated session with cancelled status
    """
    try:
        service = CounselingService()
        result = await service.cancel_session(session_id, current_user.id, reason)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.post("/counseling/sessions/{session_id}/start")
async def start_counseling_session(
    session_id: str,
    current_user: CurrentUser = Depends(RoleChecker([UserRole.COUNSELOR]))
) -> CounselingSessionResponse:
    """
    Start a counseling session (Counselor only)

    **Requires:** Counselor authentication

    **Path Parameters:**
    - session_id: Session ID

    **Returns:**
    - Updated session with in_progress status and actual_start time
    """
    try:
        service = CounselingService()
        result = await service.start_session(session_id, current_user.id)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.post("/counseling/sessions/{session_id}/complete")
async def complete_counseling_session(
    session_id: str,
    current_user: CurrentUser = Depends(RoleChecker([UserRole.COUNSELOR]))
) -> CounselingSessionResponse:
    """
    Complete a counseling session (Counselor only)

    **Requires:** Counselor authentication

    **Path Parameters:**
    - session_id: Session ID

    **Returns:**
    - Updated session with completed status and actual_end time
    """
    try:
        service = CounselingService()
        result = await service.complete_session(session_id, current_user.id)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.get("/counseling/sessions")
async def list_counseling_sessions(
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
    status: Optional[str] = None,
    session_type: Optional[str] = None,
    current_user: CurrentUser = Depends(get_current_user)
) -> CounselingSessionListResponse:
    """
    List counseling sessions

    **Requires:** Authentication

    **Query Parameters:**
    - page: Page number (default: 1)
    - page_size: Items per page (default: 20, max: 100)
    - status: Filter by status (scheduled, in_progress, completed, cancelled)
    - session_type: Filter by type (academic, career, personal, etc.)

    **Returns:**
    - Paginated list of sessions
    - Students see their own sessions
    - Counselors see sessions they're conducting
    - Admins see all sessions
    """
    try:
        service = CounselingService()
        user_role = current_user.role if current_user.role in ["counselor", "student"] else (
            "counselor" if "counselor" in current_user.available_roles else "student"
        )
        result = await service.list_sessions(current_user.id, user_role, page, page_size, status, session_type)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.post("/counseling/sessions/{session_id}/feedback")
async def add_session_feedback(
    session_id: str,
    feedback_data: SessionFeedbackRequest,
    current_user: CurrentUser = Depends(get_current_user)
) -> CounselingSessionResponse:
    """
    Add feedback to a completed session (Student only)

    **Requires:** Student authentication

    **Path Parameters:**
    - session_id: Session ID

    **Request Body:**
    - rating: Rating from 1.0 to 5.0
    - comment: Optional feedback comment

    **Returns:**
    - Updated session with feedback
    """
    try:
        service = CounselingService()
        result = await service.add_feedback(session_id, current_user.id, feedback_data)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


# Session Notes Endpoints
@router.post("/counseling/sessions/{session_id}/notes", status_code=status.HTTP_201_CREATED)
async def create_session_notes(
    session_id: str,
    notes_data: SessionNotesCreateRequest,
    current_user: CurrentUser = Depends(RoleChecker([UserRole.COUNSELOR]))
) -> SessionNotesResponse:
    """
    Create session notes (Counselor only)

    **Requires:** Counselor authentication

    **Path Parameters:**
    - session_id: Session ID

    **Request Body:**
    - private_notes: Notes visible only to counselor (required)
    - shared_notes: Optional notes shared with student
    - action_items: Optional list of action items
    - follow_up_required: Whether follow-up is needed
    - follow_up_date: Optional follow-up date

    **Returns:**
    - Created session notes

    **Note:** Private notes are only visible to the counselor
    """
    try:
        notes_data.session_id = session_id
        service = CounselingService()
        result = await service.create_session_notes(current_user.id, notes_data)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.get("/counseling/notes/{notes_id}")
async def get_session_notes(
    notes_id: str,
    current_user: CurrentUser = Depends(get_current_user)
) -> SessionNotesResponse:
    """
    Get session notes

    **Requires:** Authentication

    **Path Parameters:**
    - notes_id: Notes ID

    **Returns:**
    - Session notes
    - Counselors see all notes
    - Students/parents see only shared notes
    """
    try:
        service = CounselingService()
        user_role = current_user.role if current_user.role in ["counselor", "student"] else (
            "counselor" if "counselor" in current_user.available_roles else "student"
        )
        result = await service.get_session_notes(notes_id, current_user.id, user_role)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=str(e)
        )


# Counselor Availability Endpoints
@router.post("/counseling/availability", status_code=status.HTTP_201_CREATED)
async def set_counselor_availability(
    availability_data: CounselorAvailabilityCreateRequest,
    current_user: CurrentUser = Depends(RoleChecker([UserRole.COUNSELOR]))
) -> CounselorAvailabilityResponse:
    """
    Set counselor availability (Counselor only)

    **Requires:** Counselor authentication

    **Request Body:**
    - day_of_week: Day of week (0=Monday, 6=Sunday)
    - start_time: Start time (HH:MM format)
    - end_time: End time (HH:MM format)
    - session_duration: Session duration in minutes (default: 30)
    - max_sessions_per_day: Optional max sessions per day

    **Returns:**
    - Created availability record
    """
    try:
        service = CounselingService()
        result = await service.set_availability(current_user.id, availability_data)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.get("/counseling/counselors/{counselor_id}/availability")
async def get_counselor_availability(
    counselor_id: str,
    current_user: CurrentUser = Depends(get_current_user)
) -> CounselorAvailabilityListResponse:
    """
    Get counselor's availability

    **Requires:** Authentication

    **Path Parameters:**
    - counselor_id: Counselor's user ID

    **Returns:**
    - List of availability slots by day of week
    """
    try:
        service = CounselingService()
        result = await service.get_counselor_availability(counselor_id)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


# Students List Endpoint (for counselors)
@router.get("/counseling/students")
async def list_students_for_counselor(
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
    search: Optional[str] = None,
    current_user: CurrentUser = Depends(RoleChecker([UserRole.COUNSELOR]))
):
    """
    List students for counselor to schedule sessions with

    **Requires:** Counselor authentication

    **Query Parameters:**
    - page: Page number (default: 1)
    - page_size: Items per page (default: 20, max: 100)
    - search: Optional search by name or email

    **Returns:**
    - List of students with basic info
    """
    try:
        service = CounselingService()
        result = await service.list_students(page, page_size, search)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


# Statistics Endpoints
@router.get("/counseling/stats/me")
async def get_my_counseling_stats(
    current_user: CurrentUser = Depends(get_current_user)
) -> CounselingStats:
    """
    Get counseling statistics for current user

    **Requires:** Authentication

    **Returns:**
    - total_sessions: Total number of sessions
    - completed_sessions: Completed session count
    - upcoming_sessions: Scheduled session count
    - cancelled_sessions: Cancelled session count
    - average_rating: Average feedback rating
    - total_hours: Total hours of counseling
    - by_type: Count by session type
    - by_status: Count by status
    - recent_sessions: Last 5 sessions

    **Note:** Students see their sessions, counselors see sessions they conducted
    """
    try:
        service = CounselingService()
        user_role = current_user.role if current_user.role in ["counselor", "student"] else (
            "counselor" if "counselor" in current_user.available_roles else "student"
        )
        result = await service.get_counseling_stats(current_user.id, user_role)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


# ==================== STUDENT ACCESS ENDPOINTS ====================

@router.get("/counseling/my-counselor")
async def get_my_counselor(
    current_user: CurrentUser = Depends(get_current_user)
):
    """
    Get assigned counselor for current student

    **Requires:** Student authentication

    **Returns:**
    - Counselor info including name, email, availability
    - Counselor stats (completed sessions, rating)
    - Returns null if no counselor assigned
    """
    try:
        service = CounselingService()
        result = await service.get_student_counselor(current_user.id)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.get("/counseling/available-slots/{counselor_id}")
async def get_available_slots(
    counselor_id: str,
    start_date: str = Query(..., description="Start date (ISO format)"),
    end_date: str = Query(..., description="End date (ISO format)"),
    current_user: CurrentUser = Depends(get_current_user)
):
    """
    Get available booking slots for a counselor

    **Requires:** Authentication

    **Path Parameters:**
    - counselor_id: Counselor's user ID

    **Query Parameters:**
    - start_date: Start of date range (ISO format)
    - end_date: End of date range (ISO format)

    **Returns:**
    - List of available time slots with start/end times
    """
    try:
        service = CounselingService()
        result = await service.get_available_slots(counselor_id, start_date, end_date)
        return {"slots": result}
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.post("/counseling/sessions/book", status_code=status.HTTP_201_CREATED)
async def book_session_as_student(
    counselor_id: str = Body(...),
    scheduled_start: str = Body(...),
    session_type: str = Body("general"),
    topic: Optional[str] = Body(None),
    description: Optional[str] = Body(None),
    current_user: CurrentUser = Depends(get_current_user)
):
    """
    Book a counseling session (Student-initiated)

    **Requires:** Student authentication

    **Request Body:**
    - counselor_id: ID of the counselor to book with
    - scheduled_start: Session start time (ISO datetime)
    - session_type: Type of session (academic, career, personal, etc.)
    - topic: Optional session topic
    - description: Optional description

    **Returns:**
    - Created session data
    """
    try:
        service = CounselingService()
        result = await service.book_session_as_student(
            student_id=current_user.id,
            counselor_id=counselor_id,
            scheduled_start=scheduled_start,
            session_type=session_type,
            topic=topic,
            description=description
        )
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


# ==================== PARENT ACCESS ENDPOINTS ====================

@router.get("/counseling/children/{child_id}/counselor")
async def get_child_counselor(
    child_id: str,
    current_user: CurrentUser = Depends(get_current_user)
):
    """
    Get child's assigned counselor (Parent access)

    **Requires:** Parent authentication with valid parent-child link

    **Path Parameters:**
    - child_id: Child's user ID

    **Returns:**
    - Counselor info including name, email, availability
    - Returns null if no counselor assigned
    """
    try:
        service = CounselingService()
        result = await service.get_child_counselor(child_id, current_user.id)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=str(e)
        )


@router.get("/counseling/children/{child_id}/sessions")
async def get_child_sessions(
    child_id: str,
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
    status: Optional[str] = None,
    current_user: CurrentUser = Depends(get_current_user)
):
    """
    Get child's counseling sessions (Parent access)

    **Requires:** Parent authentication with valid parent-child link

    **Path Parameters:**
    - child_id: Child's user ID

    **Query Parameters:**
    - page: Page number (default: 1)
    - page_size: Items per page (default: 20, max: 100)
    - status: Filter by status

    **Returns:**
    - Paginated list of child's counseling sessions
    - Parents only see shared notes, not private counselor notes
    """
    try:
        service = CounselingService()
        result = await service.get_child_sessions(
            child_id=child_id,
            parent_id=current_user.id,
            page=page,
            page_size=page_size,
            status_filter=status
        )
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=str(e)
        )


# ==================== INSTITUTION ACCESS ENDPOINTS ====================

@router.get("/counseling/institution/counselors")
async def list_institution_counselors(
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
    search: Optional[str] = None,
    current_user: CurrentUser = Depends(RoleChecker([UserRole.INSTITUTION]))
):
    """
    List all counselors in institution (Admin only)

    **Requires:** Admin authentication

    **Query Parameters:**
    - page: Page number (default: 1)
    - page_size: Items per page (default: 20, max: 100)
    - search: Search by name or email

    **Returns:**
    - Paginated list of counselors with stats
    """
    try:
        service = CounselingService()
        # Get institution_id from current user
        institution_id = getattr(current_user, 'institution_id', None)
        result = await service.list_institution_counselors(institution_id, page, page_size, search)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.post("/counseling/assign")
async def assign_counselor_to_student(
    counselor_id: str = Body(...),
    student_id: str = Body(...),
    current_user: CurrentUser = Depends(RoleChecker([UserRole.INSTITUTION]))
):
    """
    Assign a counselor to a student (Admin only)

    **Requires:** Admin authentication

    **Request Body:**
    - counselor_id: ID of the counselor
    - student_id: ID of the student

    **Returns:**
    - Assignment record
    """
    try:
        service = CounselingService()
        result = await service.assign_counselor_to_student(
            counselor_id=counselor_id,
            student_id=student_id,
            assigned_by=current_user.id
        )
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.get("/counseling/institution/stats")
async def get_institution_counseling_stats(
    current_user: CurrentUser = Depends(RoleChecker([UserRole.INSTITUTION]))
):
    """
    Get institution-wide counseling statistics (Admin only)

    **Requires:** Admin authentication

    **Returns:**
    - Total counselors
    - Total students assigned
    - Total/completed/upcoming sessions
    - Average rating
    - Sessions by type
    - Counselor performance summary
    """
    try:
        service = CounselingService()
        institution_id = getattr(current_user, 'institution_id', None)
        result = await service.get_institution_counseling_stats(institution_id)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )
