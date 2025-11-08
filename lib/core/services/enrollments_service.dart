/// Enrollments Service
/// Handles course enrollment-related API calls

import '../api/api_client.dart';
import '../api/api_config.dart';
import '../api/api_response.dart';

enum EnrollmentStatus {
  active,
  completed,
  dropped,
  suspended,
}

extension EnrollmentStatusExtension on EnrollmentStatus {
  String get value => name;

  static EnrollmentStatus fromString(String value) {
    return EnrollmentStatus.values.firstWhere(
      (status) => status.name == value.toLowerCase(),
      orElse: () => EnrollmentStatus.active,
    );
  }
}

class Enrollment {
  final String id;
  final String studentId;
  final String courseId;
  final String courseName;
  final String institutionName;
  final EnrollmentStatus status;
  final DateTime enrolledAt;
  final DateTime? completedAt;
  final double? grade;
  final double progress;
  final int attendancePercentage;
  final Map<String, dynamic>? metadata;

  Enrollment({
    required this.id,
    required this.studentId,
    required this.courseId,
    required this.courseName,
    required this.institutionName,
    required this.status,
    required this.enrolledAt,
    this.completedAt,
    this.grade,
    this.progress = 0.0,
    this.attendancePercentage = 0,
    this.metadata,
  });

  factory Enrollment.fromJson(Map<String, dynamic> json) {
    return Enrollment(
      id: json['id'],
      studentId: json['student_id'],
      courseId: json['course_id'],
      courseName: json['course_name'] ?? '',
      institutionName: json['institution_name'] ?? '',
      status: EnrollmentStatusExtension.fromString(json['status']),
      enrolledAt: DateTime.parse(json['enrolled_at']),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'])
          : null,
      grade: json['grade']?.toDouble(),
      progress: (json['progress'] ?? 0).toDouble(),
      attendancePercentage: json['attendance_percentage'] ?? 0,
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'course_id': courseId,
      'course_name': courseName,
      'institution_name': institutionName,
      'status': status.value,
      'enrolled_at': enrolledAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'grade': grade,
      'progress': progress,
      'attendance_percentage': attendancePercentage,
      'metadata': metadata,
    };
  }

  bool get isActive => status == EnrollmentStatus.active;
  bool get isCompleted => status == EnrollmentStatus.completed;
}

class EnrollmentsService {
  final ApiClient _apiClient;

  EnrollmentsService(this._apiClient);

  /// Get student enrollments
  Future<ApiResponse<PaginatedResponse<Enrollment>>> getEnrollments({
    String? studentId,
    String? courseId,
    String? institutionId,
    EnrollmentStatus? status,
    int page = 1,
    int pageSize = 20,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'page_size': pageSize,
      if (studentId != null) 'student_id': studentId,
      if (courseId != null) 'course_id': courseId,
      if (institutionId != null) 'institution_id': institutionId,
      if (status != null) 'status': status.value,
    };

    return await _apiClient.get(
      ApiConfig.enrollments,
      queryParameters: queryParams,
      fromJson: (data) => PaginatedResponse.fromJson(
        data,
        (json) => Enrollment.fromJson(json),
      ),
    );
  }

  /// Get enrollment by ID
  Future<ApiResponse<Enrollment>> getEnrollmentById(String enrollmentId) async {
    return await _apiClient.get(
      '${ApiConfig.enrollments}/$enrollmentId',
      fromJson: (data) => Enrollment.fromJson(data),
    );
  }

  /// Enroll in a course (Student)
  Future<ApiResponse<Enrollment>> enrollInCourse({
    required String courseId,
    Map<String, dynamic>? metadata,
  }) async {
    return await _apiClient.post(
      ApiConfig.enrollments,
      data: {
        'course_id': courseId,
        if (metadata != null) 'metadata': metadata,
      },
      fromJson: (data) => Enrollment.fromJson(data),
    );
  }

  /// Update enrollment progress (Institution)
  Future<ApiResponse<Enrollment>> updateEnrollmentProgress({
    required String enrollmentId,
    double? progress,
    double? grade,
    int? attendancePercentage,
    EnrollmentStatus? status,
  }) async {
    return await _apiClient.patch(
      '${ApiConfig.enrollments}/$enrollmentId',
      data: {
        if (progress != null) 'progress': progress,
        if (grade != null) 'grade': grade,
        if (attendancePercentage != null)
          'attendance_percentage': attendancePercentage,
        if (status != null) 'status': status.value,
      },
      fromJson: (data) => Enrollment.fromJson(data),
    );
  }

  /// Drop enrollment (Student)
  Future<ApiResponse<Enrollment>> dropEnrollment({
    required String enrollmentId,
    String? reason,
  }) async {
    return await _apiClient.post(
      '${ApiConfig.enrollments}/$enrollmentId/drop',
      data: {
        if (reason != null) 'reason': reason,
      },
      fromJson: (data) => Enrollment.fromJson(data),
    );
  }

  /// Complete enrollment (Institution)
  Future<ApiResponse<Enrollment>> completeEnrollment({
    required String enrollmentId,
    required double finalGrade,
  }) async {
    return await _apiClient.post(
      '${ApiConfig.enrollments}/$enrollmentId/complete',
      data: {
        'final_grade': finalGrade,
      },
      fromJson: (data) => Enrollment.fromJson(data),
    );
  }

  /// Get my enrollments (Current user)
  Future<ApiResponse<PaginatedResponse<Enrollment>>> getMyEnrollments({
    EnrollmentStatus? status,
    int page = 1,
    int pageSize = 20,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'page_size': pageSize,
      if (status != null) 'status': status.value,
    };

    return await _apiClient.get(
      '${ApiConfig.enrollments}/me',
      queryParameters: queryParams,
      fromJson: (data) => PaginatedResponse.fromJson(
        data,
        (json) => Enrollment.fromJson(json),
      ),
    );
  }

  /// Get enrollment statistics
  Future<ApiResponse<Map<String, dynamic>>> getEnrollmentStats({
    String? studentId,
    String? courseId,
  }) async {
    final queryParams = <String, dynamic>{
      if (studentId != null) 'student_id': studentId,
      if (courseId != null) 'course_id': courseId,
    };

    return await _apiClient.get(
      '${ApiConfig.enrollments}/stats',
      queryParameters: queryParams,
      fromJson: (data) => data as Map<String, dynamic>,
    );
  }
}
