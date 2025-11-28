"""
Recommendations API endpoints - Cloud-Based (Supabase)
ML-Enhanced with automatic fallback to rule-based scoring
Phase 3.2 - Enhanced with personalized recommendations and tracking
"""
from fastapi import APIRouter, Depends, HTTPException, Query, Header
from supabase import Client
from app.database.config import get_db
from app.schemas.recommendation import (
    GenerateRecommendationsRequest,
    RecommendationResponse,
    RecommendationListResponse,
    UpdateRecommendationRequest,
)
from app.schemas.recommendation_tracking import (
    PersonalizedRecommendationsResponse,
    RecommendationClickCreate,
    RecommendationClickResponse,
    RecommendationFeedbackCreate,
    RecommendationFeedbackResponse,
    StudentInteractionSummaryResponse
)
from app.services.personalized_recommendations_service import PersonalizedRecommendationsService
# Lazy import ML engine to avoid loading heavy dependencies at startup
# from app.ml.ml_recommendation_engine import MLRecommendationEngine
import logging
import os
from typing import Optional

logger = logging.getLogger(__name__)

router = APIRouter()

# Get ML models directory from environment variable
ML_MODELS_DIR = os.environ.get('ML_MODELS_DIR', './ml_models')


@router.post("/recommendations/generate", response_model=RecommendationListResponse)
def generate_recommendations(
    request: GenerateRecommendationsRequest, db: Client = Depends(get_db)
):
    """Generate university recommendations for a student"""
    try:
        # Get student profile from Supabase
        response = db.table('student_profiles').select('*').eq('user_id', request.user_id).execute()

        if not response.data or len(response.data) == 0:
            raise HTTPException(status_code=404, detail="Student profile not found")

        student = response.data[0]

        # Delete existing recommendations for this student
        db.table('recommendations').delete().eq('student_id', student['id']).execute()

        # Generate new recommendations using ML-enhanced engine
        # Automatically uses ML if models available, otherwise falls back to rule-based
        # Lazy import to avoid loading ML dependencies at startup
        from app.ml.ml_recommendation_engine import MLRecommendationEngine
        engine = MLRecommendationEngine(db, model_dir=ML_MODELS_DIR)
        recommendations = engine.generate_recommendations(
            student, max_results=request.max_results or 15
        )

        # Insert recommendations into Supabase
        if recommendations:
            db.table('recommendations').insert(recommendations).execute()

        logger.info(
            f"Generated {len(recommendations)} recommendations for user: {request.user_id}"
        )

        # Fetch the inserted recommendations with university data
        response = db.table('recommendations').select(
            '*, universities(*)'
        ).eq('student_id', student['id']).execute()

        inserted_recommendations = response.data

        # Organize by category
        safety_schools = [r for r in inserted_recommendations if r["category"] == "Safety"]
        match_schools = [r for r in inserted_recommendations if r["category"] == "Match"]
        reach_schools = [r for r in inserted_recommendations if r["category"] == "Reach"]

        return RecommendationListResponse(
            total=len(inserted_recommendations),
            safety_schools=safety_schools,
            match_schools=match_schools,
            reach_schools=reach_schools,
        )

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error generating recommendations: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/recommendations/{user_id}", response_model=RecommendationListResponse)
def get_recommendations(user_id: str, db: Client = Depends(get_db)):
    """Get existing recommendations for a student"""
    try:
        # Get student profile
        response = db.table('student_profiles').select('*').eq('user_id', user_id).execute()

        if not response.data or len(response.data) == 0:
            raise HTTPException(status_code=404, detail="Student profile not found")

        student = response.data[0]

        # Get recommendations with university data
        response = db.table('recommendations').select(
            '*, universities(*)'
        ).eq('student_id', student['id']).execute()

        recommendations = response.data

        if not recommendations:
            raise HTTPException(
                status_code=404,
                detail="No recommendations found. Generate recommendations first.",
            )

        # Organize by category
        safety_schools = [r for r in recommendations if r["category"] == "Safety"]
        match_schools = [r for r in recommendations if r["category"] == "Match"]
        reach_schools = [r for r in recommendations if r["category"] == "Reach"]

        return RecommendationListResponse(
            total=len(recommendations),
            safety_schools=safety_schools,
            match_schools=match_schools,
            reach_schools=reach_schools,
        )

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error fetching recommendations: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.put("/recommendations/{recommendation_id}", response_model=RecommendationResponse)
def update_recommendation(
    recommendation_id: int,
    request: UpdateRecommendationRequest,
    db: Client = Depends(get_db),
):
    """Update a recommendation (favorite, add notes)"""
    try:
        # Check if recommendation exists
        response = db.table('recommendations').select('id').eq('id', recommendation_id).execute()

        if not response.data or len(response.data) == 0:
            raise HTTPException(status_code=404, detail="Recommendation not found")

        # Build update data
        update_data = {}
        if request.favorited is not None:
            update_data['favorited'] = 1 if request.favorited else 0
        if request.notes is not None:
            update_data['notes'] = request.notes

        if not update_data:
            # No fields to update, return current
            response = db.table('recommendations').select(
                '*, universities(*)'
            ).eq('id', recommendation_id).execute()
            return response.data[0]

        # Update the recommendation
        result = db.table('recommendations').update(update_data).eq('id', recommendation_id).execute()

        # Fetch with university data
        response = db.table('recommendations').select(
            '*, universities(*)'
        ).eq('id', recommendation_id).execute()

        logger.info(f"Updated recommendation: {recommendation_id}")
        return response.data[0]

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error updating recommendation: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/recommendations/{user_id}/favorites", response_model=list[RecommendationResponse])
def get_favorite_recommendations(user_id: str, db: Client = Depends(get_db)):
    """Get favorited recommendations for a student"""
    try:
        # Get student profile
        response = db.table('student_profiles').select('*').eq('user_id', user_id).execute()

        if not response.data or len(response.data) == 0:
            raise HTTPException(status_code=404, detail="Student profile not found")

        student = response.data[0]

        # Get favorited recommendations with university data
        response = db.table('recommendations').select(
            '*, universities(*)'
        ).eq('student_id', student['id']).eq('favorited', 1).execute()

        recommendations = response.data

        return recommendations

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error fetching favorite recommendations: {e}")
        raise HTTPException(status_code=500, detail=str(e))


# ==================== Phase 3.2 - Personalized Recommendations with Tracking ====================

@router.get("/recommendations/personalized", response_model=PersonalizedRecommendationsResponse)
async def get_personalized_recommendations(
    student_id: Optional[str] = Query(None, description="Student user ID (optional if authenticated)"),
    max_results: int = Query(10, ge=1, le=50, description="Maximum number of recommendations"),
    category: Optional[str] = Query(None, description="Filter by category (Safety, Match, Reach)"),
    db: Client = Depends(get_db),
    authorization: Optional[str] = Header(None)
):
    """
    Get personalized university recommendations with match explanations and tracking

    **Phase 3.2 - ML Recommendations API Enhancement**

    This endpoint provides:
    - Personalized recommendations with match scores
    - Human-readable match explanations
    - Detailed breakdown of matching factors
    - Automatic tracking of impressions for ML improvement
    - Confidence scores from ML model

    **Query Parameters:**
    - student_id: Student's user ID
    - max_results: Number of recommendations to return (1-50, default: 10)
    - category: Optional filter by Safety/Match/Reach

    **Returns:**
    - List of personalized recommendations with explanations
    - Session ID for tracking clicks/feedback
    - Category counts (safety, match, reach)
    - ML model information

    **Note:** Recommendations must be generated first using POST /recommendations/generate
    """
    try:
        # If student_id not provided, try to extract from authorization token
        effective_student_id = student_id
        if not effective_student_id and authorization:
            try:
                from app.utils.security import verify_supabase_token
                token = authorization.replace("Bearer ", "") if authorization.startswith("Bearer ") else authorization
                token_data = await verify_supabase_token(token)
                effective_student_id = token_data.sub
                logger.info(f"Extracted student_id from token: {effective_student_id}")
            except Exception as token_error:
                logger.warning(f"Could not extract user from token: {token_error}")

        if not effective_student_id:
            raise HTTPException(
                status_code=400,
                detail="student_id query parameter is required, or provide Authorization header"
            )

        service = PersonalizedRecommendationsService(db)
        return await service.generate_personalized_recommendations(
            student_id=effective_student_id,
            max_results=max_results,
            category_filter=category
        )

    except HTTPException:
        raise
    except ValueError as e:
        raise HTTPException(status_code=404, detail=str(e))
    except Exception as e:
        logger.error(f"Error generating personalized recommendations: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/recommendations/clicks", response_model=RecommendationClickResponse, status_code=201)
async def track_recommendation_click(
    click_data: RecommendationClickCreate,
    db: Client = Depends(get_db)
):
    """
    Track when a user clicks on a recommendation

    **Use Cases:**
    - User views university details
    - User applies to university
    - User favorites a university
    - User shares a university

    **Request Body:**
    - impression_id: Optional link to the impression record
    - student_id: Student who clicked
    - university_id: University that was clicked
    - action_type: Type of action (view_details, apply, favorite, share)
    - time_to_click_seconds: Optional time from impression to click
    - device_type: Optional device type (web, mobile, tablet)

    **ML Usage:**
    - Click data is used to improve recommendation accuracy
    - High click-through rates indicate good matches
    - Action types show different levels of engagement
    """
    try:
        service = PersonalizedRecommendationsService(db)
        result = service.track_click(click_data)
        return result

    except Exception as e:
        logger.error(f"Error tracking click: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/recommendations/feedback", response_model=RecommendationFeedbackResponse, status_code=201)
async def submit_recommendation_feedback(
    feedback_data: RecommendationFeedbackCreate,
    db: Client = Depends(get_db)
):
    """
    Submit explicit feedback about a recommendation

    **Feedback Types:**
    - thumbs_up: Helpful recommendation
    - thumbs_down: Not helpful
    - not_interested: User not interested in this university
    - already_applied: User already applied
    - helpful/not_helpful: General feedback

    **Request Body:**
    - student_id: Student providing feedback
    - university_id: University being rated
    - feedback_type: Type of feedback
    - rating: Optional 1-5 star rating
    - comment: Optional text comment
    - reasons: Optional array of specific reasons

    **ML Usage:**
    - Explicit feedback directly improves ML model
    - Negative feedback reduces similar recommendations
    - Reasons help identify what factors matter most
    """
    try:
        service = PersonalizedRecommendationsService(db)
        result = service.submit_feedback(feedback_data)
        return result

    except Exception as e:
        logger.error(f"Error submitting feedback: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/recommendations/analytics/{student_id}", response_model=Optional[StudentInteractionSummaryResponse])
async def get_student_recommendation_analytics(
    student_id: str,
    db: Client = Depends(get_db)
):
    """
    Get aggregated analytics for a student's recommendation interactions

    **Returns:**
    - Total impressions (recommendations shown)
    - Total clicks
    - Total applications from recommendations
    - Total favorites
    - Click-through rate (CTR)
    - Preferred categories (based on clicks)
    - Preferred locations
    - Preferred cost range
    - Last interaction timestamp

    **Use Cases:**
    - Student dashboard analytics
    - Understanding student preferences
    - Personalizing future recommendations
    """
    try:
        service = PersonalizedRecommendationsService(db)
        result = service.get_student_interaction_summary(student_id)

        if result is None:
            return None  # No interactions yet

        return result

    except Exception as e:
        logger.error(f"Error getting analytics: {e}")
        raise HTTPException(status_code=500, detail=str(e))
