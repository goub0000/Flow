"""
Counseling Service
Business logic for counseling sessions and bookings
"""
from typing import Optional, List, Dict, Any
from datetime import datetime, timedelta
import logging
from uuid import uuid4

from app.database.config import get_supabase_admin
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
        self.db = get_supabase_admin()

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
                query = self.db.table('counseling_sessions').select('*').eq('counselor_id', user_id)
            elif user_role == "student":
                query = self.db.table('counseling_sessions').select('*').eq('student_id', user_id)
            else:
                # Admin can see all
                query = self.db.table('counseling_sessions').select('*')

            if status:
                query = query.eq('status', status)

            if session_type:
                query = query.eq('type', session_type)  # Table uses 'type' not 'session_type'

            offset = (page - 1) * page_size
            # Table uses 'scheduled_date' not 'scheduled_start'
            query = query.order('scheduled_date', desc=True).range(offset, offset + page_size - 1)

            response = query.execute()

            sessions = []
            if response.data:
                for s in response.data:
                    try:
                        # Transform database schema to response schema
                        scheduled_date = s.get('scheduled_date', '')
                        duration = s.get('duration_minutes', 30)

                        # Calculate end time from duration
                        scheduled_end = scheduled_date
                        if scheduled_date:
                            try:
                                start_dt = datetime.fromisoformat(scheduled_date.replace('Z', '+00:00'))
                                end_dt = start_dt + timedelta(minutes=duration)
                                scheduled_end = end_dt.isoformat()
                            except:
                                pass

                        session_data = {
                            'id': s.get('id', ''),
                            'counselor_id': s.get('counselor_id', ''),
                            'student_id': s.get('student_id', ''),
                            'session_type': s.get('type', 'general'),
                            'session_mode': 'video',  # Default since table doesn't have this
                            'status': s.get('status', 'scheduled'),
                            'scheduled_start': scheduled_date,
                            'scheduled_end': scheduled_end,
                            'topic': s.get('notes', ''),  # Use notes as topic
                            'description': s.get('summary', ''),
                            'created_at': s.get('created_at', ''),
                            'updated_at': s.get('updated_at', ''),
                        }
                        sessions.append(CounselingSessionResponse(**session_data))
                    except Exception as e:
                        logger.warning(f"Could not parse session {s.get('id')}: {e}")

            total = len(response.data) if response.data else 0

            return CounselingSessionListResponse(
                sessions=sessions,
                total=total,
                page=page,
                page_size=page_size,
                has_more=(offset + page_size) < total
            )

        except Exception as e:
            logger.error(f"List sessions error: {e}")
            # Return empty list instead of crashing
            return CounselingSessionListResponse(
                sessions=[],
                total=0,
                page=page,
                page_size=page_size,
                has_more=False
            )

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

    async def list_students(
        self,
        page: int = 1,
        page_size: int = 20,
        search: Optional[str] = None
    ) -> Dict[str, Any]:
        """List students for counselor to schedule sessions with"""
        try:
            # Query users with student role - simpler approach
            # Get all users and filter in Python for reliability
            response = self.db.table('users').select(
                'id, email, display_name, created_at, active_role, available_roles'
            ).execute()

            students = []
            if response.data:
                for user in response.data:
                    # Check if user is a student
                    active_role = user.get('active_role', '')
                    available_roles = user.get('available_roles', []) or []

                    is_student = active_role == 'student' or 'student' in available_roles

                    if not is_student:
                        continue

                    # Apply search filter if provided
                    if search:
                        search_lower = search.lower()
                        name = (user.get('display_name') or '').lower()
                        email = (user.get('email') or '').lower()
                        if search_lower not in name and search_lower not in email:
                            continue

                    students.append({
                        "id": user.get('id'),
                        "name": user.get('display_name', user.get('email', 'Unknown')),
                        "email": user.get('email', ''),
                        "created_at": user.get('created_at')
                    })

            # Calculate pagination
            total = len(students)
            offset = (page - 1) * page_size
            paginated_students = students[offset:offset + page_size]

            return {
                "students": paginated_students,
                "total": total,
                "page": page,
                "page_size": page_size,
                "total_pages": (total + page_size - 1) // page_size if total > 0 else 0
            }

        except Exception as e:
            logger.error(f"List students error: {e}")
            raise Exception(f"Failed to list students: {str(e)}")

    # ==================== STUDENT ACCESS METHODS ====================

    async def get_student_counselor(self, student_id: str) -> Optional[Dict[str, Any]]:
        """Get assigned counselor for a student"""
        try:
            # Check student_counselor_assignments table first
            assignment = self.db.table('student_counselor_assignments').select(
                'counselor_id, assigned_at'
            ).eq('student_id', student_id).eq('is_active', True).single().execute()

            if not assignment.data:
                return None

            counselor_id = assignment.data['counselor_id']

            # Get counselor details
            counselor = self.db.table('users').select(
                'id, email, display_name, created_at'
            ).eq('id', counselor_id).single().execute()

            if not counselor.data:
                return None

            # Get counselor's availability
            availability = await self.get_counselor_availability(counselor_id)

            # Get counselor's stats (completed sessions, rating)
            stats_query = self.db.table('counseling_sessions').select('*').eq(
                'counselor_id', counselor_id
            ).eq('status', SessionStatus.COMPLETED.value).execute()

            completed_sessions = len(stats_query.data) if stats_query.data else 0
            ratings = [s.get('feedback_rating') for s in (stats_query.data or []) if s.get('feedback_rating')]
            avg_rating = sum(ratings) / len(ratings) if ratings else None

            return {
                "id": counselor.data['id'],
                "name": counselor.data.get('display_name', counselor.data.get('email', 'Unknown')),
                "email": counselor.data.get('email', ''),
                "assigned_at": assignment.data.get('assigned_at'),
                "availability": [a.model_dump() for a in availability.availability] if availability.availability else [],
                "completed_sessions": completed_sessions,
                "average_rating": avg_rating
            }

        except Exception as e:
            logger.error(f"Get student counselor error: {e}")
            return None

    async def get_available_slots(
        self,
        counselor_id: str,
        start_date: str,
        end_date: str
    ) -> List[Dict[str, Any]]:
        """Get available booking slots for a counselor within date range"""
        try:
            # Get counselor availability
            availability_response = await self.get_counselor_availability(counselor_id)
            availability = availability_response.availability if availability_response else []

            if not availability:
                return []

            # Parse dates
            start = datetime.fromisoformat(start_date.replace('Z', '+00:00'))
            end = datetime.fromisoformat(end_date.replace('Z', '+00:00'))

            # Get existing sessions in the date range
            existing_sessions = self.db.table('counseling_sessions').select(
                'scheduled_date, duration_minutes, status'
            ).eq('counselor_id', counselor_id).gte(
                'scheduled_date', start_date
            ).lte('scheduled_date', end_date).in_(
                'status', [SessionStatus.SCHEDULED.value, SessionStatus.IN_PROGRESS.value]
            ).execute()

            booked_slots = set()
            if existing_sessions.data:
                for session in existing_sessions.data:
                    if session.get('scheduled_date'):
                        booked_slots.add(session['scheduled_date'][:16])  # Compare by minute

            # Generate available slots
            available_slots = []
            current_date = start.date()
            end_date_obj = end.date()

            while current_date <= end_date_obj:
                day_of_week = current_date.weekday()  # 0=Monday, 6=Sunday

                # Find availability for this day
                day_availability = [a for a in availability if a.day_of_week == day_of_week]

                for avail in day_availability:
                    # Parse start and end times
                    start_time_parts = avail.start_time.split(':')
                    end_time_parts = avail.end_time.split(':')

                    slot_start = datetime.combine(
                        current_date,
                        datetime.strptime(avail.start_time, '%H:%M').time()
                    )
                    slot_end = datetime.combine(
                        current_date,
                        datetime.strptime(avail.end_time, '%H:%M').time()
                    )

                    duration = avail.session_duration or 30

                    # Generate slots
                    while slot_start + timedelta(minutes=duration) <= slot_end:
                        slot_key = slot_start.isoformat()[:16]

                        # Check if not booked and not in the past
                        if slot_key not in booked_slots and slot_start > datetime.now():
                            available_slots.append({
                                "start": slot_start.isoformat(),
                                "end": (slot_start + timedelta(minutes=duration)).isoformat(),
                                "duration_minutes": duration,
                                "counselor_id": counselor_id
                            })

                        slot_start += timedelta(minutes=duration)

                current_date += timedelta(days=1)

            return available_slots

        except Exception as e:
            logger.error(f"Get available slots error: {e}")
            return []

    async def book_session_as_student(
        self,
        student_id: str,
        counselor_id: str,
        scheduled_start: str,
        session_type: str = "general",
        topic: Optional[str] = None,
        description: Optional[str] = None
    ) -> Dict[str, Any]:
        """Book a counseling session as a student"""
        try:
            # Verify counselor exists
            counselor = self.db.table('users').select('id, active_role, available_roles').eq(
                'id', counselor_id
            ).single().execute()

            if not counselor.data:
                raise Exception("Counselor not found")

            # Check if slot is available
            start_dt = datetime.fromisoformat(scheduled_start.replace('Z', '+00:00'))
            end_dt = start_dt + timedelta(minutes=30)  # Default 30 min sessions

            conflicts = self.db.table('counseling_sessions').select('id').eq(
                'counselor_id', counselor_id
            ).eq('scheduled_date', scheduled_start[:10]).in_(
                'status', [SessionStatus.SCHEDULED.value, SessionStatus.IN_PROGRESS.value]
            ).execute()

            # Check for time overlap
            if conflicts.data:
                for conflict in conflicts.data:
                    raise Exception("This time slot is no longer available")

            # Create session
            session = {
                "id": str(uuid4()),
                "counselor_id": counselor_id,
                "student_id": student_id,
                "type": session_type,
                "status": SessionStatus.SCHEDULED.value,
                "scheduled_date": scheduled_start,
                "duration_minutes": 30,
                "notes": topic or "",
                "summary": description or "",
                "created_at": datetime.utcnow().isoformat(),
                "updated_at": datetime.utcnow().isoformat(),
            }

            response = self.db.table('counseling_sessions').insert(session).execute()

            if not response.data:
                raise Exception("Failed to book session")

            logger.info(f"Session booked by student: {response.data[0]['id']}")

            return response.data[0]

        except Exception as e:
            logger.error(f"Book session as student error: {e}")
            raise Exception(f"Failed to book session: {str(e)}")

    # ==================== PARENT ACCESS METHODS ====================

    async def get_child_counselor(self, child_id: str, parent_id: str) -> Optional[Dict[str, Any]]:
        """Get child's assigned counselor (for parent viewing)"""
        try:
            # Verify parent-child relationship
            relationship = self.db.table('parent_child_links').select('id').eq(
                'parent_id', parent_id
            ).eq('child_id', child_id).eq('status', 'active').single().execute()

            if not relationship.data:
                raise Exception("Not authorized to view this child's information")

            # Get the child's counselor
            return await self.get_student_counselor(child_id)

        except Exception as e:
            logger.error(f"Get child counselor error: {e}")
            raise Exception(f"Failed to get child's counselor: {str(e)}")

    async def get_child_sessions(
        self,
        child_id: str,
        parent_id: str,
        page: int = 1,
        page_size: int = 20,
        status_filter: Optional[str] = None
    ) -> Dict[str, Any]:
        """Get child's counseling sessions (for parent viewing)"""
        try:
            # Verify parent-child relationship
            relationship = self.db.table('parent_child_links').select('id').eq(
                'parent_id', parent_id
            ).eq('child_id', child_id).eq('status', 'active').single().execute()

            if not relationship.data:
                raise Exception("Not authorized to view this child's sessions")

            # Get sessions
            query = self.db.table('counseling_sessions').select('*').eq('student_id', child_id)

            if status_filter:
                query = query.eq('status', status_filter)

            offset = (page - 1) * page_size
            query = query.order('scheduled_date', desc=True).range(offset, offset + page_size - 1)

            response = query.execute()

            sessions = []
            if response.data:
                for s in response.data:
                    # Get counselor info
                    counselor = self.db.table('users').select('display_name, email').eq(
                        'id', s.get('counselor_id')
                    ).single().execute()

                    counselor_name = "Unknown"
                    if counselor.data:
                        counselor_name = counselor.data.get('display_name', counselor.data.get('email', 'Unknown'))

                    sessions.append({
                        "id": s.get('id'),
                        "counselor_id": s.get('counselor_id'),
                        "counselor_name": counselor_name,
                        "type": s.get('type', 'general'),
                        "status": s.get('status'),
                        "scheduled_date": s.get('scheduled_date'),
                        "duration_minutes": s.get('duration_minutes', 30),
                        "notes": s.get('notes'),  # Shared notes only
                        "created_at": s.get('created_at')
                    })

            total = len(response.data) if response.data else 0

            return {
                "sessions": sessions,
                "total": total,
                "page": page,
                "page_size": page_size,
                "has_more": (offset + page_size) < total
            }

        except Exception as e:
            logger.error(f"Get child sessions error: {e}")
            raise Exception(f"Failed to get child's sessions: {str(e)}")

    # ==================== INSTITUTION ACCESS METHODS ====================

    async def list_institution_counselors(
        self,
        institution_id: str,
        page: int = 1,
        page_size: int = 20,
        search: Optional[str] = None
    ) -> Dict[str, Any]:
        """List all counselors in an institution"""
        try:
            # Get all users with counselor role (institution_id column may not exist)
            response = self.db.table('users').select(
                'id, email, display_name, created_at, active_role, available_roles'
            ).execute()

            counselors = []
            if response.data:
                for user in response.data:
                    # Check if user is a counselor
                    active_role = user.get('active_role', '')
                    available_roles = user.get('available_roles', []) or []

                    is_counselor = active_role == 'counselor' or 'counselor' in available_roles

                    if not is_counselor:
                        continue

                    # Apply search filter
                    if search:
                        search_lower = search.lower()
                        name = (user.get('display_name') or '').lower()
                        email = (user.get('email') or '').lower()
                        if search_lower not in name and search_lower not in email:
                            continue

                    # Get counselor stats (handle missing table gracefully)
                    total_sessions = 0
                    completed = 0
                    avg_rating = None
                    try:
                        sessions = self.db.table('counseling_sessions').select('id, status, feedback_rating').eq(
                            'counselor_id', user['id']
                        ).execute()

                        session_data = sessions.data or []
                        total_sessions = len(session_data)
                        completed = len([s for s in session_data if s.get('status') == SessionStatus.COMPLETED.value])
                        ratings = [s.get('feedback_rating') for s in session_data if s.get('feedback_rating')]
                        avg_rating = sum(ratings) / len(ratings) if ratings else None
                    except Exception:
                        # Table might not exist yet
                        pass

                    # Get assigned students count (handle missing table gracefully)
                    student_count = 0
                    try:
                        students = self.db.table('student_counselor_assignments').select('id').eq(
                            'counselor_id', user['id']
                        ).eq('is_active', True).execute()
                        student_count = len(students.data) if students.data else 0
                    except Exception:
                        # Table might not exist yet
                        student_count = 0

                    counselors.append({
                        "id": user.get('id'),
                        "name": user.get('display_name', user.get('email', 'Unknown')),
                        "email": user.get('email', ''),
                        "created_at": user.get('created_at'),
                        "total_sessions": total_sessions,
                        "completed_sessions": completed,
                        "average_rating": avg_rating,
                        "assigned_students": student_count
                    })

            # Calculate pagination
            total = len(counselors)
            offset = (page - 1) * page_size
            paginated_counselors = counselors[offset:offset + page_size]

            return {
                "counselors": paginated_counselors,
                "total": total,
                "page": page,
                "page_size": page_size,
                "total_pages": (total + page_size - 1) // page_size if total > 0 else 0
            }

        except Exception as e:
            logger.error(f"List institution counselors error: {e}")
            raise Exception(f"Failed to list counselors: {str(e)}")

    async def assign_counselor_to_student(
        self,
        counselor_id: str,
        student_id: str,
        assigned_by: str
    ) -> Dict[str, Any]:
        """Assign a counselor to a student"""
        try:
            # Verify counselor exists and has counselor role
            counselor = self.db.table('users').select('id, active_role, available_roles').eq(
                'id', counselor_id
            ).single().execute()

            if not counselor.data:
                raise Exception("Counselor not found")

            active_role = counselor.data.get('active_role', '')
            available_roles = counselor.data.get('available_roles', []) or []
            if active_role != 'counselor' and 'counselor' not in available_roles:
                raise Exception("User is not a counselor")

            # Verify student exists
            student = self.db.table('users').select('id').eq('id', student_id).single().execute()
            if not student.data:
                raise Exception("Student not found")

            # Deactivate any existing assignment
            self.db.table('student_counselor_assignments').update({
                'is_active': False,
                'updated_at': datetime.utcnow().isoformat()
            }).eq('student_id', student_id).eq('is_active', True).execute()

            # Create new assignment
            assignment = {
                "id": str(uuid4()),
                "student_id": student_id,
                "counselor_id": counselor_id,
                "assigned_by": assigned_by,
                "assigned_at": datetime.utcnow().isoformat(),
                "is_active": True,
                "created_at": datetime.utcnow().isoformat(),
                "updated_at": datetime.utcnow().isoformat()
            }

            response = self.db.table('student_counselor_assignments').insert(assignment).execute()

            if not response.data:
                raise Exception("Failed to create assignment")

            logger.info(f"Counselor {counselor_id} assigned to student {student_id}")

            return response.data[0]

        except Exception as e:
            logger.error(f"Assign counselor error: {e}")
            raise Exception(f"Failed to assign counselor: {str(e)}")

    async def get_institution_counseling_stats(self, institution_id: str) -> Dict[str, Any]:
        """Get institution-wide counseling statistics"""
        try:
            # Get all counselors in institution
            counselors_response = await self.list_institution_counselors(institution_id, page_size=1000)
            counselors = counselors_response.get('counselors', [])
            counselor_ids = [c['id'] for c in counselors]

            if not counselor_ids:
                return {
                    "total_counselors": 0,
                    "total_students_assigned": 0,
                    "total_sessions": 0,
                    "completed_sessions": 0,
                    "upcoming_sessions": 0,
                    "average_rating": None,
                    "sessions_by_type": {},
                    "sessions_by_month": []
                }

            # Get all sessions for these counselors
            all_sessions = []
            for counselor_id in counselor_ids:
                sessions = self.db.table('counseling_sessions').select('*').eq(
                    'counselor_id', counselor_id
                ).execute()
                if sessions.data:
                    all_sessions.extend(sessions.data)

            total_sessions = len(all_sessions)
            completed = len([s for s in all_sessions if s.get('status') == SessionStatus.COMPLETED.value])
            upcoming = len([s for s in all_sessions if s.get('status') == SessionStatus.SCHEDULED.value])

            # Average rating
            ratings = [s.get('feedback_rating') for s in all_sessions if s.get('feedback_rating')]
            avg_rating = sum(ratings) / len(ratings) if ratings else None

            # Sessions by type
            by_type = {}
            for s in all_sessions:
                stype = s.get('type', 'general')
                by_type[stype] = by_type.get(stype, 0) + 1

            # Total students assigned
            total_students = sum(c.get('assigned_students', 0) for c in counselors)

            return {
                "total_counselors": len(counselors),
                "total_students_assigned": total_students,
                "total_sessions": total_sessions,
                "completed_sessions": completed,
                "upcoming_sessions": upcoming,
                "average_rating": avg_rating,
                "sessions_by_type": by_type,
                "counselor_performance": [
                    {
                        "id": c['id'],
                        "name": c['name'],
                        "sessions": c['total_sessions'],
                        "rating": c['average_rating'],
                        "students": c['assigned_students']
                    }
                    for c in counselors[:10]  # Top 10
                ]
            }

        except Exception as e:
            logger.error(f"Get institution stats error: {e}")
            raise Exception(f"Failed to get institution statistics: {str(e)}")
