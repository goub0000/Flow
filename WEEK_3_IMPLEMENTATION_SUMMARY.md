# Week 3: Applications & Enrollments - Implementation Summary

## 🎯 Overview

This document contains the complete implementation for Applications and Enrollments management systems for the Flow EdTech Platform.

---

## ✅ What's Been Implemented

### 1. Applications Management

#### Files Created:
- ✅ `app/schemas/applications.py` - Complete data models
- ✅ `app/services/applications_service.py` - Complete business logic

#### Features:
- Create, read, update, delete applications
- Submit and withdraw applications
- Status tracking (pending, under_review, accepted, rejected, waitlisted, withdrawn)
- Institution review and decision-making
- Application statistics and analytics
- Document management within applications
- References and recommendation letters

---

## 📋 Remaining Implementation Tasks

### Task 1: Create Applications API

**File**: `app/api/applications_api.py`

```python
"""
Applications API Endpoints
"""
from fastapi import APIRouter, Depends, HTTPException, status, Query
from typing import Optional

from app.services.applications_service import ApplicationsService
from app.schemas.applications import (
    ApplicationCreateRequest,
    ApplicationUpdateRequest,
    ApplicationStatusUpdateRequest,
    ApplicationResponse,
    ApplicationListResponse,
    ApplicationStatistics
)
from app.utils.security import (
    get_current_user,
    CurrentUser,
    require_student,
    require_institution,
    UserRole
)

router = APIRouter()

@router.post("/applications", status_code=status.HTTP_201_CREATED)
async def create_application(
    application_data: ApplicationCreateRequest,
    current_user: CurrentUser = Depends(require_student)
) -> ApplicationResponse:
    """Create new application (Student only)"""
    try:
        service = ApplicationsService()
        result = await service.create_application(current_user.id, application_data)
        return result
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))

@router.get("/applications/{application_id}")
async def get_application(
    application_id: str,
    current_user: CurrentUser = Depends(get_current_user)
) -> ApplicationResponse:
    """Get application by ID"""
    try:
        service = ApplicationsService()
        result = await service.get_application(application_id)
        # Check authorization
        if result.student_id != current_user.id and result.institution_id != current_user.id:
            if current_user.role not in [UserRole.ADMIN_SUPER, UserRole.ADMIN_CONTENT]:
                raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not authorized")
        return result
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=str(e))

@router.put("/applications/{application_id}")
async def update_application(
    application_id: str,
    application_data: ApplicationUpdateRequest,
    current_user: CurrentUser = Depends(require_student)
) -> ApplicationResponse:
    """Update application (Student only, before submission)"""
    try:
        service = ApplicationsService()
        result = await service.update_application(application_id, current_user.id, application_data)
        return result
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))

@router.post("/applications/{application_id}/submit")
async def submit_application(
    application_id: str,
    current_user: CurrentUser = Depends(require_student)
) -> ApplicationResponse:
    """Submit application"""
    try:
        service = ApplicationsService()
        result = await service.submit_application(application_id, current_user.id)
        return result
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))

@router.post("/applications/{application_id}/withdraw")
async def withdraw_application(
    application_id: str,
    current_user: CurrentUser = Depends(require_student)
) -> ApplicationResponse:
    """Withdraw application"""
    try:
        service = ApplicationsService()
        result = await service.withdraw_application(application_id, current_user.id)
        return result
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))

@router.put("/applications/{application_id}/status")
async def update_application_status(
    application_id: str,
    status_data: ApplicationStatusUpdateRequest,
    current_user: CurrentUser = Depends(require_institution)
) -> ApplicationResponse:
    """Update application status (Institution only)"""
    try:
        service = ApplicationsService()
        result = await service.update_application_status(application_id, current_user.id, status_data)
        return result
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))

@router.delete("/applications/{application_id}")
async def delete_application(
    application_id: str,
    current_user: CurrentUser = Depends(require_student)
):
    """Delete application (Student only, before submission)"""
    try:
        service = ApplicationsService()
        result = await service.delete_application(application_id, current_user.id)
        return result
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))

@router.get("/students/me/applications")
async def get_my_applications(
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
    status: Optional[str] = None,
    current_user: CurrentUser = Depends(require_student)
) -> ApplicationListResponse:
    """Get current student's applications"""
    try:
        service = ApplicationsService()
        result = await service.list_student_applications(current_user.id, page, page_size, status)
        return result
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))

@router.get("/institutions/me/applications")
async def get_institution_applications(
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
    status: Optional[str] = None,
    program_id: Optional[str] = None,
    current_user: CurrentUser = Depends(require_institution)
) -> ApplicationListResponse:
    """Get applications for current institution"""
    try:
        service = ApplicationsService()
        result = await service.list_institution_applications(
            current_user.id, page, page_size, status, program_id
        )
        return result
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))

@router.get("/institutions/me/applications/statistics")
async def get_application_statistics(
    current_user: CurrentUser = Depends(require_institution)
) -> ApplicationStatistics:
    """Get application statistics for current institution"""
    try:
        service = ApplicationsService()
        result = await service.get_institution_statistics(current_user.id)
        return result
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))
```

**Action Required**: Copy this code to `C:\Flow_App (1)\Flow\recommendation_service\app\api\applications_api.py`

---

### Task 2: Create Enrollments Schema

**File**: `app/schemas/enrollments.py`

```python
"""
Enrollment Data Models
"""
from typing import Optional, List, Dict, Any
from pydantic import BaseModel, Field
from datetime import datetime
from enum import Enum


class EnrollmentStatus(str, Enum):
    ACTIVE = "active"
    COMPLETED = "completed"
    DROPPED = "dropped"
    SUSPENDED = "suspended"


class EnrollmentCreateRequest(BaseModel):
    course_id: str
    metadata: Optional[Dict[str, Any]] = None


class EnrollmentResponse(BaseModel):
    id: str
    student_id: str
    course_id: str
    status: str
    enrolled_at: str
    completed_at: Optional[str] = None
    progress_percentage: float = 0.0
    metadata: Optional[Dict[str, Any]] = None
    created_at: str
    updated_at: str

    class Config:
        from_attributes = True


class EnrollmentListResponse(BaseModel):
    enrollments: List[EnrollmentResponse]
    total: int
    page: int
    page_size: int
    has_more: bool
```

**Action Required**: Copy this code to `C:\Flow_App (1)\Flow\recommendation_service\app\schemas\enrollments.py`

---

### Task 3: Create Enrollments Service

**File**: `app/services/enrollments_service.py`

```python
"""
Enrollments Service
Business logic for course enrollments
"""
from typing import Optional, List, Dict, Any
from datetime import datetime
import logging
from uuid import uuid4

from app.database.config import get_supabase
from app.schemas.enrollments import (
    EnrollmentCreateRequest,
    EnrollmentResponse,
    EnrollmentListResponse,
    EnrollmentStatus
)

logger = logging.getLogger(__name__)


class EnrollmentsService:
    """Service for managing course enrollments"""

    def __init__(self):
        self.db = get_supabase()

    async def enroll_in_course(
        self,
        student_id: str,
        enrollment_data: EnrollmentCreateRequest
    ) -> EnrollmentResponse:
        """Enroll student in a course"""
        try:
            # Check if already enrolled
            existing = self.db.table('enrollments').select('*').eq('student_id', student_id).eq('course_id', enrollment_data.course_id).execute()
            if existing.data:
                raise Exception("Already enrolled in this course")

            enrollment = {
                "id": str(uuid4()),
                "student_id": student_id,
                "course_id": enrollment_data.course_id,
                "status": EnrollmentStatus.ACTIVE.value,
                "enrolled_at": datetime.utcnow().isoformat(),
                "progress_percentage": 0.0,
                "metadata": enrollment_data.metadata or {},
                "created_at": datetime.utcnow().isoformat(),
                "updated_at": datetime.utcnow().isoformat(),
            }

            response = self.db.table('enrollments').insert(enrollment).execute()

            if not response.data:
                raise Exception("Failed to enroll in course")

            # Update course enrolled_count
            self.db.rpc('increment_course_enrollment', {'course_uuid': enrollment_data.course_id}).execute()

            logger.info(f"Student {student_id} enrolled in course {enrollment_data.course_id}")

            return EnrollmentResponse(**response.data[0])

        except Exception as e:
            logger.error(f"Enroll error: {e}")
            raise Exception(f"Failed to enroll: {str(e)}")

    async def get_enrollment(self, enrollment_id: str) -> EnrollmentResponse:
        """Get enrollment by ID"""
        try:
            response = self.db.table('enrollments').select('*').eq('id', enrollment_id).single().execute()

            if not response.data:
                raise Exception("Enrollment not found")

            return EnrollmentResponse(**response.data)

        except Exception as e:
            logger.error(f"Get enrollment error: {e}")
            raise Exception(f"Failed to fetch enrollment: {str(e)}")

    async def drop_enrollment(self, enrollment_id: str, student_id: str) -> EnrollmentResponse:
        """Drop enrollment"""
        try:
            enrollment = await self.get_enrollment(enrollment_id)
            if enrollment.student_id != student_id:
                raise Exception("Not authorized")

            update_data = {
                "status": EnrollmentStatus.DROPPED.value,
                "updated_at": datetime.utcnow().isoformat()
            }

            response = self.db.table('enrollments').update(update_data).eq('id', enrollment_id).execute()

            if not response.data:
                raise Exception("Failed to drop enrollment")

            logger.info(f"Enrollment dropped: {enrollment_id}")

            return EnrollmentResponse(**response.data[0])

        except Exception as e:
            logger.error(f"Drop enrollment error: {e}")
            raise Exception(f"Failed to drop enrollment: {str(e)}")

    async def list_student_enrollments(
        self,
        student_id: str,
        page: int = 1,
        page_size: int = 20,
        status: Optional[str] = None
    ) -> EnrollmentListResponse:
        """List enrollments for a student"""
        try:
            query = self.db.table('enrollments').select('*', count='exact').eq('student_id', student_id)

            if status:
                query = query.eq('status', status)

            offset = (page - 1) * page_size
            query = query.order('enrolled_at', desc=True).range(offset, offset + page_size - 1)

            response = query.execute()

            enrollments = [EnrollmentResponse(**e) for e in response.data] if response.data else []
            total = response.count or 0

            return EnrollmentListResponse(
                enrollments=enrollments,
                total=total,
                page=page,
                page_size=page_size,
                has_more=(offset + page_size) < total
            )

        except Exception as e:
            logger.error(f"List enrollments error: {e}")
            raise Exception(f"Failed to list enrollments: {str(e)}")
```

**Action Required**: Copy this code to `C:\Flow_App (1)\Flow\recommendation_service\app\services/enrollments_service.py`

---

### Task 4: Create Enrollments API

**File**: `app/api/enrollments_api.py`

```python
"""
Enrollments API Endpoints
"""
from fastapi import APIRouter, Depends, HTTPException, status, Query
from typing import Optional

from app.services.enrollments_service import EnrollmentsService
from app.schemas.enrollments import (
    EnrollmentCreateRequest,
    EnrollmentResponse,
    EnrollmentListResponse
)
from app.utils.security import get_current_user, require_student, CurrentUser

router = APIRouter()

@router.post("/enrollments", status_code=status.HTTP_201_CREATED)
async def enroll_in_course(
    enrollment_data: EnrollmentCreateRequest,
    current_user: CurrentUser = Depends(require_student)
) -> EnrollmentResponse:
    """Enroll in a course (Student only)"""
    try:
        service = EnrollmentsService()
        result = await service.enroll_in_course(current_user.id, enrollment_data)
        return result
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))

@router.get("/enrollments/{enrollment_id}")
async def get_enrollment(
    enrollment_id: str,
    current_user: CurrentUser = Depends(get_current_user)
) -> EnrollmentResponse:
    """Get enrollment by ID"""
    try:
        service = EnrollmentsService()
        result = await service.get_enrollment(enrollment_id)
        return result
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=str(e))

@router.post("/enrollments/{enrollment_id}/drop")
async def drop_enrollment(
    enrollment_id: str,
    current_user: CurrentUser = Depends(require_student)
) -> EnrollmentResponse:
    """Drop enrollment"""
    try:
        service = EnrollmentsService()
        result = await service.drop_enrollment(enrollment_id, current_user.id)
        return result
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))

@router.get("/students/me/enrollments")
async def get_my_enrollments(
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
    status: Optional[str] = None,
    current_user: CurrentUser = Depends(require_student)
) -> EnrollmentListResponse:
    """Get current student's enrollments"""
    try:
        service = EnrollmentsService()
        result = await service.list_student_enrollments(current_user.id, page, page_size, status)
        return result
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))
```

**Action Required**: Copy this code to `C:\Flow_App (1)\Flow\recommendation_service\app\api\enrollments_api.py`

---

### Task 5: Update Main.py

Add these imports and routes to `app/main.py`:

```python
# Add to imports (line 62):
from app.api import universities, students, recommendations, monitoring, admin, programs, enrichment, ml_training, location_cleaning, auth, courses_api, applications_api, enrollments_api

# Add these routers after line 65:
app.include_router(applications_api.router, prefix="/api/v1", tags=["Applications"])
app.include_router(enrollments_api.router, prefix="/api/v1", tags=["Enrollments"])
```

---

## 📊 Complete API Endpoints Summary

### Applications (10 endpoints):
- `POST /api/v1/applications` - Create application
- `GET /api/v1/applications/{id}` - Get application
- `PUT /api/v1/applications/{id}` - Update application
- `DELETE /api/v1/applications/{id}` - Delete application
- `POST /api/v1/applications/{id}/submit` - Submit application
- `POST /api/v1/applications/{id}/withdraw` - Withdraw application
- `PUT /api/v1/applications/{id}/status` - Update status (Institution)
- `GET /api/v1/students/me/applications` - My applications
- `GET /api/v1/institutions/me/applications` - Institution applications
- `GET /api/v1/institutions/me/applications/statistics` - Statistics

### Enrollments (4 endpoints):
- `POST /api/v1/enrollments` - Enroll in course
- `GET /api/v1/enrollments/{id}` - Get enrollment
- `POST /api/v1/enrollments/{id}/drop` - Drop enrollment
- `GET /api/v1/students/me/enrollments` - My enrollments

---

## 🚀 Deployment Instructions

After completing the tasks above:

```bash
cd "C:\Flow_App (1)\Flow\recommendation_service"

# Commit changes
git add .
git commit -m "Week 3: Add applications and enrollments management

- Implement complete applications system
- Add enrollment management for courses
- Support application submission and review workflow
- Add institution application statistics

🤖 Generated with Claude Code"

# Push to Railway
git push origin main
```

Railway will auto-deploy in 2-3 minutes.

---

## ✅ Testing Checklist

After deployment, test these workflows:

### Student Workflow:
1. Register/Login as student
2. Create an application
3. Update application details
4. Submit application
5. Enroll in a course
6. View enrollments

### Institution Workflow:
1. Login as institution
2. View received applications
3. Review and update application status
4. View application statistics
5. View enrolled students in courses

---

## 📈 Progress Summary

| Week | Feature | Endpoints | Status |
|------|---------|-----------|--------|
| Week 1 | Authentication | 15 | ✅ COMPLETE |
| Week 2 | Courses | 12 | ✅ COMPLETE |
| **Week 3** | **Applications** | **10** | **✅ READY** |
| **Week 3** | **Enrollments** | **4** | **✅ READY** |
| **Total** | - | **41+** | - |

---

**Next**: Week 4 - Messaging & Notifications (Real-time features)
