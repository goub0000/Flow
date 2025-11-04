"""
Recommendations API endpoints
"""
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.database.config import SessionLocal
from app.models.university import StudentProfile, Recommendation, University
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

# Dependency to get database session
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


@router.post("/recommendations/generate", response_model=RecommendationListResponse)
def generate_recommendations(
    request: GenerateRecommendationsRequest, db: Session = Depends(get_db)
):
    """Generate university recommendations for a student"""
    try:
        # Get student profile
        student = (
            db.query(StudentProfile)
            .filter(StudentProfile.user_id == request.user_id)
            .first()
        )

        if not student:
            raise HTTPException(status_code=404, detail="Student profile not found")

        # Delete existing recommendations for this student
        db.query(Recommendation).filter(
            Recommendation.student_id == student.id
        ).delete()
        db.commit()

        # Generate new recommendations
        engine = RecommendationEngine(db)
        recommendations = engine.generate_recommendations(
            student, max_results=request.max_results or 15
        )

        # Save recommendations
        for rec in recommendations:
            db.add(rec)

        db.commit()

        # Refresh and load relationships
        for rec in recommendations:
            db.refresh(rec)

        logger.info(
            f"Generated {len(recommendations)} recommendations for user: {request.user_id}"
        )

        # Organize by category
        safety_schools = [r for r in recommendations if r.category == "Safety"]
        match_schools = [r for r in recommendations if r.category == "Match"]
        reach_schools = [r for r in recommendations if r.category == "Reach"]

        return RecommendationListResponse(
            total=len(recommendations),
            safety_schools=safety_schools,
            match_schools=match_schools,
            reach_schools=reach_schools,
        )

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error generating recommendations: {e}")
        db.rollback()
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/recommendations/{user_id}", response_model=RecommendationListResponse)
def get_recommendations(user_id: str, db: Session = Depends(get_db)):
    """Get existing recommendations for a student"""
    # Get student profile
    student = (
        db.query(StudentProfile).filter(StudentProfile.user_id == user_id).first()
    )

    if not student:
        raise HTTPException(status_code=404, detail="Student profile not found")

    # Get recommendations
    recommendations = (
        db.query(Recommendation)
        .filter(Recommendation.student_id == student.id)
        .all()
    )

    if not recommendations:
        raise HTTPException(
            status_code=404,
            detail="No recommendations found. Generate recommendations first.",
        )

    # Organize by category
    safety_schools = [r for r in recommendations if r.category == "Safety"]
    match_schools = [r for r in recommendations if r.category == "Match"]
    reach_schools = [r for r in recommendations if r.category == "Reach"]

    return RecommendationListResponse(
        total=len(recommendations),
        safety_schools=safety_schools,
        match_schools=match_schools,
        reach_schools=reach_schools,
    )


@router.put("/recommendations/{recommendation_id}", response_model=RecommendationResponse)
def update_recommendation(
    recommendation_id: int,
    request: UpdateRecommendationRequest,
    db: Session = Depends(get_db),
):
    """Update a recommendation (favorite, add notes)"""
    recommendation = (
        db.query(Recommendation)
        .filter(Recommendation.id == recommendation_id)
        .first()
    )

    if not recommendation:
        raise HTTPException(status_code=404, detail="Recommendation not found")

    try:
        # Update fields
        if request.favorited is not None:
            recommendation.favorited = request.favorited
        if request.notes is not None:
            recommendation.notes = request.notes

        db.commit()
        db.refresh(recommendation)
        logger.info(f"Updated recommendation: {recommendation_id}")
        return recommendation

    except Exception as e:
        logger.error(f"Error updating recommendation: {e}")
        db.rollback()
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/recommendations/{user_id}/favorites", response_model=list[RecommendationResponse])
def get_favorite_recommendations(user_id: str, db: Session = Depends(get_db)):
    """Get favorited recommendations for a student"""
    # Get student profile
    student = (
        db.query(StudentProfile).filter(StudentProfile.user_id == user_id).first()
    )

    if not student:
        raise HTTPException(status_code=404, detail="Student profile not found")

    # Get favorited recommendations
    recommendations = (
        db.query(Recommendation)
        .filter(Recommendation.student_id == student.id, Recommendation.favorited == 1)
        .all()
    )

    return recommendations
