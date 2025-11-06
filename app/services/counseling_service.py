"""
Counseling Service
Business logic for counseling sessions and bookings
"""
from typing import Optional, List, Dict, Any
from datetime import datetime, timedelta
import logging
from uuid import uuid4

from app.database.config import get_supabase
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
    CounselorStats,
    AvailableTimeSlot,
    AvailableTimeSlotsResponse,
    SessionStatus,
    SessionType
)

logger = logging.getLogger(__name__)


class CounselingService:
    """Service for managing counseling sessions"""

    def __init__(self):
        self.db = get_supabase()

    async def create_session(
        self,
        user_id: str,
        user_role: str,
        session_data: CounselingSessionCreateRequest
    ) -> CounselingSessionResponse:
        """Create a new counseling session booking"""
        try:
            # Determine student_id based on who's creating
            if user_role == "counselor":
                # Counselor creating for a student
                student_id = session_data.student_id
                if not student_id:
                    raise Exception("student_id required when counselor creates session")
                counselor_id = user_id
            else:
                # Student booking a session
                student_id = user_id
                counselor_id = session_data.counselor_id

            # Verify counselor exists and has counselor role
            counselor = self.db.table('users').select('roles').eq('id', counselor_id).single().execute()
            if not counselor.data or 'counselor' not in counselor.data.get('roles', []):
                raise Exception("Invalid counselor")

            # Check for scheduling conflicts
            conflicts = self.db.table('counseling_sessions').select('id').eq(
                'counselor_id', counselor_id
            ).in_('status', [SessionStatus.SCHEDULED.value, SessionStatus.IN_PROGRESS.value]).or_(
                f"and(scheduled_start.lte.{session_data.scheduled_end},scheduled_end.gte.{session_data.scheduled_start})"
            ).execute()

            if conflicts.data:
                raise Exception("Counselor has a conflicting session at this time")

            session = {
                "id": str(uuid4()),
                "counselor_id": counselor_id,
                "student_id": student_id,
                "session_type": session_data.session_type.value,
                "session_mode": session_data.session_mode.value,
                "status": SessionStatus.SCHEDULED.value,
                "scheduled_start": session_data.scheduled_start,
                "scheduled_end": session_data.scheduled_end,
                "topic": session_data.topic,
                "description": session_data.description,
                "metadata": session_data.metadata or {},
                "created_at": datetime.utcnow().isoformat(),
                "updated_at": datetime.utcnow().isoformat(),
            }

            response = self.db.table('counseling_sessions').insert(session).execute()

            if not response.data:
                raise Exception("Failed to create session")

            logger.info(f"Counseling session created: {response.data[0]['id']}")

            return CounselingSessionResponse(**response.data[0])

        except Exception as e:
            logger.error(f"Create session error: {e}")
            raise Exception(f"Failed to create session: {str(e)}")

    async def get_session(self, session_id: str, user_id: str) -> CounselingSessionResponse:
        """Get session by ID"""
        try:
            response = self.db.table('counseling_sessions').select('*').eq('id', session_id).single().execute()

            if not response.data:
                raise Exception("Session not found")

            # Verify access (student, counselor, or admin)
            session_data = response.data
            if session_data['student_id'] != user_id and session_data['counselor_id'] != user_id:
                # Check if admin
                user = self.db.table('users').select('roles').eq('id', user_id).single().execute()
                if not user.data or not any(role.startswith('admin_') for role in user.data.get('roles', [])):
                    raise Exception("Not authorized to view this session")

            return CounselingSessionResponse(**session_data)

        except Exception as e:
            logger.error(f"Get session error: {e}")
            raise Exception(f"Failed to fetch session: {str(e)}")

    async def update_session(
        self,
        session_id: str,
        user_id: str,
        update_data: CounselingSessionUpdateRequest
    ) -> CounselingSessionResponse:
        """Update a counseling session"""
        try:
            session = await self.get_session(session_id, user_id)

            # Only counselor or student can update
            if session.counselor_id != user_id and session.student_id != user_id:
                raise Exception("Not authorized to update this session")

            # Can't update completed/cancelled sessions
            if session.status in [SessionStatus.COMPLETED.value, SessionStatus.CANCELLED.value]:
                raise Exception(f"Cannot update {session.status} session")

            update = {"updated_at": datetime.utcnow().isoformat()}

            if update_data.scheduled_start:
                update["scheduled_start"] = update_data.scheduled_start
                update["status"] = SessionStatus.RESCHEDULED.value

            if update_data.scheduled_end:
                update["scheduled_end"] = update_data.scheduled_end

            if update_data.topic is not None:
                update["topic"] = update_data.topic

            if update_data.description is not None:
                update["description"] = update_data.description

            if update_data.session_mode:
                update["session_mode"] = update_data.session_mode.value

            response = self.db.table('counseling_sessions').update(update).eq('id', session_id).execute()

            if not response.data:
                raise Exception("Failed to update session")

            logger.info(f"Session updated: {session_id}")

            return CounselingSessionResponse(**response.data[0])

        except Exception as e:
            logger.error(f"Update session error: {e}")
            raise Exception(f"Failed to update session: {str(e)}")

    async def cancel_session(self, session_id: str, user_id: str, reason: Optional[str] = None) -> CounselingSessionResponse:
        """Cancel a counseling session"""
        try:
            session = await self.get_session(session_id, user_id)

            # Only counselor or student can cancel
            if session.counselor_id != user_id and session.student_id != user_id:
                raise Exception("Not authorized to cancel this session")

            if session.status in [SessionStatus.COMPLETED.value, SessionStatus.CANCELLED.value]:
                raise Exception(f"Cannot cancel {session.status} session")

            update = {
                "status": SessionStatus.CANCELLED.value,
                "metadata": {**(session.metadata or {}), "cancellation_reason": reason, "cancelled_by": user_id},
                "updated_at": datetime.utcnow().isoformat()
            }

            response = self.db.table('counseling_sessions').update(update).eq('id', session_id).execute()

            if not response.data:
                raise Exception("Failed to cancel session")

            logger.info(f"Session cancelled: {session_id}")

            return CounselingSessionResponse(**response.data[0])

        except Exception as e:
            logger.error(f"Cancel session error: {e}")
            raise Exception(f"Failed to cancel session: {str(e)}")

    async def start_session(self, session_id: str, counselor_id: str) -> CounselingSessionResponse:
        """Start a counseling session"""
        try:
            session = await self.get_session(session_id, counselor_id)

            if session.counselor_id != counselor_id:
                raise Exception("Only the counselor can start the session")

            if session.status != SessionStatus.SCHEDULED.value:
                raise Exception(f"Cannot start session with status: {session.status}")

            update = {
                "status": SessionStatus.IN_PROGRESS.value,
                "actual_start": datetime.utcnow().isoformat(),
                "updated_at": datetime.utcnow().isoformat()
            }

            response = self.db.table('counseling_sessions').update(update).eq('id', session_id).execute()

            if not response.data:
                raise Exception("Failed to start session")

            logger.info(f"Session started: {session_id}")

            return CounselingSessionResponse(**response.data[0])

        except Exception as e:
            logger.error(f"Start session error: {e}")
            raise Exception(f"Failed to start session: {str(e)}")

    async def complete_session(self, session_id: str, counselor_id: str) -> CounselingSessionResponse:
        """Complete a counseling session"""
        try:
            session = await self.get_session(session_id, counselor_id)

            if session.counselor_id != counselor_id:
                raise Exception("Only the counselor can complete the session")

            if session.status != SessionStatus.IN_PROGRESS.value:
                raise Exception(f"Cannot complete session with status: {session.status}")

            update = {
                "status": SessionStatus.COMPLETED.value,
                "actual_end": datetime.utcnow().isoformat(),
                "updated_at": datetime.utcnow().isoformat()
            }

            response = self.db.table('counseling_sessions').update(update).eq('id', session_id).execute()

            if not response.data:
                raise Exception("Failed to complete session")

            logger.info(f"Session completed: {session_id}")

            return CounselingSessionResponse(**response.data[0])

        except Exception as e:
            logger.error(f"Complete session error: {e}")
            raise Exception(f"Failed to complete session: {str(e)}")

    async def list_sessions(
        self,
        user_id: str,
        user_role: str,
        page: int = 1,
        page_size: int = 20,
        status: Optional[str] = None,
        session_type: Optional[str] = None
    ) -> CounselingSessionListResponse:
        """List counseling sessions for user"""
        try:
            # Build query based on role
            if user_role == "counselor":
                query = self.db.table('counseling_sessions').select('*', count='exact').eq('counselor_id', user_id)
            elif user_role == "student":
                query = self.db.table('counseling_sessions').select('*', count='exact').eq('student_id', user_id)
            else:
                # Admin can see all
                query = self.db.table('counseling_sessions').select('*', count='exact')

            if status:
                query = query.eq('status', status)

            if session_type:
                query = query.eq('session_type', session_type)

            offset = (page - 1) * page_size
            query = query.order('scheduled_start', desc=True).range(offset, offset + page_size - 1)

            response = query.execute()

            sessions = [CounselingSessionResponse(**s) for s in response.data] if response.data else []
            total = response.count or 0

            return CounselingSessionListResponse(
                sessions=sessions,
                total=total,
                page=page,
                page_size=page_size,
                has_more=(offset + page_size) < total
            )

        except Exception as e:
            logger.error(f"List sessions error: {e}")
            raise Exception(f"Failed to list sessions: {str(e)}")

    async def add_feedback(
        self,
        session_id: str,
        student_id: str,
        feedback_data: SessionFeedbackRequest
    ) -> CounselingSessionResponse:
        """Add feedback to a completed session"""
        try:
            session = await self.get_session(session_id, student_id)

            if session.student_id != student_id:
                raise Exception("Only the student can provide feedback")

            if session.status != SessionStatus.COMPLETED.value:
                raise Exception("Can only provide feedback for completed sessions")

            update = {
                "feedback_rating": feedback_data.rating,
                "feedback_comment": feedback_data.comment,
                "updated_at": datetime.utcnow().isoformat()
            }

            response = self.db.table('counseling_sessions').update(update).eq('id', session_id).execute()

            if not response.data:
                raise Exception("Failed to add feedback")

            logger.info(f"Feedback added to session: {session_id}")

            return CounselingSessionResponse(**response.data[0])

        except Exception as e:
            logger.error(f"Add feedback error: {e}")
            raise Exception(f"Failed to add feedback: {str(e)}")

    # Session Notes Methods
    async def create_session_notes(
        self,
        counselor_id: str,
        notes_data: SessionNotesCreateRequest
    ) -> SessionNotesResponse:
        """Create session notes (counselor only)"""
        try:
            # Verify session and counselor
            session = await self.get_session(notes_data.session_id, counselor_id)

            if session.counselor_id != counselor_id:
                raise Exception("Only the session counselor can create notes")

            notes = {
                "id": str(uuid4()),
                "session_id": notes_data.session_id,
                "counselor_id": counselor_id,
                "private_notes": notes_data.private_notes,
                "shared_notes": notes_data.shared_notes,
                "action_items": notes_data.action_items or [],
                "follow_up_required": notes_data.follow_up_required,
                "follow_up_date": notes_data.follow_up_date,
                "created_at": datetime.utcnow().isoformat(),
                "updated_at": datetime.utcnow().isoformat(),
            }

            response = self.db.table('session_notes').insert(notes).execute()

            if not response.data:
                raise Exception("Failed to create notes")

            # Link notes to session
            self.db.table('counseling_sessions').update({
                "notes_id": response.data[0]['id']
            }).eq('id', notes_data.session_id).execute()

            logger.info(f"Session notes created: {response.data[0]['id']}")

            return SessionNotesResponse(**response.data[0])

        except Exception as e:
            logger.error(f"Create notes error: {e}")
            raise Exception(f"Failed to create notes: {str(e)}")

    async def get_session_notes(
        self,
        notes_id: str,
        user_id: str,
        user_role: str
    ) -> SessionNotesResponse:
        """Get session notes"""
        try:
            response = self.db.table('session_notes').select('*').eq('id', notes_id).single().execute()

            if not response.data:
                raise Exception("Notes not found")

            notes = SessionNotesResponse(**response.data)

            # Only counselor can see private notes
            if user_role != "counselor" or notes.counselor_id != user_id:
                # Student/parent can only see shared notes
                notes.private_notes = "[Private - Counselor Only]"

            return notes

        except Exception as e:
            logger.error(f"Get notes error: {e}")
            raise Exception(f"Failed to fetch notes: {str(e)}")

    # Counselor Availability Methods
    async def set_availability(
        self,
        counselor_id: str,
        availability_data: CounselorAvailabilityCreateRequest
    ) -> CounselorAvailabilityResponse:
        """Set counselor availability"""
        try:
            availability = {
                "id": str(uuid4()),
                "counselor_id": counselor_id,
                "day_of_week": availability_data.day_of_week,
                "start_time": availability_data.start_time,
                "end_time": availability_data.end_time,
                "session_duration": availability_data.session_duration,
                "max_sessions_per_day": availability_data.max_sessions_per_day,
                "is_active": True,
                "created_at": datetime.utcnow().isoformat(),
                "updated_at": datetime.utcnow().isoformat(),
            }

            response = self.db.table('counselor_availability').insert(availability).execute()

            if not response.data:
                raise Exception("Failed to set availability")

            logger.info(f"Availability set for counselor: {counselor_id}")

            return CounselorAvailabilityResponse(**response.data[0])

        except Exception as e:
            logger.error(f"Set availability error: {e}")
            raise Exception(f"Failed to set availability: {str(e)}")

    async def get_counselor_availability(self, counselor_id: str) -> CounselorAvailabilityListResponse:
        """Get counselor's availability"""
        try:
            response = self.db.table('counselor_availability').select('*').eq(
                'counselor_id', counselor_id
            ).eq('is_active', True).order('day_of_week').execute()

            availability = [CounselorAvailabilityResponse(**a) for a in response.data] if response.data else []

            return CounselorAvailabilityListResponse(
                availability=availability,
                total=len(availability)
            )

        except Exception as e:
            logger.error(f"Get availability error: {e}")
            raise Exception(f"Failed to get availability: {str(e)}")

    async def get_counseling_stats(self, user_id: str, user_role: str) -> CounselingStats:
        """Get counseling statistics"""
        try:
            if user_role == "student":
                sessions_query = self.db.table('counseling_sessions').select('*').eq('student_id', user_id)
            elif user_role == "counselor":
                sessions_query = self.db.table('counseling_sessions').select('*').eq('counselor_id', user_id)
            else:
                sessions_query = self.db.table('counseling_sessions').select('*')

            sessions_response = sessions_query.execute()
            sessions = sessions_response.data if sessions_response.data else []

            total = len(sessions)
            completed = len([s for s in sessions if s['status'] == SessionStatus.COMPLETED.value])
            upcoming = len([s for s in sessions if s['status'] == SessionStatus.SCHEDULED.value])
            cancelled = len([s for s in sessions if s['status'] == SessionStatus.CANCELLED.value])

            # Calculate average rating
            ratings = [s['feedback_rating'] for s in sessions if s.get('feedback_rating')]
            avg_rating = sum(ratings) / len(ratings) if ratings else None

            # Calculate total hours
            total_hours = 0.0
            for s in sessions:
                if s.get('actual_start') and s.get('actual_end'):
                    start = datetime.fromisoformat(s['actual_start'].replace('Z', '+00:00'))
                    end = datetime.fromisoformat(s['actual_end'].replace('Z', '+00:00'))
                    total_hours += (end - start).total_seconds() / 3600

            # Group by type
            by_type = {}
            for s in sessions:
                stype = s.get('session_type', 'unknown')
                by_type[stype] = by_type.get(stype, 0) + 1

            # Group by status
            by_status = {}
            for s in sessions:
                sstatus = s.get('status', 'unknown')
                by_status[sstatus] = by_status.get(sstatus, 0) + 1

            # Recent sessions
            recent = sorted(sessions, key=lambda x: x.get('created_at', ''), reverse=True)[:5]
            recent_sessions = [
                {
                    "id": s.get('id'),
                    "type": s.get('session_type'),
                    "status": s.get('status'),
                    "scheduled_start": s.get('scheduled_start'),
                    "topic": s.get('topic')
                }
                for s in recent
            ]

            return CounselingStats(
                total_sessions=total,
                completed_sessions=completed,
                upcoming_sessions=upcoming,
                cancelled_sessions=cancelled,
                average_rating=avg_rating,
                total_hours=total_hours,
                by_type=by_type,
                by_status=by_status,
                recent_sessions=recent_sessions
            )

        except Exception as e:
            logger.error(f"Get stats error: {e}")
            raise Exception(f"Failed to get statistics: {str(e)}")
