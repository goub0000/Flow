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
    """Get a student profile by user ID or internal profile ID"""
    try:
        # First try to find by user_id (auth ID)
        response = db.table('student_profiles').select('*').eq('user_id', user_id).execute()

        if response.data and len(response.data) > 0:
            return response.data[0]

        # If not found, try by internal profile id
        response = db.table('student_profiles').select('*').eq('id', user_id).execute()

        if response.data and len(response.data) > 0:
            logger.info(f"Found profile by internal id: {user_id}")
            return response.data[0]

        raise HTTPException(status_code=404, detail="Student profile not found")

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error fetching student profile: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.put("/students/profile/{user_id}", response_model=StudentProfileResponse)
def update_student_profile(
    user_id: str, profile_data: StudentProfileUpdate, db: Client = Depends(get_db)
):
    """Update a student profile by user ID or internal profile ID"""
    try:
        # First try to find by user_id (auth ID)
        response = db.table('student_profiles').select('id, user_id').eq('user_id', user_id).execute()
        lookup_field = 'user_id'
        lookup_value = user_id

        if not response.data or len(response.data) == 0:
            # Try by internal profile id
            response = db.table('student_profiles').select('id, user_id').eq('id', user_id).execute()
            lookup_field = 'id'

        if not response.data or len(response.data) == 0:
            raise HTTPException(status_code=404, detail="Student profile not found")

        # Update fields
        update_data = profile_data.model_dump(exclude_unset=True)

        if not update_data:
            # No fields to update
            response = db.table('student_profiles').select('*').eq(lookup_field, lookup_value).execute()
            return response.data[0]

        result = db.table('student_profiles').update(update_data).eq(lookup_field, lookup_value).execute()

        logger.info(f"Updated profile for user: {user_id}")
        return result.data[0]

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error updating student profile: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.delete("/students/profile/{user_id}")
def delete_student_profile(user_id: str, db: Client = Depends(get_db)):
    """Delete a student profile by user ID or internal profile ID"""
    try:
        # Check if profile exists - handle both user_id (auth) and internal profile ID
        response = db.table('student_profiles').select('id').eq('user_id', user_id).execute()
        lookup_field = 'user_id'

        if not response.data or len(response.data) == 0:
            # Try by internal profile id
            response = db.table('student_profiles').select('id').eq('id', user_id).execute()
            lookup_field = 'id'

        if not response.data or len(response.data) == 0:
            raise HTTPException(status_code=404, detail="Student profile not found")

        # Delete the profile using the correct lookup field
        db.table('student_profiles').delete().eq(lookup_field, user_id).execute()

        logger.info(f"Deleted profile for user: {user_id}")
        return {"message": "Profile deleted successfully"}

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error deleting student profile: {e}")
        raise HTTPException(status_code=500, detail=str(e))


# ==================== STUDENT ANALYTICS ====================

@router.get("/students/{user_id}/analytics/application-success")
def get_application_success_rate(user_id: str, db: Client = Depends(get_db)):
    """
    Get application success rate analytics for a student

    **Phase 4.2 - Student Progress Visualizations**

    Returns breakdown of applications by status for pie chart visualization:
    - Accepted: Applications that were accepted
    - Pending: Applications still under review
    - Rejected: Applications that were rejected
    - Withdrawn: Applications withdrawn by student

    **Returns:**
    - total_applications: Total number of applications
    - accepted_count: Number of accepted applications
    - pending_count: Number of pending applications
    - rejected_count: Number of rejected applications
    - withdrawn_count: Number of withdrawn applications
    - acceptance_rate: Percentage of applications accepted
    - distributions: Array of {status, count, percentage} for chart
    """
    try:
        # Get student profile - handle both user_id (auth) and internal profile ID
        # We need to find the auth user_id (UUID) for querying applications table
        auth_user_id = user_id  # Assume it's already the auth UUID

        profile_response = db.table('student_profiles').select('id, user_id').eq('user_id', user_id).execute()

        if not profile_response.data or len(profile_response.data) == 0:
            # Try by internal profile id - in this case we need to get the user_id
            profile_response = db.table('student_profiles').select('id, user_id').eq('id', user_id).execute()
            if profile_response.data and len(profile_response.data) > 0:
                auth_user_id = profile_response.data[0].get('user_id', user_id)

        if not profile_response.data or len(profile_response.data) == 0:
            raise HTTPException(status_code=404, detail="Student profile not found")

        # Use auth user_id (UUID) for applications table query
        # applications.student_id references auth.users(id) which is UUID
        applications_response = db.table('applications').select('status').eq('student_id', auth_user_id).execute()

        if not applications_response.data:
            return {
                "total_applications": 0,
                "accepted_count": 0,
                "pending_count": 0,
                "rejected_count": 0,
                "withdrawn_count": 0,
                "acceptance_rate": 0.0,
                "distributions": []
            }

        applications = applications_response.data

        # Count by status
        status_counts = {
            "accepted": 0,
            "pending": 0,
            "rejected": 0,
            "withdrawn": 0
        }

        for app in applications:
            status = app.get('status', 'pending').lower()
            if status in status_counts:
                status_counts[status] += 1
            elif status in ['submitted', 'under_review', 'in_review']:
                status_counts['pending'] += 1

        total = len(applications)

        # Calculate acceptance rate
        acceptance_rate = (status_counts['accepted'] / total * 100) if total > 0 else 0.0

        # Build distributions for chart
        distributions = []
        for status, count in status_counts.items():
            if count > 0:  # Only include statuses with applications
                percentage = (count / total * 100) if total > 0 else 0.0
                distributions.append({
                    "status": status.capitalize(),
                    "count": count,
                    "percentage": round(percentage, 1)
                })

        return {
            "total_applications": total,
            "accepted_count": status_counts['accepted'],
            "pending_count": status_counts['pending'],
            "rejected_count": status_counts['rejected'],
            "withdrawn_count": status_counts['withdrawn'],
            "acceptance_rate": round(acceptance_rate, 1),
            "distributions": distributions
        }

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error fetching application success rate: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/students/{user_id}/analytics/gpa-trend")
def get_gpa_trend(user_id: str, db: Client = Depends(get_db)):
    """
    Get GPA trend analytics for a student

    **Phase 4.2 - Student Progress Visualizations**

    Returns GPA history over time for line chart visualization.
    Uses gpa_history table if available, otherwise returns current GPA.

    **Returns:**
    - current_gpa: Current/latest GPA
    - goal_gpa: Target GPA if set in profile
    - data_points: Array of {date, gpa, semester} for chart
    - trend: "improving", "declining", or "stable"
    - average_gpa: Average GPA across all semesters
    """
    try:
        # Get student profile with current GPA - handle both user_id (auth) and internal ID
        # We need both the profile data and the auth user_id for gpa_history query
        auth_user_id = user_id  # Assume it's already the auth UUID

        profile_response = db.table('student_profiles').select('id, user_id, gpa').eq('user_id', user_id).execute()

        if not profile_response.data or len(profile_response.data) == 0:
            # Try by internal profile id - get the user_id for gpa_history query
            profile_response = db.table('student_profiles').select('id, user_id, gpa').eq('id', user_id).execute()
            if profile_response.data and len(profile_response.data) > 0:
                auth_user_id = profile_response.data[0].get('user_id', user_id)

        if not profile_response.data or len(profile_response.data) == 0:
            raise HTTPException(status_code=404, detail="Student profile not found")

        student_profile = profile_response.data[0]
        current_gpa = student_profile.get('gpa') or 0.0  # Handle None values

        # Try to get GPA history from gpa_history table (Phase 3.4)
        # gpa_history.student_id references auth.users(id) which is UUID
        try:
            gpa_history_response = db.table('gpa_history').select(
                'semester, school_year, gpa, calculated_at'
            ).eq('student_id', auth_user_id).order('school_year').order('semester').execute()

            if gpa_history_response.data and len(gpa_history_response.data) > 0:
                # We have historical data
                data_points = []
                gpas = []

                for record in gpa_history_response.data:
                    gpa = record.get('gpa', 0.0)
                    gpas.append(gpa)

                    data_points.append({
                        "date": record.get('calculated_at'),
                        "gpa": round(gpa, 2),
                        "semester": f"{record.get('semester', '')} {record.get('school_year', '')}"
                    })

                # Calculate trend
                if len(gpas) >= 2:
                    if gpas[-1] > gpas[0]:
                        trend = "improving"
                    elif gpas[-1] < gpas[0]:
                        trend = "declining"
                    else:
                        trend = "stable"
                else:
                    trend = "stable"

                average_gpa = sum(gpas) / len(gpas) if gpas else 0.0

                return {
                    "current_gpa": round(current_gpa, 2),
                    "goal_gpa": 4.0,  # Could be stored in profile
                    "data_points": data_points,
                    "trend": trend,
                    "average_gpa": round(average_gpa, 2)
                }
            else:
                # No historical data, return single point
                return {
                    "current_gpa": round(current_gpa, 2),
                    "goal_gpa": 4.0,
                    "data_points": [{
                        "date": None,
                        "gpa": round(current_gpa, 2),
                        "semester": "Current"
                    }],
                    "trend": "stable",
                    "average_gpa": round(current_gpa, 2)
                }

        except Exception as history_error:
            # gpa_history table might not exist, fallback to current GPA only
            logger.warning(f"Could not fetch GPA history: {history_error}")

            return {
                "current_gpa": round(current_gpa, 2),
                "goal_gpa": 4.0,
                "data_points": [{
                    "date": None,
                    "gpa": round(current_gpa, 2),
                    "semester": "Current"
                }],
                "trend": "stable",
                "average_gpa": round(current_gpa, 2)
            }

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error fetching GPA trend: {e}")
        raise HTTPException(status_code=500, detail=str(e))
