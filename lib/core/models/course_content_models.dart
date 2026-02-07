// ignore_for_file: unnecessary_brace_in_string_interps

/// Course Content Models
/// Models for course modules, lessons, and content types
/// Matches backend CourseContent schemas
library;

import 'package:flutter/material.dart';

// =============================================================================
// COURSE MODULE MODEL
// =============================================================================

/// Course Module Model
class CourseModule {
  final String id;
  final String courseId;
  final String title;
  final String? description;
  final int orderIndex;
  final List<String> learningObjectives;
  final int lessonCount;
  final int durationMinutes;
  final bool isPublished;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Additional fields for UI
  final List<CourseLesson>? lessons;

  CourseModule({
    required this.id,
    required this.courseId,
    required this.title,
    this.description,
    required this.orderIndex,
    this.learningObjectives = const [],
    this.lessonCount = 0,
    this.durationMinutes = 0,
    this.isPublished = false,
    required this.createdAt,
    required this.updatedAt,
    this.lessons,
  });

  factory CourseModule.fromJson(Map<String, dynamic> json) {
    return CourseModule(
      id: json['id'] as String,
      courseId: json['course_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      orderIndex: json['order_index'] as int,
      learningObjectives: (json['learning_objectives'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      lessonCount: json['lesson_count'] as int? ?? 0,
      durationMinutes: json['duration_minutes'] as int? ?? 0,
      isPublished: json['is_published'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      lessons: (json['lessons'] as List<dynamic>?)
          ?.map((e) => CourseLesson.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_id': courseId,
      'title': title,
      'description': description,
      'order_index': orderIndex,
      'learning_objectives': learningObjectives,
      'lesson_count': lessonCount,
      'duration_minutes': durationMinutes,
      'is_published': isPublished,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  CourseModule copyWith({
    String? id,
    String? courseId,
    String? title,
    String? description,
    int? orderIndex,
    List<String>? learningObjectives,
    int? lessonCount,
    int? durationMinutes,
    bool? isPublished,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<CourseLesson>? lessons,
  }) {
    return CourseModule(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      description: description ?? this.description,
      orderIndex: orderIndex ?? this.orderIndex,
      learningObjectives: learningObjectives ?? this.learningObjectives,
      lessonCount: lessonCount ?? this.lessonCount,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      isPublished: isPublished ?? this.isPublished,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lessons: lessons ?? this.lessons,
    );
  }

  String get durationDisplay {
    if (durationMinutes < 60) return '$durationMinutes min';
    final hours = durationMinutes ~/ 60;
    final minutes = durationMinutes % 60;
    return minutes > 0 ? '${hours}h ${minutes}m' : '${hours}h';
  }
}

/// Module Create/Update Request
class ModuleRequest {
  final String title;
  final String? description;
  final int? orderIndex;
  final List<String> learningObjectives;
  final bool isPublished;

  ModuleRequest({
    required this.title,
    this.description,
    this.orderIndex,
    this.learningObjectives = const [],
    this.isPublished = false,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'title': title,
      'learning_objectives': learningObjectives,
      'is_published': isPublished,
    };

    if (description != null) json['description'] = description;
    if (orderIndex != null) json['order_index'] = orderIndex;

    return json;
  }
}

// =============================================================================
// COURSE LESSON MODEL
// =============================================================================

/// Lesson Type Enumeration
enum LessonType {
  video,
  text,
  quiz,
  assignment;

  String get value => name;
  String get displayName {
    switch (this) {
      case LessonType.video:
        return 'Video';
      case LessonType.text:
        return 'Reading';
      case LessonType.quiz:
        return 'Quiz';
      case LessonType.assignment:
        return 'Assignment';
    }
  }

  IconData get icon {
    switch (this) {
      case LessonType.video:
        return Icons.play_circle_outline;
      case LessonType.text:
        return Icons.article_outlined;
      case LessonType.quiz:
        return Icons.quiz_outlined;
      case LessonType.assignment:
        return Icons.assignment_outlined;
    }
  }

  static LessonType fromString(String value) {
    return LessonType.values.firstWhere(
      (e) => e.value == value.toLowerCase(),
      orElse: () => LessonType.video,
    );
  }
}

/// Course Lesson Model
class CourseLesson {
  final String id;
  final String moduleId;
  final String title;
  final String? description;
  final LessonType lessonType;
  final int orderIndex;
  final int durationMinutes;
  final String? contentUrl;
  final bool isMandatory;
  final bool isPublished;
  final bool allowPreview;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Additional fields for UI
  final bool? isCompleted;
  final dynamic content; // Video, Text, Quiz, or Assignment content

  CourseLesson({
    required this.id,
    required this.moduleId,
    required this.title,
    this.description,
    required this.lessonType,
    required this.orderIndex,
    this.durationMinutes = 0,
    this.contentUrl,
    this.isMandatory = true,
    this.isPublished = false,
    this.allowPreview = false,
    required this.createdAt,
    required this.updatedAt,
    this.isCompleted,
    this.content,
  });

  factory CourseLesson.fromJson(Map<String, dynamic> json) {
    return CourseLesson(
      id: json['id'] as String,
      moduleId: json['module_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      lessonType: LessonType.fromString(json['lesson_type'] as String),
      orderIndex: json['order_index'] as int,
      durationMinutes: json['duration_minutes'] as int? ?? 0,
      contentUrl: json['content_url'] as String?,
      isMandatory: json['is_mandatory'] as bool? ?? true,
      isPublished: json['is_published'] as bool? ?? false,
      allowPreview: json['allow_preview'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      isCompleted: json['is_completed'] as bool?,
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'module_id': moduleId,
      'title': title,
      'description': description,
      'lesson_type': lessonType.value,
      'order_index': orderIndex,
      'duration_minutes': durationMinutes,
      'content_url': contentUrl,
      'is_mandatory': isMandatory,
      'is_published': isPublished,
      'allow_preview': allowPreview,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  CourseLesson copyWith({
    String? id,
    String? moduleId,
    String? title,
    String? description,
    LessonType? lessonType,
    int? orderIndex,
    int? durationMinutes,
    String? contentUrl,
    bool? isMandatory,
    bool? isPublished,
    bool? allowPreview,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isCompleted,
    dynamic content,
  }) {
    return CourseLesson(
      id: id ?? this.id,
      moduleId: moduleId ?? this.moduleId,
      title: title ?? this.title,
      description: description ?? this.description,
      lessonType: lessonType ?? this.lessonType,
      orderIndex: orderIndex ?? this.orderIndex,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      contentUrl: contentUrl ?? this.contentUrl,
      isMandatory: isMandatory ?? this.isMandatory,
      isPublished: isPublished ?? this.isPublished,
      allowPreview: allowPreview ?? this.allowPreview,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isCompleted: isCompleted ?? this.isCompleted,
      content: content ?? this.content,
    );
  }

  String get durationDisplay {
    if (durationMinutes < 60) return '$durationMinutes min';
    final hours = durationMinutes ~/ 60;
    final minutes = durationMinutes % 60;
    return minutes > 0 ? '${hours}h ${minutes}m' : '${hours}h';
  }
}

/// Lesson Create/Update Request
class LessonRequest {
  final String title;
  final String? description;
  final LessonType lessonType;
  final int? orderIndex;
  final int? durationMinutes;
  final String? contentUrl;
  final bool isMandatory;
  final bool isPublished;
  final bool allowPreview;

  LessonRequest({
    required this.title,
    this.description,
    required this.lessonType,
    this.orderIndex,
    this.durationMinutes,
    this.contentUrl,
    this.isMandatory = true,
    this.isPublished = false,
    this.allowPreview = false,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'title': title,
      'lesson_type': lessonType.value,
      'is_mandatory': isMandatory,
      'is_published': isPublished,
      'allow_preview': allowPreview,
    };

    if (description != null) json['description'] = description;
    if (orderIndex != null) json['order_index'] = orderIndex;
    if (durationMinutes != null) json['duration_minutes'] = durationMinutes;
    if (contentUrl != null) json['content_url'] = contentUrl;

    return json;
  }
}

// =============================================================================
// VIDEO CONTENT MODEL
// =============================================================================

/// Video Content Model
class VideoContent {
  final String id;
  final String lessonId;
  final String videoUrl;
  final String videoPlatform;
  final String? thumbnailUrl;
  final int? durationSeconds;
  final String? transcript;
  final bool allowDownload;
  final bool autoPlay;
  final bool showControls;
  final DateTime createdAt;
  final DateTime updatedAt;

  VideoContent({
    required this.id,
    required this.lessonId,
    required this.videoUrl,
    this.videoPlatform = 'youtube',
    this.thumbnailUrl,
    this.durationSeconds,
    this.transcript,
    this.allowDownload = false,
    this.autoPlay = false,
    this.showControls = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VideoContent.fromJson(Map<String, dynamic> json) {
    return VideoContent(
      id: json['id'] as String,
      lessonId: json['lesson_id'] as String,
      videoUrl: json['video_url'] as String,
      videoPlatform: json['video_platform'] as String? ?? 'youtube',
      thumbnailUrl: json['thumbnail_url'] as String?,
      durationSeconds: json['duration_seconds'] as int?,
      transcript: json['transcript'] as String?,
      allowDownload: json['allow_download'] as bool? ?? false,
      autoPlay: json['auto_play'] as bool? ?? false,
      showControls: json['show_controls'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lesson_id': lessonId,
      'video_url': videoUrl,
      'video_platform': videoPlatform,
      'thumbnail_url': thumbnailUrl,
      'duration_seconds': durationSeconds,
      'transcript': transcript,
      'allow_download': allowDownload,
      'auto_play': autoPlay,
      'show_controls': showControls,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String get durationDisplay {
    if (durationSeconds == null) return '';
    final minutes = durationSeconds! ~/ 60;
    final seconds = durationSeconds! % 60;
    return '${minutes}:${seconds.toString().padLeft(2, '0')}';
  }
}

/// Video Content Request
class VideoContentRequest {
  final String videoUrl;
  final String? videoPlatform;
  final String? thumbnailUrl;
  final int? durationSeconds;
  final String? transcript;
  final bool? allowDownload;
  final bool? autoPlay;
  final bool? showControls;

  VideoContentRequest({
    required this.videoUrl,
    this.videoPlatform,
    this.thumbnailUrl,
    this.durationSeconds,
    this.transcript,
    this.allowDownload,
    this.autoPlay,
    this.showControls,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'video_url': videoUrl,
    };

    if (videoPlatform != null) json['video_platform'] = videoPlatform;
    if (thumbnailUrl != null) json['thumbnail_url'] = thumbnailUrl;
    if (durationSeconds != null) json['duration_seconds'] = durationSeconds;
    if (transcript != null) json['transcript'] = transcript;
    if (allowDownload != null) json['allow_download'] = allowDownload;
    if (autoPlay != null) json['auto_play'] = autoPlay;
    if (showControls != null) json['show_controls'] = showControls;

    return json;
  }
}

// =============================================================================
// TEXT CONTENT MODEL
// =============================================================================

/// Text Content Model
class TextContent {
  final String id;
  final String lessonId;
  final String content;
  final String contentFormat;
  final int? estimatedReadingTime;
  final List<Map<String, dynamic>> attachments;
  final List<Map<String, dynamic>> externalLinks;
  final DateTime createdAt;
  final DateTime updatedAt;

  TextContent({
    required this.id,
    required this.lessonId,
    required this.content,
    this.contentFormat = 'markdown',
    this.estimatedReadingTime,
    this.attachments = const [],
    this.externalLinks = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory TextContent.fromJson(Map<String, dynamic> json) {
    return TextContent(
      id: json['id'] as String,
      lessonId: json['lesson_id'] as String,
      content: json['content'] as String,
      contentFormat: json['content_format'] as String? ?? 'markdown',
      estimatedReadingTime: json['estimated_reading_time'] as int?,
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          [],
      externalLinks: (json['external_links'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          [],
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lesson_id': lessonId,
      'content': content,
      'content_format': contentFormat,
      'estimated_reading_time': estimatedReadingTime,
      'attachments': attachments,
      'external_links': externalLinks,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

/// Text Content Request
class TextContentRequest {
  final String content;
  final String? contentFormat;
  final int? estimatedReadingTime;
  final List<Map<String, dynamic>>? attachments;
  final List<Map<String, dynamic>>? externalLinks;

  TextContentRequest({
    required this.content,
    this.contentFormat,
    this.estimatedReadingTime,
    this.attachments,
    this.externalLinks,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'content': content,
    };

    if (contentFormat != null) json['content_format'] = contentFormat;
    if (estimatedReadingTime != null) {
      json['estimated_reading_time'] = estimatedReadingTime;
    }
    if (attachments != null) json['attachments'] = attachments;
    if (externalLinks != null) json['external_links'] = externalLinks;

    return json;
  }
}

// =============================================================================
// REORDER REQUESTS
// =============================================================================

/// Module Reorder Request
class ModuleReorderRequest {
  final List<Map<String, dynamic>> moduleOrders;

  ModuleReorderRequest({required this.moduleOrders});

  Map<String, dynamic> toJson() {
    return {
      'module_orders': moduleOrders,
    };
  }
}

/// Lesson Reorder Request
class LessonReorderRequest {
  final List<Map<String, dynamic>> lessonOrders;

  LessonReorderRequest({required this.lessonOrders});

  Map<String, dynamic> toJson() {
    return {
      'lesson_orders': lessonOrders,
    };
  }
}

// =============================================================================
// PROGRESS TRACKING MODELS
// =============================================================================

/// Lesson Completion Model
class LessonCompletion {
  final String id;
  final String lessonId;
  final String userId;
  final DateTime completedAt;
  final int timeSpentMinutes;
  final String? completedFromDevice;
  final double completionPercentage;
  final DateTime createdAt;
  final DateTime updatedAt;

  LessonCompletion({
    required this.id,
    required this.lessonId,
    required this.userId,
    required this.completedAt,
    this.timeSpentMinutes = 0,
    this.completedFromDevice,
    this.completionPercentage = 100.0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LessonCompletion.fromJson(Map<String, dynamic> json) {
    return LessonCompletion(
      id: json['id'] as String,
      lessonId: json['lesson_id'] as String,
      userId: json['user_id'] as String,
      completedAt: DateTime.parse(json['completed_at'] as String),
      timeSpentMinutes: json['time_spent_minutes'] as int? ?? 0,
      completedFromDevice: json['completed_from_device'] as String?,
      completionPercentage:
          (json['completion_percentage'] as num?)?.toDouble() ?? 100.0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}

/// Course Progress Model
class CourseProgress {
  final String userId;
  final String courseId;
  final int totalLessons;
  final int completedLessons;
  final double progressPercentage;
  final int totalTimeSpentMinutes;
  final List<String> completedLessonIds;

  CourseProgress({
    required this.userId,
    required this.courseId,
    required this.totalLessons,
    required this.completedLessons,
    required this.progressPercentage,
    required this.totalTimeSpentMinutes,
    required this.completedLessonIds,
  });

  factory CourseProgress.fromJson(Map<String, dynamic> json) {
    return CourseProgress(
      userId: json['user_id'] as String,
      courseId: json['course_id'] as String,
      totalLessons: json['total_lessons'] as int,
      completedLessons: json['completed_lessons'] as int,
      progressPercentage: (json['progress_percentage'] as num).toDouble(),
      totalTimeSpentMinutes: json['total_time_spent_minutes'] as int,
      completedLessonIds: (json['completed_lesson_ids'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
    );
  }
}
