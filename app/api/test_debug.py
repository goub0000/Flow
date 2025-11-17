"""
Debug endpoint for testing application retrieval
TEMPORARY FILE - DELETE AFTER DEBUGGING
"""
from fastapi import APIRouter, Depends
from app.database.config import get_supabase
from app.utils.security import get_current_user, CurrentUser
import logging

logger = logging.getLogger(__name__)
router = APIRouter()

@router.get("/debug/applications")
async def debug_applications(current_user: CurrentUser = Depends(get_current_user)):
    """
    Debug endpoint to check applications in database
    """
    try:
        db = get_supabase()

        # Get all applications
        all_apps = db.table('applications').select('*').execute()

        # Get current user's applications
        user_apps = db.table('applications').select('*').eq('student_id', current_user.id).execute()

        result = {
            "current_user_id": current_user.id,
            "current_user_email": current_user.email,
            "total_applications_in_db": len(all_apps.data) if all_apps.data else 0,
            "user_applications_count": len(user_apps.data) if user_apps.data else 0,
            "user_applications": user_apps.data if user_apps.data else [],
            "sample_app_student_ids": [app['student_id'] for app in (all_apps.data[:5] if all_apps.data else [])]
        }

        logger.info(f"[DEBUG] Debug endpoint result: {result}")

        return result

    except Exception as e:
        logger.error(f"Debug endpoint error: {e}")
        return {"error": str(e)}