"""
Course Content API endpoints
"""

from fastapi import APIRouter, HTTPException, status
from typing import List, Dict, Any
import logging

from app.schemas.course_content import (
    ModuleCreate,
    ModuleUpdate,
    ModuleResponse,
    ModuleReorderRequest,
    LessonCreate,
    LessonUpdate,
    LessonResponse,
    LessonReorderRequest,
    VideoContentCreate,
    VideoContentUpdate,
    VideoContentResponse,
    TextContentCreate,
    TextContentUpdate,
    TextContentResponse,
    QuizContentCreate,
    QuizContentUpdate,
    QuizContentResponse,
    AssignmentContentCreate,
    AssignmentContentUpdate,
    AssignmentContentResponse,
    QuizQuestionCreate,
    QuizQuestionUpdate,
    QuizQuestionResponse,
    QuestionOptionCreate,
    QuestionOptionUpdate,
    QuestionOptionResponse,
    LessonCompletionCreate,
    CourseProgressResponse,
    QuizAttemptCreate,
    QuizAttemptSubmit,
    QuizAttemptResponse,
    AssignmentSubmissionCreate,
    AssignmentSubmissionUpdate,
    AssignmentSubmissionResponse
)
from app.services.course_content_service import CourseContentService

logger = logging.getLogger(__name__)
router = APIRouter()


# =============================================================================
# MODULE ENDPOINTS
# =============================================================================

@router.post(
    "/courses/{course_id}/modules",
    response_model=ModuleResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Create course module",
    description="Create a new module within a course"
)
async def create_module(
    course_id: str,
    module_data: ModuleCreate
):
    """Create a new course module"""
    try:
        service = CourseContentService()
        module = service.create_module(course_id, module_data)
        logger.info(f"Created module {module['id']} for course {course_id}")
        return module
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error creating module: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to create module: {str(e)}"
        )


@router.get(
    "/courses/{course_id}/modules",
    response_model=List[ModuleResponse],
    summary="Get course modules",
    description="Get all modules for a course"
)
async def get_course_modules(
    course_id: str
):
    """Get all modules for a course"""
    try:
        service = CourseContentService()
        modules = service.get_course_modules(course_id)
        return modules
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error getting modules: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to retrieve modules"
        )


@router.get(
    "/modules/{module_id}",
    response_model=ModuleResponse,
    summary="Get module by ID",
    description="Get a specific module by ID"
)
async def get_module(
    module_id: str
):
    """Get module by ID"""
    try:
        service = CourseContentService()
        module = service.get_module_by_id(module_id)
        if not module:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Module not found: {module_id}"
            )
        return module
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error getting module: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to retrieve module"
        )


@router.put(
    "/modules/{module_id}",
    response_model=ModuleResponse,
    summary="Update module",
    description="Update an existing module"
)
async def update_module(
    module_id: str,
    module_data: ModuleUpdate
):
    """Update a module"""
    try:
        service = CourseContentService()
        module = service.update_module(module_id, module_data)
        logger.info(f"Updated module {module_id}")
        return module
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error updating module: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to update module"
        )


@router.delete(
    "/modules/{module_id}",
    status_code=status.HTTP_204_NO_CONTENT,
    summary="Delete module",
    description="Delete a module and all its lessons"
)
async def delete_module(
    module_id: str
):
    """Delete a module"""
    try:
        service = CourseContentService()
        service.delete_module(module_id)
        logger.info(f"Deleted module {module_id}")
        return None
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error deleting module: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to delete module"
        )


@router.post(
    "/courses/{course_id}/modules/reorder",
    response_model=Dict[str, str],
    summary="Reorder modules",
    description="Reorder modules within a course"
)
async def reorder_modules(
    course_id: str,
    reorder_data: ModuleReorderRequest
):
    """Reorder course modules"""
    try:
        service = CourseContentService()
        service.reorder_modules(course_id, reorder_data.module_orders)
        logger.info(f"Reordered modules for course {course_id}")
        return {"message": "Modules reordered successfully"}
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error reordering modules: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to reorder modules"
        )


# =============================================================================
# LESSON ENDPOINTS
# =============================================================================

@router.post(
    "/modules/{module_id}/lessons",
    response_model=LessonResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Create lesson",
    description="Create a new lesson within a module"
)
async def create_lesson(
    module_id: str,
    lesson_data: LessonCreate
):
    """Create a new lesson"""
    try:
        service = CourseContentService()
        lesson = service.create_lesson(module_id, lesson_data)
        logger.info(f"Created lesson {lesson['id']} for module {module_id}")
        return lesson
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error creating lesson: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to create lesson: {str(e)}"
        )


@router.get(
    "/modules/{module_id}/lessons",
    response_model=List[LessonResponse],
    summary="Get module lessons",
    description="Get all lessons for a module"
)
async def get_module_lessons(
    module_id: str
):
    """Get all lessons for a module"""
    try:
        service = CourseContentService()
        lessons = service.get_module_lessons(module_id)
        return lessons
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error getting lessons: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to retrieve lessons"
        )


@router.get(
    "/lessons/{lesson_id}",
    response_model=LessonResponse,
    summary="Get lesson by ID",
    description="Get a specific lesson by ID"
)
async def get_lesson(
    lesson_id: str
):
    """Get lesson by ID"""
    try:
        service = CourseContentService()
        lesson = service.get_lesson_by_id(lesson_id)
        if not lesson:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Lesson not found: {lesson_id}"
            )
        return lesson
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error getting lesson: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to retrieve lesson"
        )


@router.put(
    "/lessons/{lesson_id}",
    response_model=LessonResponse,
    summary="Update lesson",
    description="Update an existing lesson"
)
async def update_lesson(
    lesson_id: str,
    lesson_data: LessonUpdate
):
    """Update a lesson"""
    try:
        service = CourseContentService()
        lesson = service.update_lesson(lesson_id, lesson_data)
        logger.info(f"Updated lesson {lesson_id}")
        return lesson
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error updating lesson: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to update lesson"
        )


@router.delete(
    "/lessons/{lesson_id}",
    status_code=status.HTTP_204_NO_CONTENT,
    summary="Delete lesson",
    description="Delete a lesson and its content"
)
async def delete_lesson(
    lesson_id: str
):
    """Delete a lesson"""
    try:
        service = CourseContentService()
        service.delete_lesson(lesson_id)
        logger.info(f"Deleted lesson {lesson_id}")
        return None
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error deleting lesson: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to delete lesson"
        )


@router.post(
    "/modules/{module_id}/lessons/reorder",
    response_model=Dict[str, str],
    summary="Reorder lessons",
    description="Reorder lessons within a module"
)
async def reorder_lessons(
    module_id: str,
    reorder_data: LessonReorderRequest
):
    """Reorder module lessons"""
    try:
        service = CourseContentService()
        service.reorder_lessons(module_id, reorder_data.lesson_orders)
        logger.info(f"Reordered lessons for module {module_id}")
        return {"message": "Lessons reordered successfully"}
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error reordering lessons: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to reorder lessons"
        )


# =============================================================================
# VIDEO CONTENT ENDPOINTS
# =============================================================================

@router.post(
    "/lessons/{lesson_id}/video",
    response_model=VideoContentResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Create video content",
    description="Create video content for a lesson"
)
async def create_video_content(
    lesson_id: str,
    content_data: VideoContentCreate
):
    """Create video content"""
    try:
        service = CourseContentService()
        content = service.create_video_content(lesson_id, content_data)
        logger.info(f"Created video content for lesson {lesson_id}")
        return content
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error creating video content: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to create video content"
        )


@router.get(
    "/lessons/{lesson_id}/video",
    response_model=VideoContentResponse,
    summary="Get video content",
    description="Get video content for a lesson"
)
async def get_video_content(
    lesson_id: str
):
    """Get video content"""
    try:
        service = CourseContentService()
        content = service.get_video_content(lesson_id)
        if not content:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Video content not found"
            )
        return content
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error getting video content: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to retrieve video content"
        )


@router.put(
    "/lessons/{lesson_id}/video",
    response_model=VideoContentResponse,
    summary="Update video content",
    description="Update video content for a lesson"
)
async def update_video_content(
    lesson_id: str,
    content_data: VideoContentUpdate
):
    """Update video content"""
    try:
        service = CourseContentService()
        content = service.update_video_content(lesson_id, content_data)
        logger.info(f"Updated video content for lesson {lesson_id}")
        return content
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error updating video content: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to update video content"
        )


# =============================================================================
# TEXT CONTENT ENDPOINTS
# =============================================================================

@router.post(
    "/lessons/{lesson_id}/text",
    response_model=TextContentResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Create text content",
    description="Create text content for a lesson"
)
async def create_text_content(
    lesson_id: str,
    content_data: TextContentCreate
):
    """Create text content"""
    try:
        service = CourseContentService()
        content = service.create_text_content(lesson_id, content_data)
        logger.info(f"Created text content for lesson {lesson_id}")
        return content
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error creating text content: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to create text content"
        )


@router.get(
    "/lessons/{lesson_id}/text",
    response_model=TextContentResponse,
    summary="Get text content",
    description="Get text content for a lesson"
)
async def get_text_content(
    lesson_id: str
):
    """Get text content"""
    try:
        service = CourseContentService()
        content = service.get_text_content(lesson_id)
        if not content:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Text content not found"
            )
        return content
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error getting text content: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to retrieve text content"
        )


@router.put(
    "/lessons/{lesson_id}/text",
    response_model=TextContentResponse,
    summary="Update text content",
    description="Update text content for a lesson"
)
async def update_text_content(
    lesson_id: str,
    content_data: TextContentUpdate
):
    """Update text content"""
    try:
        service = CourseContentService()
        content = service.update_text_content(lesson_id, content_data)
        logger.info(f"Updated text content for lesson {lesson_id}")
        return content
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error updating text content: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to update text content"
        )


# =============================================================================
# QUIZ CONTENT ENDPOINTS
# =============================================================================

@router.post(
    "/lessons/{lesson_id}/quiz",
    response_model=QuizContentResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Create quiz content",
    description="Create quiz content for a lesson"
)
async def create_quiz_content(
    lesson_id: str,
    content_data: QuizContentCreate
):
    """Create quiz content"""
    try:
        service = CourseContentService()
        content = service.create_quiz_content(lesson_id, content_data)
        logger.info(f"Created quiz content for lesson {lesson_id}")
        return content
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error creating quiz content: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to create quiz content"
        )


@router.get(
    "/lessons/{lesson_id}/quiz",
    response_model=QuizContentResponse,
    summary="Get quiz content",
    description="Get quiz content for a lesson"
)
async def get_quiz_content(
    lesson_id: str
):
    """Get quiz content"""
    try:
        service = CourseContentService()
        content = service.get_quiz_content(lesson_id)
        if not content:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Quiz content not found"
            )
        return content
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error getting quiz content: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to retrieve quiz content"
        )


@router.put(
    "/lessons/{lesson_id}/quiz",
    response_model=QuizContentResponse,
    summary="Update quiz content",
    description="Update quiz content for a lesson"
)
async def update_quiz_content(
    lesson_id: str,
    content_data: QuizContentUpdate
):
    """Update quiz content"""
    try:
        service = CourseContentService()
        content = service.update_quiz_content(lesson_id, content_data)
        logger.info(f"Updated quiz content for lesson {lesson_id}")
        return content
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error updating quiz content: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to update quiz content"
        )


# =============================================================================
# QUIZ QUESTION ENDPOINTS
# =============================================================================

@router.post(
    "/quizzes/{quiz_id}/questions",
    response_model=QuizQuestionResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Create quiz question",
    description="Create a question for a quiz"
)
async def create_quiz_question(
    quiz_id: str,
    question_data: QuizQuestionCreate
):
    """Create quiz question"""
    try:
        service = CourseContentService()
        question = service.create_quiz_question(quiz_id, question_data)
        logger.info(f"Created question for quiz {quiz_id}")
        return question
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error creating quiz question: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to create quiz question"
        )


@router.get(
    "/quizzes/{quiz_id}/questions",
    response_model=List[QuizQuestionResponse],
    summary="Get quiz questions",
    description="Get all questions for a quiz"
)
async def get_quiz_questions(
    quiz_id: str
):
    """Get quiz questions"""
    try:
        service = CourseContentService()
        questions = service.get_quiz_questions(quiz_id)
        return questions
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error getting quiz questions: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to retrieve quiz questions"
        )


@router.put(
    "/questions/{question_id}",
    response_model=QuizQuestionResponse,
    summary="Update quiz question",
    description="Update a quiz question"
)
async def update_quiz_question(
    question_id: str,
    question_data: QuizQuestionUpdate
):
    """Update quiz question"""
    try:
        service = CourseContentService()
        question = service.update_quiz_question(question_id, question_data)
        logger.info(f"Updated question {question_id}")
        return question
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error updating quiz question: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to update quiz question"
        )


@router.delete(
    "/questions/{question_id}",
    status_code=status.HTTP_204_NO_CONTENT,
    summary="Delete quiz question",
    description="Delete a quiz question"
)
async def delete_quiz_question(
    question_id: str
):
    """Delete quiz question"""
    try:
        service = CourseContentService()
        service.delete_quiz_question(question_id)
        logger.info(f"Deleted question {question_id}")
        return None
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error deleting quiz question: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to delete quiz question"
        )


# =============================================================================
# QUESTION OPTION ENDPOINTS
# =============================================================================

@router.post(
    "/questions/{question_id}/options",
    response_model=QuestionOptionResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Create question option",
    description="Create an option for a multiple choice question"
)
async def create_question_option(
    question_id: str,
    option_data: QuestionOptionCreate
):
    """Create question option"""
    try:
        service = CourseContentService()
        option = service.create_question_option(question_id, option_data)
        logger.info(f"Created option for question {question_id}")
        return option
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error creating question option: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to create question option"
        )


@router.put(
    "/options/{option_id}",
    response_model=QuestionOptionResponse,
    summary="Update question option",
    description="Update a question option"
)
async def update_question_option(
    option_id: str,
    option_data: QuestionOptionUpdate
):
    """Update question option"""
    try:
        service = CourseContentService()
        option = service.update_question_option(option_id, option_data)
        logger.info(f"Updated option {option_id}")
        return option
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error updating question option: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to update question option"
        )


@router.delete(
    "/options/{option_id}",
    status_code=status.HTTP_204_NO_CONTENT,
    summary="Delete question option",
    description="Delete a question option"
)
async def delete_question_option(
    option_id: str
):
    """Delete question option"""
    try:
        service = CourseContentService()
        service.delete_question_option(option_id)
        logger.info(f"Deleted option {option_id}")
        return None
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error deleting question option: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to delete question option"
        )


# =============================================================================
# ASSIGNMENT CONTENT ENDPOINTS
# =============================================================================

@router.post(
    "/lessons/{lesson_id}/assignment",
    response_model=AssignmentContentResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Create assignment content",
    description="Create assignment content for a lesson"
)
async def create_assignment_content(
    lesson_id: str,
    content_data: AssignmentContentCreate
):
    """Create assignment content"""
    try:
        service = CourseContentService()
        content = service.create_assignment_content(lesson_id, content_data)
        logger.info(f"Created assignment content for lesson {lesson_id}")
        return content
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error creating assignment content: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to create assignment content"
        )


@router.get(
    "/lessons/{lesson_id}/assignment",
    response_model=AssignmentContentResponse,
    summary="Get assignment content",
    description="Get assignment content for a lesson"
)
async def get_assignment_content(
    lesson_id: str
):
    """Get assignment content"""
    try:
        service = CourseContentService()
        content = service.get_assignment_content(lesson_id)
        if not content:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Assignment content not found"
            )
        return content
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error getting assignment content: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to retrieve assignment content"
        )


@router.put(
    "/lessons/{lesson_id}/assignment",
    response_model=AssignmentContentResponse,
    summary="Update assignment content",
    description="Update assignment content for a lesson"
)
async def update_assignment_content(
    lesson_id: str,
    content_data: AssignmentContentUpdate
):
    """Update assignment content"""
    try:
        service = CourseContentService()
        content = service.update_assignment_content(lesson_id, content_data)
        logger.info(f"Updated assignment content for lesson {lesson_id}")
        return content
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error updating assignment content: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to update assignment content"
        )


# =============================================================================
# STUDENT PROGRESS ENDPOINTS
# =============================================================================

@router.post(
    "/lessons/{lesson_id}/complete",
    response_model=Dict[str, Any],
    summary="Mark lesson complete",
    description="Mark a lesson as completed by a student"
)
async def mark_lesson_complete(
    lesson_id: str,
    completion_data: LessonCompletionCreate
):
    """Mark lesson as completed"""
    try:
        service = CourseContentService()
        completion = service.mark_lesson_complete(
            lesson_id,
            completion_data.user_id,
            completion_data.time_spent_minutes
        )
        logger.info(f"Marked lesson {lesson_id} complete for user {completion_data.user_id}")
        return completion
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error marking lesson complete: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to mark lesson complete"
        )


@router.get(
    "/courses/{course_id}/progress/{user_id}",
    response_model=CourseProgressResponse,
    summary="Get course progress",
    description="Get student's progress for a course"
)
async def get_course_progress(
    course_id: str,
    user_id: str
):
    """Get course progress for a student"""
    try:
        service = CourseContentService()
        progress = service.get_user_course_progress(user_id, course_id)
        return progress
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error getting course progress: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to retrieve course progress"
        )


# =============================================================================
# QUIZ ATTEMPT ENDPOINTS
# =============================================================================

@router.post(
    "/quizzes/{quiz_id}/attempts",
    response_model=QuizAttemptResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Create quiz attempt",
    description="Start a new quiz attempt"
)
async def create_quiz_attempt(
    quiz_id: str,
    attempt_data: QuizAttemptCreate
):
    """Create a new quiz attempt"""
    try:
        service = CourseContentService()
        attempt = service.create_quiz_attempt(quiz_id, attempt_data.user_id)
        logger.info(f"Created quiz attempt for quiz {quiz_id} by user {attempt_data.user_id}")
        return attempt
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error creating quiz attempt: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to create quiz attempt"
        )


@router.post(
    "/quiz-attempts/{attempt_id}/submit",
    response_model=QuizAttemptResponse,
    summary="Submit quiz attempt",
    description="Submit a quiz attempt with answers"
)
async def submit_quiz_attempt(
    attempt_id: str,
    submission_data: QuizAttemptSubmit
):
    """Submit quiz attempt"""
    try:
        service = CourseContentService()
        attempt = service.submit_quiz_attempt(
            attempt_id,
            submission_data.answers
        )
        logger.info(f"Submitted quiz attempt {attempt_id}")
        return attempt
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error submitting quiz attempt: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to submit quiz attempt"
        )


@router.get(
    "/quizzes/{quiz_id}/attempts/{user_id}",
    response_model=List[QuizAttemptResponse],
    summary="Get quiz attempts",
    description="Get all attempts for a quiz by a user"
)
async def get_quiz_attempts(
    quiz_id: str,
    user_id: str
):
    """Get quiz attempts for a user"""
    try:
        service = CourseContentService()
        attempts = service.get_user_quiz_attempts(quiz_id, user_id)
        return attempts
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error getting quiz attempts: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to retrieve quiz attempts"
        )


# =============================================================================
# ASSIGNMENT SUBMISSION ENDPOINTS
# =============================================================================

@router.post(
    "/assignments/{assignment_id}/submit",
    response_model=AssignmentSubmissionResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Submit assignment",
    description="Submit or update an assignment submission"
)
async def submit_assignment(
    assignment_id: str,
    submission_data: AssignmentSubmissionCreate
):
    """Submit assignment"""
    try:
        service = CourseContentService()
        submission = service.create_assignment_submission(assignment_id, submission_data)
        logger.info(f"Created submission for assignment {assignment_id} by user {submission_data.user_id}")
        return submission
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error submitting assignment: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to submit assignment"
        )


@router.get(
    "/assignments/{assignment_id}/submissions/{user_id}",
    response_model=AssignmentSubmissionResponse,
    summary="Get assignment submission",
    description="Get a student's submission for an assignment"
)
async def get_assignment_submission(
    assignment_id: str,
    user_id: str
):
    """Get assignment submission"""
    try:
        service = CourseContentService()
        submission = service.get_assignment_submission(assignment_id, user_id)
        if not submission:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Submission not found"
            )
        return submission
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error getting assignment submission: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to retrieve assignment submission"
        )


@router.put(
    "/submissions/{submission_id}/grade",
    response_model=AssignmentSubmissionResponse,
    summary="Grade assignment submission",
    description="Grade a student's assignment submission (institutions only)"
)
async def grade_assignment_submission(
    submission_id: str,
    grade_data: AssignmentSubmissionUpdate
):
    """Grade assignment submission"""
    try:
        service = CourseContentService()
        submission = service.update_assignment_submission(submission_id, grade_data)
        logger.info(f"Graded submission {submission_id}")
        return submission
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error grading submission: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to grade submission"
        )


@router.get(
    "/assignments/{assignment_id}/submissions",
    response_model=List[AssignmentSubmissionResponse],
    summary="Get all assignment submissions",
    description="Get all submissions for an assignment (institutions only)"
)
async def get_all_assignment_submissions(
    assignment_id: str
):
    """Get all submissions for an assignment"""
    try:
        service = CourseContentService()
        submissions = service.get_all_assignment_submissions(assignment_id)
        return submissions
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error getting submissions: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to retrieve submissions"
        )
