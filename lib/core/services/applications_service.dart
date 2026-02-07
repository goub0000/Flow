/// Applications Service
/// Handles university/program application-related API calls
library;

import 'dart:typed_data';
import '../api/api_client.dart';
import '../api/api_config.dart';
import '../api/api_response.dart';

enum ApplicationStatus {
  draft,
  submitted,
  underReview,
  pendingDocuments,
  interviewScheduled,
  accepted,
  rejected,
  waitlisted,
  withdrawn,
}

extension ApplicationStatusExtension on ApplicationStatus {
  String get value {
    switch (this) {
      case ApplicationStatus.draft:
        return 'draft';
      case ApplicationStatus.submitted:
        return 'submitted';
      case ApplicationStatus.underReview:
        return 'under_review';
      case ApplicationStatus.pendingDocuments:
        return 'pending_documents';
      case ApplicationStatus.interviewScheduled:
        return 'interview_scheduled';
      case ApplicationStatus.accepted:
        return 'accepted';
      case ApplicationStatus.rejected:
        return 'rejected';
      case ApplicationStatus.waitlisted:
        return 'waitlisted';
      case ApplicationStatus.withdrawn:
        return 'withdrawn';
    }
  }

  String get displayName {
    switch (this) {
      case ApplicationStatus.draft:
        return 'Draft';
      case ApplicationStatus.submitted:
        return 'Submitted';
      case ApplicationStatus.underReview:
        return 'Under Review';
      case ApplicationStatus.pendingDocuments:
        return 'Pending Documents';
      case ApplicationStatus.interviewScheduled:
        return 'Interview Scheduled';
      case ApplicationStatus.accepted:
        return 'Accepted';
      case ApplicationStatus.rejected:
        return 'Rejected';
      case ApplicationStatus.waitlisted:
        return 'Waitlisted';
      case ApplicationStatus.withdrawn:
        return 'Withdrawn';
    }
  }

  static ApplicationStatus fromString(String value) {
    return ApplicationStatus.values.firstWhere(
      (status) => status.value == value.toLowerCase(),
      orElse: () => ApplicationStatus.draft,
    );
  }

  bool get isFinal =>
      this == ApplicationStatus.accepted ||
      this == ApplicationStatus.rejected ||
      this == ApplicationStatus.withdrawn;

  bool get isPending =>
      this == ApplicationStatus.submitted ||
      this == ApplicationStatus.underReview ||
      this == ApplicationStatus.pendingDocuments ||
      this == ApplicationStatus.interviewScheduled ||
      this == ApplicationStatus.waitlisted;
}

class Application {
  final String id;
  final String studentId;
  final String programId;
  final String programName;
  final String universityName;
  final ApplicationStatus status;
  final DateTime createdAt;
  final DateTime? submittedAt;
  final DateTime? decidedAt;
  final String? reviewerNotes;
  final Map<String, dynamic>? applicationData;
  final List<Map<String, dynamic>> documents;

  Application({
    required this.id,
    required this.studentId,
    required this.programId,
    required this.programName,
    required this.universityName,
    required this.status,
    required this.createdAt,
    this.submittedAt,
    this.decidedAt,
    this.reviewerNotes,
    this.applicationData,
    this.documents = const [],
  });

  factory Application.fromJson(Map<String, dynamic> json) {
    return Application(
      id: json['id'],
      studentId: json['student_id'],
      programId: json['program_id'],
      programName: json['program_name'] ?? '',
      universityName: json['university_name'] ?? '',
      status: ApplicationStatusExtension.fromString(json['status']),
      createdAt: DateTime.parse(json['created_at']),
      submittedAt: json['submitted_at'] != null
          ? DateTime.parse(json['submitted_at'])
          : null,
      decidedAt: json['decided_at'] != null
          ? DateTime.parse(json['decided_at'])
          : null,
      reviewerNotes: json['reviewer_notes'],
      applicationData: json['application_data'],
      documents: json['documents'] != null
          ? List<Map<String, dynamic>>.from(json['documents'])
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'program_id': programId,
      'program_name': programName,
      'university_name': universityName,
      'status': status.value,
      'created_at': createdAt.toIso8601String(),
      'submitted_at': submittedAt?.toIso8601String(),
      'decided_at': decidedAt?.toIso8601String(),
      'reviewer_notes': reviewerNotes,
      'application_data': applicationData,
      'documents': documents,
    };
  }
}

class ApplicationsService {
  final ApiClient _apiClient;

  ApplicationsService(this._apiClient);

  /// Get applications with filters
  Future<ApiResponse<PaginatedResponse<Application>>> getApplications({
    String? studentId,
    String? programId,
    String? universityId,
    ApplicationStatus? status,
    int page = 1,
    int pageSize = 20,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'page_size': pageSize,
      if (studentId != null) 'student_id': studentId,
      if (programId != null) 'program_id': programId,
      if (universityId != null) 'university_id': universityId,
      if (status != null) 'status': status.value,
    };

    return await _apiClient.get(
      ApiConfig.applications,
      queryParameters: queryParams,
      fromJson: (data) => PaginatedResponse.fromJson(
        data,
        (json) => Application.fromJson(json),
      ),
    );
  }

  /// Get application by ID
  Future<ApiResponse<Application>> getApplicationById(String applicationId) async {
    return await _apiClient.get(
      '${ApiConfig.applications}/$applicationId',
      fromJson: (data) => Application.fromJson(data),
    );
  }

  /// Create new application (Student)
  Future<ApiResponse<Application>> createApplication({
    required String programId,
    Map<String, dynamic>? applicationData,
  }) async {
    return await _apiClient.post(
      ApiConfig.applications,
      data: {
        'program_id': programId,
        if (applicationData != null) 'application_data': applicationData,
      },
      fromJson: (data) => Application.fromJson(data),
    );
  }

  /// Update application (Student - only if draft)
  Future<ApiResponse<Application>> updateApplication({
    required String applicationId,
    Map<String, dynamic>? applicationData,
  }) async {
    return await _apiClient.patch(
      '${ApiConfig.applications}/$applicationId',
      data: {
        if (applicationData != null) 'application_data': applicationData,
      },
      fromJson: (data) => Application.fromJson(data),
    );
  }

  /// Submit application (Student)
  Future<ApiResponse<Application>> submitApplication(String applicationId) async {
    return await _apiClient.post(
      '${ApiConfig.applications}/$applicationId/submit',
      fromJson: (data) => Application.fromJson(data),
    );
  }

  /// Withdraw application (Student)
  Future<ApiResponse<Application>> withdrawApplication({
    required String applicationId,
    String? reason,
  }) async {
    return await _apiClient.post(
      '${ApiConfig.applications}/$applicationId/withdraw',
      data: {
        if (reason != null) 'reason': reason,
      },
      fromJson: (data) => Application.fromJson(data),
    );
  }

  /// Update application status (Institution)
  Future<ApiResponse<Application>> updateApplicationStatus({
    required String applicationId,
    required ApplicationStatus status,
    String? reviewerNotes,
  }) async {
    return await _apiClient.post(
      '${ApiConfig.applications}/$applicationId/status',
      data: {
        'status': status.value,
        if (reviewerNotes != null) 'reviewer_notes': reviewerNotes,
      },
      fromJson: (data) => Application.fromJson(data),
    );
  }

  /// Upload application document
  /// [fileBytes] - The document content as Uint8List
  /// [fileName] - The name of the file including extension
  /// [mimeType] - Optional MIME type (e.g., 'application/pdf')
  Future<ApiResponse<Map<String, dynamic>>> uploadDocument({
    required String applicationId,
    required Uint8List fileBytes,
    required String fileName,
    required String documentType,
    String? mimeType,
    String? description,
    void Function(int, int)? onProgress,
  }) async {
    return await _apiClient.uploadFile(
      '${ApiConfig.applications}/$applicationId/documents',
      fileBytes,
      fileName: fileName,
      fieldName: 'file',
      mimeType: mimeType,
      data: {
        'document_type': documentType,
        if (description != null) 'description': description,
      },
      fromJson: (data) => data as Map<String, dynamic>,
      onSendProgress: onProgress,
    );
  }

  /// Delete application document
  Future<ApiResponse<void>> deleteDocument({
    required String applicationId,
    required String documentId,
  }) async {
    return await _apiClient.delete(
      '${ApiConfig.applications}/$applicationId/documents/$documentId',
    );
  }

  /// Get my applications (Current user)
  Future<ApiResponse<PaginatedResponse<Application>>> getMyApplications({
    ApplicationStatus? status,
    int page = 1,
    int pageSize = 20,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'page_size': pageSize,
      if (status != null) 'status': status.value,
    };

    return await _apiClient.get(
      '${ApiConfig.applications}/me',
      queryParameters: queryParams,
      fromJson: (data) => PaginatedResponse.fromJson(
        data,
        (json) => Application.fromJson(json),
      ),
    );
  }

  /// Get application statistics
  Future<ApiResponse<Map<String, dynamic>>> getApplicationStats({
    String? studentId,
    String? programId,
    String? universityId,
  }) async {
    final queryParams = <String, dynamic>{
      if (studentId != null) 'student_id': studentId,
      if (programId != null) 'program_id': programId,
      if (universityId != null) 'university_id': universityId,
    };

    return await _apiClient.get(
      '${ApiConfig.applications}/stats',
      queryParameters: queryParams,
      fromJson: (data) => data as Map<String, dynamic>,
    );
  }

  /// Get application timeline/history
  Future<ApiResponse<List<Map<String, dynamic>>>> getApplicationTimeline(
      String applicationId) async {
    return await _apiClient.get(
      '${ApiConfig.applications}/$applicationId/timeline',
      fromJson: (data) {
        final List<dynamic> list = data;
        return list.cast<Map<String, dynamic>>();
      },
    );
  }
}
