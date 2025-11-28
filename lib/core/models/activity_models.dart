import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_models.freezed.dart';
part 'activity_models.g.dart';

/// Types of student activities
enum StudentActivityType {
  @JsonValue('application_submitted')
  applicationSubmitted,
  @JsonValue('application_status_changed')
  applicationStatusChanged,
  @JsonValue('achievement_earned')
  achievementEarned,
  @JsonValue('payment_made')
  paymentMade,
  @JsonValue('message_received')
  messageReceived,
  @JsonValue('course_completed')
  courseCompleted,
  @JsonValue('meeting_scheduled')
  meetingScheduled,
  @JsonValue('meeting_completed')
  meetingCompleted,
}

/// Extension for activity type labels
extension StudentActivityTypeExtension on StudentActivityType {
  String get displayName {
    switch (this) {
      case StudentActivityType.applicationSubmitted:
        return 'Application Submitted';
      case StudentActivityType.applicationStatusChanged:
        return 'Application Status Changed';
      case StudentActivityType.achievementEarned:
        return 'Achievement Earned';
      case StudentActivityType.paymentMade:
        return 'Payment Made';
      case StudentActivityType.messageReceived:
        return 'Message Received';
      case StudentActivityType.courseCompleted:
        return 'Course Completed';
      case StudentActivityType.meetingScheduled:
        return 'Meeting Scheduled';
      case StudentActivityType.meetingCompleted:
        return 'Meeting Completed';
    }
  }
}

/// Student activity feed item
@freezed
class StudentActivity with _$StudentActivity {
  const factory StudentActivity({
    required String id,
    required DateTime timestamp,
    required StudentActivityType type,
    required String title,
    required String description,
    required String icon,
    String? relatedEntityId,
    @Default({}) Map<String, dynamic> metadata,
  }) = _StudentActivity;

  factory StudentActivity.fromJson(Map<String, dynamic> json) =>
      _$StudentActivityFromJson(json);
}

/// Student activity feed response with pagination
@freezed
class StudentActivityFeedResponse with _$StudentActivityFeedResponse {
  const factory StudentActivityFeedResponse({
    required List<StudentActivity> activities,
    @Default(0) int totalCount,
    @Default(1) int page,
    @Default(10) int limit,
    @Default(false) bool hasMore,
  }) = _StudentActivityFeedResponse;

  factory StudentActivityFeedResponse.fromJson(Map<String, dynamic> json) =>
      _$StudentActivityFeedResponseFromJson(json);
}

/// Filter request for student activities
@freezed
class StudentActivityFilterRequest with _$StudentActivityFilterRequest {
  const factory StudentActivityFilterRequest({
    @Default(1) int page,
    @Default(10) int limit,
    List<StudentActivityType>? activityTypes,
    DateTime? startDate,
    DateTime? endDate,
  }) = _StudentActivityFilterRequest;

  factory StudentActivityFilterRequest.fromJson(Map<String, dynamic> json) =>
      _$StudentActivityFilterRequestFromJson(json);
}

/// Extension for StudentActivityFilterRequest
extension StudentActivityFilterRequestExtension on StudentActivityFilterRequest {
  /// Convert to query parameters for API request
  Map<String, dynamic> toQueryParams() {
    final params = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
    };

    if (activityTypes != null && activityTypes!.isNotEmpty) {
      params['activity_types'] = activityTypes!
          .map((type) => type.toString().split('.').last)
          .join(',');
    }

    if (startDate != null) {
      params['start_date'] = startDate!.toIso8601String();
    }

    if (endDate != null) {
      params['end_date'] = endDate!.toIso8601String();
    }

    return params;
  }
}
