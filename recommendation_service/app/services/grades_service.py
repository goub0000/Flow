"""
Grades Service
Business logic for grade tracking and parent-child grade sync
"""
import logging
from typing import List, Optional, Dict, Any
from datetime import datetime, date
from uuid import uuid4

from supabase import Client

from app.schemas.grades import (
    GradeResponse,
    StudentGradesResponse,
    ChildGradesSummary,
    CourseGradeSummary,
    GPAHistoryResponse,
    GradeAlertResponse,
    GradeAnalytics,
    AlertType,
    AlertSeverity
)

logger = logging.getLogger(__name__)


class GradesService:
    """Service for managing student grades and parent access"""

    def __init__(self, db: Client):
        self.db = db

    async def get_student_grades(
        self,
        student_id: str,
        school_year: Optional[str] = None,
        semester: Optional[str] = None
    ) -> StudentGradesResponse:
        """
        Get all grades for a student

        Args:
            student_id: Student's user ID
            school_year: Optional filter by school year
            semester: Optional filter by semester

        Returns:
            Complete student grades with course summaries
        """
        try:
            # Get enrollments with course details
            query = self.db.table('course_enrollments')\
                .select('*, courses(*)')\
                .eq('student_id', student_id)\
                .eq('status', 'active')

            if school_year:
                query = query.eq('courses.school_year', school_year)
            if semester:
                query = query.eq('courses.semester', semester)

            enrollments_result = query.execute()
            enrollments = enrollments_result.data if enrollments_result.data else []

            course_summaries = []

            for enrollment in enrollments:
                course_id = enrollment['course_id']

                # Get all grades for this course
                grades_result = self.db.table('grades')\
                    .select('*')\
                    .eq('student_id', student_id)\
                    .eq('course_id', course_id)\
                    .execute()

                grades = grades_result.data if grades_result.data else []

                # Calculate course statistics
                summary = self._calculate_course_summary(enrollment, grades)
                course_summaries.append(summary)

            # Get current GPA
            current_gpa = await self._get_current_gpa(student_id)

            return StudentGradesResponse(
                student_id=student_id,
                courses=course_summaries,
                current_gpa=current_gpa.get('gpa') if current_gpa else None,
                cumulative_gpa=current_gpa.get('cumulative_gpa') if current_gpa else None
            )

        except Exception as e:
            logger.error(f"Error fetching student grades: {e}")
            raise

    async def get_child_grades(
        self,
        parent_id: str,
        child_id: str
    ) -> ChildGradesSummary:
        """
        Get grades for a parent's child

        Args:
            parent_id: Parent's user ID
            child_id: Child/student's user ID

        Returns:
            Child's grades summary with alerts
        """
        try:
            # Verify parent-child relationship
            relationship = self.db.table('parent_children')\
                .select('*')\
                .eq('parent_id', parent_id)\
                .eq('child_id', child_id)\
                .single()\
                .execute()

            if not relationship.data:
                raise ValueError("Parent-child relationship not found")

            if not relationship.data.get('can_view_grades'):
                raise ValueError("Parent does not have permission to view grades")

            # Get student grades
            student_grades = await self.get_student_grades(child_id)

            # Get child's name
            child_result = self.db.table('users')\
                .select('display_name, full_name, email')\
                .eq('id', child_id)\
                .single()\
                .execute()

            child_name = child_result.data.get('display_name') or \
                        child_result.data.get('full_name') or \
                        child_result.data.get('email', 'Student')

            # Get recent alerts
            alerts_result = self.db.table('grade_alerts')\
                .select('*')\
                .eq('parent_id', parent_id)\
                .eq('student_id', child_id)\
                .order('created_at', desc=True)\
                .limit(10)\
                .execute()

            alerts = [GradeAlertResponse(**alert) for alert in (alerts_result.data or [])]

            # Count total missing assignments
            total_missing = sum(
                course.missing_assignments
                for course in student_grades.courses
            )

            return ChildGradesSummary(
                child_id=child_id,
                child_name=child_name,
                courses=student_grades.courses,
                current_gpa=student_grades.current_gpa,
                recent_alerts=alerts,
                total_missing_assignments=total_missing
            )

        except ValueError as e:
            raise
        except Exception as e:
            logger.error(f"Error fetching child grades: {e}")
            raise

    async def get_gpa_history(
        self,
        student_id: str,
        limit: int = 10
    ) -> List[GPAHistoryResponse]:
        """Get GPA history for a student"""
        try:
            result = self.db.table('gpa_history')\
                .select('*')\
                .eq('student_id', student_id)\
                .order('school_year', desc=True)\
                .order('semester', desc=True)\
                .limit(limit)\
                .execute()

            return [GPAHistoryResponse(**record) for record in (result.data or [])]

        except Exception as e:
            logger.error(f"Error fetching GPA history: {e}")
            raise

    async def create_grade_alert(
        self,
        student_id: str,
        parent_id: str,
        alert_type: AlertType,
        severity: AlertSeverity,
        title: str,
        message: str,
        course_id: Optional[str] = None,
        grade_id: Optional[str] = None,
        current_value: Optional[str] = None,
        previous_value: Optional[str] = None,
        threshold_value: Optional[str] = None
    ) -> GradeAlertResponse:
        """Create a grade alert for a parent"""
        try:
            alert_data = {
                'id': str(uuid4()),
                'student_id': student_id,
                'parent_id': parent_id,
                'alert_type': alert_type.value,
                'severity': severity.value,
                'title': title,
                'message': message,
                'course_id': course_id,
                'grade_id': grade_id,
                'current_value': current_value,
                'previous_value': previous_value,
                'threshold_value': threshold_value,
                'is_read': False,
                'is_acknowledged': False,
                'created_at': datetime.utcnow().isoformat()
            }

            result = self.db.table('grade_alerts').insert(alert_data).execute()

            return GradeAlertResponse(**result.data[0])

        except Exception as e:
            logger.error(f"Error creating grade alert: {e}")
            raise

    async def mark_alert_read(
        self,
        alert_id: str,
        parent_id: str
    ) -> GradeAlertResponse:
        """Mark an alert as read"""
        try:
            update_data = {
                'is_read': True,
                'read_at': datetime.utcnow().isoformat()
            }

            result = self.db.table('grade_alerts')\
                .update(update_data)\
                .eq('id', alert_id)\
                .eq('parent_id', parent_id)\
                .execute()

            if not result.data:
                raise ValueError("Alert not found")

            return GradeAlertResponse(**result.data[0])

        except Exception as e:
            logger.error(f"Error marking alert as read: {e}")
            raise

    def _calculate_course_summary(
        self,
        enrollment: Dict[str, Any],
        grades: List[Dict[str, Any]]
    ) -> CourseGradeSummary:
        """Calculate summary statistics for a course"""
        from app.schemas.grades import CourseResponse, EnrollmentResponse

        course = CourseResponse(**enrollment['courses'])
        enrollment_data = {k: v for k, v in enrollment.items() if k != 'courses'}
        enrollment_resp = EnrollmentResponse(course=course, **enrollment_data)

        # Calculate category averages
        category_totals = {}
        category_counts = {}

        missing_count = 0
        late_count = 0

        for grade in grades:
            if grade.get('status') == 'missing':
                missing_count += 1
                continue
            if grade.get('status') == 'late':
                late_count += 1

            if grade.get('percentage') is not None:
                category = grade.get('category')
                if category:
                    if category not in category_totals:
                        category_totals[category] = 0
                        category_counts[category] = 0
                    category_totals[category] += grade['percentage']
                    category_counts[category] += 1

        category_averages = {
            cat: category_totals[cat] / category_counts[cat]
            for cat in category_totals
        }

        # Calculate current course percentage
        if category_averages:
            current_percentage = sum(category_averages.values()) / len(category_averages)
        else:
            current_percentage = None

        # Determine letter grade
        current_letter_grade = self._percentage_to_letter(current_percentage) if current_percentage else None

        return CourseGradeSummary(
            course=course,
            enrollment=enrollment_resp,
            current_percentage=current_percentage,
            current_letter_grade=current_letter_grade,
            grades_count=len(grades),
            missing_assignments=missing_count,
            late_assignments=late_count,
            category_averages=category_averages
        )

    async def _get_current_gpa(self, student_id: str) -> Optional[Dict[str, float]]:
        """Get most recent GPA for a student"""
        try:
            result = self.db.table('gpa_history')\
                .select('gpa, cumulative_gpa')\
                .eq('student_id', student_id)\
                .order('calculated_at', desc=True)\
                .limit(1)\
                .execute()

            return result.data[0] if result.data else None

        except Exception:
            return None

    def _percentage_to_letter(self, percentage: float) -> str:
        """Convert percentage to letter grade"""
        if percentage >= 97:
            return "A+"
        elif percentage >= 93:
            return "A"
        elif percentage >= 90:
            return "A-"
        elif percentage >= 87:
            return "B+"
        elif percentage >= 83:
            return "B"
        elif percentage >= 80:
            return "B-"
        elif percentage >= 77:
            return "C+"
        elif percentage >= 73:
            return "C"
        elif percentage >= 70:
            return "C-"
        elif percentage >= 67:
            return "D+"
        elif percentage >= 63:
            return "D"
        elif percentage >= 60:
            return "D-"
        else:
            return "F"
