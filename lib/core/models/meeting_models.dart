/// Meeting models for parent-teacher/counselor scheduling system
library;

enum MeetingStatus {
  pending,
  approved,
  declined,
  cancelled,
  completed;

  String get displayName {
    switch (this) {
      case MeetingStatus.pending:
        return 'Pending';
      case MeetingStatus.approved:
        return 'Approved';
      case MeetingStatus.declined:
        return 'Declined';
      case MeetingStatus.cancelled:
        return 'Cancelled';
      case MeetingStatus.completed:
        return 'Completed';
    }
  }

  static MeetingStatus fromString(String value) {
    return MeetingStatus.values.firstWhere(
      (status) => status.name == value,
      orElse: () => MeetingStatus.pending,
    );
  }
}

enum MeetingMode {
  inPerson('in_person', 'In Person'),
  videoCall('video_call', 'Video Call'),
  phoneCall('phone_call', 'Phone Call');

  final String value;
  final String displayName;

  const MeetingMode(this.value, this.displayName);

  static MeetingMode fromString(String value) {
    return MeetingMode.values.firstWhere(
      (mode) => mode.value == value,
      orElse: () => MeetingMode.videoCall,
    );
  }
}

enum StaffType {
  teacher,
  counselor;

  String get displayName {
    switch (this) {
      case StaffType.teacher:
        return 'Teacher';
      case StaffType.counselor:
        return 'Counselor';
    }
  }

  static StaffType fromString(String value) {
    return StaffType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => StaffType.teacher,
    );
  }
}

enum MeetingType {
  parentTeacher('parent_teacher', 'Parent-Teacher'),
  parentCounselor('parent_counselor', 'Parent-Counselor');

  final String value;
  final String displayName;

  const MeetingType(this.value, this.displayName);

  static MeetingType fromString(String value) {
    return MeetingType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => MeetingType.parentTeacher,
    );
  }
}

/// Meeting model
class Meeting {
  final String id;
  final String parentId;
  final String studentId;
  final String staffId;
  final StaffType staffType;
  final MeetingType meetingType;
  final MeetingStatus status;
  final DateTime? scheduledDate;
  final int durationMinutes;
  final MeetingMode meetingMode;
  final String? meetingLink;
  final String? location;
  final String subject;
  final String? notes;
  final String? parentNotes;
  final String? staffNotes;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Populated fields from joins
  final String? studentName;
  final String? staffName;
  final String? parentName;

  Meeting({
    required this.id,
    required this.parentId,
    required this.studentId,
    required this.staffId,
    required this.staffType,
    required this.meetingType,
    required this.status,
    this.scheduledDate,
    required this.durationMinutes,
    required this.meetingMode,
    this.meetingLink,
    this.location,
    required this.subject,
    this.notes,
    this.parentNotes,
    this.staffNotes,
    required this.createdAt,
    required this.updatedAt,
    this.studentName,
    this.staffName,
    this.parentName,
  });

  factory Meeting.fromJson(Map<String, dynamic> json) {
    return Meeting(
      id: json['id'] as String,
      parentId: json['parent_id'] as String,
      studentId: json['student_id'] as String,
      staffId: json['staff_id'] as String,
      staffType: StaffType.fromString(json['staff_type'] as String),
      meetingType: MeetingType.fromString(json['meeting_type'] as String),
      status: MeetingStatus.fromString(json['status'] as String),
      scheduledDate: json['scheduled_date'] != null
          ? DateTime.parse(json['scheduled_date'] as String)
          : null,
      durationMinutes: json['duration_minutes'] as int,
      meetingMode: MeetingMode.fromString(json['meeting_mode'] as String),
      meetingLink: json['meeting_link'] as String?,
      location: json['location'] as String?,
      subject: json['subject'] as String,
      notes: json['notes'] as String?,
      parentNotes: json['parent_notes'] as String?,
      staffNotes: json['staff_notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      studentName: json['student_name'] as String?,
      staffName: json['staff_name'] as String?,
      parentName: json['parent_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parent_id': parentId,
      'student_id': studentId,
      'staff_id': staffId,
      'staff_type': staffType.name,
      'meeting_type': meetingType.value,
      'status': status.name,
      'scheduled_date': scheduledDate?.toIso8601String(),
      'duration_minutes': durationMinutes,
      'meeting_mode': meetingMode.value,
      'meeting_link': meetingLink,
      'location': location,
      'subject': subject,
      'notes': notes,
      'parent_notes': parentNotes,
      'staff_notes': staffNotes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'student_name': studentName,
      'staff_name': staffName,
      'parent_name': parentName,
    };
  }

  Meeting copyWith({
    String? id,
    String? parentId,
    String? studentId,
    String? staffId,
    StaffType? staffType,
    MeetingType? meetingType,
    MeetingStatus? status,
    DateTime? scheduledDate,
    int? durationMinutes,
    MeetingMode? meetingMode,
    String? meetingLink,
    String? location,
    String? subject,
    String? notes,
    String? parentNotes,
    String? staffNotes,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? studentName,
    String? staffName,
    String? parentName,
  }) {
    return Meeting(
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      studentId: studentId ?? this.studentId,
      staffId: staffId ?? this.staffId,
      staffType: staffType ?? this.staffType,
      meetingType: meetingType ?? this.meetingType,
      status: status ?? this.status,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      meetingMode: meetingMode ?? this.meetingMode,
      meetingLink: meetingLink ?? this.meetingLink,
      location: location ?? this.location,
      subject: subject ?? this.subject,
      notes: notes ?? this.notes,
      parentNotes: parentNotes ?? this.parentNotes,
      staffNotes: staffNotes ?? this.staffNotes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      studentName: studentName ?? this.studentName,
      staffName: staffName ?? this.staffName,
      parentName: parentName ?? this.parentName,
    );
  }

  /// Check if meeting is upcoming
  bool get isUpcoming {
    if (scheduledDate == null) return false;
    return scheduledDate!.isAfter(DateTime.now()) &&
        (status == MeetingStatus.approved);
  }

  /// Check if meeting is past
  bool get isPast {
    if (scheduledDate == null) return false;
    return scheduledDate!.isBefore(DateTime.now());
  }

  /// Check if meeting is urgent (within 7 days)
  bool get isUrgent {
    if (scheduledDate == null) return false;
    final daysUntil = scheduledDate!.difference(DateTime.now()).inDays;
    return daysUntil <= 7 && daysUntil >= 0 && status == MeetingStatus.approved;
  }

  /// Get status color
  String get statusColor {
    switch (status) {
      case MeetingStatus.pending:
        return 'warning';
      case MeetingStatus.approved:
        return 'success';
      case MeetingStatus.declined:
        return 'error';
      case MeetingStatus.cancelled:
        return 'error';
      case MeetingStatus.completed:
        return 'info';
    }
  }
}

/// Staff member for meeting selection
class StaffMember {
  final String id;
  final String displayName;
  final String email;
  final StaffType role;
  final bool hasAvailability;
  final String? photoUrl;
  final String? department;

  StaffMember({
    required this.id,
    required this.displayName,
    required this.email,
    required this.role,
    required this.hasAvailability,
    this.photoUrl,
    this.department,
  });

  factory StaffMember.fromJson(Map<String, dynamic> json) {
    return StaffMember(
      id: json['id'] as String,
      displayName: json['display_name'] as String,
      email: json['email'] as String,
      role: StaffType.fromString(json['role'] as String),
      hasAvailability: json['has_availability'] as bool? ?? false,
      photoUrl: json['photo_url'] as String?,
      department: json['department'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'display_name': displayName,
      'email': email,
      'role': role.name,
      'has_availability': hasAvailability,
      'photo_url': photoUrl,
      'department': department,
    };
  }

  String get initials {
    final parts = displayName.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return displayName.substring(0, 1).toUpperCase();
  }
}

/// Staff availability slot
class StaffAvailability {
  final String id;
  final String staffId;
  final int dayOfWeek; // 0-6 (Sunday-Saturday)
  final String startTime; // HH:MM:SS format
  final String endTime;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  StaffAvailability({
    required this.id,
    required this.staffId,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StaffAvailability.fromJson(Map<String, dynamic> json) {
    return StaffAvailability(
      id: json['id'] as String,
      staffId: json['staff_id'] as String,
      dayOfWeek: json['day_of_week'] as int,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      isActive: json['is_active'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'staff_id': staffId,
      'day_of_week': dayOfWeek,
      'start_time': startTime,
      'end_time': endTime,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String get dayName {
    const days = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday'
    ];
    return days[dayOfWeek % 7];
  }
}

/// Available time slot
class AvailableSlot {
  final DateTime startTime;
  final DateTime endTime;
  final int durationMinutes;

  AvailableSlot({
    required this.startTime,
    required this.endTime,
    required this.durationMinutes,
  });

  factory AvailableSlot.fromJson(Map<String, dynamic> json) {
    return AvailableSlot(
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: DateTime.parse(json['end_time'] as String),
      durationMinutes: json['duration_minutes'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'duration_minutes': durationMinutes,
    };
  }

  String get timeRange {
    final start = '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
    final end = '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';
    return '$start - $end';
  }
}

/// Meeting statistics
class MeetingStatistics {
  final int totalMeetings;
  final int pendingMeetings;
  final int approvedMeetings;
  final int completedMeetings;
  final int declinedMeetings;
  final int cancelledMeetings;

  MeetingStatistics({
    required this.totalMeetings,
    required this.pendingMeetings,
    required this.approvedMeetings,
    required this.completedMeetings,
    required this.declinedMeetings,
    required this.cancelledMeetings,
  });

  factory MeetingStatistics.fromJson(Map<String, dynamic> json) {
    return MeetingStatistics(
      totalMeetings: json['total_meetings'] as int,
      pendingMeetings: json['pending_meetings'] as int,
      approvedMeetings: json['approved_meetings'] as int,
      completedMeetings: json['completed_meetings'] as int,
      declinedMeetings: json['declined_meetings'] as int,
      cancelledMeetings: json['cancelled_meetings'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_meetings': totalMeetings,
      'pending_meetings': pendingMeetings,
      'approved_meetings': approvedMeetings,
      'completed_meetings': completedMeetings,
      'declined_meetings': declinedMeetings,
      'cancelled_meetings': cancelledMeetings,
    };
  }
}

/// Meeting request DTO
class MeetingRequestDTO {
  final String staffId;
  final String studentId;
  final StaffType staffType;
  final MeetingType meetingType;
  final String subject;
  final int durationMinutes;
  final MeetingMode meetingMode;
  final DateTime? scheduledDate;
  final String? notes;
  final String? parentNotes;
  final String? location;

  MeetingRequestDTO({
    required this.staffId,
    required this.studentId,
    required this.staffType,
    required this.meetingType,
    required this.subject,
    this.durationMinutes = 30,
    this.meetingMode = MeetingMode.videoCall,
    this.scheduledDate,
    this.notes,
    this.parentNotes,
    this.location,
  });

  Map<String, dynamic> toJson() {
    return {
      'staff_id': staffId,
      'student_id': studentId,
      'staff_type': staffType.name,
      'meeting_type': meetingType.value,
      'subject': subject,
      'duration_minutes': durationMinutes,
      'meeting_mode': meetingMode.value,
      if (scheduledDate != null) 'scheduled_date': scheduledDate!.toIso8601String(),
      if (notes != null) 'notes': notes,
      if (parentNotes != null) 'parent_notes': parentNotes,
      if (location != null) 'location': location,
    };
  }
}

/// Meeting approval DTO
class MeetingApprovalDTO {
  final DateTime scheduledDate;
  final int? durationMinutes;
  final String? meetingLink;
  final String? location;
  final String? staffNotes;

  MeetingApprovalDTO({
    required this.scheduledDate,
    this.durationMinutes,
    this.meetingLink,
    this.location,
    this.staffNotes,
  });

  Map<String, dynamic> toJson() {
    return {
      'scheduled_date': scheduledDate.toIso8601String(),
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (meetingLink != null) 'meeting_link': meetingLink,
      if (location != null) 'location': location,
      if (staffNotes != null) 'staff_notes': staffNotes,
    };
  }
}

/// Meeting decline DTO
class MeetingDeclineDTO {
  final String staffNotes;

  MeetingDeclineDTO({
    required this.staffNotes,
  });

  Map<String, dynamic> toJson() {
    return {
      'staff_notes': staffNotes,
    };
  }
}
