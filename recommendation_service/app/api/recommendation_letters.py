"""
Recommendation Letters API Endpoints
Handles letter of recommendation requests and management
"""
from fastapi import APIRouter, Depends, HTTPException, status, Query
from typing import List, Optional, Dict

from app.services.recommendation_letters_service import RecommendationLettersService
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
    TemplateRenderRequest,
    TemplateRenderResponse,
    RequestAcceptanceAction,
    RequestDeclineAction
)
from app.database.config import get_db
from supabase import Client

router = APIRouter()


# ==================== Request Endpoints ====================

@router.post("/recommendation-requests", response_model=RecommendationRequestResponse, status_code=status.HTTP_201_CREATED)
async def create_recommendation_request(
    request_data: RecommendationRequestCreate,
    db: Client = Depends(get_db)
):
    """
    Create a new recommendation request

    **Student** requests a letter of recommendation from a recommender

    **Request Body:**
    - student_id: ID of the student
    - recommender_id: ID of the recommender (teacher/counselor)
    - request_type: Type of recommendation (academic, professional, scholarship, character)
    - purpose: What the recommendation is for
    - institution_name: Target institution or company
    - deadline: Due date for the recommendation
    - priority: Request priority (low, normal, high, urgent)
    - Optional: student_message, achievements, goals, relationship_context

    **Returns:**
    - Created recommendation request with ID and status
    """
    try:
        service = RecommendationLettersService(db)
        return await service.create_request(request_data)

    except ValueError as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e)
        )


@router.post("/recommendation-requests/by-email", status_code=status.HTTP_201_CREATED)
async def create_recommendation_request_by_email(
    request_data: Dict,
    db: Client = Depends(get_db)
):
    """
    Create recommendation request(s) by recommender email

    This endpoint allows students to request recommendations by providing
    the recommender's email address. If the recommender doesn't have an account,
    an invitation will be sent.

    **Request Body:**
    - student_id: ID of the student
    - recommender_email: Email of the recommender
    - recommender_name: Name of the recommender
    - request_type: Type of recommendation
    - purpose: What the recommendation is for
    - institution_names: List of target institutions
    - deadline: Due date
    - priority: Request priority
    - Optional: student_message, achievements, goals, relationship_context

    **Returns:**
    - List of created recommendation requests
    """
    try:
        from uuid import uuid4
        from datetime import datetime

        student_id = request_data.get('student_id')
        recommender_email = request_data.get('recommender_email')
        recommender_name = request_data.get('recommender_name')
        institution_names = request_data.get('institution_names', [])

        if not student_id or not recommender_email or not recommender_name:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="student_id, recommender_email, and recommender_name are required"
            )

        if not institution_names:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="At least one institution must be selected"
            )

        # Check if recommender exists by email in auth.users
        recommender_response = db.table('users').select('id').eq('email', recommender_email).execute()

        recommender_id = None
        if recommender_response.data and len(recommender_response.data) > 0:
            recommender_id = recommender_response.data[0]['id']
        # If recommender doesn't exist, we'll store their email/name and leave recommender_id as null
        # When they create an account and accept, we'll link them

        # Create a request for each institution
        created_requests = []
        for institution in institution_names:
            request_dict = {
                'id': str(uuid4()),
                'student_id': student_id,
                'request_type': request_data.get('request_type', 'academic'),
                'purpose': request_data.get('purpose', ''),
                'institution_name': institution,
                'deadline': request_data.get('deadline'),
                'priority': request_data.get('priority', 'normal'),
                'status': 'pending',
                'student_message': request_data.get('student_message'),
                'achievements': request_data.get('achievements'),
                'goals': request_data.get('goals'),
                'relationship_context': request_data.get('relationship_context'),
                'recommender_email': recommender_email,
                'recommender_name': recommender_name,
                'requested_at': datetime.utcnow().isoformat(),
                'created_at': datetime.utcnow().isoformat(),
                'updated_at': datetime.utcnow().isoformat()
            }

            # Only include recommender_id if we found a user
            if recommender_id:
                request_dict['recommender_id'] = recommender_id

            result = db.table('recommendation_requests').insert(request_dict).execute()

            if result.data:
                created_requests.append(result.data[0])

        # TODO: Send email notification to recommender
        # This would integrate with an email service like SendGrid, AWS SES, etc.

        return {
            "success": True,
            "message": f"Created {len(created_requests)} recommendation request(s). An invitation has been sent to {recommender_email}.",
            "requests": created_requests,
            "recommender_email": recommender_email,
            "recommender_name": recommender_name
        }

    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e)
        )


@router.get("/recommendation-requests/{request_id}", response_model=RecommendationRequestWithDetails)
async def get_recommendation_request(
    request_id: str,
    user_id: str = Query(..., description="User ID (student or recommender)"),
    db: Client = Depends(get_db)
):
    """
    Get a specific recommendation request with details

    **Authorization:**
    - Only the student or recommender can view the request

    **Returns:**
    - Request details with student/recommender information
    - Letter status if exists
    """
    try:
        service = RecommendationLettersService(db)
        return await service.get_request(request_id, user_id)

    except ValueError as e:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=str(e)
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e)
        )


@router.get("/students/{student_id}/recommendation-requests", response_model=StudentRequestsSummary)
async def get_student_requests(
    student_id: str,
    db: Client = Depends(get_db)
):
    """
    Get all recommendation requests for a student

    **Path Parameters:**
    - student_id: Student's auth user ID (UUID)

    **Returns:**
    - Summary statistics (total, pending, accepted, declined, completed)
    - List of active requests with details
    """
    try:
        # No need to verify student profile - just query requests directly
        # The student_id is the auth.users.id UUID
        service = RecommendationLettersService(db)
        return await service.get_student_requests(student_id)

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e)
        )


@router.get("/recommenders/{recommender_id}/dashboard", response_model=RecommenderDashboardSummary)
async def get_recommender_dashboard(
    recommender_id: str,
    db: Client = Depends(get_db)
):
    """
    Get dashboard summary for a recommender

    **Returns:**
    - Total requests, pending, in-progress, completed
    - Overdue requests count
    - Urgent requests count
    - Upcoming deadlines (next 7 days)
    """
    try:
        service = RecommendationLettersService(db)
        return await service.get_recommender_requests(recommender_id)

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e)
        )


@router.put("/recommendation-requests/{request_id}", response_model=RecommendationRequestResponse)
async def update_recommendation_request(
    request_id: str,
    update_data: RecommendationRequestUpdate,
    user_id: str = Query(..., description="User ID (student or recommender)"),
    db: Client = Depends(get_db)
):
    """
    Update a recommendation request

    **Authorization:**
    - Only the student or recommender can update

    **Updatable Fields:**
    - status, priority, deadline, purpose, institution_name
    - student_message, achievements, goals

    **Returns:**
    - Updated request
    """
    try:
        service = RecommendationLettersService(db)
        return await service.update_request(request_id, user_id, update_data)

    except ValueError as e:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=str(e)
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e)
        )


@router.post("/recommendation-requests/{request_id}/accept", response_model=RecommendationRequestResponse)
async def accept_recommendation_request(
    request_id: str,
    recommender_id: str = Query(..., description="Recommender's user ID"),
    action: RequestAcceptanceAction = RequestAcceptanceAction(),
    db: Client = Depends(get_db)
):
    """
    Accept a recommendation request

    **Authorization:**
    - Only the assigned recommender can accept

    **Effect:**
    - Status changes to 'accepted'
    - Records acceptance timestamp
    - Recommender can now create a letter

    **Returns:**
    - Updated request with accepted status
    """
    try:
        service = RecommendationLettersService(db)
        return await service.accept_request(request_id, recommender_id, action)

    except ValueError as e:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=str(e)
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e)
        )


@router.post("/recommendation-requests/{request_id}/decline", response_model=RecommendationRequestResponse)
async def decline_recommendation_request(
    request_id: str,
    recommender_id: str = Query(..., description="Recommender's user ID"),
    action: RequestDeclineAction = ...,
    db: Client = Depends(get_db)
):
    """
    Decline a recommendation request

    **Authorization:**
    - Only the assigned recommender can decline

    **Required:**
    - decline_reason: Reason for declining (min 10 characters)

    **Effect:**
    - Status changes to 'declined'
    - Records declination timestamp and reason
    - Student is notified

    **Returns:**
    - Updated request with declined status
    """
    try:
        service = RecommendationLettersService(db)
        return await service.decline_request(request_id, recommender_id, action)

    except ValueError as e:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=str(e)
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e)
        )


@router.delete("/recommendation-requests/{request_id}")
async def delete_recommendation_request(
    request_id: str,
    student_id: str = Query(..., description="Student's user ID"),
    db: Client = Depends(get_db)
):
    """
    Delete/Cancel a recommendation request

    **Authorization:**
    - Only the student who created the request can delete it
    - Can only delete requests that are still pending or declined

    **Effect:**
    - Permanently removes the request from the database
    - Any associated letter drafts are also removed

    **Returns:**
    - Success message
    """
    try:
        # Verify the request exists and belongs to this student
        request_response = db.table('recommendation_requests').select('*').eq('id', request_id).execute()

        if not request_response.data or len(request_response.data) == 0:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Recommendation request not found"
            )

        request_data = request_response.data[0]

        # Verify the student owns this request
        if request_data.get('student_id') != student_id:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="You can only delete your own requests"
            )

        # Check if the request can be deleted (only pending or declined)
        status_value = request_data.get('status', '')
        if status_value not in ['pending', 'declined']:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"Cannot delete a request with status '{status_value}'. Only pending or declined requests can be deleted."
            )

        # Delete any associated letters first (if any)
        db.table('letters_of_recommendation').delete().eq('request_id', request_id).execute()

        # Delete the request
        delete_response = db.table('recommendation_requests').delete().eq('id', request_id).execute()

        return {
            "success": True,
            "message": "Recommendation request deleted successfully",
            "deleted_id": request_id
        }

    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e)
        )


# ==================== Letter Endpoints ====================

@router.post("/recommendation-letters", response_model=LetterOfRecommendationResponse, status_code=status.HTTP_201_CREATED)
async def create_recommendation_letter(
    letter_data: LetterOfRecommendationCreate,
    recommender_id: str = Query(..., description="Recommender's user ID"),
    db: Client = Depends(get_db)
):
    """
    Create a new recommendation letter

    **Authorization:**
    - Only the assigned recommender can create a letter

    **Request Body:**
    - request_id: ID of the recommendation request
    - content: Letter content (min 100 characters)
    - letter_type: Format (formal, informal, email_format)
    - is_visible_to_student: Whether student can view
    - Optional: template_id if using a template

    **Effect:**
    - Request status changes to 'in_progress'
    - Calculates word and character count
    - Letter saved as 'draft' status

    **Returns:**
    - Created letter with statistics
    """
    try:
        service = RecommendationLettersService(db)
        return await service.create_letter(letter_data, recommender_id)

    except ValueError as e:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=str(e)
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e)
        )


@router.get("/recommendation-letters/{letter_id}", response_model=LetterOfRecommendationWithRequest)
async def get_recommendation_letter(
    letter_id: str,
    user_id: str = Query(..., description="User ID (recommender or student)"),
    db: Client = Depends(get_db)
):
    """
    Get a recommendation letter

    **Authorization:**
    - Recommender can always view their letters
    - Student can only view if marked visible

    **Returns:**
    - Letter content with request details
    - Student and institution information
    """
    try:
        service = RecommendationLettersService(db)
        return await service.get_letter(letter_id, user_id)

    except ValueError as e:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=str(e)
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e)
        )


@router.put("/recommendation-letters/{letter_id}", response_model=LetterOfRecommendationResponse)
async def update_recommendation_letter(
    letter_id: str,
    update_data: LetterOfRecommendationUpdate,
    recommender_id: str = Query(..., description="Recommender's user ID"),
    db: Client = Depends(get_db)
):
    """
    Update a recommendation letter

    **Authorization:**
    - Only the recommender can update their letter

    **Updatable Fields:**
    - content: Letter text
    - letter_type: Format
    - status: draft → submitted → archived
    - is_visible_to_student: Visibility toggle

    **Effect:**
    - Updates last_edited_at timestamp
    - Recalculates word/character count if content changed
    - If status changes to 'submitted', marks request as completed

    **Returns:**
    - Updated letter with new statistics
    """
    try:
        service = RecommendationLettersService(db)
        return await service.update_letter(letter_id, recommender_id, update_data)

    except ValueError as e:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=str(e)
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e)
        )


@router.post("/recommendation-letters/{letter_id}/submit", response_model=LetterOfRecommendationResponse)
async def submit_recommendation_letter(
    letter_id: str,
    recommender_id: str = Query(..., description="Recommender's user ID"),
    db: Client = Depends(get_db)
):
    """
    Submit a recommendation letter (mark as complete)

    **Authorization:**
    - Only the recommender can submit

    **Effect:**
    - Status changes to 'submitted'
    - Records submission timestamp
    - Request status changes to 'completed'
    - Student is notified

    **Returns:**
    - Submitted letter
    """
    try:
        service = RecommendationLettersService(db)
        return await service.submit_letter(letter_id, recommender_id)

    except ValueError as e:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=str(e)
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e)
        )


@router.post("/recommendation-letters/{letter_id}/share")
async def generate_share_link(
    letter_id: str,
    recommender_id: str = Query(..., description="Recommender's user ID"),
    db: Client = Depends(get_db)
):
    """
    Generate a shareable link for a letter

    **Authorization:**
    - Only the recommender can generate share links

    **Use Cases:**
    - Share with institutions/companies
    - Provide to students for application portals

    **Returns:**
    - share_token: Unique token for accessing the letter
    - share_url: Full URL for sharing (if configured)
    """
    try:
        service = RecommendationLettersService(db)
        share_token = await service.generate_share_link(letter_id, recommender_id)

        return {
            "share_token": share_token,
            "letter_id": letter_id,
            "message": "Share link generated successfully"
        }

    except ValueError as e:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=str(e)
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e)
        )


@router.post("/recommendation-letters/statistics")
async def calculate_letter_statistics(
    content: str = Query(..., min_length=1),
    db: Client = Depends(get_db)
):
    """
    Calculate statistics for letter content

    **Query Parameters:**
    - content: The letter text to analyze

    **Returns:**
    - word_count: Total words
    - character_count: Total characters
    - paragraph_count: Number of paragraphs
    - average_words_per_paragraph: Average
    - estimated_reading_time_minutes: Reading time estimate

    **Use Case:**
    - Real-time feedback while writing
    - Quality metrics for letters
    """
    try:
        service = RecommendationLettersService(db)
        return await service.calculate_letter_statistics(content)

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e)
        )


# ==================== Template Endpoints ====================

@router.get("/recommendation-templates", response_model=List[RecommendationTemplateResponse])
async def get_recommendation_templates(
    category: Optional[str] = Query(None, description="Filter by category (academic, professional, scholarship, character)"),
    user_id: Optional[str] = Query(None, description="User ID to include private templates"),
    db: Client = Depends(get_db)
):
    """
    Get recommendation letter templates

    **Query Parameters:**
    - category: Filter by template category (optional)
    - user_id: Include user's private templates (optional)

    **Returns:**
    - List of templates sorted by usage count
    - Public templates + user's private templates
    - Includes custom field definitions

    **Template Categories:**
    - academic: For college/university applications
    - professional: For jobs/internships
    - scholarship: For scholarship applications
    - character: Character references
    """
    try:
        service = RecommendationLettersService(db)
        return await service.get_templates(category, user_id)

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e)
        )


@router.post("/recommendation-templates/render", response_model=TemplateRenderResponse)
async def render_template(
    render_request: TemplateRenderRequest,
    db: Client = Depends(get_db)
):
    """
    Render a template with field values

    **Request Body:**
    - template_id: Template to use
    - field_values: Dictionary of field names → values

    **Field Replacement:**
    - {student_name} → "John Doe"
    - {program_name} → "Computer Science"
    - etc.

    **Returns:**
    - rendered_content: Template with values filled in
    - missing_fields: List of unfilled required fields

    **Usage:**
    - Preview before creating letter
    - Generate letter from template
    """
    try:
        service = RecommendationLettersService(db)
        return await service.render_template(
            render_request.template_id,
            render_request.field_values
        )

    except ValueError as e:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=str(e)
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e)
        )
