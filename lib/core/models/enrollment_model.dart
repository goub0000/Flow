/// Enrollment Data Model
/// Tracks student enrollment in courses
library;

class Enrollment {
  final String id;
  final String studentId;
  final String courseId;
  final EnrollmentStatus status;
  final DateTime enrolledAt;
  final DateTime? completedAt;
  final double progressPercentage;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Additional fields for UI
  final String? courseTitle;
  final String? courseThumbnailUrl;
  final String? institutionName;

  Enrollment({
    required this.id,
    required this.studentId,
    required this.courseId,
    required this.status,
    required this.enrolledAt,
    this.completedAt,
    this.progressPercentage = 0.0,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
    this.courseTitle,
    this.courseThumbnailUrl,
    this.institutionName,
  });

  factory Enrollment.fromJson(Map<String, dynamic> json) {
    return Enrollment(
      id: json['id'] as String,
      studentId: json['student_id'] as String,
      courseId: json['course_id'] as String,
      status: EnrollmentStatus.fromString(json['status'] as String),
      enrolledAt: DateTime.parse(json['enrolled_at'] as String),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
      progressPercentage:
          (json['progress_percentage'] as num?)?.toDouble() ?? 0.0,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      courseTitle: json['course_title'] as String?,
      courseThumbnailUrl: json['course_thumbnail_url'] as String?,
      institutionName: json['institution_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'course_id': courseId,
      'status': status.value,
      'enrolled_at': enrolledAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'progress_percentage': progressPercentage,
      'metadata': metadata,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Enrollment copyWith({
    String? id,
    String? studentId,
    String? courseId,
    EnrollmentStatus? status,
    DateTime? enrolledAt,
    DateTime? completedAt,
    double? progressPercentage,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? courseTitle,
    String? courseThumbnailUrl,
    String? institutionName,
  }) {
    return Enrollment(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      courseId: courseId ?? this.courseId,
      status: status ?? this.status,
      enrolledAt: enrolledAt ?? this.enrolledAt,
      completedAt: completedAt ?? this.completedAt,
      progressPercentage: progressPercentage ?? this.progressPercentage,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      courseTitle: courseTitle ?? this.courseTitle,
      courseThumbnailUrl: courseThumbnailUrl ?? this.courseThumbnailUrl,
      institutionName: institutionName ?? this.institutionName,
    );
  }

  bool get isActive => status == EnrollmentStatus.active;
  bool get isCompleted => status == EnrollmentStatus.completed;
  bool get isDropped => status == EnrollmentStatus.dropped;
  bool get isSuspended => status == EnrollmentStatus.suspended;
}

/// Enrollment Status Enumeration
enum EnrollmentStatus {
  active,
  completed,
  dropped,
  suspended;

  String get value => name;
  String get displayName {
    switch (this) {
      case EnrollmentStatus.active:
        return 'Active';
      case EnrollmentStatus.completed:
        return 'Completed';
      case EnrollmentStatus.dropped:
        return 'Dropped';
      case EnrollmentStatus.suspended:
        return 'Suspended';
    }
  }

  static EnrollmentStatus fromString(String value) {
    return EnrollmentStatus.values.firstWhere(
      (e) => e.value == value.toLowerCase(),
      orElse: () => EnrollmentStatus.active,
    );
  }
}

/// Enrollment List Response (for pagination)
class EnrollmentListResponse {
  final List<Enrollment> enrollments;
  final int total;
  final int page;
  final int pageSize;
  final bool hasMore;

  EnrollmentListResponse({
    required this.enrollments,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.hasMore,
  });

  factory EnrollmentListResponse.fromJson(Map<String, dynamic> json) {
    return EnrollmentListResponse(
      enrollments: (json['enrollments'] as List<dynamic>)
          .map((e) => Enrollment.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
      page: json['page'] as int,
      pageSize: json['page_size'] as int,
      hasMore: json['has_more'] as bool,
    );
  }
}

/// Enrollment Create Request
class EnrollmentCreateRequest {
  final String courseId;
  final Map<String, dynamic>? metadata;

  EnrollmentCreateRequest({
    required this.courseId,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'course_id': courseId,
    };

    if (metadata != null) {
      json['metadata'] = metadata;
    }

    return json;
  }
}
