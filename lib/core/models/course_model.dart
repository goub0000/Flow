/// Course model
class Course {
  final String id;
  final String title;
  final String description;
  final String institutionId;
  final String institutionName;
  final String? imageUrl;
  final String level; // undergraduate, postgraduate, certificate
  final String category;
  final int duration; // in months
  final double? fee;
  final String currency;
  final List<String> prerequisites;
  final DateTime startDate;
  final DateTime? endDate;
  final int enrolledStudents;
  final int maxStudents;
  final bool isActive;
  final bool isOnline;
  final double rating;
  final DateTime createdAt;

  const Course({
    required this.id,
    required this.title,
    required this.description,
    required this.institutionId,
    required this.institutionName,
    this.imageUrl,
    required this.level,
    required this.category,
    required this.duration,
    this.fee,
    this.currency = 'USD',
    this.prerequisites = const [],
    required this.startDate,
    this.endDate,
    this.enrolledStudents = 0,
    this.maxStudents = 100,
    this.isActive = true,
    this.isOnline = false,
    this.rating = 0.0,
    required this.createdAt,
  });

  bool get isFull => enrolledStudents >= maxStudents;
  bool get hasAvailableSlots => !isFull;

  factory Course.fromJson(Map<String, dynamic> json) {
    // Support both camelCase (courses) and snake_case (programs) formats
    final String institutionIdKey = json.containsKey('institution_id') ? 'institution_id' : 'institutionId';
    final String institutionNameKey = json.containsKey('institution_name') ? 'institution_name' : 'institutionName';
    final String imageUrlKey = json.containsKey('image_url') ? 'image_url' : 'imageUrl';
    final String startDateKey = json.containsKey('start_date') ? 'start_date' : 'startDate';
    final String endDateKey = json.containsKey('end_date') ? 'end_date' : 'endDate';
    final String enrolledStudentsKey = json.containsKey('enrolled_students') ? 'enrolled_students' : 'enrolledStudents';
    final String maxStudentsKey = json.containsKey('max_students') ? 'max_students' : 'maxStudents';
    final String isActiveKey = json.containsKey('is_active') ? 'is_active' : 'isActive';
    final String isOnlineKey = json.containsKey('is_online') ? 'is_online' : 'isOnline';
    final String createdAtKey = json.containsKey('created_at') ? 'created_at' : 'createdAt';

    // Programs API uses 'name' instead of 'title'
    final String titleValue = json['title'] as String? ?? json['name'] as String;

    // Programs API uses 'requirements' instead of 'prerequisites'
    final List<String> prerequisitesList = (json['prerequisites'] as List?)?.cast<String>() ??
                                           (json['requirements'] as List?)?.cast<String>() ?? [];

    // Programs API uses 'duration_days' instead of 'duration' (months)
    int durationMonths;
    if (json.containsKey('duration_days')) {
      // Convert days to months (approximate: 30 days per month)
      durationMonths = ((json['duration_days'] as int) / 30).round();
    } else {
      durationMonths = json['duration'] as int;
    }

    // Handle fee as either num or double
    double? feeValue;
    if (json['fee'] != null) {
      feeValue = (json['fee'] as num).toDouble();
    }

    return Course(
      id: json['id'].toString(), // Support both string and int IDs
      title: titleValue,
      description: json['description'] as String,
      institutionId: json[institutionIdKey].toString(),
      institutionName: json[institutionNameKey] as String,
      imageUrl: json[imageUrlKey] as String?,
      level: json['level'] as String,
      category: json['category'] as String,
      duration: durationMonths,
      fee: feeValue,
      currency: json['currency'] as String? ?? 'USD',
      prerequisites: prerequisitesList,
      startDate: DateTime.parse(json[startDateKey] as String),
      endDate: json[endDateKey] != null
          ? DateTime.parse(json[endDateKey] as String)
          : null,
      enrolledStudents: json[enrolledStudentsKey] as int? ?? 0,
      maxStudents: json[maxStudentsKey] as int? ?? 100,
      isActive: json[isActiveKey] as bool? ?? true,
      isOnline: json[isOnlineKey] as bool? ?? false,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.parse(json[createdAtKey] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'institutionId': institutionId,
      'institutionName': institutionName,
      'imageUrl': imageUrl,
      'level': level,
      'category': category,
      'duration': duration,
      'fee': fee,
      'currency': currency,
      'prerequisites': prerequisites,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'enrolledStudents': enrolledStudents,
      'maxStudents': maxStudents,
      'isActive': isActive,
      'isOnline': isOnline,
      'rating': rating,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

/// Enrollment model
class Enrollment {
  final String id;
  final String studentId;
  final String courseId;
  final Course? course;
  final DateTime enrolledAt;
  final String status; // active, completed, dropped
  final double progress; // 0-100
  final double? grade;

  const Enrollment({
    required this.id,
    required this.studentId,
    required this.courseId,
    this.course,
    required this.enrolledAt,
    this.status = 'active',
    this.progress = 0,
    this.grade,
  });

  factory Enrollment.fromJson(Map<String, dynamic> json) {
    return Enrollment(
      id: json['id'] as String,
      studentId: json['studentId'] as String,
      courseId: json['courseId'] as String,
      course:
          json['course'] != null ? Course.fromJson(json['course']) : null,
      enrolledAt: DateTime.parse(json['enrolledAt'] as String),
      status: json['status'] as String? ?? 'active',
      progress: (json['progress'] as num?)?.toDouble() ?? 0,
      grade: (json['grade'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'courseId': courseId,
      'course': course?.toJson(),
      'enrolledAt': enrolledAt.toIso8601String(),
      'status': status,
      'progress': progress,
      'grade': grade,
    };
  }
}
