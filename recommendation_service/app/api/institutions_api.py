"""
Institutions API Endpoints
Handles fetching registered institutions (users with 'institution' role)
and institution analytics (Phase 4.3)
"""
from fastapi import APIRouter, Depends, HTTPException, Query, status
from typing import List, Optional, Dict
import logging
from datetime import datetime, timedelta
from collections import defaultdict

from app.database.config import get_supabase
from app.utils.security import get_current_user, CurrentUser
from pydantic import BaseModel

logger = logging.getLogger(__name__)
router = APIRouter()


class InstitutionResponse(BaseModel):
    """Institution response model"""
    id: str
    name: str
    email: str
    phone_number: Optional[str] = None
    photo_url: Optional[str] = None
    created_at: Optional[str] = None
    is_verified: bool = False
    programs_count: int = 0
    courses_count: int = 0

    class Config:
        from_attributes = True


class InstitutionsListResponse(BaseModel):
    """Institutions list with pagination"""
    institutions: List[InstitutionResponse]
    total: int
    page: int
    page_size: int


@router.get("/institutions", response_model=InstitutionsListResponse)
async def get_institutions(
    search: Optional[str] = Query(None, description="Search by institution name or email"),
    page: int = Query(1, ge=1, description="Page number"),
    page_size: int = Query(20, ge=1, le=100, description="Items per page"),
    is_verified: Optional[bool] = Query(None, description="Filter by verification status"),
    current_user: CurrentUser = Depends(get_current_user)
):
    """
    Get list of registered institutions (users with 'institution' role)

    This endpoint returns only institutions that are registered users in the Flow platform,
    NOT the universities from the recommendation database.

    **Use this for:**
    - Browsing institutions to apply to
    - Selecting institution for creating applications
    - Institution directory

    **Query Parameters:**
    - search: Search by name or email
    - page: Page number (starts at 1)
    - page_size: Number of items per page (max 100)
    - is_verified: Filter by email verification status

    **Returns:**
    - List of registered institutions with their basic info
    - Total count for pagination
    """
    try:
        db = get_supabase()

        # Calculate offset for pagination
        offset = (page - 1) * page_size

        # Build query - fetch users with 'institution' role
        query = db.table('users').select(
            'id, display_name, email, phone_number, photo_url, '
            'created_at, email_verified, metadata',
            count='exact'
        ).in_('active_role', ['institution']).or_(
            'available_roles.cs.{institution}'
        )

        # Apply search filter
        if search:
            search_lower = search.lower()
            # Note: Supabase doesn't support case-insensitive search directly,
            # we'll filter on the backend side after fetching
            pass

        # Apply verification filter
        if is_verified is not None:
            query = query.eq('email_verified', is_verified)

        # Apply ordering
        query = query.order('display_name', desc=False)

        # Apply pagination
        query = query.range(offset, offset + page_size - 1)

        # Execute query
        response = query.execute()

        institutions_data = response.data
        total = response.count if hasattr(response, 'count') else len(institutions_data)

        # Apply search filter on backend if search is provided
        if search:
            search_lower = search.lower()
            institutions_data = [
                inst for inst in institutions_data
                if search_lower in (inst.get('display_name', '') or '').lower()
                or search_lower in (inst.get('email', '') or '').lower()
            ]
            total = len(institutions_data)

        # Get program counts for each institution
        institutions = []
        for inst in institutions_data:
            # Count programs
            programs_response = db.table('programs').select(
                'id', count='exact'
            ).eq('institution_id', inst['id']).execute()
            programs_count = programs_response.count if hasattr(programs_response, 'count') else 0

            institutions.append(InstitutionResponse(
                id=inst['id'],
                name=inst.get('display_name', 'Unnamed Institution'),
                email=inst['email'],
                phone_number=inst.get('phone_number'),
                photo_url=inst.get('photo_url'),
                created_at=inst.get('created_at'),
                is_verified=inst.get('email_verified', False),
                programs_count=programs_count,
                courses_count=0  # Courses removed from system
            ))

        logger.info(
            f"User {current_user.id} fetched {len(institutions)} institutions "
            f"(page {page}, total {total})"
        )

        return InstitutionsListResponse(
            institutions=institutions,
            total=total,
            page=page,
            page_size=page_size
        )

    except Exception as e:
        logger.error(f"Error fetching institutions: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to fetch institutions: {str(e)}"
        )


@router.get("/institutions/{institution_id}", response_model=InstitutionResponse)
async def get_institution(
    institution_id: str,
    current_user: CurrentUser = Depends(get_current_user)
):
    """
    Get a specific institution by ID

    **Path Parameters:**
    - institution_id: UUID of the institution user

    **Returns:**
    - Institution details including programs and courses count
    """
    try:
        db = get_supabase()

        # Fetch institution
        response = db.table('users').select(
            'id, display_name, email, phone_number, photo_url, '
            'created_at, email_verified, active_role, available_roles'
        ).eq('id', institution_id).execute()

        if not response.data:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Institution with ID {institution_id} not found"
            )

        inst = response.data[0]

        # Verify it's an institution
        if inst.get('active_role') != 'institution' and 'institution' not in inst.get('available_roles', []):
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="The specified user is not an institution"
            )

        # Count programs
        programs_response = db.table('programs').select(
            'id', count='exact'
        ).eq('institution_id', institution_id).execute()
        programs_count = programs_response.count if hasattr(programs_response, 'count') else 0

        return InstitutionResponse(
            id=inst['id'],
            name=inst.get('display_name', 'Unnamed Institution'),
            email=inst['email'],
            phone_number=inst.get('phone_number'),
            photo_url=inst.get('photo_url'),
            created_at=inst.get('created_at'),
            is_verified=inst.get('email_verified', False),
            programs_count=programs_count,
            courses_count=0  # Courses removed from system
        )

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error fetching institution {institution_id}: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to fetch institution: {str(e)}"
        )


# ==================== INSTITUTION ANALYTICS MODELS (Phase 4.3) ====================

class FunnelStageData(BaseModel):
    """Data for a single funnel stage"""
    stage: str
    count: int
    percentage: float
    conversion_rate: Optional[float] = None


class ApplicationFunnelResponse(BaseModel):
    """Application funnel analytics response"""
    total_viewed: int
    total_started: int
    total_submitted: int
    total_reviewed: int
    total_accepted: int
    stages: List[FunnelStageData]
    overall_conversion_rate: float


class DemographicDistribution(BaseModel):
    """Demographic distribution data"""
    label: str
    count: int
    percentage: float


class ApplicantDemographicsResponse(BaseModel):
    """Applicant demographics analytics response"""
    total_applicants: int
    location_distribution: List[DemographicDistribution]
    age_distribution: List[DemographicDistribution]
    academic_background_distribution: List[DemographicDistribution]


class ProgramMetrics(BaseModel):
    """Metrics for a single program"""
    program_id: str
    program_name: str
    views: int
    applications: int
    acceptances: int
    acceptance_rate: float


class ProgramPopularityResponse(BaseModel):
    """Program popularity metrics response"""
    total_programs: int
    most_viewed: List[ProgramMetrics]
    most_applied: List[ProgramMetrics]
    highest_acceptance_rate: List[ProgramMetrics]


class TimeToDecisionResponse(BaseModel):
    """Time-to-decision metrics response"""
    average_days: float
    median_days: float
    pending_applications: int
    age_distribution: List[DemographicDistribution]


# ==================== INSTITUTION ANALYTICS ENDPOINTS (Phase 4.3) ====================

@router.get("/institutions/{institution_id}/analytics/application-funnel")
async def get_application_funnel(
    institution_id: str,
    period: str = Query(default="30_days", description="Time period: 7_days, 30_days, 90_days, 1_year, all_time"),
    current_user: CurrentUser = Depends(get_current_user)
) -> ApplicationFunnelResponse:
    """
    Get application funnel visualization data for an institution

    **Phase 4.3 - Institution Analytics Dashboard**

    Tracks the application journey through stages:
    - Viewed: Program page views (estimated)
    - Started: Applications in draft/started state
    - Submitted: Applications submitted
    - Reviewed: Applications under review
    - Accepted: Applications accepted

    **Returns:**
    - Total counts for each stage
    - Conversion rates between stages
    - Overall conversion rate from viewed to accepted
    """
    try:
        db = get_supabase()

        # Calculate date filter based on period
        if period == "7_days":
            start_date = datetime.now() - timedelta(days=7)
        elif period == "30_days":
            start_date = datetime.now() - timedelta(days=30)
        elif period == "90_days":
            start_date = datetime.now() - timedelta(days=90)
        elif period == "1_year":
            start_date = datetime.now() - timedelta(days=365)
        else:  # all_time
            start_date = None

        # Build query for applications
        query = db.table('applications').select('*').eq('institution_id', institution_id)

        if start_date:
            query = query.gte('created_at', start_date.isoformat())

        response = query.execute()

        if not response.data:
            return ApplicationFunnelResponse(
                total_viewed=0,
                total_started=0,
                total_submitted=0,
                total_reviewed=0,
                total_accepted=0,
                stages=[],
                overall_conversion_rate=0.0
            )

        applications = response.data

        # Count applications by status
        status_counts = defaultdict(int)
        for app in applications:
            status = app.get('status', 'pending').lower()
            status_counts[status] += 1

        # Map statuses to funnel stages
        total_started = status_counts['draft'] + status_counts['started']
        total_submitted = (
            status_counts['submitted'] +
            status_counts['pending'] +
            status_counts['under_review'] +
            status_counts['reviewed'] +
            status_counts['accepted'] +
            status_counts['rejected']
        )
        total_reviewed = (
            status_counts['under_review'] +
            status_counts['reviewed'] +
            status_counts['accepted'] +
            status_counts['rejected']
        )
        total_accepted = status_counts['accepted']

        # Estimate "viewed" as 1.5x total applications
        total_viewed = int(len(applications) * 1.5)

        # Calculate funnel stages with conversion rates
        stages = []

        # Stage 1: Viewed
        stages.append(FunnelStageData(
            stage="Viewed",
            count=total_viewed,
            percentage=100.0,
            conversion_rate=None
        ))

        # Stage 2: Started
        started_percentage = (total_started / total_viewed * 100) if total_viewed > 0 else 0
        stages.append(FunnelStageData(
            stage="Started",
            count=total_started,
            percentage=started_percentage,
            conversion_rate=started_percentage
        ))

        # Stage 3: Submitted
        submitted_percentage = (total_submitted / total_viewed * 100) if total_viewed > 0 else 0
        submitted_conversion = (total_submitted / total_started * 100) if total_started > 0 else 0
        stages.append(FunnelStageData(
            stage="Submitted",
            count=total_submitted,
            percentage=submitted_percentage,
            conversion_rate=submitted_conversion
        ))

        # Stage 4: Reviewed
        reviewed_percentage = (total_reviewed / total_viewed * 100) if total_viewed > 0 else 0
        reviewed_conversion = (total_reviewed / total_submitted * 100) if total_submitted > 0 else 0
        stages.append(FunnelStageData(
            stage="Reviewed",
            count=total_reviewed,
            percentage=reviewed_percentage,
            conversion_rate=reviewed_conversion
        ))

        # Stage 5: Accepted
        accepted_percentage = (total_accepted / total_viewed * 100) if total_viewed > 0 else 0
        accepted_conversion = (total_accepted / total_reviewed * 100) if total_reviewed > 0 else 0
        stages.append(FunnelStageData(
            stage="Accepted",
            count=total_accepted,
            percentage=accepted_percentage,
            conversion_rate=accepted_conversion
        ))

        overall_conversion = accepted_percentage

        return ApplicationFunnelResponse(
            total_viewed=total_viewed,
            total_started=total_started,
            total_submitted=total_submitted,
            total_reviewed=total_reviewed,
            total_accepted=total_accepted,
            stages=stages,
            overall_conversion_rate=round(overall_conversion, 1)
        )

    except Exception as e:
        logger.error(f"Error fetching application funnel: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/institutions/{institution_id}/analytics/applicant-demographics")
async def get_applicant_demographics(
    institution_id: str,
    current_user: CurrentUser = Depends(get_current_user)
) -> ApplicantDemographicsResponse:
    """
    Get applicant demographics analytics for an institution

    **Phase 4.3 - Institution Analytics Dashboard**

    Returns demographic breakdowns:
    - Location distribution (by state/country)
    - Age distribution (age ranges)
    - Academic background distribution (high school, bachelor's, master's, etc.)
    """
    try:
        db = get_supabase()

        # Get all applications for this institution
        response = db.table('applications').select(
            'id, student_id'
        ).eq('institution_id', institution_id).execute()

        if not response.data or len(response.data) == 0:
            return ApplicantDemographicsResponse(
                total_applicants=0,
                location_distribution=[],
                age_distribution=[],
                academic_background_distribution=[]
            )

        applications = response.data
        total_applicants = len(applications)

        # Get unique student IDs
        student_ids = list(set([app['student_id'] for app in applications if app.get('student_id')]))

        if not student_ids:
            return ApplicantDemographicsResponse(
                total_applicants=total_applicants,
                location_distribution=[],
                age_distribution=[],
                academic_background_distribution=[]
            )

        # Fetch student profiles (batch fetch, limit to 1000 for performance)
        # Use correct column names: current_country, current_region, nationality, grading_system
        profiles_response = db.table('student_profiles').select(
            'user_id, current_country, current_region, nationality, grading_system, field_of_study'
        ).in_('user_id', student_ids[:1000]).execute()

        profiles = profiles_response.data if profiles_response.data else []

        # Process location distribution (using current_country)
        location_counts = defaultdict(int)
        for profile in profiles:
            location = profile.get('current_country') or profile.get('nationality') or 'Unknown'
            if location and location != 'Unknown':
                location_counts[location] += 1
            else:
                location_counts['Unknown'] += 1

        location_distribution = [
            DemographicDistribution(
                label=location,
                count=count,
                percentage=round(count / len(profiles) * 100, 1) if profiles else 0
            )
            for location, count in sorted(location_counts.items(), key=lambda x: x[1], reverse=True)[:10]
        ]

        # Process age distribution
        # Note: student_profiles doesn't have date_of_birth, so we get this from users table if available
        age_counts = defaultdict(int)
        # For now, mark all as "Not Available" since we don't have DOB data
        age_counts['Not Available'] = len(profiles) if profiles else 0

        age_distribution = [
            DemographicDistribution(
                label='Not Available',
                count=age_counts['Not Available'],
                percentage=100.0 if profiles else 0
            )
        ] if profiles else []

        # Process academic background (using field_of_study or grading_system)
        education_counts = defaultdict(int)
        for profile in profiles:
            # Use field_of_study as academic background indicator
            field = profile.get('field_of_study') or profile.get('grading_system') or 'Not Specified'
            education_counts[field] += 1

        academic_background_distribution = [
            DemographicDistribution(
                label=education,
                count=count,
                percentage=round(count / len(profiles) * 100, 1) if profiles else 0
            )
            for education, count in sorted(education_counts.items(), key=lambda x: x[1], reverse=True)[:10]
        ]

        return ApplicantDemographicsResponse(
            total_applicants=total_applicants,
            location_distribution=location_distribution,
            age_distribution=age_distribution,
            academic_background_distribution=academic_background_distribution
        )

    except Exception as e:
        logger.error(f"Error fetching applicant demographics: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/institutions/{institution_id}/analytics/program-popularity")
async def get_program_popularity(
    institution_id: str,
    limit: int = Query(default=10, description="Number of programs to return"),
    current_user: CurrentUser = Depends(get_current_user)
) -> ProgramPopularityResponse:
    """
    Get program popularity metrics for an institution

    **Phase 4.3 - Institution Analytics Dashboard**

    Returns top programs by:
    - Most viewed (estimated)
    - Most applied
    - Highest acceptance rate
    """
    try:
        db = get_supabase()

        # Get all applications for this institution grouped by program
        response = db.table('applications').select(
            'program_id, program_name, status'
        ).eq('institution_id', institution_id).execute()

        if not response.data or len(response.data) == 0:
            return ProgramPopularityResponse(
                total_programs=0,
                most_viewed=[],
                most_applied=[],
                highest_acceptance_rate=[]
            )

        applications = response.data

        # Aggregate data by program
        program_data = defaultdict(lambda: {
            'program_id': None,
            'program_name': 'Unknown',
            'applications': 0,
            'acceptances': 0,
            'views': 0
        })

        for app in applications:
            program_id = app.get('program_id', 'unknown')
            program_name = app.get('program_name', 'Unknown Program')
            status = app.get('status', '').lower()

            program_data[program_id]['program_id'] = program_id
            program_data[program_id]['program_name'] = program_name
            program_data[program_id]['applications'] += 1

            if status == 'accepted':
                program_data[program_id]['acceptances'] += 1

            # Estimate views (2 views per application)
            program_data[program_id]['views'] += 2

        # Convert to list of programs with metrics
        programs = []
        for prog_id, data in program_data.items():
            acceptance_rate = (
                data['acceptances'] / data['applications'] * 100
                if data['applications'] > 0 else 0
            )

            programs.append(ProgramMetrics(
                program_id=data['program_id'],
                program_name=data['program_name'],
                views=data['views'],
                applications=data['applications'],
                acceptances=data['acceptances'],
                acceptance_rate=round(acceptance_rate, 1)
            ))

        # Sort and get top programs
        most_viewed = sorted(programs, key=lambda x: x.views, reverse=True)[:limit]
        most_applied = sorted(programs, key=lambda x: x.applications, reverse=True)[:limit]

        # Highest acceptance rate (only for programs with at least 5 applications)
        programs_with_apps = [p for p in programs if p.applications >= 5]
        highest_acceptance_rate = sorted(
            programs_with_apps,
            key=lambda x: x.acceptance_rate,
            reverse=True
        )[:limit]

        return ProgramPopularityResponse(
            total_programs=len(programs),
            most_viewed=most_viewed,
            most_applied=most_applied,
            highest_acceptance_rate=highest_acceptance_rate
        )

    except Exception as e:
        logger.error(f"Error fetching program popularity: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/institutions/{institution_id}/analytics/time-to-decision")
async def get_time_to_decision(
    institution_id: str,
    current_user: CurrentUser = Depends(get_current_user)
) -> TimeToDecisionResponse:
    """
    Get time-to-decision metrics for an institution

    **Phase 4.3 - Institution Analytics Dashboard**

    Calculates how long it takes to make decisions on applications:
    - Average time from submission to decision
    - Median time to decision
    - Distribution of pending application ages
    """
    try:
        db = get_supabase()

        # Get all applications
        response = db.table('applications').select(
            'id, created_at, updated_at, status, submitted_at, decision_date'
        ).eq('institution_id', institution_id).execute()

        if not response.data or len(response.data) == 0:
            return TimeToDecisionResponse(
                average_days=0.0,
                median_days=0.0,
                pending_applications=0,
                age_distribution=[]
            )

        applications = response.data

        decision_times = []
        pending_count = 0
        pending_ages = []

        for app in applications:
            status = app.get('status', '').lower()

            if status in ['accepted', 'rejected']:
                # Calculate time from submission to decision
                submitted_at = app.get('submitted_at') or app.get('created_at')
                decision_date = app.get('decision_date') or app.get('updated_at')

                if submitted_at and decision_date:
                    try:
                        submit_dt = datetime.fromisoformat(submitted_at.replace('Z', '+00:00'))
                        decision_dt = datetime.fromisoformat(decision_date.replace('Z', '+00:00'))
                        days_to_decision = (decision_dt - submit_dt).days

                        if days_to_decision >= 0:
                            decision_times.append(days_to_decision)
                    except:
                        pass

            elif status in ['pending', 'submitted', 'under_review']:
                pending_count += 1

                submitted_at = app.get('submitted_at') or app.get('created_at')
                if submitted_at:
                    try:
                        submit_dt = datetime.fromisoformat(submitted_at.replace('Z', '+00:00'))
                        age_days = (datetime.now() - submit_dt).days
                        if age_days >= 0:
                            pending_ages.append(age_days)
                    except:
                        pass

        # Calculate average and median
        if decision_times:
            average_days = sum(decision_times) / len(decision_times)
            sorted_times = sorted(decision_times)
            median_days = sorted_times[len(sorted_times) // 2]
        else:
            average_days = 0.0
            median_days = 0.0

        # Create age distribution for pending applications
        age_distribution_data = defaultdict(int)
        for age in pending_ages:
            if age <= 7:
                age_range = '0-7 days'
            elif age <= 14:
                age_range = '8-14 days'
            elif age <= 30:
                age_range = '15-30 days'
            elif age <= 60:
                age_range = '31-60 days'
            else:
                age_range = '60+ days'

            age_distribution_data[age_range] += 1

        age_order = ['0-7 days', '8-14 days', '15-30 days', '31-60 days', '60+ days']
        age_distribution = [
            DemographicDistribution(
                label=age_range,
                count=age_distribution_data[age_range],
                percentage=round(age_distribution_data[age_range] / pending_count * 100, 1) if pending_count > 0 else 0
            )
            for age_range in age_order if age_distribution_data[age_range] > 0
        ]

        return TimeToDecisionResponse(
            average_days=round(average_days, 1),
            median_days=round(median_days, 1),
            pending_applications=pending_count,
            age_distribution=age_distribution
        )

    except Exception as e:
        logger.error(f"Error fetching time-to-decision metrics: {e}")
        raise HTTPException(status_code=500, detail=str(e))
