"""
Recommendation Letters Service
Business logic for letter of recommendation management
"""
import logging
import secrets
from typing import List, Optional, Dict, Any
from datetime import datetime, date, timedelta
from uuid import uuid4

from supabase import Client

from app.schemas.recommendation_letters import (
    RecommendationRequestCreate,
    RecommendationRequestUpdate,
    RecommendationRequestResponse,
    RecommendationRequestWithDetails,
    LetterOfRecommendationCreate,
    LetterOfRecommendationUpdate,
    LetterOfRecommendationResponse,
    LetterOfRecommendationWithRequest,
    RecommendationTemplateCreate,
    RecommendationTemplateUpdate,
    RecommendationTemplateResponse,
    RecommenderDashboardSummary,
    StudentRequestsSummary,
    LetterStatistics,
    TemplateRenderResponse,
    RequestAcceptanceAction,
    RequestDeclineAction,
    RequestStatus,
    LetterStatus,
    ReminderType
)

logger = logging.getLogger(__name__)


class RecommendationLettersService:
    """Service for managing recommendation letters and requests"""

    def __init__(self, db: Client):
        self.db = db

    # ==================== Request Management ====================

    async def create_request(
        self,
        request_data: RecommendationRequestCreate
    ) -> RecommendationRequestResponse:
        """
        Create a new recommendation request

        Args:
            request_data: Request creation data

        Returns:
            Created recommendation request
        """
        try:
            # Validate deadline is in the future
            if request_data.deadline < date.today():
                raise ValueError("Deadline must be in the future")

            # Create request
            request_dict = {
                'id': str(uuid4()),
                'student_id': request_data.student_id,
                'recommender_id': request_data.recommender_id,
                'request_type': request_data.request_type.value,
                'purpose': request_data.purpose,
                'institution_name': request_data.institution_name,
                'deadline': request_data.deadline.isoformat(),
                'priority': request_data.priority.value,
                'student_message': request_data.student_message,
                'achievements': request_data.achievements,
                'goals': request_data.goals,
                'relationship_context': request_data.relationship_context,
                'status': 'pending',
                'requested_at': datetime.utcnow().isoformat(),
                'created_at': datetime.utcnow().isoformat(),
                'updated_at': datetime.utcnow().isoformat()
            }

            result = self.db.table('recommendation_requests').insert(request_dict).execute()

            if not result.data:
                raise Exception("Failed to create recommendation request")

            # Create automatic reminders
            await self._create_default_reminders(result.data[0]['id'], request_data.deadline)

            return RecommendationRequestResponse(**result.data[0])

        except Exception as e:
            logger.error(f"Error creating recommendation request: {e}")
            raise

    async def get_request(self, request_id: str, user_id: str) -> RecommendationRequestWithDetails:
        """Get a recommendation request with details"""
        try:
            # Get request
            result = self.db.table('recommendation_requests')\
                .select('*')\
                .eq('id', request_id)\
                .single()\
                .execute()

            if not result.data:
                raise ValueError("Request not found")

            request = result.data

            # Verify access (recommender_id may be null if they haven't registered yet)
            is_student = request['student_id'] == user_id
            is_recommender = request.get('recommender_id') and request['recommender_id'] == user_id
            if not is_student and not is_recommender:
                raise ValueError("Access denied")

            # Get student info
            student_result = self.db.table('users')\
                .select('display_name, email')\
                .eq('id', request['student_id'])\
                .single()\
                .execute()

            # Get recommender info (may be null if recommender hasn't registered yet)
            recommender_name = request.get('recommender_name')
            recommender_email = request.get('recommender_email')

            if request.get('recommender_id'):
                recommender_result = self.db.table('users')\
                    .select('display_name, email')\
                    .eq('id', request['recommender_id'])\
                    .execute()

                if recommender_result.data and len(recommender_result.data) > 0:
                    recommender_name = recommender_result.data[0].get('display_name') or recommender_name
                    recommender_email = recommender_result.data[0].get('email') or recommender_email

            # Check if letter exists
            letter_result = self.db.table('letter_of_recommendations')\
                .select('status')\
                .eq('request_id', request_id)\
                .execute()

            has_letter = len(letter_result.data or []) > 0
            letter_status = letter_result.data[0]['status'] if has_letter else None

            return RecommendationRequestWithDetails(
                **request,
                student_name=student_result.data.get('display_name') if student_result.data else None,
                student_email=student_result.data.get('email') if student_result.data else None,
                recommender_name=recommender_name,
                recommender_email=recommender_email,
                has_letter=has_letter,
                letter_status=letter_status
            )

        except Exception as e:
            logger.error(f"Error fetching request: {e}")
            raise

    async def get_student_requests(self, student_id: str) -> StudentRequestsSummary:
        """Get all requests for a student with summary"""
        try:
            # student_id should be the auth.users.id UUID
            # recommendation_requests.student_id references auth.users.id, not student_profiles.id
            # Just use the student_id directly - it's already the correct UUID

            result = self.db.table('recommendation_requests')\
                .select('*')\
                .eq('student_id', student_id)\
                .order('requested_at', desc=True)\
                .execute()

            requests = result.data or []

            # Calculate summary
            total = len(requests)
            pending = sum(1 for r in requests if r['status'] == 'pending')
            accepted = sum(1 for r in requests if r['status'] == 'accepted')
            declined = sum(1 for r in requests if r['status'] == 'declined')
            completed = sum(1 for r in requests if r['status'] == 'completed')

            # Get active requests with details
            active_requests = []
            for request in requests:
                if request['status'] in ['pending', 'accepted', 'in_progress']:
                    request_with_details = await self.get_request(request['id'], student_id)
                    active_requests.append(request_with_details)

            return StudentRequestsSummary(
                total_requests=total,
                pending=pending,
                accepted=accepted,
                declined=declined,
                completed=completed,
                active_requests=active_requests
            )

        except Exception as e:
            logger.error(f"Error fetching student requests: {e}")
            raise

    async def get_recommender_requests(self, recommender_id: str) -> RecommenderDashboardSummary:
        """Get all requests for a recommender with dashboard summary"""
        try:
            result = self.db.table('recommendation_requests')\
                .select('*')\
                .eq('recommender_id', recommender_id)\
                .order('deadline', desc=False)\
                .execute()

            requests = result.data or []

            # Calculate summary
            total = len(requests)
            pending = sum(1 for r in requests if r['status'] == 'pending')
            in_progress = sum(1 for r in requests if r['status'] == 'in_progress')
            completed = sum(1 for r in requests if r['status'] == 'completed')

            # Find overdue and urgent requests
            today = date.today()
            overdue = sum(1 for r in requests if date.fromisoformat(r['deadline']) < today and r['status'] != 'completed')
            urgent = sum(1 for r in requests if r['priority'] == 'urgent' and r['status'] != 'completed')

            # Get upcoming deadlines (next 7 days)
            upcoming_deadline = today + timedelta(days=7)
            upcoming_requests = []
            for request in requests:
                deadline = date.fromisoformat(request['deadline'])
                if today <= deadline <= upcoming_deadline and request['status'] != 'completed':
                    request_with_details = await self.get_request(request['id'], recommender_id)
                    upcoming_requests.append(request_with_details)

            return RecommenderDashboardSummary(
                total_requests=total,
                pending_requests=pending,
                in_progress=in_progress,
                completed=completed,
                overdue_requests=overdue,
                urgent_requests=urgent,
                upcoming_deadlines=upcoming_requests[:5]  # Limit to 5
            )

        except Exception as e:
            logger.error(f"Error fetching recommender requests: {e}")
            raise

    async def update_request(
        self,
        request_id: str,
        user_id: str,
        update_data: RecommendationRequestUpdate
    ) -> RecommendationRequestResponse:
        """Update a recommendation request"""
        try:
            # Verify access
            request_result = self.db.table('recommendation_requests')\
                .select('student_id, recommender_id')\
                .eq('id', request_id)\
                .single()\
                .execute()

            if not request_result.data:
                raise ValueError("Request not found")

            # Only student or recommender can update
            if request_result.data['student_id'] != user_id and request_result.data['recommender_id'] != user_id:
                raise ValueError("Access denied")

            # Build update dict
            update_dict = update_data.model_dump(exclude_unset=True)
            if update_dict:
                update_dict['updated_at'] = datetime.utcnow().isoformat()

                # Convert enums to strings
                if 'status' in update_dict:
                    update_dict['status'] = update_dict['status'].value
                if 'priority' in update_dict:
                    update_dict['priority'] = update_dict['priority'].value
                if 'deadline' in update_dict:
                    update_dict['deadline'] = update_dict['deadline'].isoformat()

                result = self.db.table('recommendation_requests')\
                    .update(update_dict)\
                    .eq('id', request_id)\
                    .execute()

                if not result.data:
                    raise Exception("Failed to update request")

                return RecommendationRequestResponse(**result.data[0])

        except Exception as e:
            logger.error(f"Error updating request: {e}")
            raise

    async def accept_request(
        self,
        request_id: str,
        recommender_id: str,
        action: RequestAcceptanceAction
    ) -> RecommendationRequestResponse:
        """Accept a recommendation request"""
        try:
            update_dict = {
                'status': RequestStatus.ACCEPTED.value,
                'accepted_at': datetime.utcnow().isoformat(),
                'updated_at': datetime.utcnow().isoformat()
            }

            result = self.db.table('recommendation_requests')\
                .update(update_dict)\
                .eq('id', request_id)\
                .eq('recommender_id', recommender_id)\
                .execute()

            if not result.data:
                raise ValueError("Request not found or access denied")

            return RecommendationRequestResponse(**result.data[0])

        except Exception as e:
            logger.error(f"Error accepting request: {e}")
            raise

    async def decline_request(
        self,
        request_id: str,
        recommender_id: str,
        action: RequestDeclineAction
    ) -> RecommendationRequestResponse:
        """Decline a recommendation request"""
        try:
            update_dict = {
                'status': RequestStatus.DECLINED.value,
                'declined_at': datetime.utcnow().isoformat(),
                'decline_reason': action.decline_reason,
                'updated_at': datetime.utcnow().isoformat()
            }

            result = self.db.table('recommendation_requests')\
                .update(update_dict)\
                .eq('id', request_id)\
                .eq('recommender_id', recommender_id)\
                .execute()

            if not result.data:
                raise ValueError("Request not found or access denied")

            return RecommendationRequestResponse(**result.data[0])

        except Exception as e:
            logger.error(f"Error declining request: {e}")
            raise

    # ==================== Letter Management ====================

    async def create_letter(
        self,
        letter_data: LetterOfRecommendationCreate,
        recommender_id: str
    ) -> LetterOfRecommendationResponse:
        """Create a new recommendation letter"""
        try:
            # Verify recommender owns the request
            request_result = self.db.table('recommendation_requests')\
                .select('recommender_id')\
                .eq('id', letter_data.request_id)\
                .single()\
                .execute()

            if not request_result.data or request_result.data['recommender_id'] != recommender_id:
                raise ValueError("Access denied")

            # Calculate word and character count
            word_count = len(letter_data.content.split())
            character_count = len(letter_data.content)

            letter_dict = {
                'id': str(uuid4()),
                'request_id': letter_data.request_id,
                'content': letter_data.content,
                'letter_type': letter_data.letter_type.value if letter_data.letter_type else 'formal',
                'word_count': word_count,
                'character_count': character_count,
                'status': 'draft',
                'is_template_based': letter_data.template_id is not None,
                'template_id': letter_data.template_id,
                'is_visible_to_student': letter_data.is_visible_to_student,
                'drafted_at': datetime.utcnow().isoformat(),
                'last_edited_at': datetime.utcnow().isoformat(),
                'created_at': datetime.utcnow().isoformat()
            }

            result = self.db.table('letter_of_recommendations').insert(letter_dict).execute()

            if not result.data:
                raise Exception("Failed to create letter")

            # Update request status to in_progress
            await self._update_request_status(letter_data.request_id, RequestStatus.IN_PROGRESS)

            return LetterOfRecommendationResponse(**result.data[0])

        except Exception as e:
            logger.error(f"Error creating letter: {e}")
            raise

    async def get_letter(self, letter_id: str, user_id: str) -> LetterOfRecommendationWithRequest:
        """Get a recommendation letter with request details"""
        try:
            result = self.db.table('letter_of_recommendations')\
                .select('*')\
                .eq('id', letter_id)\
                .single()\
                .execute()

            if not result.data:
                raise ValueError("Letter not found")

            letter = result.data

            # Get request to verify access
            request_result = self.db.table('recommendation_requests')\
                .select('*')\
                .eq('id', letter['request_id'])\
                .single()\
                .execute()

            request = request_result.data

            # Verify access
            if request['recommender_id'] != user_id:
                # Student can only view if marked visible
                if request['student_id'] != user_id or not letter['is_visible_to_student']:
                    raise ValueError("Access denied")

            return LetterOfRecommendationWithRequest(
                **letter,
                request=RecommendationRequestResponse(**request),
                student_name=request.get('student_name'),
                institution_name=request.get('institution_name')
            )

        except Exception as e:
            logger.error(f"Error fetching letter: {e}")
            raise

    async def update_letter(
        self,
        letter_id: str,
        recommender_id: str,
        update_data: LetterOfRecommendationUpdate
    ) -> LetterOfRecommendationResponse:
        """Update a recommendation letter"""
        try:
            # Verify access
            letter_result = self.db.table('letter_of_recommendations')\
                .select('request_id')\
                .eq('id', letter_id)\
                .single()\
                .execute()

            if not letter_result.data:
                raise ValueError("Letter not found")

            request_result = self.db.table('recommendation_requests')\
                .select('recommender_id')\
                .eq('id', letter_result.data['request_id'])\
                .single()\
                .execute()

            if not request_result.data or request_result.data['recommender_id'] != recommender_id:
                raise ValueError("Access denied")

            # Build update dict
            update_dict = update_data.model_dump(exclude_unset=True)
            if update_dict:
                update_dict['last_edited_at'] = datetime.utcnow().isoformat()

                # Recalculate counts if content changed
                if 'content' in update_dict:
                    update_dict['word_count'] = len(update_dict['content'].split())
                    update_dict['character_count'] = len(update_dict['content'])

                # Convert enums to strings
                if 'letter_type' in update_dict:
                    update_dict['letter_type'] = update_dict['letter_type'].value
                if 'status' in update_dict:
                    update_dict['status'] = update_dict['status'].value
                    # If submitting, set submitted_at
                    if update_dict['status'] == 'submitted':
                        update_dict['submitted_at'] = datetime.utcnow().isoformat()
                        # Update request to completed
                        await self._update_request_status(letter_result.data['request_id'], RequestStatus.COMPLETED)

                result = self.db.table('letter_of_recommendations')\
                    .update(update_dict)\
                    .eq('id', letter_id)\
                    .execute()

                if not result.data:
                    raise Exception("Failed to update letter")

                return LetterOfRecommendationResponse(**result.data[0])

        except Exception as e:
            logger.error(f"Error updating letter: {e}")
            raise

    async def submit_letter(
        self,
        letter_id: str,
        recommender_id: str
    ) -> LetterOfRecommendationResponse:
        """Submit a letter (mark as complete)"""
        try:
            update_data = LetterOfRecommendationUpdate(status=LetterStatus.SUBMITTED)
            return await self.update_letter(letter_id, recommender_id, update_data)

        except Exception as e:
            logger.error(f"Error submitting letter: {e}")
            raise

    async def generate_share_link(self, letter_id: str, recommender_id: str) -> str:
        """Generate a shareable link for a letter"""
        try:
            # Verify access
            letter_result = self.db.table('letter_of_recommendations')\
                .select('request_id')\
                .eq('id', letter_id)\
                .single()\
                .execute()

            if not letter_result.data:
                raise ValueError("Letter not found")

            request_result = self.db.table('recommendation_requests')\
                .select('recommender_id')\
                .eq('id', letter_result.data['request_id'])\
                .single()\
                .execute()

            if not request_result.data or request_result.data['recommender_id'] != recommender_id:
                raise ValueError("Access denied")

            # Generate unique token
            share_token = secrets.token_urlsafe(32)

            # Update letter with share token
            self.db.table('letter_of_recommendations')\
                .update({'share_token': share_token})\
                .eq('id', letter_id)\
                .execute()

            return share_token

        except Exception as e:
            logger.error(f"Error generating share link: {e}")
            raise

    # ==================== Template Management ====================

    async def get_templates(
        self,
        category: Optional[str] = None,
        user_id: Optional[str] = None
    ) -> List[RecommendationTemplateResponse]:
        """Get recommendation templates"""
        try:
            query = self.db.table('recommendation_templates').select('*')

            if category:
                query = query.eq('category', category)

            result = query.order('usage_count', desc=True).execute()

            templates = result.data or []

            return [RecommendationTemplateResponse(**template) for template in templates]

        except Exception as e:
            logger.error(f"Error fetching templates: {e}")
            raise

    async def render_template(
        self,
        template_id: str,
        field_values: Dict[str, str]
    ) -> TemplateRenderResponse:
        """Render a template with field values"""
        try:
            # Get template
            result = self.db.table('recommendation_templates')\
                .select('*')\
                .eq('id', template_id)\
                .single()\
                .execute()

            if not result.data:
                raise ValueError("Template not found")

            template = result.data
            content = template['content']
            custom_fields = template.get('custom_fields', [])

            # Find missing fields
            missing_fields = [field for field in custom_fields if field not in field_values]

            # Replace placeholders
            for field, value in field_values.items():
                placeholder = f"{{{field}}}"
                content = content.replace(placeholder, value)

            # Increment usage count
            self.db.table('recommendation_templates')\
                .update({'usage_count': template['usage_count'] + 1})\
                .eq('id', template_id)\
                .execute()

            return TemplateRenderResponse(
                rendered_content=content,
                missing_fields=missing_fields
            )

        except Exception as e:
            logger.error(f"Error rendering template: {e}")
            raise

    # ==================== Helper Methods ====================

    async def _update_request_status(self, request_id: str, status: RequestStatus):
        """Update request status"""
        update_dict = {
            'status': status.value,
            'updated_at': datetime.utcnow().isoformat()
        }

        if status == RequestStatus.COMPLETED:
            update_dict['completed_at'] = datetime.utcnow().isoformat()

        self.db.table('recommendation_requests')\
            .update(update_dict)\
            .eq('id', request_id)\
            .execute()

    async def _create_default_reminders(self, request_id: str, deadline: date):
        """Create default reminders for a request"""
        try:
            reminders = [
                {'days_before': 7, 'type': ReminderType.DEADLINE_APPROACHING.value},
                {'days_before': 3, 'type': ReminderType.DEADLINE_APPROACHING.value},
                {'days_before': 1, 'type': ReminderType.DEADLINE_APPROACHING.value}
            ]

            for reminder in reminders:
                reminder_data = {
                    'id': str(uuid4()),
                    'request_id': request_id,
                    'reminder_type': reminder['type'],
                    'days_before_deadline': reminder['days_before'],
                    'is_sent': False,
                    'created_at': datetime.utcnow().isoformat()
                }
                self.db.table('recommendation_reminders').insert(reminder_data).execute()

        except Exception as e:
            logger.error(f"Error creating reminders: {e}")
            # Don't raise - reminders are optional

    async def calculate_letter_statistics(self, content: str) -> LetterStatistics:
        """Calculate statistics for a letter"""
        words = content.split()
        word_count = len(words)
        character_count = len(content)

        # Count paragraphs (split by double newline or multiple spaces)
        paragraphs = [p.strip() for p in content.split('\n\n') if p.strip()]
        paragraph_count = len(paragraphs)

        avg_words_per_paragraph = word_count / paragraph_count if paragraph_count > 0 else 0

        # Estimate reading time (average 200 words per minute)
        estimated_reading_time = word_count / 200.0

        return LetterStatistics(
            word_count=word_count,
            character_count=character_count,
            paragraph_count=paragraph_count,
            average_words_per_paragraph=avg_words_per_paragraph,
            estimated_reading_time_minutes=estimated_reading_time
        )
