"""
Recommendations API endpoints - Cloud-Based (Supabase)
"""
from fastapi import APIRouter, Depends, HTTPException
from supabase import Client
from app.database.config import get_db
from app.schemas.recommendation import (
    GenerateRecommendationsRequest,
    RecommendationResponse,
    RecommendationListResponse,
    UpdateRecommendationRequest,
)
from app.services.recommendation_engine import RecommendationEngine
import logging

logger = logging.getLogger(__name__)

router = APIRouter()


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

        # Generate new recommendations using the engine
        engine = RecommendationEngine(db)
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
