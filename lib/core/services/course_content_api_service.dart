import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/course_content_models.dart';
import '../models/quiz_assignment_models.dart';

/// Service for communicating with Course Content API
/// Handles modules, lessons, quizzes, assignments, and progress tracking
class CourseContentApiService {
  // API base URL - Railway production deployment
  static const String baseUrl =
      'https://web-production-51e34.up.railway.app/api/v1/course-content';

  final http.Client _client;
  final String? _accessToken;

  CourseContentApiService({
    http.Client? client,
    String? accessToken,
  })  : _client = client ?? http.Client(),
        _accessToken = accessToken;

  /// Build headers with optional authentication
  Map<String, String> _buildHeaders() {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (_accessToken != null) {
      headers['Authorization'] = 'Bearer $_accessToken';
    }
    return headers;
  }

  // ==================== MODULE ENDPOINTS ====================

  /// Create a new module for a course
  Future<CourseModule> createModule(
    String courseId,
    ModuleRequest moduleData,
  ) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/courses/$courseId/modules'),
        headers: _buildHeaders(),
        body: jsonEncode(moduleData.toJson()),
      );

      if (response.statusCode == 201) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return CourseModule.fromJson(json);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Institution authentication required');
      } else if (response.statusCode == 400) {
        final error = jsonDecode(response.body);
        throw Exception('Validation error: ${error['detail']}');
      } else {
        throw Exception('Failed to create module: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating module: $e');
    }
  }

  /// Get all modules for a course
  Future<List<CourseModule>> getCourseModules(String courseId) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/courses/$courseId/modules'),
        headers: _buildHeaders(),
      );

      if (response.statusCode == 200) {
        final jsonList = jsonDecode(response.body) as List<dynamic>;
        return jsonList
            .map((json) => CourseModule.fromJson(json as Map<String, dynamic>))
            .toList();
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please log in again');
      } else {
        throw Exception('Failed to load modules: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching modules: $e');
    }
  }

  /// Get a specific module by ID
  Future<CourseModule> getModule(String moduleId) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/modules/$moduleId'),
        headers: _buildHeaders(),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return CourseModule.fromJson(json);
      } else if (response.statusCode == 404) {
        throw Exception('Module not found');
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please log in again');
      } else {
        throw Exception('Failed to load module: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching module: $e');
    }
  }

  /// Update a module
  Future<CourseModule> updateModule(
    String moduleId,
    ModuleRequest moduleData,
  ) async {
    try {
      final response = await _client.put(
        Uri.parse('$baseUrl/modules/$moduleId'),
        headers: _buildHeaders(),
        body: jsonEncode(moduleData.toJson()),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return CourseModule.fromJson(json);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Institution authentication required');
      } else if (response.statusCode == 400) {
        final error = jsonDecode(response.body);
        throw Exception('Update error: ${error['detail']}');
      } else {
        throw Exception('Failed to update module: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating module: $e');
    }
  }

  /// Delete a module
  Future<void> deleteModule(String moduleId) async {
    try {
      final response = await _client.delete(
        Uri.parse('$baseUrl/modules/$moduleId'),
        headers: _buildHeaders(),
      );

      if (response.statusCode == 204) {
        return;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Institution authentication required');
      } else if (response.statusCode == 404) {
        throw Exception('Module not found');
      } else {
        throw Exception('Failed to delete module: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting module: $e');
    }
  }

  /// Reorder modules within a course
  Future<void> reorderModules(
    String courseId,
    ModuleReorderRequest reorderData,
  ) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/courses/$courseId/modules/reorder'),
        headers: _buildHeaders(),
        body: jsonEncode(reorderData.toJson()),
      );

      if (response.statusCode == 200) {
        return;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Institution authentication required');
      } else {
        throw Exception('Failed to reorder modules: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error reordering modules: $e');
    }
  }

  // ==================== LESSON ENDPOINTS ====================

  /// Create a new lesson for a module
  Future<CourseLesson> createLesson(
    String moduleId,
    LessonRequest lessonData,
  ) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/modules/$moduleId/lessons'),
        headers: _buildHeaders(),
        body: jsonEncode(lessonData.toJson()),
      );

      if (response.statusCode == 201) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return CourseLesson.fromJson(json);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Institution authentication required');
      } else if (response.statusCode == 400) {
        final error = jsonDecode(response.body);
        throw Exception('Validation error: ${error['detail']}');
      } else {
        throw Exception('Failed to create lesson: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating lesson: $e');
    }
  }

  /// Get all lessons for a module
  Future<List<CourseLesson>> getModuleLessons(String moduleId) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/modules/$moduleId/lessons'),
        headers: _buildHeaders(),
      );

      if (response.statusCode == 200) {
        final jsonList = jsonDecode(response.body) as List<dynamic>;
        return jsonList
            .map((json) => CourseLesson.fromJson(json as Map<String, dynamic>))
            .toList();
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please log in again');
      } else {
        throw Exception('Failed to load lessons: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching lessons: $e');
    }
  }

  /// Get a specific lesson by ID
  Future<CourseLesson> getLesson(String lessonId) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/lessons/$lessonId'),
        headers: _buildHeaders(),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return CourseLesson.fromJson(json);
      } else if (response.statusCode == 404) {
        throw Exception('Lesson not found');
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please log in again');
      } else {
        throw Exception('Failed to load lesson: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching lesson: $e');
    }
  }

  /// Update a lesson
  Future<CourseLesson> updateLesson(
    String lessonId,
    LessonRequest lessonData,
  ) async {
    try {
      final response = await _client.put(
        Uri.parse('$baseUrl/lessons/$lessonId'),
        headers: _buildHeaders(),
        body: jsonEncode(lessonData.toJson()),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return CourseLesson.fromJson(json);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Institution authentication required');
      } else if (response.statusCode == 400) {
        final error = jsonDecode(response.body);
        throw Exception('Update error: ${error['detail']}');
      } else {
        throw Exception('Failed to update lesson: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating lesson: $e');
    }
  }

  /// Delete a lesson
  Future<void> deleteLesson(String lessonId) async {
    try {
      final response = await _client.delete(
        Uri.parse('$baseUrl/lessons/$lessonId'),
        headers: _buildHeaders(),
      );

      if (response.statusCode == 204) {
        return;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Institution authentication required');
      } else if (response.statusCode == 404) {
        throw Exception('Lesson not found');
      } else {
        throw Exception('Failed to delete lesson: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting lesson: $e');
    }
  }

  /// Reorder lessons within a module
  Future<void> reorderLessons(
    String moduleId,
    LessonReorderRequest reorderData,
  ) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/modules/$moduleId/lessons/reorder'),
        headers: _buildHeaders(),
        body: jsonEncode(reorderData.toJson()),
      );

      if (response.statusCode == 200) {
        return;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Institution authentication required');
      } else {
        throw Exception('Failed to reorder lessons: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error reordering lessons: $e');
    }
  }

  // ==================== VIDEO CONTENT ENDPOINTS ====================

  /// Create video content for a lesson
  Future<VideoContent> createVideoContent(
    String lessonId,
    VideoContentRequest contentData,
  ) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/lessons/$lessonId/video'),
        headers: _buildHeaders(),
        body: jsonEncode(contentData.toJson()),
      );

      if (response.statusCode == 201) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return VideoContent.fromJson(json);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Institution authentication required');
      } else if (response.statusCode == 400) {
        final error = jsonDecode(response.body);
        throw Exception('Validation error: ${error['detail']}');
      } else {
        throw Exception('Failed to create video content: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating video content: $e');
    }
  }

  /// Get video content for a lesson
  Future<VideoContent> getVideoContent(String lessonId) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/lessons/$lessonId/video'),
        headers: _buildHeaders(),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return VideoContent.fromJson(json);
      } else if (response.statusCode == 404) {
        throw Exception('Video content not found');
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please log in again');
      } else {
        throw Exception('Failed to load video content: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching video content: $e');
    }
  }

  /// Update video content for a lesson
  Future<VideoContent> updateVideoContent(
    String lessonId,
    VideoContentRequest contentData,
  ) async {
    try {
      final response = await _client.put(
        Uri.parse('$baseUrl/lessons/$lessonId/video'),
        headers: _buildHeaders(),
        body: jsonEncode(contentData.toJson()),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return VideoContent.fromJson(json);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Institution authentication required');
      } else if (response.statusCode == 400) {
        final error = jsonDecode(response.body);
        throw Exception('Update error: ${error['detail']}');
      } else {
        throw Exception('Failed to update video content: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating video content: $e');
    }
  }

  // ==================== TEXT CONTENT ENDPOINTS ====================

  /// Create text content for a lesson
  Future<TextContent> createTextContent(
    String lessonId,
    TextContentRequest contentData,
  ) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/lessons/$lessonId/text'),
        headers: _buildHeaders(),
        body: jsonEncode(contentData.toJson()),
      );

      if (response.statusCode == 201) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return TextContent.fromJson(json);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Institution authentication required');
      } else if (response.statusCode == 400) {
        final error = jsonDecode(response.body);
        throw Exception('Validation error: ${error['detail']}');
      } else {
        throw Exception('Failed to create text content: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating text content: $e');
    }
  }

  /// Get text content for a lesson
  Future<TextContent> getTextContent(String lessonId) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/lessons/$lessonId/text'),
        headers: _buildHeaders(),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return TextContent.fromJson(json);
      } else if (response.statusCode == 404) {
        throw Exception('Text content not found');
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please log in again');
      } else {
        throw Exception('Failed to load text content: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching text content: $e');
    }
  }

  /// Update text content for a lesson
  Future<TextContent> updateTextContent(
    String lessonId,
    TextContentRequest contentData,
  ) async {
    try {
      final response = await _client.put(
        Uri.parse('$baseUrl/lessons/$lessonId/text'),
        headers: _buildHeaders(),
        body: jsonEncode(contentData.toJson()),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return TextContent.fromJson(json);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Institution authentication required');
      } else if (response.statusCode == 400) {
        final error = jsonDecode(response.body);
        throw Exception('Update error: ${error['detail']}');
      } else {
        throw Exception('Failed to update text content: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating text content: $e');
    }
  }

  // ==================== QUIZ CONTENT ENDPOINTS ====================

  /// Create quiz content for a lesson
  Future<QuizContent> createQuizContent(
    String lessonId,
    QuizContentRequest contentData,
  ) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/lessons/$lessonId/quiz'),
        headers: _buildHeaders(),
        body: jsonEncode(contentData.toJson()),
      );

      if (response.statusCode == 201) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return QuizContent.fromJson(json);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Institution authentication required');
      } else if (response.statusCode == 400) {
        final error = jsonDecode(response.body);
        throw Exception('Validation error: ${error['detail']}');
      } else {
        throw Exception('Failed to create quiz content: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating quiz content: $e');
    }
  }

  /// Get quiz content for a lesson
  Future<QuizContent> getQuizContent(String lessonId) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/lessons/$lessonId/quiz'),
        headers: _buildHeaders(),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return QuizContent.fromJson(json);
      } else if (response.statusCode == 404) {
        throw Exception('Quiz content not found');
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please log in again');
      } else {
        throw Exception('Failed to load quiz content: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching quiz content: $e');
    }
  }

  /// Update quiz content for a lesson
  Future<QuizContent> updateQuizContent(
    String lessonId,
    QuizContentRequest contentData,
  ) async {
    try {
      final response = await _client.put(
        Uri.parse('$baseUrl/lessons/$lessonId/quiz'),
        headers: _buildHeaders(),
        body: jsonEncode(contentData.toJson()),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return QuizContent.fromJson(json);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Institution authentication required');
      } else if (response.statusCode == 400) {
        final error = jsonDecode(response.body);
        throw Exception('Update error: ${error['detail']}');
      } else {
        throw Exception('Failed to update quiz content: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating quiz content: $e');
    }
  }

  // ==================== QUIZ QUESTION ENDPOINTS ====================

  /// Create a question for a quiz
  Future<QuizQuestion> createQuizQuestion(
    String quizId,
    QuizQuestionRequest questionData,
  ) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/quizzes/$quizId/questions'),
        headers: _buildHeaders(),
        body: jsonEncode(questionData.toJson()),
      );

      if (response.statusCode == 201) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return QuizQuestion.fromJson(json);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Institution authentication required');
      } else if (response.statusCode == 400) {
        final error = jsonDecode(response.body);
        throw Exception('Validation error: ${error['detail']}');
      } else {
        throw Exception('Failed to create question: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating question: $e');
    }
  }

  /// Get all questions for a quiz
  Future<List<QuizQuestion>> getQuizQuestions(String quizId) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/quizzes/$quizId/questions'),
        headers: _buildHeaders(),
      );

      if (response.statusCode == 200) {
        final jsonList = jsonDecode(response.body) as List<dynamic>;
        return jsonList
            .map((json) => QuizQuestion.fromJson(json as Map<String, dynamic>))
            .toList();
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please log in again');
      } else {
        throw Exception('Failed to load questions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching questions: $e');
    }
  }

  /// Update a quiz question
  Future<QuizQuestion> updateQuizQuestion(
    String questionId,
    QuizQuestionRequest questionData,
  ) async {
    try {
      final response = await _client.put(
        Uri.parse('$baseUrl/questions/$questionId'),
        headers: _buildHeaders(),
        body: jsonEncode(questionData.toJson()),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return QuizQuestion.fromJson(json);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Institution authentication required');
      } else if (response.statusCode == 400) {
        final error = jsonDecode(response.body);
        throw Exception('Update error: ${error['detail']}');
      } else {
        throw Exception('Failed to update question: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating question: $e');
    }
  }

  /// Delete a quiz question
  Future<void> deleteQuizQuestion(String questionId) async {
    try {
      final response = await _client.delete(
        Uri.parse('$baseUrl/questions/$questionId'),
        headers: _buildHeaders(),
      );

      if (response.statusCode == 204) {
        return;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Institution authentication required');
      } else if (response.statusCode == 404) {
        throw Exception('Question not found');
      } else {
        throw Exception('Failed to delete question: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting question: $e');
    }
  }

  // ==================== QUESTION OPTION ENDPOINTS ====================

  /// Create an option for a question
  Future<QuestionOption> createQuestionOption(
    String questionId,
    QuestionOptionRequest optionData,
  ) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/questions/$questionId/options'),
        headers: _buildHeaders(),
        body: jsonEncode(optionData.toJson()),
      );

      if (response.statusCode == 201) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return QuestionOption.fromJson(json);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Institution authentication required');
      } else if (response.statusCode == 400) {
        final error = jsonDecode(response.body);
        throw Exception('Validation error: ${error['detail']}');
      } else {
        throw Exception('Failed to create option: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating option: $e');
    }
  }

  /// Update a question option
  Future<QuestionOption> updateQuestionOption(
    String optionId,
    QuestionOptionRequest optionData,
  ) async {
    try {
      final response = await _client.put(
        Uri.parse('$baseUrl/options/$optionId'),
        headers: _buildHeaders(),
        body: jsonEncode(optionData.toJson()),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return QuestionOption.fromJson(json);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Institution authentication required');
      } else if (response.statusCode == 400) {
        final error = jsonDecode(response.body);
        throw Exception('Update error: ${error['detail']}');
      } else {
        throw Exception('Failed to update option: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating option: $e');
    }
  }

  /// Delete a question option
  Future<void> deleteQuestionOption(String optionId) async {
    try {
      final response = await _client.delete(
        Uri.parse('$baseUrl/options/$optionId'),
        headers: _buildHeaders(),
      );

      if (response.statusCode == 204) {
        return;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Institution authentication required');
      } else if (response.statusCode == 404) {
        throw Exception('Option not found');
      } else {
        throw Exception('Failed to delete option: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting option: $e');
    }
  }

  // ==================== ASSIGNMENT CONTENT ENDPOINTS ====================

  /// Create assignment content for a lesson
  Future<AssignmentContent> createAssignmentContent(
    String lessonId,
    AssignmentContentRequest contentData,
  ) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/lessons/$lessonId/assignment'),
        headers: _buildHeaders(),
        body: jsonEncode(contentData.toJson()),
      );

      if (response.statusCode == 201) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return AssignmentContent.fromJson(json);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Institution authentication required');
      } else if (response.statusCode == 400) {
        final error = jsonDecode(response.body);
        throw Exception('Validation error: ${error['detail']}');
      } else {
        throw Exception('Failed to create assignment content: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating assignment content: $e');
    }
  }

  /// Get assignment content for a lesson
  Future<AssignmentContent> getAssignmentContent(String lessonId) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/lessons/$lessonId/assignment'),
        headers: _buildHeaders(),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return AssignmentContent.fromJson(json);
      } else if (response.statusCode == 404) {
        throw Exception('Assignment content not found');
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please log in again');
      } else {
        throw Exception('Failed to load assignment content: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching assignment content: $e');
    }
  }

  /// Update assignment content for a lesson
  Future<AssignmentContent> updateAssignmentContent(
    String lessonId,
    AssignmentContentRequest contentData,
  ) async {
    try {
      final response = await _client.put(
        Uri.parse('$baseUrl/lessons/$lessonId/assignment'),
        headers: _buildHeaders(),
        body: jsonEncode(contentData.toJson()),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return AssignmentContent.fromJson(json);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Institution authentication required');
      } else if (response.statusCode == 400) {
        final error = jsonDecode(response.body);
        throw Exception('Update error: ${error['detail']}');
      } else {
        throw Exception('Failed to update assignment content: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating assignment content: $e');
    }
  }

  // ==================== PROGRESS TRACKING ENDPOINTS ====================

  /// Mark a lesson as complete
  Future<void> markLessonComplete(
    String lessonId,
    String userId,
    int timeSpentMinutes,
  ) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/lessons/$lessonId/complete'),
        headers: _buildHeaders(),
        body: jsonEncode({
          'user_id': userId,
          'time_spent_minutes': timeSpentMinutes,
        }),
      );

      if (response.statusCode == 200) {
        return;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please log in again');
      } else {
        throw Exception('Failed to mark lesson complete: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error marking lesson complete: $e');
    }
  }

  /// Get course progress for a user
  Future<CourseProgress> getCourseProgress(
    String courseId,
    String userId,
  ) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/courses/$courseId/progress/$userId'),
        headers: _buildHeaders(),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return CourseProgress.fromJson(json);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please log in again');
      } else if (response.statusCode == 404) {
        throw Exception('Progress not found');
      } else {
        throw Exception('Failed to load progress: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching progress: $e');
    }
  }

  // ==================== QUIZ ATTEMPT ENDPOINTS ====================

  /// Create a new quiz attempt
  Future<QuizAttempt> createQuizAttempt(
    String quizId,
    String userId,
  ) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/quizzes/$quizId/attempts'),
        headers: _buildHeaders(),
        body: jsonEncode({'user_id': userId}),
      );

      if (response.statusCode == 201) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return QuizAttempt.fromJson(json);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please log in again');
      } else if (response.statusCode == 400) {
        final error = jsonDecode(response.body);
        throw Exception('Validation error: ${error['detail']}');
      } else {
        throw Exception('Failed to create quiz attempt: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating quiz attempt: $e');
    }
  }

  /// Submit a quiz attempt with answers
  Future<QuizAttempt> submitQuizAttempt(
    String attemptId,
    List<Map<String, dynamic>> answers,
  ) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/quiz-attempts/$attemptId/submit'),
        headers: _buildHeaders(),
        body: jsonEncode({'answers': answers}),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return QuizAttempt.fromJson(json);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please log in again');
      } else if (response.statusCode == 400) {
        final error = jsonDecode(response.body);
        throw Exception('Validation error: ${error['detail']}');
      } else {
        throw Exception('Failed to submit quiz attempt: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error submitting quiz attempt: $e');
    }
  }

  /// Get quiz attempts for a user
  Future<List<QuizAttempt>> getQuizAttempts(
    String quizId,
    String userId,
  ) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/quizzes/$quizId/attempts/$userId'),
        headers: _buildHeaders(),
      );

      if (response.statusCode == 200) {
        final jsonList = jsonDecode(response.body) as List<dynamic>;
        return jsonList
            .map((json) => QuizAttempt.fromJson(json as Map<String, dynamic>))
            .toList();
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please log in again');
      } else {
        throw Exception('Failed to load quiz attempts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching quiz attempts: $e');
    }
  }

  // ==================== ASSIGNMENT SUBMISSION ENDPOINTS ====================

  /// Submit an assignment
  Future<AssignmentSubmission> submitAssignment(
    String assignmentId,
    AssignmentSubmissionRequest submissionData,
  ) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/assignments/$assignmentId/submit'),
        headers: _buildHeaders(),
        body: jsonEncode(submissionData.toJson()),
      );

      if (response.statusCode == 201) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return AssignmentSubmission.fromJson(json);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please log in again');
      } else if (response.statusCode == 400) {
        final error = jsonDecode(response.body);
        throw Exception('Validation error: ${error['detail']}');
      } else {
        throw Exception('Failed to submit assignment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error submitting assignment: $e');
    }
  }

  /// Get assignment submission for a user
  Future<AssignmentSubmission> getAssignmentSubmission(
    String assignmentId,
    String userId,
  ) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/assignments/$assignmentId/submissions/$userId'),
        headers: _buildHeaders(),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return AssignmentSubmission.fromJson(json);
      } else if (response.statusCode == 404) {
        throw Exception('Submission not found');
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please log in again');
      } else {
        throw Exception('Failed to load submission: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching submission: $e');
    }
  }

  /// Get all submissions for an assignment (Institution only)
  Future<List<AssignmentSubmission>> getAllAssignmentSubmissions(
    String assignmentId,
  ) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/assignments/$assignmentId/submissions'),
        headers: _buildHeaders(),
      );

      if (response.statusCode == 200) {
        final jsonList = jsonDecode(response.body) as List<dynamic>;
        return jsonList
            .map((json) =>
                AssignmentSubmission.fromJson(json as Map<String, dynamic>))
            .toList();
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Institution authentication required');
      } else {
        throw Exception('Failed to load submissions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching submissions: $e');
    }
  }

  /// Grade an assignment submission (Institution only)
  Future<AssignmentSubmission> gradeAssignmentSubmission(
    String submissionId,
    Map<String, dynamic> gradeData,
  ) async {
    try {
      final response = await _client.put(
        Uri.parse('$baseUrl/submissions/$submissionId/grade'),
        headers: _buildHeaders(),
        body: jsonEncode(gradeData),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return AssignmentSubmission.fromJson(json);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Institution authentication required');
      } else if (response.statusCode == 400) {
        final error = jsonDecode(response.body);
        throw Exception('Grading error: ${error['detail']}');
      } else {
        throw Exception('Failed to grade submission: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error grading submission: $e');
    }
  }
}
