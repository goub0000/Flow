import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_config.dart';
import '../../../../core/providers/service_providers.dart';

/// Assessment item model for admin management
class AssessmentItem {
  final String id;
  final String assessmentType; // 'quiz' or 'assignment'
  final String? lessonId;
  final String? lessonTitle;
  final String? moduleTitle;
  final String? courseId;
  final String? courseTitle;
  final String title;
  final double? passingScore;
  final double? totalPoints;
  final int questionCount;
  final int attemptCount;
  final double? averageScore;
  final double? passRate;
  final double? pointsPossible;
  final int submissionCount;
  final int gradedCount;
  final double? averageGrade;
  final String? dueDate;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const AssessmentItem({
    required this.id,
    required this.assessmentType,
    this.lessonId,
    this.lessonTitle,
    this.moduleTitle,
    this.courseId,
    this.courseTitle,
    required this.title,
    this.passingScore,
    this.totalPoints,
    this.questionCount = 0,
    this.attemptCount = 0,
    this.averageScore,
    this.passRate,
    this.pointsPossible,
    this.submissionCount = 0,
    this.gradedCount = 0,
    this.averageGrade,
    this.dueDate,
    required this.createdAt,
    this.updatedAt,
  });

  factory AssessmentItem.fromJson(Map<String, dynamic> json) {
    return AssessmentItem(
      id: json['id'] as String? ?? '',
      assessmentType: json['assessment_type'] as String? ?? 'quiz',
      lessonId: json['lesson_id'] as String?,
      lessonTitle: json['lesson_title'] as String?,
      moduleTitle: json['module_title'] as String?,
      courseId: json['course_id'] as String?,
      courseTitle: json['course_title'] as String?,
      title: json['title'] as String? ?? '',
      passingScore: (json['passing_score'] as num?)?.toDouble(),
      totalPoints: (json['total_points'] as num?)?.toDouble(),
      questionCount: json['question_count'] as int? ?? 0,
      attemptCount: json['attempt_count'] as int? ?? 0,
      averageScore: (json['average_score'] as num?)?.toDouble(),
      passRate: (json['pass_rate'] as num?)?.toDouble(),
      pointsPossible: (json['points_possible'] as num?)?.toDouble(),
      submissionCount: json['submission_count'] as int? ?? 0,
      gradedCount: json['graded_count'] as int? ?? 0,
      averageGrade: (json['average_grade'] as num?)?.toDouble(),
      dueDate: json['due_date'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }
}

/// Assessment statistics model
class AssessmentStats {
  final int totalAssessments;
  final int quizCount;
  final int assignmentCount;
  final int totalAttempts;
  final int totalSubmissions;
  final double? averagePassRate;
  final int pendingGrading;

  const AssessmentStats({
    this.totalAssessments = 0,
    this.quizCount = 0,
    this.assignmentCount = 0,
    this.totalAttempts = 0,
    this.totalSubmissions = 0,
    this.averagePassRate,
    this.pendingGrading = 0,
  });

  factory AssessmentStats.fromJson(Map<String, dynamic> json) {
    return AssessmentStats(
      totalAssessments: json['total_assessments'] as int? ?? 0,
      quizCount: json['quiz_count'] as int? ?? 0,
      assignmentCount: json['assignment_count'] as int? ?? 0,
      totalAttempts: json['total_attempts'] as int? ?? 0,
      totalSubmissions: json['total_submissions'] as int? ?? 0,
      averagePassRate: (json['average_pass_rate'] as num?)?.toDouble(),
      pendingGrading: json['pending_grading'] as int? ?? 0,
    );
  }
}

/// State class for assessments management
class AdminAssessmentsState {
  final List<AssessmentItem> assessments;
  final AssessmentStats stats;
  final bool isLoading;
  final String? error;

  const AdminAssessmentsState({
    this.assessments = const [],
    this.stats = const AssessmentStats(),
    this.isLoading = false,
    this.error,
  });

  AdminAssessmentsState copyWith({
    List<AssessmentItem>? assessments,
    AssessmentStats? stats,
    bool? isLoading,
    String? error,
  }) {
    return AdminAssessmentsState(
      assessments: assessments ?? this.assessments,
      stats: stats ?? this.stats,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// StateNotifier for assessments management
class AdminAssessmentsNotifier extends StateNotifier<AdminAssessmentsState> {
  final ApiClient _apiClient;

  AdminAssessmentsNotifier(this._apiClient) : super(const AdminAssessmentsState()) {
    fetchAssessments();
  }

  /// Fetch all assessments from backend API
  Future<void> fetchAssessments({
    String? type,
    String? search,
    String? courseId,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final queryParams = <String, String>{};
      if (type != null && type != 'all') queryParams['assessment_type'] = type;
      if (search != null && search.isNotEmpty) queryParams['search'] = search;
      if (courseId != null && courseId.isNotEmpty) queryParams['course_id'] = courseId;

      final queryString = queryParams.isNotEmpty
          ? '?${queryParams.entries.map((e) => '${e.key}=${e.value}').join('&')}'
          : '';

      final response = await _apiClient.get(
        '${ApiConfig.admin}/assessments$queryString',
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (response.success && response.data != null) {
        final assessmentsData = response.data!['assessments'] as List<dynamic>? ?? [];
        final statsData = response.data!['stats'] as Map<String, dynamic>? ?? {};

        final assessmentsList = assessmentsData
            .map((item) => AssessmentItem.fromJson(item as Map<String, dynamic>))
            .toList();

        final stats = AssessmentStats.fromJson(statsData);

        state = state.copyWith(
          assessments: assessmentsList,
          stats: stats,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to fetch assessments',
          isLoading: false,
        );
      }
    } catch (e) {
      print('[AdminAssessments] Error fetching assessments: $e');
      state = state.copyWith(
        error: 'Failed to fetch assessments: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Create a new assessment (quiz or assignment) — creates lesson + content
  Future<bool> createAssessment({
    required String assessmentType,
    required String courseId,
    required String moduleId,
    required String lessonTitle,
    required String title,
    // Quiz fields
    double? passingScore,
    int? timeLimitMinutes,
    // Assignment fields
    String? instructions,
    int? pointsPossible,
    String? dueDate,
  }) async {
    try {
      final response = await _apiClient.post(
        '${ApiConfig.admin}/assessments',
        data: {
          'assessment_type': assessmentType,
          'course_id': courseId,
          'module_id': moduleId,
          'lesson_title': lessonTitle,
          'title': title,
          'passing_score': passingScore,
          'time_limit_minutes': timeLimitMinutes,
          'instructions': instructions,
          'points_possible': pointsPossible,
          'due_date': dueDate,
        },
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (response.success) {
        await fetchAssessments();
        return true;
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to create assessment',
        );
        return false;
      }
    } catch (e) {
      print('[AdminAssessments] Error creating assessment: $e');
      state = state.copyWith(
        error: 'Failed to create assessment: ${e.toString()}',
      );
      return false;
    }
  }
}

/// Provider for admin assessments state
final adminAssessmentsProvider =
    StateNotifierProvider<AdminAssessmentsNotifier, AdminAssessmentsState>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AdminAssessmentsNotifier(apiClient);
});

/// Provider for assessment statistics
final adminAssessmentsStatsProvider = Provider<AssessmentStats>((ref) {
  final assessmentsState = ref.watch(adminAssessmentsProvider);
  return assessmentsState.stats;
});
