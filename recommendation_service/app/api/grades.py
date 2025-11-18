"""
Grades API Endpoints
Handles student grade viewing and parent-child grade sync
"""
from fastapi import APIRouter, Depends, HTTPException, status, Query
from typing import List, Optional

from app.services.grades_service import GradesService
from app.schemas.grades import (
    StudentGradesResponse,
    ChildGradesSummary,
    GPAHistoryResponse,
    GradeAlertResponse
)
from app.database.config import get_db
from supabase import Client

router = APIRouter()


# ==================== Student Endpoints ====================

@router.get("/students/{student_id}/grades", response_model=StudentGradesResponse)
async def get_student_grades(
    student_id: str,
    school_year: Optional[str] = Query(None),
    semester: Optional[str] = Query(None),
    db: Client = Depends(get_db)
):
    """
    Get all grades for a student

    **Path Parameters:**
    - student_id: Student's user ID

    **Query Parameters:**
    - school_year: Optional filter (e.g., "2024-2025")
    - semester: Optional filter (Fall, Spring, Summer)

    **Returns:**
    - Complete student grades with course summaries
    - Current and cumulative GPA
    - Missing and late assignments count
    """
    try:
        service = GradesService(db)
        return await service.get_student_grades(student_id, school_year, semester)

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e)
        )


@router.get("/students/{student_id}/gpa-history", response_model=List[GPAHistoryResponse])
async def get_student_gpa_history(
    student_id: str,
    limit: int = Query(10, ge=1, le=50),
    db: Client = Depends(get_db)
):
    """
    Get GPA history for a student

    **Path Parameters:**
    - student_id: Student's user ID

    **Query Parameters:**
    - limit: Maximum records to return (1-50, default 10)

    **Returns:**
    - Historical GPA records by semester/year
    - Cumulative GPA progression
    - Class rank history
    """
    try:
        service = GradesService(db)
        return await service.get_gpa_history(student_id, limit)

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e)
        )


# ==================== Parent Endpoints ====================

@router.get("/parents/{parent_id}/children/{child_id}/grades", response_model=ChildGradesSummary)
async def get_child_grades(
    parent_id: str,
    child_id: str,
    db: Client = Depends(get_db)
):
    """
    Get grades for a parent's child

    **Path Parameters:**
    - parent_id: Parent's user ID
    - child_id: Child/student's user ID

    **Authorization:**
    - Verifies parent-child relationship
    - Checks grade viewing permissions

    **Returns:**
    - Child's complete grade summary
    - Recent grade alerts
    - Missing assignments count
    """
    try:
        service = GradesService(db)
        return await service.get_child_grades(parent_id, child_id)

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


@router.get("/parents/{parent_id}/children/{child_id}/gpa", response_model=List[GPAHistoryResponse])
async def get_child_gpa_history(
    parent_id: str,
    child_id: str,
    limit: int = Query(10, ge=1, le=50),
    db: Client = Depends(get_db)
):
    """
    Get GPA history for a parent's child

    **Path Parameters:**
    - parent_id: Parent's user ID
    - child_id: Child/student's user ID

    **Query Parameters:**
    - limit: Maximum records to return (1-50, default 10)

    **Authorization:**
    - Verifies parent-child relationship
    - Checks grade viewing permissions

    **Returns:**
    - Historical GPA records
    """
    try:
        # Verify relationship and permissions
        service = GradesService(db)

        # First verify the relationship exists and has permissions
        relationship = db.table('parent_children')\
            .select('can_view_grades')\
            .eq('parent_id', parent_id)\
            .eq('child_id', child_id)\
            .single()\
            .execute()

        if not relationship.data:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Parent-child relationship not found"
            )

        if not relationship.data.get('can_view_grades'):
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Parent does not have permission to view grades"
            )

        # Get GPA history
        return await service.get_gpa_history(child_id, limit)

    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e)
        )


# ==================== Grade Alert Endpoints ====================

@router.get("/parents/{parent_id}/alerts", response_model=List[GradeAlertResponse])
async def get_parent_alerts(
    parent_id: str,
    unread_only: bool = Query(False),
    limit: int = Query(50, ge=1, le=100),
    db: Client = Depends(get_db)
):
    """
    Get grade alerts for a parent

    **Path Parameters:**
    - parent_id: Parent's user ID

    **Query Parameters:**
    - unread_only: Only return unread alerts (default: false)
    - limit: Maximum alerts to return (1-100, default 50)

    **Returns:**
    - List of grade alerts sorted by newest first
    """
    try:
        query = db.table('grade_alerts')\
            .select('*')\
            .eq('parent_id', parent_id)

        if unread_only:
            query = query.eq('is_read', False)

        result = query.order('created_at', desc=True)\
            .limit(limit)\
            .execute()

        return [GradeAlertResponse(**alert) for alert in (result.data or [])]

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e)
        )


@router.put("/alerts/{alert_id}/mark-read", response_model=GradeAlertResponse)
async def mark_alert_read(
    alert_id: str,
    parent_id: str = Query(..., description="Parent's user ID"),
    db: Client = Depends(get_db)
):
    """
    Mark a grade alert as read

    **Path Parameters:**
    - alert_id: Alert ID

    **Query Parameters:**
    - parent_id: Parent's user ID (for authorization)

    **Returns:**
    - Updated alert
    """
    try:
        service = GradesService(db)
        return await service.mark_alert_read(alert_id, parent_id)

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


# ==================== Statistics Endpoints ====================

@router.get("/students/{student_id}/grade-statistics")
async def get_grade_statistics(
    student_id: str,
    db: Client = Depends(get_db)
):
    """
    Get grade statistics and analytics for a student

    **Path Parameters:**
    - student_id: Student's user ID

    **Returns:**
    - Overall grade average
    - Trend analysis (improving/declining/stable)
    - Course-by-course breakdown
    - Comparison to class averages (if available)
    """
    try:
        # Get all student grades
        service = GradesService(db)
        student_grades = await service.get_student_grades(student_id)

        # Calculate statistics
        all_percentages = []
        course_stats = []

        for course in student_grades.courses:
            if course.current_percentage:
                all_percentages.append(course.current_percentage)

            course_stats.append({
                'course_name': course.course.course_name,
                'course_code': course.course.course_code,
                'current_percentage': course.current_percentage,
                'letter_grade': course.current_letter_grade,
                'missing_assignments': course.missing_assignments,
                'late_assignments': course.late_assignments
            })

        # Calculate overall statistics
        overall_average = sum(all_percentages) / len(all_percentages) if all_percentages else None

        # Determine trend (simplified - could be enhanced with historical data)
        trend = "stable"
        if overall_average:
            if overall_average >= 90:
                trend = "excellent"
            elif overall_average >= 80:
                trend = "good"
            elif overall_average >= 70:
                trend = "satisfactory"
            else:
                trend = "needs_improvement"

        return {
            'student_id': student_id,
            'overall_average': overall_average,
            'current_gpa': student_grades.current_gpa,
            'cumulative_gpa': student_grades.cumulative_gpa,
            'trend': trend,
            'total_courses': len(student_grades.courses),
            'total_missing_assignments': sum(c.missing_assignments for c in student_grades.courses),
            'course_statistics': course_stats
        }

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e)
        )
