"""
Parent Monitoring Data Models
Pydantic schemas for parent monitoring and student activity tracking
"""
from typing import Optional, List, Dict, Any
from pydantic import BaseModel, Field
from datetime import datetime
from enum import Enum


class LinkStatus(str, Enum):
    """Parent-student link status"""
    PENDING = "pending"  # Invitation sent, awaiting approval
    ACTIVE = "active"  # Link active
    DECLINED = "declined"  # Student declined
    REVOKED = "revoked"  # Parent or student revoked


class ActivityType(str, Enum):
    """Student activity types"""
    LOGIN = "login"
    COURSE_ENROLLMENT = "course_enrollment"
    COURSE_PROGRESS = "course_progress"
    ASSIGNMENT_SUBMISSION = "assignment_submission"
    GRADE_RECEIVED = "grade_received"
    APPLICATION_SUBMITTED = "application_submitted"
    APPLICATION_STATUS_CHANGE = "application_status_change"
    COUNSELING_SESSION = "counseling_session"
    ACHIEVEMENT_EARNED = "achievement_earned"
    MESSAGE_SENT = "message_sent"


class AlertType(str, Enum):
    """Alert types for parents"""
    LOW_ACTIVITY = "low_activity"  # Student inactive for X days
    POOR_PERFORMANCE = "poor_performance"  # Grades below threshold
    MISSED_DEADLINE = "missed_deadline"  # Missed assignment/application deadline
    NEW_GRADE = "new_grade"  # New grade posted
    COUNSELING_SCHEDULED = "counseling_scheduled"  # Session scheduled
    BEHAVIOR_CONCERN = "behavior_concern"  # Behavior flag from counselor
    ACHIEVEMENT = "achievement"  # New achievement earned


# Parent-Student Link Models
class ParentStudentLinkCreateRequest(BaseModel):
    """Request model for creating parent-student link"""
    student_id: str
    relationship: str = Field(..., max_length=50)  # e.g., "father", "mother", "guardian"
    can_view_grades: bool = True
    can_view_activity: bool = True
    can_view_messages: bool = False  # Privacy setting
    can_receive_alerts: bool = True


class ParentStudentLinkResponse(BaseModel):
    """Response model for parent-student link"""
    id: str
    parent_id: str
    student_id: str
    relationship: str
    status: str
    can_view_grades: bool
    can_view_activity: bool
    can_view_messages: bool
    can_receive_alerts: bool
    linked_at: Optional[str] = None
    created_at: str
    updated_at: str

    class Config:
        from_attributes = True


class ParentStudentLinkListResponse(BaseModel):
    """Response model for parent-student link list"""
    links: List[ParentStudentLinkResponse]
    total: int


class LinkPermissionsUpdateRequest(BaseModel):
    """Request model for updating link permissions"""
    can_view_grades: Optional[bool] = None
    can_view_activity: Optional[bool] = None
    can_view_messages: Optional[bool] = None
    can_receive_alerts: Optional[bool] = None


# Student Activity Models
class StudentActivityResponse(BaseModel):
    """Response model for student activity"""
    id: str
    student_id: str
    activity_type: str
    title: str
    description: Optional[str] = None
    metadata: Optional[Dict[str, Any]] = None
    timestamp: str
    created_at: str

    class Config:
        from_attributes = True


class StudentActivityListResponse(BaseModel):
    """Response model for student activity list"""
    activities: List[StudentActivityResponse]
    total: int
    page: int
    page_size: int
    has_more: bool


# Progress Report Models
class ProgressReportRequest(BaseModel):
    """Request model for generating progress report"""
    student_id: str
    report_period_start: str  # ISO date
    report_period_end: str  # ISO date
    include_courses: bool = True
    include_applications: bool = True
    include_counseling: bool = True
    include_achievements: bool = True


class CourseProgressSummary(BaseModel):
    """Summary of course progress"""
    course_id: str
    course_title: str
    enrollment_status: str
    progress_percentage: float
    grade: Optional[str] = None
    last_activity: Optional[str] = None


class ApplicationProgressSummary(BaseModel):
    """Summary of application progress"""
    application_id: str
    institution_name: str
    program_name: str
    status: str
    submitted_at: Optional[str] = None
    last_updated: str


class CounselingSessionSummary(BaseModel):
    """Summary of counseling sessions"""
    session_id: str
    counselor_name: str
    session_type: str
    status: str
    scheduled_start: str
    feedback_rating: Optional[float] = None


class ProgressReportResponse(BaseModel):
    """Response model for progress report"""
    student_id: str
    student_name: str
    report_period_start: str
    report_period_end: str
    generated_at: str

    # Overall statistics
    total_courses: int = 0
    active_courses: int = 0
    completed_courses: int = 0
    average_progress: float = 0.0

    total_applications: int = 0
    pending_applications: int = 0
    accepted_applications: int = 0

    total_counseling_sessions: int = 0
    completed_sessions: int = 0
    average_session_rating: Optional[float] = None

    total_achievements: int = 0
    achievements_this_period: int = 0

    # Detailed data
    courses: List[CourseProgressSummary] = Field(default_factory=list)
    applications: List[ApplicationProgressSummary] = Field(default_factory=list)
    counseling_sessions: List[CounselingSessionSummary] = Field(default_factory=list)
    recent_achievements: List[Dict[str, Any]] = Field(default_factory=list)

    # Activity summary
    total_activities: int = 0
    activities_by_type: Dict[str, int] = Field(default_factory=dict)
    most_active_day: Optional[str] = None


# Alert Settings Models
class AlertSettingsUpdateRequest(BaseModel):
    """Request model for updating alert settings"""
    low_activity_threshold_days: Optional[int] = Field(None, ge=1, le=30)
    poor_performance_threshold: Optional[float] = Field(None, ge=0.0, le=100.0)
    email_alerts_enabled: Optional[bool] = None
    push_alerts_enabled: Optional[bool] = None
    sms_alerts_enabled: Optional[bool] = None
    alert_types: Optional[Dict[str, bool]] = None  # Enable/disable specific alert types


class AlertSettingsResponse(BaseModel):
    """Response model for alert settings"""
    id: str
    parent_id: str
    student_id: str
    low_activity_threshold_days: int = 7
    poor_performance_threshold: float = 70.0
    email_alerts_enabled: bool = True
    push_alerts_enabled: bool = True
    sms_alerts_enabled: bool = False
    alert_types: Dict[str, bool] = Field(default_factory=dict)
    created_at: str
    updated_at: str

    class Config:
        from_attributes = True


# Parent Alert Models
class ParentAlertResponse(BaseModel):
    """Response model for parent alert"""
    id: str
    parent_id: str
    student_id: str
    alert_type: str
    title: str
    message: str
    severity: str  # "low", "medium", "high"
    is_read: bool = False
    read_at: Optional[str] = None
    action_url: Optional[str] = None
    metadata: Optional[Dict[str, Any]] = None
    created_at: str

    class Config:
        from_attributes = True


class ParentAlertListResponse(BaseModel):
    """Response model for parent alert list"""
    alerts: List[ParentAlertResponse]
    total: int
    unread_count: int
    page: int
    page_size: int
    has_more: bool


# Dashboard Statistics Models
class ParentDashboardStats(BaseModel):
    """Statistics for parent dashboard"""
    student_id: str
    student_name: str

    # Current status
    is_active: bool  # Active in last 7 days
    last_activity: Optional[str] = None

    # Courses
    active_courses: int
    average_course_progress: float
    courses_at_risk: int  # Progress < 50% and past midpoint

    # Applications
    total_applications: int
    pending_applications: int
    accepted_applications: int
    rejected_applications: int

    # Counseling
    upcoming_sessions: int
    completed_sessions_this_month: int
    average_counseling_rating: Optional[float] = None

    # Performance
    average_grade: Optional[float] = None
    achievements_count: int
    achievements_this_month: int

    # Alerts
    unread_alerts: int
    high_severity_alerts: int

    # Activity summary (last 30 days)
    total_activities_last_30_days: int
    most_frequent_activity_type: Optional[str] = None

    # Time tracking
    total_study_time_hours: float = 0.0  # If focus mode data available
    average_daily_study_time: float = 0.0


class MultiStudentDashboardResponse(BaseModel):
    """Response model for parent with multiple students"""
    parent_id: str
    students: List[ParentDashboardStats]
    total_students: int
    summary: Dict[str, Any] = Field(default_factory=dict)


# Child Models (for frontend compatibility)
class ChildApplicationResponse(BaseModel):
    """Child application for parent view"""
    id: str
    institutionName: str
    programName: str
    status: str
    submittedAt: str


class ChildResponse(BaseModel):
    """Child response model matching frontend Child model"""
    id: str
    parentId: str
    name: str
    email: str
    dateOfBirth: str
    photoUrl: Optional[str] = None
    schoolName: Optional[str] = None
    grade: str
    enrolledCourses: List[str] = Field(default_factory=list)
    applications: List[ChildApplicationResponse] = Field(default_factory=list)
    averageGrade: float = 0.0
    lastActive: str

    class Config:
        from_attributes = True


class ChildListResponse(BaseModel):
    """Response model for children list"""
    children: List[ChildResponse]
    total: int


class ChildEnrollmentResponse(BaseModel):
    """Enrollment response for child"""
    id: str
    courseName: str
    completionPercentage: float = 0.0
    currentGrade: float = 0.0
    assignmentsCompleted: int = 0
    totalAssignments: int = 0
    lastActivity: str


class AddChildRequest(BaseModel):
    """Request model for adding a child"""
    student_id: str
    relationship: str = "parent"


# Email-based Linking Models
class LinkByEmailRequest(BaseModel):
    """Request model for creating parent-student link by email"""
    student_email: str = Field(..., description="Student's email address")
    relationship: str = Field("parent", max_length=50)  # e.g., "father", "mother", "guardian"
    can_view_grades: bool = True
    can_view_activity: bool = True
    can_view_messages: bool = False  # Privacy setting
    can_receive_alerts: bool = True


class LinkByEmailResponse(BaseModel):
    """Response model for email-based link request"""
    success: bool
    message: str
    link_id: Optional[str] = None
    student_name: Optional[str] = None
    status: str = "pending"


# Invite Code Models
class InviteCodeCreateRequest(BaseModel):
    """Request model for generating invite code"""
    expires_in_days: int = Field(7, ge=1, le=30, description="Days until code expires")
    max_uses: int = Field(1, ge=1, le=5, description="Maximum number of times code can be used")


class InviteCodeResponse(BaseModel):
    """Response model for invite code"""
    id: str
    code: str
    student_id: str
    expires_at: str
    max_uses: int
    uses_remaining: int
    is_active: bool
    created_at: str

    class Config:
        from_attributes = True


class InviteCodeListResponse(BaseModel):
    """Response model for invite code list"""
    codes: List[InviteCodeResponse]
    total: int


class UseInviteCodeRequest(BaseModel):
    """Request model for parent using invite code"""
    code: str = Field(..., min_length=6, max_length=12, description="Invite code from student")
    relationship: str = Field("parent", max_length=50)


class UseInviteCodeResponse(BaseModel):
    """Response model for using invite code"""
    success: bool
    message: str
    link_id: Optional[str] = None
    student_name: Optional[str] = None
    student_email: Optional[str] = None
    status: str = "pending"


# Pending Links for Student View
class PendingLinkResponse(BaseModel):
    """Response model for pending link (student view)"""
    id: str
    parent_id: str
    parent_name: str
    parent_email: str
    relationship: str
    requested_permissions: Dict[str, bool]
    created_at: str

    class Config:
        from_attributes = True


class PendingLinksListResponse(BaseModel):
    """Response model for pending links list"""
    links: List[PendingLinkResponse]
    total: int
