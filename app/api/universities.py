"""
Universities API endpoints
"""
from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from sqlalchemy import or_
from app.database.config import SessionLocal
from app.models.university import University, Program
from app.schemas.university import UniversityResponse, UniversitySearchResponse
from typing import Optional
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


@router.get("/universities", response_model=UniversitySearchResponse)
def search_universities(
    country: Optional[str] = None,
    state: Optional[str] = None,
    university_type: Optional[str] = None,
    location_type: Optional[str] = None,
    min_acceptance_rate: Optional[float] = None,
    max_acceptance_rate: Optional[float] = None,
    max_tuition: Optional[float] = None,
    search: Optional[str] = None,
    skip: int = 0,
    limit: int = Query(default=50, le=100),
    db: Session = Depends(get_db),
):
    """Search universities with filters"""
    try:
        query = db.query(University)

        # Apply filters
        if country:
            query = query.filter(University.country == country)

        if state:
            query = query.filter(University.state == state)

        if university_type:
            query = query.filter(University.university_type == university_type)

        if location_type:
            query = query.filter(University.location_type == location_type)

        if min_acceptance_rate is not None:
            query = query.filter(University.acceptance_rate >= min_acceptance_rate)

        if max_acceptance_rate is not None:
            query = query.filter(University.acceptance_rate <= max_acceptance_rate)

        if max_tuition is not None:
            query = query.filter(University.total_cost <= max_tuition)

        if search:
            search_term = f"%{search}%"
            query = query.filter(
                or_(
                    University.name.ilike(search_term),
                    University.city.ilike(search_term),
                    University.state.ilike(search_term),
                )
            )

        # Get total count
        total = query.count()

        # Apply pagination
        universities = query.offset(skip).limit(limit).all()

        return UniversitySearchResponse(total=total, universities=universities)

    except Exception as e:
        logger.error(f"Error searching universities: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/universities/{university_id}", response_model=UniversityResponse)
def get_university(university_id: int, db: Session = Depends(get_db)):
    """Get a specific university by ID"""
    university = db.query(University).filter(University.id == university_id).first()

    if not university:
        raise HTTPException(status_code=404, detail="University not found")

    return university


@router.get("/universities/{university_id}/programs")
def get_university_programs(university_id: int, db: Session = Depends(get_db)):
    """Get programs offered by a university"""
    university = db.query(University).filter(University.id == university_id).first()

    if not university:
        raise HTTPException(status_code=404, detail="University not found")

    programs = db.query(Program).filter(Program.university_id == university_id).all()

    return {"university_id": university_id, "programs": programs}
