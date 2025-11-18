"""
Grades Schemas
Data models for grade tracking and parent-child grade sync
"""
from typing import Optional, List
from pydantic import BaseModel, Field
from datetime import date, datetime
from enum import Enum


class GradeCategory(str, Enum):
    """Categories for assignments/assessments"""
    QUIZ = "quiz"
    ASSIGNMENT = "assignment"
    EXAM = "exam"
    PROJECT = "project"
    PARTICIPATION = "participation"
    HOMEWORK = "homework"
    LAB = "lab"
    PRESENTATION = "presentation"


class GradeStatus(str, Enum):
    """Status of a grade"""
    PENDING = "pending"
    SUBMITTED = "submitted"
    GRADED = "graded"
    LATE = "late"
    MISSING = "missing"
    EXCUSED = "excused"


class EnrollmentStatus(str, Enum):
    """Status of course enrollment"""
    ACTIVE = "active"
    COMPLETED = "completed"
    DROPPED = "dropped"
    WITHDRAWN = "withdrawn"


class AlertType(str, Enum):
    """Types of grade alerts"""
    GRADE_DROP = "grade_drop"
    MISSING_ASSIGNMENT = "missing_assignment"
    LOW_GRADE = "low_grade"
    IMPROVED_GRADE = "improved_grade"
    COURSE_FAILING = "course_failing"


class AlertSeverity(str, Enum):
    """Severity levels for alerts"""
    LOW = "low"
    MEDIUM = "medium"
    HIGH = "high"
    CRITICAL = "critical"


# ==================== Grade Models ====================

class GradeBase(BaseModel):
    """Base grade model"""
    assignment_name: str
    category: GradeCategory
    points_earned: Optional[float] = None
    points_possible: Optional[float] = None
    percentage: Optional[float] = Field(None, ge=0, le=100)
    letter_grade: Optional[str] = None
    weight: float = Field(1.0, ge=0)
    assigned_date: Optional[date] = None
    due_date: Optional[date] = None
    submitted_date: Optional[date] = None
    graded_date: Optional[date] = None
    status: GradeStatus = GradeStatus.GRADED
    is_extra_credit: bool = False
    teacher_comments: Optional[str] = None


class GradeCreate(GradeBase):
    """Create new grade"""
    student_id: str
    course_id: str
    enrollment_id: str


class GradeResponse(GradeBase):
    """Grade response"""
    id: str
    student_id: str
    course_id: str
    enrollment_id: str
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


# ==================== Course Models ====================

class CourseBase(BaseModel):
    """Base course model"""
    course_code: str
    course_name: str
    school_year: str
    semester: Optional[str] = None
    credits: Optional[float] = None
    description: Optional[str] = None


class CourseCreate(CourseBase):
    """Create new course"""
    teacher_id: Optional[str] = None


class CourseResponse(CourseBase):
    """Course response"""
    id: str
    teacher_id: Optional[str] = None
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


# ==================== Enrollment Models ====================

class EnrollmentBase(BaseModel):
    """Base enrollment model"""
    enrollment_date: date
    status: EnrollmentStatus = EnrollmentStatus.ACTIVE
    final_grade: Optional[str] = None
    final_percentage: Optional[float] = Field(None, ge=0, le=100)
    gpa_points: Optional[float] = Field(None, ge=0, le=4)


class EnrollmentCreate(EnrollmentBase):
    """Create new enrollment"""
    student_id: str
    course_id: str


class EnrollmentResponse(EnrollmentBase):
    """Enrollment response with course details"""
    id: str
    student_id: str
    course_id: str
    course: Optional[CourseResponse] = None
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


# ==================== GPA Models ====================

class GPAHistoryBase(BaseModel):
    """Base GPA history model"""
    school_year: str
    semester: Optional[str] = None
    gpa: float = Field(..., ge=0, le=4)
    weighted_gpa: Optional[float] = Field(None, ge=0, le=5)
    cumulative_gpa: Optional[float] = Field(None, ge=0, le=4)
    credits_attempted: Optional[float] = None
    credits_earned: Optional[float] = None
    class_rank: Optional[int] = None
    class_size: Optional[int] = None
    percentile: Optional[float] = Field(None, ge=0, le=100)


class GPAHistoryCreate(GPAHistoryBase):
    """Create GPA history record"""
    student_id: str


class GPAHistoryResponse(GPAHistoryBase):
    """GPA history response"""
    id: str
    student_id: str
    calculated_at: datetime
    created_at: datetime

    class Config:
        from_attributes = True


# ==================== Parent-Child Models ====================

class ParentChildBase(BaseModel):
    """Base parent-child relationship"""
    relationship_type: str = "parent"
    is_primary: bool = False
    can_view_grades: bool = True
    can_view_attendance: bool = True
    can_view_discipline: bool = True


class ParentChildCreate(ParentChildBase):
    """Create parent-child relationship"""
    parent_id: str
    child_id: str


class ParentChildResponse(ParentChildBase):
    """Parent-child relationship response"""
    id: str
    parent_id: str
    child_id: str
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


# ==================== Alert Models ====================

class GradeAlertBase(BaseModel):
    """Base grade alert model"""
    alert_type: AlertType
    severity: AlertSeverity = AlertSeverity.MEDIUM
    title: str
    message: str
    current_value: Optional[str] = None
    previous_value: Optional[str] = None
    threshold_value: Optional[str] = None


class GradeAlertCreate(GradeAlertBase):
    """Create grade alert"""
    student_id: str
    parent_id: str
    grade_id: Optional[str] = None
    course_id: Optional[str] = None


class GradeAlertResponse(GradeAlertBase):
    """Grade alert response"""
    id: str
    student_id: str
    parent_id: str
    grade_id: Optional[str] = None
    course_id: Optional[str] = None
    is_read: bool
    is_acknowledged: bool
    read_at: Optional[datetime] = None
    acknowledged_at: Optional[datetime] = None
    created_at: datetime

    class Config:
        from_attributes = True


# ==================== Aggregate/Summary Models ====================

class CourseGradeSummary(BaseModel):
    """Summary of grades for a course"""
    course: CourseResponse
    enrollment: EnrollmentResponse
    current_percentage: Optional[float] = None
    current_letter_grade: Optional[str] = None
    grades_count: int
    missing_assignments: int
    late_assignments: int
    category_averages: dict  # {"quiz": 85.5, "exam": 92.0, ...}


class StudentGradesResponse(BaseModel):
    """Complete student grades response"""
    student_id: str
    courses: List[CourseGradeSummary]
    current_gpa: Optional[float] = None
    cumulative_gpa: Optional[float] = None


class ChildGradesSummary(BaseModel):
    """Summary for parent viewing child's grades"""
    child_id: str
    child_name: str
    courses: List[CourseGradeSummary]
    current_gpa: Optional[float] = None
    recent_alerts: List[GradeAlertResponse]
    total_missing_assignments: int


class GradeAnalytics(BaseModel):
    """Grade analytics and trends"""
    student_id: str
    course_id: Optional[str] = None

    # Overall stats
    average_grade: float
    highest_grade: float
    lowest_grade: float

    # Trends
    trend: str  # "improving", "declining", "stable"
    trend_percentage: float  # How much change

    # Comparisons
    class_average: Optional[float] = None
    percentile: Optional[float] = None

    # Predictions
    predicted_final_grade: Optional[float] = None
    predicted_letter_grade: Optional[str] = None
