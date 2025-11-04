"""
Student Profile API endpoints
"""
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.database.config import SessionLocal
from app.models.university import StudentProfile
from app.schemas.student import (
    StudentProfileCreate,
    StudentProfileUpdate,
    StudentProfileResponse,
)
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


@router.post("/students/profile", response_model=StudentProfileResponse)
def create_or_update_student_profile(
    profile_data: StudentProfileCreate, db: Session = Depends(get_db)
):
    """Create or update a student profile"""
    try:
        # Check if profile already exists
        existing_profile = (
            db.query(StudentProfile)
            .filter(StudentProfile.user_id == profile_data.user_id)
            .first()
        )

        if existing_profile:
            # Update existing profile
            for key, value in profile_data.model_dump(exclude_unset=True).items():
                if key != "user_id":  # Don't update user_id
                    setattr(existing_profile, key, value)

            db.commit()
            db.refresh(existing_profile)
            logger.info(f"Updated profile for user: {profile_data.user_id}")
            return existing_profile
        else:
            # Create new profile
            new_profile = StudentProfile(**profile_data.model_dump())
            db.add(new_profile)
            db.commit()
            db.refresh(new_profile)
            logger.info(f"Created profile for user: {profile_data.user_id}")
            return new_profile

    except Exception as e:
        logger.error(f"Error creating/updating student profile: {e}")
        db.rollback()
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/students/profile/{user_id}", response_model=StudentProfileResponse)
def get_student_profile(user_id: str, db: Session = Depends(get_db)):
    """Get a student profile by user ID"""
    profile = (
        db.query(StudentProfile).filter(StudentProfile.user_id == user_id).first()
    )

    if not profile:
        raise HTTPException(status_code=404, detail="Student profile not found")

    return profile


@router.put("/students/profile/{user_id}", response_model=StudentProfileResponse)
def update_student_profile(
    user_id: str, profile_data: StudentProfileUpdate, db: Session = Depends(get_db)
):
    """Update a student profile"""
    profile = (
        db.query(StudentProfile).filter(StudentProfile.user_id == user_id).first()
    )

    if not profile:
        raise HTTPException(status_code=404, detail="Student profile not found")

    try:
        # Update fields
        for key, value in profile_data.model_dump(exclude_unset=True).items():
            setattr(profile, key, value)

        db.commit()
        db.refresh(profile)
        logger.info(f"Updated profile for user: {user_id}")
        return profile

    except Exception as e:
        logger.error(f"Error updating student profile: {e}")
        db.rollback()
        raise HTTPException(status_code=500, detail=str(e))


@router.delete("/students/profile/{user_id}")
def delete_student_profile(user_id: str, db: Session = Depends(get_db)):
    """Delete a student profile"""
    profile = (
        db.query(StudentProfile).filter(StudentProfile.user_id == user_id).first()
    )

    if not profile:
        raise HTTPException(status_code=404, detail="Student profile not found")

    try:
        db.delete(profile)
        db.commit()
        logger.info(f"Deleted profile for user: {user_id}")
        return {"message": "Profile deleted successfully"}

    except Exception as e:
        logger.error(f"Error deleting student profile: {e}")
        db.rollback()
        raise HTTPException(status_code=500, detail=str(e))
