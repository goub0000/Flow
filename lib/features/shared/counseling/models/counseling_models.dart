/// Shared counseling models used across student, parent, and institution dashboards

/// Session status enum
enum SessionStatus {
  scheduled,
  inProgress,
  completed,
  cancelled,
  rescheduled,
  noShow;

  String get displayName {
    switch (this) {
      case SessionStatus.scheduled:
        return 'Scheduled';
      case SessionStatus.inProgress:
        return 'In Progress';
      case SessionStatus.completed:
        return 'Completed';
      case SessionStatus.cancelled:
        return 'Cancelled';
      case SessionStatus.rescheduled:
        return 'Rescheduled';
      case SessionStatus.noShow:
        return 'No Show';
    }
  }

  static SessionStatus fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'scheduled':
        return SessionStatus.scheduled;
      case 'in_progress':
      case 'inprogress':
        return SessionStatus.inProgress;
      case 'completed':
        return SessionStatus.completed;
      case 'cancelled':
        return SessionStatus.cancelled;
      case 'rescheduled':
        return SessionStatus.rescheduled;
      case 'no_show':
      case 'noshow':
        return SessionStatus.noShow;
      default:
        return SessionStatus.scheduled;
    }
  }
}

/// Session type enum
enum SessionType {
  academic,
  career,
  personal,
  college,
  general;

  String get displayName {
    switch (this) {
      case SessionType.academic:
        return 'Academic';
      case SessionType.career:
        return 'Career';
      case SessionType.personal:
        return 'Personal';
      case SessionType.college:
        return 'College';
      case SessionType.general:
        return 'General';
    }
  }

  static SessionType fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'academic':
        return SessionType.academic;
      case 'career':
        return SessionType.career;
      case 'personal':
        return SessionType.personal;
      case 'college':
        return SessionType.college;
      default:
        return SessionType.general;
    }
  }
}

/// Counselor information model
class CounselorInfo {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final DateTime? assignedAt;
  final List<AvailabilitySlot> availability;
  final int completedSessions;
  final double? averageRating;

  CounselorInfo({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.assignedAt,
    this.availability = const [],
    this.completedSessions = 0,
    this.averageRating,
  });

  factory CounselorInfo.fromJson(Map<String, dynamic> json) {
    return CounselorInfo(
      id: json['id'] ?? '',
      name: json['name'] ?? json['display_name'] ?? 'Unknown',
      email: json['email'] ?? '',
      avatarUrl: json['avatar_url'],
      assignedAt: json['assigned_at'] != null
          ? DateTime.tryParse(json['assigned_at'])
          : null,
      availability: (json['availability'] as List<dynamic>?)
              ?.map((a) => AvailabilitySlot.fromJson(a))
              .toList() ??
          [],
      completedSessions: json['completed_sessions'] ?? 0,
      averageRating: json['average_rating']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'avatar_url': avatarUrl,
        'assigned_at': assignedAt?.toIso8601String(),
        'availability': availability.map((a) => a.toJson()).toList(),
        'completed_sessions': completedSessions,
        'average_rating': averageRating,
      };
}

/// Availability slot model
class AvailabilitySlot {
  final int dayOfWeek; // 0=Monday, 6=Sunday
  final String startTime;
  final String endTime;
  final int sessionDuration;
  final int? maxSessionsPerDay;

  AvailabilitySlot({
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    this.sessionDuration = 30,
    this.maxSessionsPerDay,
  });

  factory AvailabilitySlot.fromJson(Map<String, dynamic> json) {
    return AvailabilitySlot(
      dayOfWeek: json['day_of_week'] ?? 0,
      startTime: json['start_time'] ?? '09:00',
      endTime: json['end_time'] ?? '17:00',
      sessionDuration: json['session_duration'] ?? 30,
      maxSessionsPerDay: json['max_sessions_per_day'],
    );
  }

  Map<String, dynamic> toJson() => {
        'day_of_week': dayOfWeek,
        'start_time': startTime,
        'end_time': endTime,
        'session_duration': sessionDuration,
        'max_sessions_per_day': maxSessionsPerDay,
      };

  String get dayName {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return days[dayOfWeek.clamp(0, 6)];
  }
}

/// Available time slot for booking
class BookingSlot {
  final DateTime start;
  final DateTime end;
  final int durationMinutes;
  final String counselorId;

  BookingSlot({
    required this.start,
    required this.end,
    required this.durationMinutes,
    required this.counselorId,
  });

  factory BookingSlot.fromJson(Map<String, dynamic> json) {
    return BookingSlot(
      start: DateTime.parse(json['start']),
      end: DateTime.parse(json['end']),
      durationMinutes: json['duration_minutes'] ?? 30,
      counselorId: json['counselor_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'start': start.toIso8601String(),
        'end': end.toIso8601String(),
        'duration_minutes': durationMinutes,
        'counselor_id': counselorId,
      };
}

/// Counseling session model
class CounselingSession {
  final String id;
  final String counselorId;
  final String? counselorName;
  final String studentId;
  final String? studentName;
  final SessionType type;
  final SessionStatus status;
  final DateTime scheduledDate;
  final int durationMinutes;
  final String? topic;
  final String? notes;
  final double? feedbackRating;
  final String? feedbackComment;
  final DateTime createdAt;

  CounselingSession({
    required this.id,
    required this.counselorId,
    this.counselorName,
    required this.studentId,
    this.studentName,
    required this.type,
    required this.status,
    required this.scheduledDate,
    this.durationMinutes = 30,
    this.topic,
    this.notes,
    this.feedbackRating,
    this.feedbackComment,
    required this.createdAt,
  });

  factory CounselingSession.fromJson(Map<String, dynamic> json) {
    return CounselingSession(
      id: json['id'] ?? '',
      counselorId: json['counselor_id'] ?? '',
      counselorName: json['counselor_name'],
      studentId: json['student_id'] ?? '',
      studentName: json['student_name'],
      type: SessionType.fromString(json['type'] ?? json['session_type']),
      status: SessionStatus.fromString(json['status']),
      scheduledDate: DateTime.parse(
          json['scheduled_date'] ?? json['scheduled_start'] ?? DateTime.now().toIso8601String()),
      durationMinutes: json['duration_minutes'] ?? 30,
      topic: json['topic'] ?? json['notes'],
      notes: json['notes'] ?? json['summary'],
      feedbackRating: json['feedback_rating']?.toDouble(),
      feedbackComment: json['feedback_comment'],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'counselor_id': counselorId,
        'counselor_name': counselorName,
        'student_id': studentId,
        'student_name': studentName,
        'type': type.name,
        'status': status.name,
        'scheduled_date': scheduledDate.toIso8601String(),
        'duration_minutes': durationMinutes,
        'topic': topic,
        'notes': notes,
        'feedback_rating': feedbackRating,
        'feedback_comment': feedbackComment,
        'created_at': createdAt.toIso8601String(),
      };

  DateTime get scheduledEnd =>
      scheduledDate.add(Duration(minutes: durationMinutes));

  bool get isUpcoming =>
      status == SessionStatus.scheduled && scheduledDate.isAfter(DateTime.now());

  bool get canCancel =>
      status == SessionStatus.scheduled &&
      scheduledDate.isAfter(DateTime.now().add(const Duration(hours: 24)));

  bool get canProvideFeedback =>
      status == SessionStatus.completed && feedbackRating == null;
}

/// Book session request
class BookSessionRequest {
  final String counselorId;
  final DateTime scheduledStart;
  final SessionType sessionType;
  final String? topic;
  final String? description;

  BookSessionRequest({
    required this.counselorId,
    required this.scheduledStart,
    this.sessionType = SessionType.general,
    this.topic,
    this.description,
  });

  Map<String, dynamic> toJson() => {
        'counselor_id': counselorId,
        'scheduled_start': scheduledStart.toIso8601String(),
        'session_type': sessionType.name,
        'topic': topic,
        'description': description,
      };
}

/// Session feedback request
class SessionFeedbackRequest {
  final double rating;
  final String? comment;

  SessionFeedbackRequest({
    required this.rating,
    this.comment,
  });

  Map<String, dynamic> toJson() => {
        'rating': rating,
        'comment': comment,
      };
}

/// Counseling statistics
class CounselingStats {
  final int totalSessions;
  final int completedSessions;
  final int upcomingSessions;
  final int cancelledSessions;
  final double? averageRating;
  final double totalHours;
  final Map<String, int> byType;
  final Map<String, int> byStatus;

  CounselingStats({
    this.totalSessions = 0,
    this.completedSessions = 0,
    this.upcomingSessions = 0,
    this.cancelledSessions = 0,
    this.averageRating,
    this.totalHours = 0,
    this.byType = const {},
    this.byStatus = const {},
  });

  factory CounselingStats.fromJson(Map<String, dynamic> json) {
    return CounselingStats(
      totalSessions: json['total_sessions'] ?? 0,
      completedSessions: json['completed_sessions'] ?? 0,
      upcomingSessions: json['upcoming_sessions'] ?? 0,
      cancelledSessions: json['cancelled_sessions'] ?? 0,
      averageRating: json['average_rating']?.toDouble(),
      totalHours: (json['total_hours'] ?? 0).toDouble(),
      byType: Map<String, int>.from(json['by_type'] ?? {}),
      byStatus: Map<String, int>.from(json['by_status'] ?? {}),
    );
  }
}

/// Institution counselor model (with stats)
class InstitutionCounselor {
  final String id;
  final String name;
  final String email;
  final DateTime createdAt;
  final int totalSessions;
  final int completedSessions;
  final double? averageRating;
  final int assignedStudents;

  InstitutionCounselor({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
    this.totalSessions = 0,
    this.completedSessions = 0,
    this.averageRating,
    this.assignedStudents = 0,
  });

  factory InstitutionCounselor.fromJson(Map<String, dynamic> json) {
    return InstitutionCounselor(
      id: json['id'] ?? '',
      name: json['name'] ?? json['display_name'] ?? 'Unknown',
      email: json['email'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      totalSessions: json['total_sessions'] ?? 0,
      completedSessions: json['completed_sessions'] ?? 0,
      averageRating: json['average_rating']?.toDouble(),
      assignedStudents: json['assigned_students'] ?? 0,
    );
  }
}
