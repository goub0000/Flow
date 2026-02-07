"""
Institution Debug Endpoints
Comprehensive debugging tools for institution dashboard issues
"""
from fastapi import APIRouter, Depends, HTTPException, status
from typing import Dict, Any, List, Optional
import logging
from datetime import datetime

from app.database.config import get_supabase, get_supabase_admin
from app.utils.security import get_current_user, CurrentUser, require_institution
from pydantic import BaseModel

logger = logging.getLogger(__name__)
router = APIRouter()


class DebugResponse(BaseModel):
    """Debug response model"""
    timestamp: str
    user_id: str
    user_email: str
    user_role: str
    debug_info: Dict[str, Any]
    applications_found: List[Dict[str, Any]]
    error_logs: List[str]
    recommendations: List[str]


@router.get("/institutions/debug/applications")
async def debug_institution_applications(
    current_user: CurrentUser = Depends(require_institution)
) -> DebugResponse:
    """
    Comprehensive debug endpoint for institution applications

    This endpoint helps diagnose why institutions aren't seeing applications.

    **Returns:**
    - User authentication info
    - Applications query results
    - Database state
    - Potential issues and recommendations
    """
    error_logs = []
    recommendations = []
    debug_info = {}
    applications_found = []

    try:
        db = get_supabase_admin()  # Use admin client for data access
        timestamp = datetime.utcnow().isoformat()

        # 1. Log current user info
        logger.info(f"[DEBUG] Institution user accessing debug: {current_user.id} ({current_user.email})")
        debug_info["user_info"] = {
            "id": current_user.id,
            "email": current_user.email,
            "role": current_user.role,
            "authenticated": True
        }

        # 2. Check if institution exists in users table
        user_check = db.table('users').select('*').eq('id', current_user.id).execute()
        if not user_check.data:
            error_logs.append(f"Institution user {current_user.id} not found in users table")
            recommendations.append("Ensure institution user is properly registered in the users table")
        else:
            debug_info["institution_user"] = {
                "exists": True,
                "display_name": user_check.data[0].get('display_name'),
                "active_role": user_check.data[0].get('active_role'),
                "available_roles": user_check.data[0].get('available_roles', [])
            }

            # Verify it's actually an institution role
            if user_check.data[0].get('active_role') != 'institution':
                error_logs.append(f"User active_role is '{user_check.data[0].get('active_role')}', not 'institution'")
                recommendations.append("Update user's active_role to 'institution' in the database")

        # 3. Query applications for this institution
        logger.info(f"[DEBUG] Querying applications for institution_id: {current_user.id}")

        # Direct query
        apps_response = db.table('applications').select(
            'id, student_id, institution_id, program_id, status, created_at, submitted_at, is_submitted'
        ).eq('institution_id', current_user.id).execute()

        if apps_response.data:
            logger.info(f"[DEBUG] Found {len(apps_response.data)} applications for institution")
            applications_found = apps_response.data
            debug_info["applications_count"] = len(apps_response.data)
            debug_info["applications_by_status"] = {}

            for app in apps_response.data:
                app_status = app.get('status', 'unknown')
                if app_status not in debug_info["applications_by_status"]:
                    debug_info["applications_by_status"][app_status] = 0
                debug_info["applications_by_status"][app_status] += 1
        else:
            logger.warning(f"[DEBUG] No applications found for institution_id: {current_user.id}")
            error_logs.append(f"No applications found with institution_id = {current_user.id}")

            # Check if there are ANY applications in the database
            all_apps = db.table('applications').select('id, institution_id').execute()
            if all_apps.data:
                debug_info["total_applications_in_db"] = len(all_apps.data)

                # Get unique institution IDs
                unique_inst_ids = set(app.get('institution_id') for app in all_apps.data if app.get('institution_id'))
                debug_info["unique_institution_ids"] = list(unique_inst_ids)[:10]  # Show first 10

                if current_user.id not in unique_inst_ids:
                    error_logs.append("This institution has no applications in the entire database")
                    recommendations.append("Students need to submit applications to this institution first")
                    recommendations.append("Verify students are selecting the correct institution when applying")
            else:
                error_logs.append("No applications exist in the database at all")
                recommendations.append("Create test applications to verify the system")

        # 4. Check programs for this institution
        programs_response = db.table('programs').select('id, name, is_active').eq('institution_id', current_user.id).execute()
        if programs_response.data:
            debug_info["programs"] = {
                "count": len(programs_response.data),
                "active": len([p for p in programs_response.data if p.get('is_active', True)]),
                "program_ids": [p['id'] for p in programs_response.data]
            }
        else:
            error_logs.append("No programs found for this institution")
            recommendations.append("Create programs first before students can apply")

        # 5. Check courses for this institution
        courses_response = db.table('courses').select('id, title, status').eq('institution_id', current_user.id).execute()
        if courses_response.data:
            debug_info["courses"] = {
                "count": len(courses_response.data),
                "by_status": {}
            }
            for course in courses_response.data:
                course_status = course.get('status', 'unknown')
                if course_status not in debug_info["courses"]["by_status"]:
                    debug_info["courses"]["by_status"][course_status] = 0
                debug_info["courses"]["by_status"][course_status] += 1
        else:
            debug_info["courses"] = {"count": 0, "by_status": {}}

        # 6. Check enrollment permissions
        permissions_response = db.table('enrollment_permissions').select('id, status').eq('institution_id', current_user.id).execute()
        if permissions_response.data:
            debug_info["enrollment_permissions"] = {
                "count": len(permissions_response.data),
                "by_status": {}
            }
            for perm in permissions_response.data:
                perm_status = perm.get('status', 'unknown')
                if perm_status not in debug_info["enrollment_permissions"]["by_status"]:
                    debug_info["enrollment_permissions"]["by_status"][perm_status] = 0
                debug_info["enrollment_permissions"]["by_status"][perm_status] += 1
        else:
            debug_info["enrollment_permissions"] = {"count": 0, "by_status": {}}

        # 7. Check for common issues

        # Issue: Applications exist but with different institution_id format
        if not applications_found:
            # Check if there are applications with email as institution_id
            email_apps = db.table('applications').select('id, institution_id').eq('institution_id', current_user.email).execute()
            if email_apps.data:
                error_logs.append(f"Found {len(email_apps.data)} applications using email as institution_id instead of UUID")
                recommendations.append("Update applications to use institution UUID instead of email")
                debug_info["applications_with_email_id"] = len(email_apps.data)

        # Issue: Applications not submitted
        if applications_found:
            not_submitted = [app for app in applications_found if not app.get('is_submitted')]
            if not_submitted:
                debug_info["not_submitted_count"] = len(not_submitted)
                recommendations.append(f"{len(not_submitted)} applications are created but not submitted")

        # 8. Check RLS policies (simulated check)
        debug_info["rls_check"] = {
            "note": "Ensure RLS policies allow institutions to SELECT applications where institution_id = auth.uid()",
            "required_policy": "CREATE POLICY 'Institutions can view their applications' ON applications FOR SELECT USING (institution_id = auth.uid())"
        }

        # 9. Generate final recommendations
        if not error_logs:
            recommendations.append("No issues detected - institution should see applications")
        else:
            recommendations.append("Review and fix the errors listed above")

        return DebugResponse(
            timestamp=timestamp,
            user_id=current_user.id,
            user_email=current_user.email,
            user_role=current_user.role,
            debug_info=debug_info,
            applications_found=applications_found[:10],  # Limit to first 10 for readability
            error_logs=error_logs,
            recommendations=recommendations
        )

    except Exception as e:
        logger.error(f"Debug endpoint error: {str(e)}")
        error_logs.append(f"Debug endpoint error: {str(e)}")

        return DebugResponse(
            timestamp=datetime.utcnow().isoformat(),
            user_id=current_user.id,
            user_email=current_user.email,
            user_role=current_user.role,
            debug_info=debug_info,
            applications_found=[],
            error_logs=error_logs,
            recommendations=["Fix the debug endpoint error first"]
        )


@router.get("/institutions/debug/check-student-applications")
async def check_student_applications(
    student_id: Optional[str] = None,
    current_user: CurrentUser = Depends(require_institution)
) -> Dict[str, Any]:
    """
    Check applications from a specific student or all students

    **Parameters:**
    - student_id: Optional student ID to check (if not provided, checks all)

    **Returns:**
    - Application details and diagnostic information
    """
    try:
        db = get_supabase_admin()  # Use admin client for data access

        if student_id:
            # Check specific student
            apps = db.table('applications').select('*').eq('student_id', student_id).execute()

            # Find which institutions they applied to
            inst_apps = [app for app in (apps.data or []) if app.get('institution_id') == current_user.id]
            other_inst_apps = [app for app in (apps.data or []) if app.get('institution_id') != current_user.id]

            return {
                "student_id": student_id,
                "total_applications": len(apps.data) if apps.data else 0,
                "applications_to_your_institution": len(inst_apps),
                "applications_to_other_institutions": len(other_inst_apps),
                "your_applications": inst_apps,
                "diagnostic": {
                    "student_exists": len(apps.data) > 0 if apps.data else False,
                    "applied_to_you": len(inst_apps) > 0,
                    "institution_ids_applied_to": list(set(app.get('institution_id') for app in (apps.data or [])))
                }
            }
        else:
            # Check all applications
            all_apps = db.table('applications').select('id, student_id, institution_id, status, created_at').execute()

            if all_apps.data:
                # Group by institution
                by_institution = {}
                for app in all_apps.data:
                    inst_id = app.get('institution_id')
                    if inst_id not in by_institution:
                        by_institution[inst_id] = []
                    by_institution[inst_id].append(app)

                return {
                    "total_applications_in_system": len(all_apps.data),
                    "your_institution_id": current_user.id,
                    "applications_to_your_institution": len(by_institution.get(current_user.id, [])),
                    "sample_applications_to_you": by_institution.get(current_user.id, [])[:5],
                    "institutions_receiving_applications": list(by_institution.keys())[:10],
                    "diagnostic": {
                        "you_have_applications": current_user.id in by_institution,
                        "total_institutions_with_applications": len(by_institution)
                    }
                }
            else:
                return {
                    "total_applications_in_system": 0,
                    "message": "No applications exist in the database",
                    "recommendation": "Students need to create and submit applications first"
                }

    except Exception as e:
        logger.error(f"Check student applications error: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to check applications: {str(e)}"
        )
