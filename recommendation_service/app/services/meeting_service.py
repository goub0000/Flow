"""
Meeting Service - Parent-Teacher/Counselor Meeting Management
Handles meeting requests, approvals, scheduling, and availability management
"""
from typing import Optional, Dict, Any, List
from datetime import datetime, timedelta, time
import logging
from uuid import uuid4

from app.database.config import get_supabase
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
from app.utils.activity_logger import log_activity, ActivityType

logger = logging.getLogger(__name__)


class MeetingService:
    """
    Service for managing parent-teacher/counselor meetings
    """

    def __init__(self):
        self.db = get_supabase()

    # ==================== Meeting Request & Management ====================

    async def request_meeting(
        self,
        parent_id: str,
        meeting_data: MeetingRequest
    ) -> Dict[str, Any]:
        """
        Create a new meeting request from parent
        """
        try:
            # Validate that parent has permission for the student
            # In production, add logic to verify parent-student relationship

            # Create meeting record
            meeting_record = {
                "id": str(uuid4()),
                "parent_id": parent_id,
                "student_id": meeting_data.student_id,
                "staff_id": meeting_data.staff_id,
                "staff_type": meeting_data.staff_type,
                "meeting_type": meeting_data.meeting_type,
                "status": "pending",
                "scheduled_date": meeting_data.scheduled_date.isoformat() if meeting_data.scheduled_date else None,
                "duration_minutes": meeting_data.duration_minutes,
                "meeting_mode": meeting_data.meeting_mode,
                "meeting_link": meeting_data.meeting_link,
                "location": meeting_data.location,
                "subject": meeting_data.subject,
                "notes": meeting_data.notes,
                "parent_notes": meeting_data.parent_notes,
                "created_at": datetime.utcnow().isoformat(),
                "updated_at": datetime.utcnow().isoformat()
            }

            response = self.db.table('meetings').insert(meeting_record).execute()

            if not response.data:
                raise Exception("Failed to create meeting request")

            meeting = response.data[0]

            # Get user names for logging
            parent_info = await self._get_user_info(parent_id)
            staff_info = await self._get_user_info(meeting_data.staff_id)
            student_info = await self._get_user_info(meeting_data.student_id)

            # Log activity
            await log_activity(
                action_type=ActivityType.MEETING_REQUESTED,
                description=f"Meeting requested by {parent_info.get('display_name', 'Unknown')} with {staff_info.get('display_name', 'Unknown')} for {student_info.get('display_name', 'Unknown')}",
                user_id=parent_id,
                user_name=parent_info.get('display_name'),
                user_email=parent_info.get('email'),
                user_role=parent_info.get('active_role'),
                metadata={
                    "meeting_id": meeting['id'],
                    "staff_id": meeting_data.staff_id,
                    "student_id": meeting_data.student_id,
                    "meeting_type": meeting_data.meeting_type,
                    "subject": meeting_data.subject
                }
            )

            logger.info(f"Meeting requested: {meeting['id']}")

            # Enrich response with user names
            return await self._enrich_meeting_response(meeting)

        except Exception as e:
            logger.error(f"Error requesting meeting: {e}")
            raise Exception(f"Failed to request meeting: {str(e)}")

    async def approve_meeting(
        self,
        meeting_id: str,
        staff_id: str,
        approval_data: MeetingApproval
    ) -> Dict[str, Any]:
        """
        Approve a meeting request and set scheduled time
        """
        try:
            # Get meeting to verify ownership
            meeting_response = self.db.table('meetings').select('*').eq('id', meeting_id).execute()

            if not meeting_response.data:
                raise Exception("Meeting not found")

            meeting = meeting_response.data[0]

            # Verify staff is the one assigned to this meeting
            if meeting['staff_id'] != staff_id:
                raise Exception("You are not authorized to approve this meeting")

            # Verify meeting is in pending status
            if meeting['status'] != 'pending':
                raise Exception(f"Meeting cannot be approved. Current status: {meeting['status']}")

            # Check for conflicts
            has_conflict = await self._check_scheduling_conflict(
                staff_id,
                approval_data.scheduled_date,
                approval_data.duration_minutes,
                exclude_meeting_id=meeting_id
            )

            if has_conflict:
                raise Exception("This time slot conflicts with another meeting")

            # Update meeting
            update_data = {
                "status": "approved",
                "scheduled_date": approval_data.scheduled_date.isoformat(),
                "duration_minutes": approval_data.duration_minutes,
                "meeting_link": approval_data.meeting_link,
                "location": approval_data.location,
                "staff_notes": approval_data.staff_notes,
                "updated_at": datetime.utcnow().isoformat()
            }

            response = self.db.table('meetings').update(update_data).eq('id', meeting_id).execute()

            if not response.data:
                raise Exception("Failed to approve meeting")

            updated_meeting = response.data[0]

            # Get user info for logging
            staff_info = await self._get_user_info(staff_id)
            parent_info = await self._get_user_info(meeting['parent_id'])

            # Log activity
            await log_activity(
                action_type=ActivityType.MEETING_APPROVED,
                description=f"Meeting approved by {staff_info.get('display_name', 'Unknown')} for {approval_data.scheduled_date.strftime('%Y-%m-%d %H:%M')}",
                user_id=staff_id,
                user_name=staff_info.get('display_name'),
                user_email=staff_info.get('email'),
                user_role=staff_info.get('active_role'),
                metadata={
                    "meeting_id": meeting_id,
                    "parent_id": meeting['parent_id'],
                    "scheduled_date": approval_data.scheduled_date.isoformat(),
                    "duration_minutes": approval_data.duration_minutes
                }
            )

            logger.info(f"Meeting approved: {meeting_id}")

            return await self._enrich_meeting_response(updated_meeting)

        except Exception as e:
            logger.error(f"Error approving meeting: {e}")
            raise Exception(f"Failed to approve meeting: {str(e)}")

    async def decline_meeting(
        self,
        meeting_id: str,
        staff_id: str,
        decline_data: MeetingDecline
    ) -> Dict[str, Any]:
        """
        Decline a meeting request
        """
        try:
            # Get meeting to verify ownership
            meeting_response = self.db.table('meetings').select('*').eq('id', meeting_id).execute()

            if not meeting_response.data:
                raise Exception("Meeting not found")

            meeting = meeting_response.data[0]

            # Verify staff is the one assigned to this meeting
            if meeting['staff_id'] != staff_id:
                raise Exception("You are not authorized to decline this meeting")

            # Verify meeting is in pending status
            if meeting['status'] != 'pending':
                raise Exception(f"Meeting cannot be declined. Current status: {meeting['status']}")

            # Update meeting
            update_data = {
                "status": "declined",
                "staff_notes": decline_data.staff_notes,
                "updated_at": datetime.utcnow().isoformat()
            }

            response = self.db.table('meetings').update(update_data).eq('id', meeting_id).execute()

            if not response.data:
                raise Exception("Failed to decline meeting")

            updated_meeting = response.data[0]

            # Get user info for logging
            staff_info = await self._get_user_info(staff_id)

            # Log activity
            await log_activity(
                action_type=ActivityType.MEETING_DECLINED,
                description=f"Meeting declined by {staff_info.get('display_name', 'Unknown')}",
                user_id=staff_id,
                user_name=staff_info.get('display_name'),
                user_email=staff_info.get('email'),
                user_role=staff_info.get('active_role'),
                metadata={
                    "meeting_id": meeting_id,
                    "parent_id": meeting['parent_id'],
                    "reason": decline_data.staff_notes
                }
            )

            logger.info(f"Meeting declined: {meeting_id}")

            return await self._enrich_meeting_response(updated_meeting)

        except Exception as e:
            logger.error(f"Error declining meeting: {e}")
            raise Exception(f"Failed to decline meeting: {str(e)}")

    async def cancel_meeting(
        self,
        meeting_id: str,
        user_id: str,
        cancellation_reason: Optional[str] = None
    ) -> Dict[str, Any]:
        """
        Cancel a meeting (by parent or staff)
        """
        try:
            # Get meeting
            meeting_response = self.db.table('meetings').select('*').eq('id', meeting_id).execute()

            if not meeting_response.data:
                raise Exception("Meeting not found")

            meeting = meeting_response.data[0]

            # Verify user has permission (parent or staff)
            if meeting['parent_id'] != user_id and meeting['staff_id'] != user_id:
                raise Exception("You are not authorized to cancel this meeting")

            # Verify meeting can be cancelled
            if meeting['status'] in ['cancelled', 'completed']:
                raise Exception(f"Meeting cannot be cancelled. Current status: {meeting['status']}")

            # Update meeting
            update_data = {
                "status": "cancelled",
                "updated_at": datetime.utcnow().isoformat()
            }

            # Add cancellation reason to appropriate notes field
            if cancellation_reason:
                if meeting['parent_id'] == user_id:
                    update_data['parent_notes'] = f"{meeting.get('parent_notes', '')}\\n[Cancellation: {cancellation_reason}]".strip()
                else:
                    update_data['staff_notes'] = f"{meeting.get('staff_notes', '')}\\n[Cancellation: {cancellation_reason}]".strip()

            response = self.db.table('meetings').update(update_data).eq('id', meeting_id).execute()

            if not response.data:
                raise Exception("Failed to cancel meeting")

            updated_meeting = response.data[0]

            # Get user info for logging
            user_info = await self._get_user_info(user_id)

            # Log activity
            await log_activity(
                action_type=ActivityType.MEETING_CANCELLED,
                description=f"Meeting cancelled by {user_info.get('display_name', 'Unknown')}",
                user_id=user_id,
                user_name=user_info.get('display_name'),
                user_email=user_info.get('email'),
                user_role=user_info.get('active_role'),
                metadata={
                    "meeting_id": meeting_id,
                    "cancelled_by": "parent" if meeting['parent_id'] == user_id else "staff",
                    "reason": cancellation_reason
                }
            )

            logger.info(f"Meeting cancelled: {meeting_id}")

            return await self._enrich_meeting_response(updated_meeting)

        except Exception as e:
            logger.error(f"Error cancelling meeting: {e}")
            raise Exception(f"Failed to cancel meeting: {str(e)}")

    async def get_meeting(self, meeting_id: str, user_id: str) -> Dict[str, Any]:
        """
        Get meeting details
        """
        try:
            meeting_response = self.db.table('meetings').select('*').eq('id', meeting_id).execute()

            if not meeting_response.data:
                raise Exception("Meeting not found")

            meeting = meeting_response.data[0]

            # Verify user has permission to view
            if meeting['parent_id'] != user_id and meeting['staff_id'] != user_id:
                # Check if admin
                user_info = await self._get_user_info(user_id)
                if user_info.get('active_role') != 'admin':
                    raise Exception("You are not authorized to view this meeting")

            return await self._enrich_meeting_response(meeting)

        except Exception as e:
            logger.error(f"Error getting meeting: {e}")
            raise Exception(f"Failed to get meeting: {str(e)}")

    async def get_parent_meetings(
        self,
        parent_id: str,
        status: Optional[str] = None,
        limit: int = 50,
        offset: int = 0
    ) -> List[Dict[str, Any]]:
        """
        Get all meetings for a parent
        """
        try:
            query = self.db.table('meetings').select('*').eq('parent_id', parent_id)

            if status:
                query = query.eq('status', status)

            query = query.order('created_at', desc=True).range(offset, offset + limit - 1)

            response = query.execute()

            if not response.data:
                return []

            # Enrich all meetings
            enriched_meetings = []
            for meeting in response.data:
                enriched = await self._enrich_meeting_response(meeting)
                enriched_meetings.append(enriched)

            return enriched_meetings

        except Exception as e:
            logger.error(f"Error getting parent meetings: {e}")
            raise Exception(f"Failed to get parent meetings: {str(e)}")

    async def get_staff_meetings(
        self,
        staff_id: str,
        status: Optional[str] = None,
        limit: int = 50,
        offset: int = 0
    ) -> List[Dict[str, Any]]:
        """
        Get all meetings for a staff member (teacher/counselor)
        """
        try:
            query = self.db.table('meetings').select('*').eq('staff_id', staff_id)

            if status:
                query = query.eq('status', status)

            query = query.order('created_at', desc=True).range(offset, offset + limit - 1)

            response = query.execute()

            if not response.data:
                return []

            # Enrich all meetings
            enriched_meetings = []
            for meeting in response.data:
                enriched = await self._enrich_meeting_response(meeting)
                enriched_meetings.append(enriched)

            return enriched_meetings

        except Exception as e:
            logger.error(f"Error getting staff meetings: {e}")
            raise Exception(f"Failed to get staff meetings: {str(e)}")

    # ==================== Availability Management ====================

    async def set_availability(
        self,
        staff_id: str,
        availability_data: StaffAvailabilityCreate
    ) -> Dict[str, Any]:
        """
        Set availability for a staff member
        """
        try:
            # Check if availability already exists for this day
            existing = self.db.table('staff_availability').select('*').eq(
                'staff_id', staff_id
            ).eq('day_of_week', availability_data.day_of_week).execute()

            if existing.data:
                raise Exception(f"Availability already set for this day. Use update instead.")

            # Create availability record
            availability_record = {
                "id": str(uuid4()),
                "staff_id": staff_id,
                "day_of_week": availability_data.day_of_week,
                "start_time": availability_data.start_time.isoformat(),
                "end_time": availability_data.end_time.isoformat(),
                "is_active": True,
                "created_at": datetime.utcnow().isoformat(),
                "updated_at": datetime.utcnow().isoformat()
            }

            response = self.db.table('staff_availability').insert(availability_record).execute()

            if not response.data:
                raise Exception("Failed to set availability")

            logger.info(f"Availability set for staff {staff_id}")

            return self._format_availability_response(response.data[0])

        except Exception as e:
            logger.error(f"Error setting availability: {e}")
            raise Exception(f"Failed to set availability: {str(e)}")

    async def update_availability(
        self,
        availability_id: str,
        staff_id: str,
        availability_data: StaffAvailabilityUpdate
    ) -> Dict[str, Any]:
        """
        Update staff availability
        """
        try:
            # Verify ownership
            existing = self.db.table('staff_availability').select('*').eq('id', availability_id).execute()

            if not existing.data:
                raise Exception("Availability not found")

            if existing.data[0]['staff_id'] != staff_id:
                raise Exception("You are not authorized to update this availability")

            # Build update dict
            update_data = {"updated_at": datetime.utcnow().isoformat()}

            if availability_data.start_time is not None:
                update_data['start_time'] = availability_data.start_time.isoformat()

            if availability_data.end_time is not None:
                update_data['end_time'] = availability_data.end_time.isoformat()

            if availability_data.is_active is not None:
                update_data['is_active'] = availability_data.is_active

            response = self.db.table('staff_availability').update(update_data).eq('id', availability_id).execute()

            if not response.data:
                raise Exception("Failed to update availability")

            logger.info(f"Availability updated: {availability_id}")

            return self._format_availability_response(response.data[0])

        except Exception as e:
            logger.error(f"Error updating availability: {e}")
            raise Exception(f"Failed to update availability: {str(e)}")

    async def delete_availability(
        self,
        availability_id: str,
        staff_id: str
    ) -> Dict[str, str]:
        """
        Delete staff availability
        """
        try:
            # Verify ownership
            existing = self.db.table('staff_availability').select('*').eq('id', availability_id).execute()

            if not existing.data:
                raise Exception("Availability not found")

            if existing.data[0]['staff_id'] != staff_id:
                raise Exception("You are not authorized to delete this availability")

            self.db.table('staff_availability').delete().eq('id', availability_id).execute()

            logger.info(f"Availability deleted: {availability_id}")

            return {"message": "Availability deleted successfully"}

        except Exception as e:
            logger.error(f"Error deleting availability: {e}")
            raise Exception(f"Failed to delete availability: {str(e)}")

    async def get_staff_availability(self, staff_id: str) -> List[Dict[str, Any]]:
        """
        Get all availability slots for a staff member
        """
        try:
            response = self.db.table('staff_availability').select('*').eq(
                'staff_id', staff_id
            ).eq('is_active', True).order('day_of_week').execute()

            if not response.data:
                return []

            return [self._format_availability_response(avail) for avail in response.data]

        except Exception as e:
            logger.error(f"Error getting staff availability: {e}")
            raise Exception(f"Failed to get staff availability: {str(e)}")

    async def get_available_slots(
        self,
        request_data: AvailableSlotsRequest
    ) -> List[AvailableSlot]:
        """
        Get available time slots for a staff member within date range
        """
        try:
            # Get staff availability
            availability_response = self.db.table('staff_availability').select('*').eq(
                'staff_id', request_data.staff_id
            ).eq('is_active', True).execute()

            if not availability_response.data:
                return []

            # Get existing meetings in the date range
            existing_meetings = self.db.table('meetings').select('scheduled_date, duration_minutes').eq(
                'staff_id', request_data.staff_id
            ).in_('status', ['pending', 'approved']).gte(
                'scheduled_date', request_data.start_date.isoformat()
            ).lte(
                'scheduled_date', request_data.end_date.isoformat()
            ).execute()

            # Generate available slots
            available_slots = []
            current_date = request_data.start_date.date()
            end_date = request_data.end_date.date()

            while current_date <= end_date:
                day_of_week = (current_date.weekday() + 1) % 7  # Convert to 0=Sunday

                # Find availability for this day
                day_availability = [
                    a for a in availability_response.data
                    if a['day_of_week'] == day_of_week
                ]

                for avail in day_availability:
                    # Parse times
                    start_time = datetime.fromisoformat(avail['start_time']).time()
                    end_time = datetime.fromisoformat(avail['end_time']).time()

                    # Generate slots for this availability window
                    slots = self._generate_time_slots(
                        current_date,
                        start_time,
                        end_time,
                        request_data.duration_minutes
                    )

                    # Filter out booked slots
                    for slot in slots:
                        if not self._is_slot_booked(slot['start_time'], slot['end_time'], existing_meetings.data):
                            available_slots.append(AvailableSlot(
                                date=slot['start_time'],
                                start_time=slot['start_time'],
                                end_time=slot['end_time'],
                                day_of_week=day_of_week,
                                day_name=slot['day_name']
                            ))

                current_date += timedelta(days=1)

            return available_slots

        except Exception as e:
            logger.error(f"Error getting available slots: {e}")
            raise Exception(f"Failed to get available slots: {str(e)}")

    # ==================== Staff List ====================

    async def get_staff_list(
        self,
        role: Optional[str] = None
    ) -> List[StaffListItem]:
        """
        Get list of available teachers and counselors
        """
        try:
            # Query users table - only select columns that exist
            query = self.db.table('users').select('id, display_name, email, active_role')

            if role:
                if role not in ['teacher', 'counselor']:
                    raise ValueError("Role must be 'teacher' or 'counselor'")
                query = query.eq('active_role', role)
            else:
                query = query.in_('active_role', ['teacher', 'counselor'])

            # Order by display_name (removed is_active filter as column doesn't exist)
            query = query.order('display_name')

            response = query.execute()

            if not response.data:
                return []

            # Map to StaffListItem with default values for optional fields
            staff_list = []
            for staff in response.data:
                staff_list.append(StaffListItem(
                    id=staff['id'],
                    display_name=staff.get('display_name', 'Unknown'),
                    email=staff.get('email', ''),
                    active_role=staff.get('active_role', 'teacher'),
                    photo_url=None,
                    bio=None
                ))
            return staff_list

        except Exception as e:
            logger.error(f"Error getting staff list: {e}")
            raise Exception(f"Failed to get staff list: {str(e)}")

    # ==================== Statistics ====================

    async def get_meeting_statistics(
        self,
        user_id: str,
        user_role: str
    ) -> MeetingStatistics:
        """
        Get meeting statistics for a user
        """
        try:
            # Determine filter based on role
            if user_role == 'parent':
                query = self.db.table('meetings').select('*').eq('parent_id', user_id)
            elif user_role in ['teacher', 'counselor']:
                query = self.db.table('meetings').select('*').eq('staff_id', user_id)
            else:
                # Admin gets all
                query = self.db.table('meetings').select('*')

            response = query.execute()

            if not response.data:
                return MeetingStatistics(
                    total_meetings=0,
                    pending_meetings=0,
                    approved_meetings=0,
                    declined_meetings=0,
                    cancelled_meetings=0,
                    completed_meetings=0,
                    upcoming_meetings=0,
                    meetings_by_type={},
                    meetings_by_mode={}
                )

            meetings = response.data
            now = datetime.utcnow()

            # Calculate statistics
            stats = {
                'total_meetings': len(meetings),
                'pending_meetings': len([m for m in meetings if m['status'] == 'pending']),
                'approved_meetings': len([m for m in meetings if m['status'] == 'approved']),
                'declined_meetings': len([m for m in meetings if m['status'] == 'declined']),
                'cancelled_meetings': len([m for m in meetings if m['status'] == 'cancelled']),
                'completed_meetings': len([m for m in meetings if m['status'] == 'completed']),
                'upcoming_meetings': len([
                    m for m in meetings
                    if m['status'] == 'approved' and m['scheduled_date'] and
                    datetime.fromisoformat(m['scheduled_date']) > now
                ]),
                'meetings_by_type': {},
                'meetings_by_mode': {}
            }

            # Count by type
            for meeting in meetings:
                meeting_type = meeting.get('meeting_type', 'unknown')
                stats['meetings_by_type'][meeting_type] = stats['meetings_by_type'].get(meeting_type, 0) + 1

                meeting_mode = meeting.get('meeting_mode', 'unknown')
                stats['meetings_by_mode'][meeting_mode] = stats['meetings_by_mode'].get(meeting_mode, 0) + 1

            return MeetingStatistics(**stats)

        except Exception as e:
            logger.error(f"Error getting meeting statistics: {e}")
            raise Exception(f"Failed to get meeting statistics: {str(e)}")

    # ==================== Helper Methods ====================

    async def _get_user_info(self, user_id: str) -> Dict[str, Any]:
        """Get user information"""
        try:
            response = self.db.table('users').select('id, display_name, email, active_role, photo_url').eq('id', user_id).single().execute()
            return response.data if response.data else {}
        except:
            return {}

    async def _enrich_meeting_response(self, meeting: Dict[str, Any]) -> Dict[str, Any]:
        """Enrich meeting with user names"""
        parent_info = await self._get_user_info(meeting['parent_id'])
        student_info = await self._get_user_info(meeting['student_id'])
        staff_info = await self._get_user_info(meeting['staff_id'])

        return {
            **meeting,
            'parent_name': parent_info.get('display_name'),
            'student_name': student_info.get('display_name'),
            'staff_name': staff_info.get('display_name')
        }

    def _format_availability_response(self, availability: Dict[str, Any]) -> Dict[str, Any]:
        """Format availability response with day name"""
        day_names = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']

        return {
            **availability,
            'day_name': day_names[availability['day_of_week']]
        }

    async def _check_scheduling_conflict(
        self,
        staff_id: str,
        scheduled_date: datetime,
        duration_minutes: int,
        exclude_meeting_id: Optional[str] = None
    ) -> bool:
        """Check if there's a scheduling conflict"""
        try:
            end_time = scheduled_date + timedelta(minutes=duration_minutes)
            buffer_time = timedelta(minutes=15)  # 15-minute buffer

            # Get meetings around this time
            query = self.db.table('meetings').select('id, scheduled_date, duration_minutes').eq(
                'staff_id', staff_id
            ).in_('status', ['pending', 'approved'])

            if exclude_meeting_id:
                query = query.neq('id', exclude_meeting_id)

            response = query.execute()

            if not response.data:
                return False

            # Check for overlaps
            for meeting in response.data:
                if not meeting['scheduled_date']:
                    continue

                meeting_start = datetime.fromisoformat(meeting['scheduled_date'])
                meeting_end = meeting_start + timedelta(minutes=meeting['duration_minutes'])

                # Check overlap with buffer
                if (scheduled_date - buffer_time < meeting_end and
                    end_time + buffer_time > meeting_start):
                    return True

            return False

        except Exception as e:
            logger.error(f"Error checking scheduling conflict: {e}")
            return True  # Assume conflict on error to be safe

    def _generate_time_slots(
        self,
        date: datetime.date,
        start_time: time,
        end_time: time,
        duration_minutes: int
    ) -> List[Dict[str, Any]]:
        """Generate time slots for a given day and time range"""
        slots = []
        day_names = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']

        current_datetime = datetime.combine(date, start_time)
        end_datetime = datetime.combine(date, end_time)

        while current_datetime + timedelta(minutes=duration_minutes) <= end_datetime:
            slot_end = current_datetime + timedelta(minutes=duration_minutes)

            slots.append({
                'start_time': current_datetime,
                'end_time': slot_end,
                'day_name': day_names[date.weekday()]
            })

            # Move to next slot (add small buffer)
            current_datetime = slot_end + timedelta(minutes=15)

        return slots

    def _is_slot_booked(
        self,
        start_time: datetime,
        end_time: datetime,
        existing_meetings: List[Dict[str, Any]]
    ) -> bool:
        """Check if a time slot is already booked"""
        for meeting in existing_meetings:
            if not meeting.get('scheduled_date'):
                continue

            meeting_start = datetime.fromisoformat(meeting['scheduled_date'])
            meeting_end = meeting_start + timedelta(minutes=meeting.get('duration_minutes', 30))

            # Check for overlap
            if start_time < meeting_end and end_time > meeting_start:
                return True

        return False
