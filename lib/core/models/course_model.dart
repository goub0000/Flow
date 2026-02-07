/// Course Data Model
/// Matches backend CourseResponse schema
library;

class Course {
  final String id;
  final String institutionId;
  final String title;
  final String description;
  final CourseType courseType;
  final CourseLevel level;
  final double? durationHours;
  final double price;
  final String currency;
  final String? thumbnailUrl;
  final String? previewVideoUrl;
  final String? category;
  final List<String> tags;
  final List<String> learningOutcomes;
  final List<String> prerequisites;
  final int enrolledCount;
  final int? maxStudents;
  final double? rating;
  final int reviewCount;
  final Map<String, dynamic>? syllabus;
  final CourseStatus status;
  final bool isPublished;
  final DateTime? publishedAt;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Additional fields for UI
  final String? institutionName;
  final bool? isEnrolled;

  Course({
    required this.id,
    required this.institutionId,
    required this.title,
    required this.description,
    required this.courseType,
    required this.level,
    this.durationHours,
    required this.price,
    required this.currency,
    this.thumbnailUrl,
    this.previewVideoUrl,
    this.category,
    this.tags = const [],
    this.learningOutcomes = const [],
    this.prerequisites = const [],
    this.enrolledCount = 0,
    this.maxStudents,
    this.rating,
    this.reviewCount = 0,
    this.syllabus,
    required this.status,
    required this.isPublished,
    this.publishedAt,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
    this.institutionName,
    this.isEnrolled,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as String,
      institutionId: json['institution_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      courseType: CourseType.fromString(json['course_type'] as String),
      level: CourseLevel.fromString(json['level'] as String),
      durationHours: json['duration_hours'] != null
          ? (json['duration_hours'] as num).toDouble()
          : null,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String,
      thumbnailUrl: json['thumbnail_url'] as String?,
      previewVideoUrl: json['preview_video_url'] as String?,
      category: json['category'] as String?,
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      learningOutcomes: (json['learning_outcomes'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      prerequisites: (json['prerequisites'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      enrolledCount: json['enrolled_count'] as int? ?? 0,
      maxStudents: json['max_students'] as int?,
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : null,
      reviewCount: json['review_count'] as int? ?? 0,
      syllabus: json['syllabus'] as Map<String, dynamic>?,
      status: CourseStatus.fromString(json['status'] as String),
      isPublished: json['is_published'] as bool,
      publishedAt: json['published_at'] != null
          ? DateTime.parse(json['published_at'] as String)
          : null,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      institutionName: json['institution_name'] as String?,
      isEnrolled: json['is_enrolled'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'institution_id': institutionId,
      'title': title,
      'description': description,
      'course_type': courseType.value,
      'level': level.value,
      'duration_hours': durationHours,
      'price': price,
      'currency': currency,
      'thumbnail_url': thumbnailUrl,
      'preview_video_url': previewVideoUrl,
      'category': category,
      'tags': tags,
      'learning_outcomes': learningOutcomes,
      'prerequisites': prerequisites,
      'enrolled_count': enrolledCount,
      'max_students': maxStudents,
      'rating': rating,
      'review_count': reviewCount,
      'syllabus': syllabus,
      'status': status.value,
      'is_published': isPublished,
      'published_at': publishedAt?.toIso8601String(),
      'metadata': metadata,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Course copyWith({
    String? id,
    String? institutionId,
    String? title,
    String? description,
    CourseType? courseType,
    CourseLevel? level,
    double? durationHours,
    double? price,
    String? currency,
    String? thumbnailUrl,
    String? previewVideoUrl,
    String? category,
    List<String>? tags,
    List<String>? learningOutcomes,
    List<String>? prerequisites,
    int? enrolledCount,
    int? maxStudents,
    double? rating,
    int? reviewCount,
    Map<String, dynamic>? syllabus,
    CourseStatus? status,
    bool? isPublished,
    DateTime? publishedAt,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? institutionName,
    bool? isEnrolled,
  }) {
    return Course(
      id: id ?? this.id,
      institutionId: institutionId ?? this.institutionId,
      title: title ?? this.title,
      description: description ?? this.description,
      courseType: courseType ?? this.courseType,
      level: level ?? this.level,
      durationHours: durationHours ?? this.durationHours,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      previewVideoUrl: previewVideoUrl ?? this.previewVideoUrl,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      learningOutcomes: learningOutcomes ?? this.learningOutcomes,
      prerequisites: prerequisites ?? this.prerequisites,
      enrolledCount: enrolledCount ?? this.enrolledCount,
      maxStudents: maxStudents ?? this.maxStudents,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      syllabus: syllabus ?? this.syllabus,
      status: status ?? this.status,
      isPublished: isPublished ?? this.isPublished,
      publishedAt: publishedAt ?? this.publishedAt,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      institutionName: institutionName ?? this.institutionName,
      isEnrolled: isEnrolled ?? this.isEnrolled,
    );
  }

  bool get isFull => maxStudents != null && enrolledCount >= maxStudents!;
  bool get isFree => price == 0.0;
  String get formattedPrice => isFree ? 'Free' : '$currency $price';
}

/// Course Type Enumeration
enum CourseType {
  video,
  text,
  interactive,
  live,
  hybrid;

  String get value => name;
  String get displayName {
    switch (this) {
      case CourseType.video:
        return 'Video Course';
      case CourseType.text:
        return 'Text-Based';
      case CourseType.interactive:
        return 'Interactive';
      case CourseType.live:
        return 'Live Sessions';
      case CourseType.hybrid:
        return 'Hybrid';
    }
  }

  static CourseType fromString(String value) {
    return CourseType.values.firstWhere(
      (e) => e.value == value.toLowerCase(),
      orElse: () => CourseType.video,
    );
  }
}

/// Course Level Enumeration
enum CourseLevel {
  beginner,
  intermediate,
  advanced,
  expert;

  String get value => name;
  String get displayName {
    switch (this) {
      case CourseLevel.beginner:
        return 'Beginner';
      case CourseLevel.intermediate:
        return 'Intermediate';
      case CourseLevel.advanced:
        return 'Advanced';
      case CourseLevel.expert:
        return 'Expert';
    }
  }

  static CourseLevel fromString(String value) {
    return CourseLevel.values.firstWhere(
      (e) => e.value == value.toLowerCase(),
      orElse: () => CourseLevel.beginner,
    );
  }
}

/// Course Status Enumeration
enum CourseStatus {
  draft,
  published,
  archived;

  String get value => name;
  String get displayName {
    switch (this) {
      case CourseStatus.draft:
        return 'Draft';
      case CourseStatus.published:
        return 'Published';
      case CourseStatus.archived:
        return 'Archived';
    }
  }

  static CourseStatus fromString(String value) {
    return CourseStatus.values.firstWhere(
      (e) => e.value == value.toLowerCase(),
      orElse: () => CourseStatus.draft,
    );
  }
}

/// Course Statistics Model
class CourseStatistics {
  final int totalCourses;
  final int publishedCourses;
  final int draftCourses;
  final int archivedCourses;
  final int totalEnrollments;
  final double averageRating;
  final double totalRevenue;

  CourseStatistics({
    required this.totalCourses,
    required this.publishedCourses,
    required this.draftCourses,
    required this.archivedCourses,
    required this.totalEnrollments,
    required this.averageRating,
    required this.totalRevenue,
  });

  factory CourseStatistics.fromJson(Map<String, dynamic> json) {
    return CourseStatistics(
      totalCourses: json['total_courses'] as int,
      publishedCourses: json['published_courses'] as int,
      draftCourses: json['draft_courses'] as int,
      archivedCourses: json['archived_courses'] as int,
      totalEnrollments: json['total_enrollments'] as int,
      averageRating: (json['average_rating'] as num).toDouble(),
      totalRevenue: (json['total_revenue'] as num).toDouble(),
    );
  }
}

/// Course List Response (for pagination)
class CourseListResponse {
  final List<Course> courses;
  final int total;
  final int page;
  final int pageSize;
  final bool hasMore;

  CourseListResponse({
    required this.courses,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.hasMore,
  });

  factory CourseListResponse.fromJson(Map<String, dynamic> json) {
    return CourseListResponse(
      courses: (json['courses'] as List<dynamic>)
          .map((e) => Course.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
      page: json['page'] as int,
      pageSize: json['page_size'] as int,
      hasMore: json['has_more'] as bool,
    );
  }
}

/// Course Create/Update Request
class CourseRequest {
  final String title;
  final String description;
  final CourseType courseType;
  final CourseLevel level;
  final double? durationHours;
  final double? price;
  final String currency;
  final String? thumbnailUrl;
  final String? previewVideoUrl;
  final String? category;
  final List<String> tags;
  final List<String> learningOutcomes;
  final List<String> prerequisites;
  final int? maxStudents;
  final Map<String, dynamic>? syllabus;
  final Map<String, dynamic>? metadata;

  CourseRequest({
    required this.title,
    required this.description,
    required this.courseType,
    this.level = CourseLevel.beginner,
    this.durationHours,
    this.price,
    this.currency = 'USD',
    this.thumbnailUrl,
    this.previewVideoUrl,
    this.category,
    this.tags = const [],
    this.learningOutcomes = const [],
    this.prerequisites = const [],
    this.maxStudents,
    this.syllabus,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'title': title,
      'description': description,
      'course_type': courseType.value,
      'level': level.value,
      'currency': currency,
      'tags': tags,
      'learning_outcomes': learningOutcomes,
      'prerequisites': prerequisites,
    };

    // Only include optional fields if they're not null
    if (durationHours != null) json['duration_hours'] = durationHours;
    if (price != null) json['price'] = price;
    if (thumbnailUrl != null) json['thumbnail_url'] = thumbnailUrl;
    if (previewVideoUrl != null) json['preview_video_url'] = previewVideoUrl;
    if (category != null) json['category'] = category;
    if (maxStudents != null) json['max_students'] = maxStudents;
    if (syllabus != null) json['syllabus'] = syllabus;
    if (metadata != null) json['metadata'] = metadata;

    return json;
  }
}
