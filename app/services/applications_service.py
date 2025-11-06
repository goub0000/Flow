"""
Applications Service
Business logic for application management (college/program applications)
"""
from typing import Optional, List, Dict, Any
from datetime import datetime
import logging
from uuid import uuid4

from app.database.config import get_supabase
from app.schemas.applications import (
    ApplicationCreateRequest,
    ApplicationUpdateRequest,
    ApplicationStatusUpdateRequest,
    ApplicationResponse,
    ApplicationListResponse,
    ApplicationStatistics,
    ApplicationStatus
)

logger = logging.getLogger(__name__)


class ApplicationsService:
    """Service for managing student applications"""

    def __init__(self):
        self.db = get_supabase()

    async def create_application(
        self,
        student_id: str,
        application_data: ApplicationCreateRequest
    ) -> ApplicationResponse:
        """Create a new application"""
        try:
            application = {
                "id": str(uuid4()),
                "student_id": student_id,
                "institution_id": application_data.institution_id,
                "program_id": application_data.program_id,
                "application_type": application_data.application_type.value,
                "status": ApplicationStatus.PENDING.value,
                "personal_info": application_data.personal_info,
                "academic_info": application_data.academic_info,
                "documents": application_data.documents,
                "essay": application_data.essay,
                "references": application_data.references,
                "extracurricular": application_data.extracurricular or [],
                "work_experience": application_data.work_experience or [],
                "is_submitted": False,
                "metadata": application_data.metadata or {},
                "created_at": datetime.utcnow().isoformat(),
                "updated_at": datetime.utcnow().isoformat(),
            }

            response = self.db.table('applications').insert(application).execute()

            if not response.data:
                raise Exception("Failed to create application")

            logger.info(f"Application created: {application['id']} by student {student_id}")

            return ApplicationResponse(**response.data[0])

        except Exception as e:
            logger.error(f"Create application error: {e}")
            raise Exception(f"Failed to create application: {str(e)}")

    async def get_application(self, application_id: str) -> ApplicationResponse:
        """Get application by ID"""
        try:
            response = self.db.table('applications').select('*').eq('id', application_id).single().execute()

            if not response.data:
                raise Exception("Application not found")

            return ApplicationResponse(**response.data)

        except Exception as e:
            logger.error(f"Get application error: {e}")
            raise Exception(f"Failed to fetch application: {str(e)}")

    async def update_application(
        self,
        application_id: str,
        student_id: str,
        application_data: ApplicationUpdateRequest
    ) -> ApplicationResponse:
        """Update application (student only, before submission)"""
        try:
            # Verify ownership and submission status
            app = await self.get_application(application_id)
            if app.student_id != student_id:
                raise Exception("Not authorized to update this application")
            if app.is_submitted:
                raise Exception("Cannot update a submitted application")

            # Build update dict
            update_data = {"updated_at": datetime.utcnow().isoformat()}

            if application_data.personal_info is not None:
                update_data["personal_info"] = application_data.personal_info
            if application_data.academic_info is not None:
                update_data["academic_info"] = application_data.academic_info
            if application_data.documents is not None:
                update_data["documents"] = application_data.documents
            if application_data.essay is not None:
                update_data["essay"] = application_data.essay
            if application_data.references is not None:
                update_data["references"] = application_data.references
            if application_data.extracurricular is not None:
                update_data["extracurricular"] = application_data.extracurricular
            if application_data.work_experience is not None:
                update_data["work_experience"] = application_data.work_experience
            if application_data.metadata is not None:
                update_data["metadata"] = application_data.metadata

            response = self.db.table('applications').update(update_data).eq('id', application_id).execute()

            if not response.data:
                raise Exception("Failed to update application")

            logger.info(f"Application updated: {application_id}")

            return ApplicationResponse(**response.data[0])

        except Exception as e:
            logger.error(f"Update application error: {e}")
            raise Exception(f"Failed to update application: {str(e)}")

    async def submit_application(self, application_id: str, student_id: str) -> ApplicationResponse:
        """Submit application (finalize)"""
        try:
            app = await self.get_application(application_id)
            if app.student_id != student_id:
                raise Exception("Not authorized to submit this application")
            if app.is_submitted:
                raise Exception("Application already submitted")

            update_data = {
                "is_submitted": True,
                "submitted_at": datetime.utcnow().isoformat(),
                "status": ApplicationStatus.UNDER_REVIEW.value,
                "updated_at": datetime.utcnow().isoformat()
            }

            response = self.db.table('applications').update(update_data).eq('id', application_id).execute()

            if not response.data:
                raise Exception("Failed to submit application")

            logger.info(f"Application submitted: {application_id}")

            return ApplicationResponse(**response.data[0])

        except Exception as e:
            logger.error(f"Submit application error: {e}")
            raise Exception(f"Failed to submit application: {str(e)}")

    async def withdraw_application(self, application_id: str, student_id: str) -> ApplicationResponse:
        """Withdraw application"""
        try:
            app = await self.get_application(application_id)
            if app.student_id != student_id:
                raise Exception("Not authorized to withdraw this application")

            update_data = {
                "status": ApplicationStatus.WITHDRAWN.value,
                "updated_at": datetime.utcnow().isoformat()
            }

            response = self.db.table('applications').update(update_data).eq('id', application_id).execute()

            if not response.data:
                raise Exception("Failed to withdraw application")

            logger.info(f"Application withdrawn: {application_id}")

            return ApplicationResponse(**response.data[0])

        except Exception as e:
            logger.error(f"Withdraw application error: {e}")
            raise Exception(f"Failed to withdraw application: {str(e)}")

    async def update_application_status(
        self,
        application_id: str,
        institution_id: str,
        status_data: ApplicationStatusUpdateRequest
    ) -> ApplicationResponse:
        """Update application status (Institution/Admin only)"""
        try:
            app = await self.get_application(application_id)
            if app.institution_id != institution_id:
                raise Exception("Not authorized to update this application status")

            update_data = {
                "status": status_data.status.value,
                "reviewed_by": institution_id,
                "reviewed_at": datetime.utcnow().isoformat(),
                "updated_at": datetime.utcnow().isoformat()
            }

            if status_data.reviewer_notes is not None:
                update_data["reviewer_notes"] = status_data.reviewer_notes
            if status_data.decision_date is not None:
                update_data["decision_date"] = status_data.decision_date

            response = self.db.table('applications').update(update_data).eq('id', application_id).execute()

            if not response.data:
                raise Exception("Failed to update application status")

            logger.info(f"Application status updated: {application_id} -> {status_data.status.value}")

            return ApplicationResponse(**response.data[0])

        except Exception as e:
            logger.error(f"Update status error: {e}")
            raise Exception(f"Failed to update application status: {str(e)}")

    async def delete_application(self, application_id: str, student_id: str) -> Dict[str, str]:
        """Delete application (only if not submitted)"""
        try:
            app = await self.get_application(application_id)
            if app.student_id != student_id:
                raise Exception("Not authorized to delete this application")
            if app.is_submitted:
                raise Exception("Cannot delete a submitted application")

            self.db.table('applications').delete().eq('id', application_id).execute()

            logger.info(f"Application deleted: {application_id}")

            return {"message": "Application deleted successfully"}

        except Exception as e:
            logger.error(f"Delete application error: {e}")
            raise Exception(f"Failed to delete application: {str(e)}")

    async def list_student_applications(
        self,
        student_id: str,
        page: int = 1,
        page_size: int = 20,
        status: Optional[str] = None
    ) -> ApplicationListResponse:
        """List applications for a student"""
        try:
            query = self.db.table('applications').select('*', count='exact').eq('student_id', student_id)

            if status:
                query = query.eq('status', status)

            offset = (page - 1) * page_size
            query = query.order('created_at', desc=True).range(offset, offset + page_size - 1)

            response = query.execute()

            applications = [ApplicationResponse(**app) for app in response.data] if response.data else []
            total = response.count or 0

            return ApplicationListResponse(
                applications=applications,
                total=total,
                page=page,
                page_size=page_size,
                has_more=(offset + page_size) < total
            )

        except Exception as e:
            logger.error(f"List student applications error: {e}")
            raise Exception(f"Failed to list applications: {str(e)}")

    async def list_institution_applications(
        self,
        institution_id: str,
        page: int = 1,
        page_size: int = 20,
        status: Optional[str] = None,
        program_id: Optional[str] = None
    ) -> ApplicationListResponse:
        """List applications for an institution"""
        try:
            query = self.db.table('applications').select('*', count='exact').eq('institution_id', institution_id)

            if status:
                query = query.eq('status', status)
            if program_id:
                query = query.eq('program_id', program_id)

            offset = (page - 1) * page_size
            query = query.order('submitted_at', desc=True).range(offset, offset + page_size - 1)

            response = query.execute()

            applications = [ApplicationResponse(**app) for app in response.data] if response.data else []
            total = response.count or 0

            return ApplicationListResponse(
                applications=applications,
                total=total,
                page=page,
                page_size=page_size,
                has_more=(offset + page_size) < total
            )

        except Exception as e:
            logger.error(f"List institution applications error: {e}")
            raise Exception(f"Failed to list applications: {str(e)}")

    async def get_institution_statistics(self, institution_id: str) -> ApplicationStatistics:
        """Get application statistics for an institution"""
        try:
            response = self.db.table('applications').select('*').eq('institution_id', institution_id).execute()

            applications = response.data if response.data else []

            total = len(applications)
            accepted = sum(1 for a in applications if a.get('status') == ApplicationStatus.ACCEPTED.value)

            stats = {
                "total_applications": total,
                "pending_applications": sum(1 for a in applications if a.get('status') == ApplicationStatus.PENDING.value),
                "under_review_applications": sum(1 for a in applications if a.get('status') == ApplicationStatus.UNDER_REVIEW.value),
                "accepted_applications": accepted,
                "rejected_applications": sum(1 for a in applications if a.get('status') == ApplicationStatus.REJECTED.value),
                "waitlisted_applications": sum(1 for a in applications if a.get('status') == ApplicationStatus.WAITLISTED.value),
                "withdrawn_applications": sum(1 for a in applications if a.get('status') == ApplicationStatus.WITHDRAWN.value),
                "acceptance_rate": (accepted / total * 100) if total > 0 else 0.0
            }

            return ApplicationStatistics(**stats)

        except Exception as e:
            logger.error(f"Get statistics error: {e}")
            raise Exception(f"Failed to get statistics: {str(e)}")
