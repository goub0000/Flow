/// Recommendation Letter Models
/// Models that match the backend API response structure
/// Backend: recommendation_service/app/schemas/recommendation_letters.py
library;

/// Request type enumeration
enum RecommendationRequestType {
  academic,
  professional,
  character,
  scholarship;

  static RecommendationRequestType fromString(String value) {
    return RecommendationRequestType.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => RecommendationRequestType.academic,
    );
  }
}

/// Request status enumeration
enum RecommendationRequestStatus {
  pending,
  accepted,
  declined,
  inProgress,
  completed,
  cancelled;

  static RecommendationRequestStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'pending':
        return RecommendationRequestStatus.pending;
      case 'accepted':
        return RecommendationRequestStatus.accepted;
      case 'declined':
        return RecommendationRequestStatus.declined;
      case 'in_progress':
        return RecommendationRequestStatus.inProgress;
      case 'completed':
        return RecommendationRequestStatus.completed;
      case 'cancelled':
        return RecommendationRequestStatus.cancelled;
      default:
        return RecommendationRequestStatus.pending;
    }
  }

  String toApiString() {
    switch (this) {
      case RecommendationRequestStatus.inProgress:
        return 'in_progress';
      default:
        return name;
    }
  }
}

/// Request priority enumeration
enum RecommendationRequestPriority {
  low,
  normal,
  high,
  urgent;

  static RecommendationRequestPriority fromString(String value) {
    return RecommendationRequestPriority.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => RecommendationRequestPriority.normal,
    );
  }
}

/// Letter status enumeration
enum LetterStatus {
  draft,
  submitted,
  archived;

  static LetterStatus fromString(String value) {
    return LetterStatus.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => LetterStatus.draft,
    );
  }
}

/// Letter type enumeration
enum LetterType {
  formal,
  informal,
  emailFormat;

  static LetterType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'formal':
        return LetterType.formal;
      case 'informal':
        return LetterType.informal;
      case 'email_format':
        return LetterType.emailFormat;
      default:
        return LetterType.formal;
    }
  }

  String toApiString() {
    switch (this) {
      case LetterType.emailFormat:
        return 'email_format';
      default:
        return name;
    }
  }
}

/// Recommendation Request model - matches backend RecommendationRequestWithDetails
class RecommendationRequest {
  final String id;
  final String studentId;
  final String recommenderId;
  final RecommendationRequestType requestType;
  final String purpose;
  final String? institutionName;
  final DateTime deadline;
  final RecommendationRequestPriority priority;
  final RecommendationRequestStatus status;
  final String? studentMessage;
  final String? achievements;
  final String? goals;
  final String? relationshipContext;
  final DateTime? acceptedAt;
  final DateTime? declinedAt;
  final String? declineReason;
  final DateTime requestedAt;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Extended fields from RecommendationRequestWithDetails
  final String? studentName;
  final String? studentEmail;
  final String? recommenderName;
  final String? recommenderEmail;
  final String? recommenderTitle;
  final bool hasLetter;
  final LetterStatus? letterStatus;

  RecommendationRequest({
    required this.id,
    required this.studentId,
    required this.recommenderId,
    required this.requestType,
    required this.purpose,
    this.institutionName,
    required this.deadline,
    required this.priority,
    required this.status,
    this.studentMessage,
    this.achievements,
    this.goals,
    this.relationshipContext,
    this.acceptedAt,
    this.declinedAt,
    this.declineReason,
    required this.requestedAt,
    this.completedAt,
    required this.createdAt,
    required this.updatedAt,
    this.studentName,
    this.studentEmail,
    this.recommenderName,
    this.recommenderEmail,
    this.recommenderTitle,
    this.hasLetter = false,
    this.letterStatus,
  });

  bool get isPending => status == RecommendationRequestStatus.pending;
  bool get isAccepted => status == RecommendationRequestStatus.accepted;
  bool get isInProgress => status == RecommendationRequestStatus.inProgress;
  bool get isCompleted => status == RecommendationRequestStatus.completed;
  bool get isDeclined => status == RecommendationRequestStatus.declined;
  bool get isOverdue => DateTime.now().isAfter(deadline) && !isCompleted;
  bool get isUrgent => priority == RecommendationRequestPriority.urgent;

  factory RecommendationRequest.fromJson(Map<String, dynamic> json) {
    return RecommendationRequest(
      id: json['id'] as String,
      studentId: json['student_id'] as String,
      recommenderId: json['recommender_id'] as String,
      requestType: RecommendationRequestType.fromString(json['request_type'] as String),
      purpose: json['purpose'] as String,
      institutionName: json['institution_name'] as String?,
      deadline: DateTime.parse(json['deadline'] as String),
      priority: RecommendationRequestPriority.fromString(json['priority'] as String? ?? 'normal'),
      status: RecommendationRequestStatus.fromString(json['status'] as String),
      studentMessage: json['student_message'] as String?,
      achievements: json['achievements'] as String?,
      goals: json['goals'] as String?,
      relationshipContext: json['relationship_context'] as String?,
      acceptedAt: json['accepted_at'] != null ? DateTime.parse(json['accepted_at'] as String) : null,
      declinedAt: json['declined_at'] != null ? DateTime.parse(json['declined_at'] as String) : null,
      declineReason: json['decline_reason'] as String?,
      requestedAt: DateTime.parse(json['requested_at'] as String),
      completedAt: json['completed_at'] != null ? DateTime.parse(json['completed_at'] as String) : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      studentName: json['student_name'] as String?,
      studentEmail: json['student_email'] as String?,
      recommenderName: json['recommender_name'] as String?,
      recommenderEmail: json['recommender_email'] as String?,
      recommenderTitle: json['recommender_title'] as String?,
      hasLetter: json['has_letter'] as bool? ?? false,
      letterStatus: json['letter_status'] != null
          ? LetterStatus.fromString(json['letter_status'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'recommender_id': recommenderId,
      'request_type': requestType.name,
      'purpose': purpose,
      'institution_name': institutionName,
      'deadline': deadline.toIso8601String().split('T')[0],
      'priority': priority.name,
      'status': status.toApiString(),
      'student_message': studentMessage,
      'achievements': achievements,
      'goals': goals,
      'relationship_context': relationshipContext,
      'accepted_at': acceptedAt?.toIso8601String(),
      'declined_at': declinedAt?.toIso8601String(),
      'decline_reason': declineReason,
      'requested_at': requestedAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

/// Letter of Recommendation model - matches backend LetterOfRecommendationResponse
class LetterOfRecommendation {
  final String id;
  final String requestId;
  final String content;
  final LetterType letterType;
  final LetterStatus status;
  final bool isTemplateBased;
  final String? templateId;
  final int? wordCount;
  final int? characterCount;
  final String? shareToken;
  final String? attachmentUrl;
  final String? attachmentFilename;
  final bool isVisibleToStudent;
  final DateTime draftedAt;
  final DateTime? submittedAt;
  final DateTime lastEditedAt;
  final DateTime createdAt;

  // Extended fields from LetterOfRecommendationWithRequest
  final RecommendationRequest? request;
  final String? studentName;
  final String? institutionName;

  LetterOfRecommendation({
    required this.id,
    required this.requestId,
    required this.content,
    required this.letterType,
    required this.status,
    required this.isTemplateBased,
    this.templateId,
    this.wordCount,
    this.characterCount,
    this.shareToken,
    this.attachmentUrl,
    this.attachmentFilename,
    required this.isVisibleToStudent,
    required this.draftedAt,
    this.submittedAt,
    required this.lastEditedAt,
    required this.createdAt,
    this.request,
    this.studentName,
    this.institutionName,
  });

  bool get isDraft => status == LetterStatus.draft;
  bool get isSubmitted => status == LetterStatus.submitted;

  factory LetterOfRecommendation.fromJson(Map<String, dynamic> json) {
    return LetterOfRecommendation(
      id: json['id'] as String,
      requestId: json['request_id'] as String,
      content: json['content'] as String,
      letterType: LetterType.fromString(json['letter_type'] as String? ?? 'formal'),
      status: LetterStatus.fromString(json['status'] as String),
      isTemplateBased: json['is_template_based'] as bool? ?? false,
      templateId: json['template_id'] as String?,
      wordCount: json['word_count'] as int?,
      characterCount: json['character_count'] as int?,
      shareToken: json['share_token'] as String?,
      attachmentUrl: json['attachment_url'] as String?,
      attachmentFilename: json['attachment_filename'] as String?,
      isVisibleToStudent: json['is_visible_to_student'] as bool? ?? false,
      draftedAt: DateTime.parse(json['drafted_at'] as String),
      submittedAt: json['submitted_at'] != null ? DateTime.parse(json['submitted_at'] as String) : null,
      lastEditedAt: DateTime.parse(json['last_edited_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      request: json['request'] != null ? RecommendationRequest.fromJson(json['request']) : null,
      studentName: json['student_name'] as String?,
      institutionName: json['institution_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'request_id': requestId,
      'content': content,
      'letter_type': letterType.toApiString(),
      'status': status.name,
      'is_template_based': isTemplateBased,
      'template_id': templateId,
      'word_count': wordCount,
      'character_count': characterCount,
      'share_token': shareToken,
      'attachment_url': attachmentUrl,
      'attachment_filename': attachmentFilename,
      'is_visible_to_student': isVisibleToStudent,
      'drafted_at': draftedAt.toIso8601String(),
      'submitted_at': submittedAt?.toIso8601String(),
      'last_edited_at': lastEditedAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}

/// Recommender Dashboard Summary - matches backend RecommenderDashboardSummary
class RecommenderDashboardSummary {
  final int totalRequests;
  final int pendingRequests;
  final int inProgress;
  final int completed;
  final int overdueRequests;
  final int urgentRequests;
  final List<RecommendationRequest> upcomingDeadlines;

  RecommenderDashboardSummary({
    required this.totalRequests,
    required this.pendingRequests,
    required this.inProgress,
    required this.completed,
    required this.overdueRequests,
    required this.urgentRequests,
    required this.upcomingDeadlines,
  });

  factory RecommenderDashboardSummary.fromJson(Map<String, dynamic> json) {
    return RecommenderDashboardSummary(
      totalRequests: json['total_requests'] as int? ?? 0,
      pendingRequests: json['pending_requests'] as int? ?? 0,
      inProgress: json['in_progress'] as int? ?? 0,
      completed: json['completed'] as int? ?? 0,
      overdueRequests: json['overdue_requests'] as int? ?? 0,
      urgentRequests: json['urgent_requests'] as int? ?? 0,
      upcomingDeadlines: (json['upcoming_deadlines'] as List<dynamic>?)
              ?.map((e) => RecommendationRequest.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  factory RecommenderDashboardSummary.empty() {
    return RecommenderDashboardSummary(
      totalRequests: 0,
      pendingRequests: 0,
      inProgress: 0,
      completed: 0,
      overdueRequests: 0,
      urgentRequests: 0,
      upcomingDeadlines: [],
    );
  }
}

/// Recommendation Template - matches backend RecommendationTemplateResponse
class RecommendationTemplate {
  final String id;
  final String name;
  final String? description;
  final String category;
  final String content;
  final List<String> customFields;
  final bool isPublic;
  final String? createdBy;
  final int usageCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  RecommendationTemplate({
    required this.id,
    required this.name,
    this.description,
    required this.category,
    required this.content,
    required this.customFields,
    required this.isPublic,
    this.createdBy,
    required this.usageCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RecommendationTemplate.fromJson(Map<String, dynamic> json) {
    return RecommendationTemplate(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      category: json['category'] as String,
      content: json['content'] as String,
      customFields: (json['custom_fields'] as List<dynamic>?)?.cast<String>() ?? [],
      isPublic: json['is_public'] as bool? ?? true,
      createdBy: json['created_by'] as String?,
      usageCount: json['usage_count'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}

/// Create recommendation request DTO
class CreateRecommendationRequestDto {
  final String studentId;
  final String recommenderId;
  final String requestType;
  final String purpose;
  final String? institutionName;
  final String deadline;
  final String priority;
  final String? studentMessage;
  final String? achievements;
  final String? goals;
  final String? relationshipContext;

  CreateRecommendationRequestDto({
    required this.studentId,
    required this.recommenderId,
    required this.requestType,
    required this.purpose,
    this.institutionName,
    required this.deadline,
    this.priority = 'normal',
    this.studentMessage,
    this.achievements,
    this.goals,
    this.relationshipContext,
  });

  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'recommender_id': recommenderId,
      'request_type': requestType,
      'purpose': purpose,
      'institution_name': institutionName,
      'deadline': deadline,
      'priority': priority,
      'student_message': studentMessage,
      'achievements': achievements,
      'goals': goals,
      'relationship_context': relationshipContext,
    };
  }
}

/// Create letter DTO
class CreateLetterDto {
  final String requestId;
  final String content;
  final String letterType;
  final bool isVisibleToStudent;
  final String? templateId;

  CreateLetterDto({
    required this.requestId,
    required this.content,
    this.letterType = 'formal',
    this.isVisibleToStudent = false,
    this.templateId,
  });

  Map<String, dynamic> toJson() {
    return {
      'request_id': requestId,
      'content': content,
      'letter_type': letterType,
      'is_visible_to_student': isVisibleToStudent,
      'template_id': templateId,
    };
  }
}

/// Update letter DTO
class UpdateLetterDto {
  final String? content;
  final String? letterType;
  final String? status;
  final bool? isVisibleToStudent;

  UpdateLetterDto({
    this.content,
    this.letterType,
    this.status,
    this.isVisibleToStudent,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (content != null) json['content'] = content;
    if (letterType != null) json['letter_type'] = letterType;
    if (status != null) json['status'] = status;
    if (isVisibleToStudent != null) json['is_visible_to_student'] = isVisibleToStudent;
    return json;
  }
}
