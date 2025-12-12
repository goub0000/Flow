"""
Course Content Service
Handles all business logic for course modules, lessons, and content management
"""

from typing import List, Dict, Any, Optional
from datetime import datetime
import logging
from fastapi import HTTPException, status

from app.database.config import get_supabase

logger = logging.getLogger(__name__)


class CourseContentService:
    """
    Service layer for course content management using Supabase

    Provides CRUD operations and business logic for:
    - Course modules
    - Course lessons
    - Lesson content (videos, texts, quizzes, assignments)
    - Quiz questions and options
    - Student progress tracking
    """

    def __init__(self, db=None):
        self.supabase = get_supabase()

    # =========================================================================
    # MODULE OPERATIONS
    # =========================================================================

    def create_module(self, course_id: str, module_data) -> Dict[str, Any]:
        """Create a new course module"""
        try:
            data = {
                "course_id": course_id,
                "title": module_data.title,
                "description": module_data.description,
                "order_index": module_data.order_index,
                "learning_objectives": module_data.learning_objectives or [],
                "is_published": module_data.is_published
            }

            response = self.supabase.table("course_modules").insert(data).execute()

            if response.data:
                logger.info(f"Created module: {response.data[0]['id']} for course: {course_id}")
                return response.data[0]
            else:
                raise HTTPException(
                    status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                    detail="Failed to create module"
                )
        except Exception as e:
            logger.error(f"Error creating module: {e}")
            raise

    def get_course_modules(self, course_id: str) -> List[Dict[str, Any]]:
        """Get all modules for a course, ordered by order_index"""
        try:
            response = self.supabase.table("course_modules")\
                .select("*")\
                .eq("course_id", course_id)\
                .order("order_index")\
                .execute()

            return response.data or []
        except Exception as e:
            logger.error(f"Error getting modules: {e}")
            raise

    def get_module_by_id(self, module_id: str) -> Optional[Dict[str, Any]]:
        """Get a single module by ID"""
        try:
            response = self.supabase.table("course_modules")\
                .select("*")\
                .eq("id", module_id)\
                .single()\
                .execute()

            return response.data
        except Exception as e:
            logger.error(f"Error getting module: {e}")
            return None

    def update_module(self, module_id: str, module_data) -> Dict[str, Any]:
        """Update module fields"""
        try:
            # Build update data from non-None fields
            update_data = {}
            if module_data.title is not None:
                update_data["title"] = module_data.title
            if module_data.description is not None:
                update_data["description"] = module_data.description
            if module_data.order_index is not None:
                update_data["order_index"] = module_data.order_index
            if module_data.learning_objectives is not None:
                update_data["learning_objectives"] = module_data.learning_objectives
            if module_data.is_published is not None:
                update_data["is_published"] = module_data.is_published

            if not update_data:
                # No updates, return existing module
                return self.get_module_by_id(module_id)

            response = self.supabase.table("course_modules")\
                .update(update_data)\
                .eq("id", module_id)\
                .execute()

            if response.data:
                logger.info(f"Updated module: {module_id}")
                return response.data[0]
            else:
                raise HTTPException(
                    status_code=status.HTTP_404_NOT_FOUND,
                    detail=f"Module not found: {module_id}"
                )
        except HTTPException:
            raise
        except Exception as e:
            logger.error(f"Error updating module: {e}")
            raise

    def delete_module(self, module_id: str) -> bool:
        """Delete a module and all its lessons (CASCADE)"""
        try:
            response = self.supabase.table("course_modules")\
                .delete()\
                .eq("id", module_id)\
                .execute()

            logger.info(f"Deleted module: {module_id}")
            return True
        except Exception as e:
            logger.error(f"Error deleting module: {e}")
            raise

    def reorder_modules(self, course_id: str, module_orders: List[Dict[str, int]]) -> bool:
        """Reorder modules for a course"""
        try:
            for order_item in module_orders:
                for module_id, order_index in order_item.items():
                    self.supabase.table("course_modules")\
                        .update({"order_index": order_index})\
                        .eq("id", module_id)\
                        .eq("course_id", course_id)\
                        .execute()

            logger.info(f"Reordered modules for course: {course_id}")
            return True
        except Exception as e:
            logger.error(f"Error reordering modules: {e}")
            raise

    # =========================================================================
    # LESSON OPERATIONS
    # =========================================================================

    def create_lesson(self, module_id: str, lesson_data) -> Dict[str, Any]:
        """Create a new lesson"""
        try:
            data = {
                "module_id": module_id,
                "title": lesson_data.title,
                "description": lesson_data.description,
                "lesson_type": lesson_data.lesson_type.value if hasattr(lesson_data.lesson_type, 'value') else lesson_data.lesson_type,
                "order_index": lesson_data.order_index,
                "duration_minutes": lesson_data.duration_minutes,
                "is_mandatory": lesson_data.is_mandatory,
                "is_published": lesson_data.is_published,
                "allow_preview": lesson_data.allow_preview
            }

            response = self.supabase.table("course_lessons").insert(data).execute()

            if response.data:
                logger.info(f"Created lesson: {response.data[0]['id']} for module: {module_id}")
                return response.data[0]
            else:
                raise HTTPException(
                    status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                    detail="Failed to create lesson"
                )
        except Exception as e:
            logger.error(f"Error creating lesson: {e}")
            raise

    def get_module_lessons(self, module_id: str) -> List[Dict[str, Any]]:
        """Get all lessons for a module, ordered by order_index"""
        try:
            response = self.supabase.table("course_lessons")\
                .select("*")\
                .eq("module_id", module_id)\
                .order("order_index")\
                .execute()

            return response.data or []
        except Exception as e:
            logger.error(f"Error getting lessons: {e}")
            raise

    def get_lesson_by_id(self, lesson_id: str) -> Optional[Dict[str, Any]]:
        """Get a single lesson by ID"""
        try:
            response = self.supabase.table("course_lessons")\
                .select("*")\
                .eq("id", lesson_id)\
                .single()\
                .execute()

            return response.data
        except Exception as e:
            logger.error(f"Error getting lesson: {e}")
            return None

    def update_lesson(self, lesson_id: str, lesson_data) -> Dict[str, Any]:
        """Update lesson fields"""
        try:
            update_data = {}
            if lesson_data.title is not None:
                update_data["title"] = lesson_data.title
            if lesson_data.description is not None:
                update_data["description"] = lesson_data.description
            if lesson_data.lesson_type is not None:
                update_data["lesson_type"] = lesson_data.lesson_type.value if hasattr(lesson_data.lesson_type, 'value') else lesson_data.lesson_type
            if lesson_data.order_index is not None:
                update_data["order_index"] = lesson_data.order_index
            if lesson_data.duration_minutes is not None:
                update_data["duration_minutes"] = lesson_data.duration_minutes
            if lesson_data.is_mandatory is not None:
                update_data["is_mandatory"] = lesson_data.is_mandatory
            if lesson_data.is_published is not None:
                update_data["is_published"] = lesson_data.is_published
            if lesson_data.allow_preview is not None:
                update_data["allow_preview"] = lesson_data.allow_preview

            if not update_data:
                return self.get_lesson_by_id(lesson_id)

            response = self.supabase.table("course_lessons")\
                .update(update_data)\
                .eq("id", lesson_id)\
                .execute()

            if response.data:
                logger.info(f"Updated lesson: {lesson_id}")
                return response.data[0]
            else:
                raise HTTPException(
                    status_code=status.HTTP_404_NOT_FOUND,
                    detail=f"Lesson not found: {lesson_id}"
                )
        except HTTPException:
            raise
        except Exception as e:
            logger.error(f"Error updating lesson: {e}")
            raise

    def delete_lesson(self, lesson_id: str) -> bool:
        """Delete a lesson and its content (CASCADE)"""
        try:
            response = self.supabase.table("course_lessons")\
                .delete()\
                .eq("id", lesson_id)\
                .execute()

            logger.info(f"Deleted lesson: {lesson_id}")
            return True
        except Exception as e:
            logger.error(f"Error deleting lesson: {e}")
            raise

    def reorder_lessons(self, module_id: str, lesson_orders: List[Dict[str, int]]) -> bool:
        """Reorder lessons within a module"""
        try:
            for order_item in lesson_orders:
                for lesson_id, order_index in order_item.items():
                    self.supabase.table("course_lessons")\
                        .update({"order_index": order_index})\
                        .eq("id", lesson_id)\
                        .eq("module_id", module_id)\
                        .execute()

            logger.info(f"Reordered lessons for module: {module_id}")
            return True
        except Exception as e:
            logger.error(f"Error reordering lessons: {e}")
            raise

    # =========================================================================
    # VIDEO CONTENT OPERATIONS
    # =========================================================================

    def create_video_content(self, lesson_id: str, content_data) -> Dict[str, Any]:
        """Create video content for a lesson"""
        try:
            data = {
                "lesson_id": lesson_id,
                "video_url": content_data.video_url,
                "video_platform": content_data.video_platform.value if hasattr(content_data.video_platform, 'value') else content_data.video_platform,
                "thumbnail_url": content_data.thumbnail_url,
                "duration_seconds": content_data.duration_seconds,
                "transcript": content_data.transcript,
                "allow_download": content_data.allow_download,
                "auto_play": content_data.auto_play,
                "show_controls": content_data.show_controls
            }

            response = self.supabase.table("lesson_videos").insert(data).execute()

            if response.data:
                logger.info(f"Created video content for lesson: {lesson_id}")
                return response.data[0]
            else:
                raise HTTPException(
                    status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                    detail="Failed to create video content"
                )
        except Exception as e:
            logger.error(f"Error creating video content: {e}")
            raise

    def get_video_content(self, lesson_id: str) -> Optional[Dict[str, Any]]:
        """Get video content for a lesson"""
        try:
            response = self.supabase.table("lesson_videos")\
                .select("*")\
                .eq("lesson_id", lesson_id)\
                .single()\
                .execute()

            return response.data
        except Exception as e:
            logger.error(f"Error getting video content: {e}")
            return None

    def update_video_content(self, lesson_id: str, content_data) -> Dict[str, Any]:
        """Update video content"""
        try:
            update_data = {}
            if content_data.video_url is not None:
                update_data["video_url"] = content_data.video_url
            if content_data.video_platform is not None:
                update_data["video_platform"] = content_data.video_platform.value if hasattr(content_data.video_platform, 'value') else content_data.video_platform
            if content_data.thumbnail_url is not None:
                update_data["thumbnail_url"] = content_data.thumbnail_url
            if content_data.duration_seconds is not None:
                update_data["duration_seconds"] = content_data.duration_seconds
            if content_data.transcript is not None:
                update_data["transcript"] = content_data.transcript
            if content_data.allow_download is not None:
                update_data["allow_download"] = content_data.allow_download
            if content_data.auto_play is not None:
                update_data["auto_play"] = content_data.auto_play
            if content_data.show_controls is not None:
                update_data["show_controls"] = content_data.show_controls

            if not update_data:
                return self.get_video_content(lesson_id)

            response = self.supabase.table("lesson_videos")\
                .update(update_data)\
                .eq("lesson_id", lesson_id)\
                .execute()

            if response.data:
                return response.data[0]
            else:
                raise HTTPException(
                    status_code=status.HTTP_404_NOT_FOUND,
                    detail="Video content not found"
                )
        except HTTPException:
            raise
        except Exception as e:
            logger.error(f"Error updating video content: {e}")
            raise

    # =========================================================================
    # TEXT CONTENT OPERATIONS
    # =========================================================================

    def create_text_content(self, lesson_id: str, content_data) -> Dict[str, Any]:
        """Create text content for a lesson"""
        try:
            data = {
                "lesson_id": lesson_id,
                "content": content_data.content,
                "content_format": content_data.content_format.value if hasattr(content_data.content_format, 'value') else content_data.content_format,
                "estimated_reading_time": content_data.estimated_reading_time,
                "attachments": content_data.attachments or [],
                "external_links": content_data.external_links or []
            }

            response = self.supabase.table("lesson_texts").insert(data).execute()

            if response.data:
                logger.info(f"Created text content for lesson: {lesson_id}")
                return response.data[0]
            else:
                raise HTTPException(
                    status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                    detail="Failed to create text content"
                )
        except Exception as e:
            logger.error(f"Error creating text content: {e}")
            raise

    def get_text_content(self, lesson_id: str) -> Optional[Dict[str, Any]]:
        """Get text content for a lesson"""
        try:
            response = self.supabase.table("lesson_texts")\
                .select("*")\
                .eq("lesson_id", lesson_id)\
                .single()\
                .execute()

            return response.data
        except Exception as e:
            logger.error(f"Error getting text content: {e}")
            return None

    def update_text_content(self, lesson_id: str, content_data) -> Dict[str, Any]:
        """Update text content"""
        try:
            update_data = {}
            if content_data.content is not None:
                update_data["content"] = content_data.content
            if content_data.content_format is not None:
                update_data["content_format"] = content_data.content_format.value if hasattr(content_data.content_format, 'value') else content_data.content_format
            if content_data.estimated_reading_time is not None:
                update_data["estimated_reading_time"] = content_data.estimated_reading_time
            if content_data.attachments is not None:
                update_data["attachments"] = content_data.attachments
            if content_data.external_links is not None:
                update_data["external_links"] = content_data.external_links

            if not update_data:
                return self.get_text_content(lesson_id)

            response = self.supabase.table("lesson_texts")\
                .update(update_data)\
                .eq("lesson_id", lesson_id)\
                .execute()

            if response.data:
                return response.data[0]
            else:
                raise HTTPException(
                    status_code=status.HTTP_404_NOT_FOUND,
                    detail="Text content not found"
                )
        except HTTPException:
            raise
        except Exception as e:
            logger.error(f"Error updating text content: {e}")
            raise

    # =========================================================================
    # QUIZ CONTENT OPERATIONS
    # =========================================================================

    def create_quiz_content(self, lesson_id: str, content_data) -> Dict[str, Any]:
        """Create quiz content for a lesson"""
        try:
            data = {
                "lesson_id": lesson_id,
                "title": content_data.title,
                "instructions": content_data.instructions,
                "passing_score": float(content_data.passing_score),
                "max_attempts": content_data.max_attempts,
                "time_limit_minutes": content_data.time_limit_minutes,
                "shuffle_questions": content_data.shuffle_questions,
                "shuffle_options": content_data.shuffle_options,
                "show_correct_answers": content_data.show_correct_answers,
                "show_feedback": content_data.show_feedback
            }

            response = self.supabase.table("lesson_quizzes").insert(data).execute()

            if response.data:
                logger.info(f"Created quiz content for lesson: {lesson_id}")
                return response.data[0]
            else:
                raise HTTPException(
                    status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                    detail="Failed to create quiz content"
                )
        except Exception as e:
            logger.error(f"Error creating quiz content: {e}")
            raise

    def get_quiz_content(self, lesson_id: str) -> Optional[Dict[str, Any]]:
        """Get quiz content for a lesson"""
        try:
            response = self.supabase.table("lesson_quizzes")\
                .select("*")\
                .eq("lesson_id", lesson_id)\
                .single()\
                .execute()

            return response.data
        except Exception as e:
            logger.error(f"Error getting quiz content: {e}")
            return None

    def update_quiz_content(self, lesson_id: str, content_data) -> Dict[str, Any]:
        """Update quiz content"""
        try:
            update_data = {}
            if content_data.title is not None:
                update_data["title"] = content_data.title
            if content_data.instructions is not None:
                update_data["instructions"] = content_data.instructions
            if content_data.passing_score is not None:
                update_data["passing_score"] = float(content_data.passing_score)
            if content_data.max_attempts is not None:
                update_data["max_attempts"] = content_data.max_attempts
            if content_data.time_limit_minutes is not None:
                update_data["time_limit_minutes"] = content_data.time_limit_minutes
            if content_data.shuffle_questions is not None:
                update_data["shuffle_questions"] = content_data.shuffle_questions
            if content_data.shuffle_options is not None:
                update_data["shuffle_options"] = content_data.shuffle_options
            if content_data.show_correct_answers is not None:
                update_data["show_correct_answers"] = content_data.show_correct_answers
            if content_data.show_feedback is not None:
                update_data["show_feedback"] = content_data.show_feedback

            if not update_data:
                return self.get_quiz_content(lesson_id)

            response = self.supabase.table("lesson_quizzes")\
                .update(update_data)\
                .eq("lesson_id", lesson_id)\
                .execute()

            if response.data:
                return response.data[0]
            else:
                raise HTTPException(
                    status_code=status.HTTP_404_NOT_FOUND,
                    detail="Quiz content not found"
                )
        except HTTPException:
            raise
        except Exception as e:
            logger.error(f"Error updating quiz content: {e}")
            raise

    # =========================================================================
    # QUIZ QUESTION OPERATIONS
    # =========================================================================

    def create_quiz_question(self, quiz_id: str, question_data) -> Dict[str, Any]:
        """Create a quiz question"""
        try:
            data = {
                "quiz_id": quiz_id,
                "question_text": question_data.question_text,
                "question_type": question_data.question_type.value if hasattr(question_data.question_type, 'value') else question_data.question_type,
                "order_index": question_data.order_index,
                "points": question_data.points,
                "correct_answer": question_data.correct_answer,
                "sample_answer": question_data.sample_answer,
                "explanation": question_data.explanation,
                "hint": question_data.hint,
                "is_required": question_data.is_required
            }

            response = self.supabase.table("quiz_questions").insert(data).execute()

            if response.data:
                logger.info(f"Created question for quiz: {quiz_id}")
                return response.data[0]
            else:
                raise HTTPException(
                    status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                    detail="Failed to create quiz question"
                )
        except Exception as e:
            logger.error(f"Error creating quiz question: {e}")
            raise

    def get_quiz_questions(self, quiz_id: str) -> List[Dict[str, Any]]:
        """Get all questions for a quiz, ordered by order_index"""
        try:
            response = self.supabase.table("quiz_questions")\
                .select("*")\
                .eq("quiz_id", quiz_id)\
                .order("order_index")\
                .execute()

            return response.data or []
        except Exception as e:
            logger.error(f"Error getting quiz questions: {e}")
            raise

    def update_quiz_question(self, question_id: str, question_data) -> Dict[str, Any]:
        """Update a quiz question"""
        try:
            update_data = {}
            if question_data.question_text is not None:
                update_data["question_text"] = question_data.question_text
            if question_data.question_type is not None:
                update_data["question_type"] = question_data.question_type.value if hasattr(question_data.question_type, 'value') else question_data.question_type
            if question_data.order_index is not None:
                update_data["order_index"] = question_data.order_index
            if question_data.points is not None:
                update_data["points"] = question_data.points
            if question_data.correct_answer is not None:
                update_data["correct_answer"] = question_data.correct_answer
            if question_data.sample_answer is not None:
                update_data["sample_answer"] = question_data.sample_answer
            if question_data.explanation is not None:
                update_data["explanation"] = question_data.explanation
            if question_data.hint is not None:
                update_data["hint"] = question_data.hint
            if question_data.is_required is not None:
                update_data["is_required"] = question_data.is_required

            if not update_data:
                response = self.supabase.table("quiz_questions")\
                    .select("*")\
                    .eq("id", question_id)\
                    .single()\
                    .execute()
                return response.data

            response = self.supabase.table("quiz_questions")\
                .update(update_data)\
                .eq("id", question_id)\
                .execute()

            if response.data:
                return response.data[0]
            else:
                raise HTTPException(
                    status_code=status.HTTP_404_NOT_FOUND,
                    detail="Quiz question not found"
                )
        except HTTPException:
            raise
        except Exception as e:
            logger.error(f"Error updating quiz question: {e}")
            raise

    def delete_quiz_question(self, question_id: str) -> bool:
        """Delete a quiz question"""
        try:
            response = self.supabase.table("quiz_questions")\
                .delete()\
                .eq("id", question_id)\
                .execute()

            return True
        except Exception as e:
            logger.error(f"Error deleting quiz question: {e}")
            raise

    # =========================================================================
    # QUESTION OPTION OPERATIONS
    # =========================================================================

    def create_question_option(self, question_id: str, option_data) -> Dict[str, Any]:
        """Create an option for a multiple choice question"""
        try:
            data = {
                "question_id": question_id,
                "option_text": option_data.option_text,
                "order_index": option_data.order_index,
                "is_correct": option_data.is_correct,
                "feedback": option_data.feedback
            }

            response = self.supabase.table("quiz_question_options").insert(data).execute()

            if response.data:
                logger.info(f"Created option for question: {question_id}")
                return response.data[0]
            else:
                raise HTTPException(
                    status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                    detail="Failed to create question option"
                )
        except Exception as e:
            logger.error(f"Error creating question option: {e}")
            raise

    def update_question_option(self, option_id: str, option_data) -> Dict[str, Any]:
        """Update a question option"""
        try:
            update_data = {}
            if option_data.option_text is not None:
                update_data["option_text"] = option_data.option_text
            if option_data.order_index is not None:
                update_data["order_index"] = option_data.order_index
            if option_data.is_correct is not None:
                update_data["is_correct"] = option_data.is_correct
            if option_data.feedback is not None:
                update_data["feedback"] = option_data.feedback

            if not update_data:
                response = self.supabase.table("quiz_question_options")\
                    .select("*")\
                    .eq("id", option_id)\
                    .single()\
                    .execute()
                return response.data

            response = self.supabase.table("quiz_question_options")\
                .update(update_data)\
                .eq("id", option_id)\
                .execute()

            if response.data:
                return response.data[0]
            else:
                raise HTTPException(
                    status_code=status.HTTP_404_NOT_FOUND,
                    detail="Question option not found"
                )
        except HTTPException:
            raise
        except Exception as e:
            logger.error(f"Error updating question option: {e}")
            raise

    def delete_question_option(self, option_id: str) -> bool:
        """Delete a question option"""
        try:
            response = self.supabase.table("quiz_question_options")\
                .delete()\
                .eq("id", option_id)\
                .execute()

            return True
        except Exception as e:
            logger.error(f"Error deleting question option: {e}")
            raise

    # =========================================================================
    # ASSIGNMENT CONTENT OPERATIONS
    # =========================================================================

    def create_assignment_content(self, lesson_id: str, content_data) -> Dict[str, Any]:
        """Create assignment content for a lesson"""
        try:
            data = {
                "lesson_id": lesson_id,
                "title": content_data.title,
                "instructions": content_data.instructions,
                "submission_type": content_data.submission_type.value if hasattr(content_data.submission_type, 'value') else content_data.submission_type,
                "allowed_file_types": content_data.allowed_file_types or [],
                "max_file_size_mb": content_data.max_file_size_mb,
                "points_possible": content_data.points_possible,
                "rubric": content_data.rubric or [],
                "due_date": content_data.due_date.isoformat() if content_data.due_date else None,
                "allow_late_submission": content_data.allow_late_submission,
                "late_penalty_percent": float(content_data.late_penalty_percent)
            }

            response = self.supabase.table("lesson_assignments").insert(data).execute()

            if response.data:
                logger.info(f"Created assignment content for lesson: {lesson_id}")
                return response.data[0]
            else:
                raise HTTPException(
                    status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                    detail="Failed to create assignment content"
                )
        except Exception as e:
            logger.error(f"Error creating assignment content: {e}")
            raise

    def get_assignment_content(self, lesson_id: str) -> Optional[Dict[str, Any]]:
        """Get assignment content for a lesson"""
        try:
            response = self.supabase.table("lesson_assignments")\
                .select("*")\
                .eq("lesson_id", lesson_id)\
                .single()\
                .execute()

            return response.data
        except Exception as e:
            logger.error(f"Error getting assignment content: {e}")
            return None

    def update_assignment_content(self, lesson_id: str, content_data) -> Dict[str, Any]:
        """Update assignment content"""
        try:
            update_data = {}
            if content_data.title is not None:
                update_data["title"] = content_data.title
            if content_data.instructions is not None:
                update_data["instructions"] = content_data.instructions
            if content_data.submission_type is not None:
                update_data["submission_type"] = content_data.submission_type.value if hasattr(content_data.submission_type, 'value') else content_data.submission_type
            if content_data.allowed_file_types is not None:
                update_data["allowed_file_types"] = content_data.allowed_file_types
            if content_data.max_file_size_mb is not None:
                update_data["max_file_size_mb"] = content_data.max_file_size_mb
            if content_data.points_possible is not None:
                update_data["points_possible"] = content_data.points_possible
            if content_data.rubric is not None:
                update_data["rubric"] = content_data.rubric
            if content_data.due_date is not None:
                update_data["due_date"] = content_data.due_date.isoformat()
            if content_data.allow_late_submission is not None:
                update_data["allow_late_submission"] = content_data.allow_late_submission
            if content_data.late_penalty_percent is not None:
                update_data["late_penalty_percent"] = float(content_data.late_penalty_percent)

            if not update_data:
                return self.get_assignment_content(lesson_id)

            response = self.supabase.table("lesson_assignments")\
                .update(update_data)\
                .eq("lesson_id", lesson_id)\
                .execute()

            if response.data:
                return response.data[0]
            else:
                raise HTTPException(
                    status_code=status.HTTP_404_NOT_FOUND,
                    detail="Assignment content not found"
                )
        except HTTPException:
            raise
        except Exception as e:
            logger.error(f"Error updating assignment content: {e}")
            raise

    # =========================================================================
    # STUDENT PROGRESS TRACKING
    # =========================================================================

    def mark_lesson_complete(self, lesson_id: str, user_id: str, time_spent_minutes: int = 0) -> Dict[str, Any]:
        """Mark a lesson as completed by a student"""
        try:
            # Check if already completed
            existing = self.supabase.table("lesson_completions")\
                .select("*")\
                .eq("lesson_id", lesson_id)\
                .eq("user_id", user_id)\
                .execute()

            if existing.data:
                # Update existing completion
                response = self.supabase.table("lesson_completions")\
                    .update({
                        "time_spent_minutes": time_spent_minutes,
                        "completed_at": datetime.utcnow().isoformat()
                    })\
                    .eq("lesson_id", lesson_id)\
                    .eq("user_id", user_id)\
                    .execute()
                return response.data[0]

            # Create new completion
            data = {
                "lesson_id": lesson_id,
                "user_id": user_id,
                "time_spent_minutes": time_spent_minutes,
                "completion_percentage": 100.0
            }

            response = self.supabase.table("lesson_completions").insert(data).execute()

            if response.data:
                logger.info(f"User {user_id} completed lesson: {lesson_id}")
                return response.data[0]
            else:
                raise HTTPException(
                    status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                    detail="Failed to mark lesson complete"
                )
        except Exception as e:
            logger.error(f"Error marking lesson complete: {e}")
            raise

    def get_user_course_progress(self, user_id: str, course_id: str) -> Dict[str, Any]:
        """Get detailed progress for a user in a course"""
        try:
            # Get all modules for the course
            modules = self.get_course_modules(course_id)

            total_lessons = 0
            completed_lessons = 0

            for module in modules:
                lessons = self.get_module_lessons(module["id"])
                total_lessons += len(lessons)

                for lesson in lessons:
                    completion = self.supabase.table("lesson_completions")\
                        .select("*")\
                        .eq("lesson_id", lesson["id"])\
                        .eq("user_id", user_id)\
                        .execute()

                    if completion.data:
                        completed_lessons += 1

            progress_percentage = (completed_lessons / total_lessons * 100) if total_lessons > 0 else 0

            return {
                "course_id": course_id,
                "user_id": user_id,
                "total_modules": len(modules),
                "total_lessons": total_lessons,
                "completed_lessons": completed_lessons,
                "progress_percentage": round(progress_percentage, 2)
            }
        except Exception as e:
            logger.error(f"Error getting course progress: {e}")
            raise

    def create_quiz_attempt(self, quiz_id: str, user_id: str) -> Dict[str, Any]:
        """Create a new quiz attempt"""
        try:
            # Get current attempt count
            existing = self.supabase.table("quiz_attempts")\
                .select("attempt_number")\
                .eq("quiz_id", quiz_id)\
                .eq("user_id", user_id)\
                .order("attempt_number", desc=True)\
                .limit(1)\
                .execute()

            attempt_number = 1
            if existing.data:
                attempt_number = existing.data[0]["attempt_number"] + 1

            data = {
                "quiz_id": quiz_id,
                "user_id": user_id,
                "attempt_number": attempt_number,
                "status": "in_progress"
            }

            response = self.supabase.table("quiz_attempts").insert(data).execute()

            if response.data:
                logger.info(f"User {user_id} started quiz attempt for quiz: {quiz_id}")
                return response.data[0]
            else:
                raise HTTPException(
                    status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                    detail="Failed to create quiz attempt"
                )
        except Exception as e:
            logger.error(f"Error creating quiz attempt: {e}")
            raise

    def submit_quiz_attempt(self, attempt_id: str, answers: List[Dict]) -> Dict[str, Any]:
        """Submit and grade a quiz attempt"""
        try:
            # Get the attempt
            attempt_response = self.supabase.table("quiz_attempts")\
                .select("*")\
                .eq("id", attempt_id)\
                .single()\
                .execute()

            if not attempt_response.data:
                raise HTTPException(
                    status_code=status.HTTP_404_NOT_FOUND,
                    detail=f"Quiz attempt not found: {attempt_id}"
                )

            # Calculate score (simplified - would need actual grading logic)
            points_earned = 0
            points_possible = 0

            for answer in answers:
                if "points" in answer:
                    points_possible += answer.get("max_points", 1)
                    if answer.get("is_correct", False):
                        points_earned += answer.get("points", 0)

            score = (points_earned / points_possible * 100) if points_possible > 0 else 0

            update_data = {
                "answers": answers,
                "points_earned": points_earned,
                "points_possible": points_possible,
                "score": score,
                "status": "submitted",
                "submitted_at": datetime.utcnow().isoformat(),
                "passed": score >= 70.0
            }

            response = self.supabase.table("quiz_attempts")\
                .update(update_data)\
                .eq("id", attempt_id)\
                .execute()

            if response.data:
                logger.info(f"Quiz attempt submitted: {attempt_id}, score: {score}%")
                return response.data[0]
            else:
                raise HTTPException(
                    status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                    detail="Failed to submit quiz attempt"
                )
        except HTTPException:
            raise
        except Exception as e:
            logger.error(f"Error submitting quiz attempt: {e}")
            raise

    def get_user_quiz_attempts(self, quiz_id: str, user_id: str) -> List[Dict[str, Any]]:
        """Get all attempts for a quiz by a user"""
        try:
            response = self.supabase.table("quiz_attempts")\
                .select("*")\
                .eq("quiz_id", quiz_id)\
                .eq("user_id", user_id)\
                .order("attempt_number")\
                .execute()

            return response.data or []
        except Exception as e:
            logger.error(f"Error getting quiz attempts: {e}")
            raise

    def create_assignment_submission(self, assignment_id: str, submission_data) -> Dict[str, Any]:
        """Create or update an assignment submission"""
        try:
            # Check if submission exists
            existing = self.supabase.table("assignment_submissions")\
                .select("*")\
                .eq("assignment_id", assignment_id)\
                .eq("user_id", submission_data.user_id)\
                .execute()

            if existing.data:
                # Update existing submission
                update_data = {
                    "text_submission": submission_data.text_submission,
                    "file_urls": submission_data.file_urls or [],
                    "external_url": submission_data.external_url,
                    "status": "submitted",
                    "submitted_at": datetime.utcnow().isoformat()
                }

                response = self.supabase.table("assignment_submissions")\
                    .update(update_data)\
                    .eq("assignment_id", assignment_id)\
                    .eq("user_id", submission_data.user_id)\
                    .execute()

                return response.data[0]

            # Create new submission
            data = {
                "assignment_id": assignment_id,
                "user_id": submission_data.user_id,
                "text_submission": submission_data.text_submission,
                "file_urls": submission_data.file_urls or [],
                "external_url": submission_data.external_url,
                "status": "submitted",
                "submitted_at": datetime.utcnow().isoformat()
            }

            response = self.supabase.table("assignment_submissions").insert(data).execute()

            if response.data:
                logger.info(f"Assignment submission created for user {submission_data.user_id}")
                return response.data[0]
            else:
                raise HTTPException(
                    status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                    detail="Failed to create assignment submission"
                )
        except Exception as e:
            logger.error(f"Error creating assignment submission: {e}")
            raise

    def get_assignment_submission(self, assignment_id: str, user_id: str) -> Optional[Dict[str, Any]]:
        """Get a student's submission for an assignment"""
        try:
            response = self.supabase.table("assignment_submissions")\
                .select("*")\
                .eq("assignment_id", assignment_id)\
                .eq("user_id", user_id)\
                .single()\
                .execute()

            return response.data
        except Exception as e:
            logger.error(f"Error getting assignment submission: {e}")
            return None

    def update_assignment_submission(self, submission_id: str, grade_data) -> Dict[str, Any]:
        """Grade an assignment submission"""
        try:
            update_data = {
                "status": "graded",
                "graded_at": datetime.utcnow().isoformat()
            }

            if grade_data.points_earned is not None:
                update_data["points_earned"] = float(grade_data.points_earned)
            if grade_data.instructor_feedback is not None:
                update_data["instructor_feedback"] = grade_data.instructor_feedback
            if grade_data.rubric_scores is not None:
                update_data["rubric_scores"] = grade_data.rubric_scores

            response = self.supabase.table("assignment_submissions")\
                .update(update_data)\
                .eq("id", submission_id)\
                .execute()

            if response.data:
                logger.info(f"Graded submission {submission_id}")
                return response.data[0]
            else:
                raise HTTPException(
                    status_code=status.HTTP_404_NOT_FOUND,
                    detail="Submission not found"
                )
        except HTTPException:
            raise
        except Exception as e:
            logger.error(f"Error grading submission: {e}")
            raise

    def get_all_assignment_submissions(self, assignment_id: str) -> List[Dict[str, Any]]:
        """Get all submissions for an assignment"""
        try:
            response = self.supabase.table("assignment_submissions")\
                .select("*")\
                .eq("assignment_id", assignment_id)\
                .execute()

            return response.data or []
        except Exception as e:
            logger.error(f"Error getting submissions: {e}")
            raise
