"""
Student Profile API endpoints - Cloud-Based (Supabase)
"""
from fastapi import APIRouter, Depends, HTTPException
from supabase import Client
from app.database.config import get_db
from app.schemas.student import (
    StudentProfileCreate,
    StudentProfileUpdate,
    StudentProfileResponse,
)
import logging

logger = logging.getLogger(__name__)

router = APIRouter()


@router.post("/students/profile", response_model=StudentProfileResponse)
def create_or_update_student_profile(
    profile_data: StudentProfileCreate, db: Client = Depends(get_db)
):
    """Create or update a student profile"""
    try:
        # Check if profile already exists
        response = db.table('student_profiles').select('*').eq('user_id', profile_data.user_id).execute()

        if response.data and len(response.data) > 0:
            # Update existing profile
            existing_profile = response.data[0]
            update_data = profile_data.model_dump(exclude_unset=True)

            # Remove user_id from update (don't update the key)
            if 'user_id' in update_data:
                del update_data['user_id']

            # Update in Supabase
            result = db.table('student_profiles').update(update_data).eq('user_id', profile_data.user_id).execute()

            logger.info(f"Updated profile for user: {profile_data.user_id}")
            return result.data[0]
        else:
            # Create new profile
            insert_data = profile_data.model_dump()
            result = db.table('student_profiles').insert(insert_data).execute()

            logger.info(f"Created profile for user: {profile_data.user_id}")
            return result.data[0]

    except Exception as e:
        logger.error(f"Error creating/updating student profile: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/students/profile/{user_id}", response_model=StudentProfileResponse)
def get_student_profile(user_id: str, db: Client = Depends(get_db)):
    """Get a student profile by user ID"""
    try:
        response = db.table('student_profiles').select('*').eq('user_id', user_id).execute()

        if not response.data or len(response.data) == 0:
            raise HTTPException(status_code=404, detail="Student profile not found")

        return response.data[0]

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error fetching student profile: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.put("/students/profile/{user_id}", response_model=StudentProfileResponse)
def update_student_profile(
    user_id: str, profile_data: StudentProfileUpdate, db: Client = Depends(get_db)
):
    """Update a student profile"""
    try:
        # Check if profile exists
        response = db.table('student_profiles').select('id').eq('user_id', user_id).execute()

        if not response.data or len(response.data) == 0:
            raise HTTPException(status_code=404, detail="Student profile not found")

        # Update fields
        update_data = profile_data.model_dump(exclude_unset=True)

        if not update_data:
            # No fields to update
            response = db.table('student_profiles').select('*').eq('user_id', user_id).execute()
            return response.data[0]

        result = db.table('student_profiles').update(update_data).eq('user_id', user_id).execute()

        logger.info(f"Updated profile for user: {user_id}")
        return result.data[0]

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error updating student profile: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.delete("/students/profile/{user_id}")
def delete_student_profile(user_id: str, db: Client = Depends(get_db)):
    """Delete a student profile"""
    try:
        # Check if profile exists
        response = db.table('student_profiles').select('id').eq('user_id', user_id).execute()

        if not response.data or len(response.data) == 0:
            raise HTTPException(status_code=404, detail="Student profile not found")

        # Delete the profile
        db.table('student_profiles').delete().eq('user_id', user_id).execute()

        logger.info(f"Deleted profile for user: {user_id}")
        return {"message": "Profile deleted successfully"}

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error deleting student profile: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/students/profile/{user_id}/exists")
def check_profile_exists(user_id: str, db: Client = Depends(get_db)):
    """Check if a student profile exists for a user"""
    try:
        response = db.table('student_profiles').select('id').eq('user_id', user_id).execute()

        exists = response.data and len(response.data) > 0

        logger.info(f"Profile exists check for user {user_id}: {exists}")
        return {
            "user_id": user_id,
            "exists": exists
        }

    except Exception as e:
        logger.error(f"Error checking profile existence: {e}")
        raise HTTPException(status_code=500, detail=str(e))
