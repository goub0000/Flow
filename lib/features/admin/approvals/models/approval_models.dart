// ignore_for_file: invalid_annotation_target
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'approval_models.freezed.dart';
part 'approval_models.g.dart';

/// Approval request status enum
enum ApprovalStatus {
  @JsonValue('draft')
  draft,
  @JsonValue('pending_review')
  pendingReview,
  @JsonValue('under_review')
  underReview,
  @JsonValue('awaiting_info')
  awaitingInfo,
  @JsonValue('escalated')
  escalated,
  @JsonValue('approved')
  approved,
  @JsonValue('denied')
  denied,
  @JsonValue('withdrawn')
  withdrawn,
  @JsonValue('expired')
  expired,
  @JsonValue('executed')
  executed,
  @JsonValue('failed')
  failed,
}

/// Approval priority levels
enum ApprovalPriority {
  @JsonValue('low')
  low,
  @JsonValue('normal')
  normal,
  @JsonValue('high')
  high,
  @JsonValue('urgent')
  urgent,
}

/// Types of approval requests
enum ApprovalRequestType {
  @JsonValue('user_management')
  userManagement,
  @JsonValue('content_management')
  contentManagement,
  @JsonValue('financial')
  financial,
  @JsonValue('system')
  system,
  @JsonValue('notifications')
  notifications,
  @JsonValue('data_export')
  dataExport,
  @JsonValue('admin_management')
  adminManagement,
}

/// Specific actions that require approval
enum ApprovalActionType {
  // User Management
  @JsonValue('delete_user_account')
  deleteUserAccount,
  @JsonValue('suspend_user_account')
  suspendUserAccount,
  @JsonValue('unsuspend_user_account')
  unsuspendUserAccount,

  // Admin Management
  @JsonValue('grant_admin_role')
  grantAdminRole,
  @JsonValue('revoke_admin_role')
  revokeAdminRole,
  @JsonValue('modify_admin_role')
  modifyAdminRole,

  // Content Management
  @JsonValue('publish_content')
  publishContent,
  @JsonValue('unpublish_content')
  unpublishContent,
  @JsonValue('delete_content')
  deleteContent,
  @JsonValue('delete_program')
  deleteProgram,
  @JsonValue('delete_institution_content')
  deleteInstitutionContent,

  // Notifications
  @JsonValue('send_bulk_notification')
  sendBulkNotification,
  @JsonValue('send_platform_announcement')
  sendPlatformAnnouncement,

  // Financial
  @JsonValue('process_large_refund')
  processLargeRefund,
  @JsonValue('modify_fee_structure')
  modifyFeeStructure,
  @JsonValue('adjust_commission')
  adjustCommission,

  // Data Export
  @JsonValue('export_sensitive_data')
  exportSensitiveData,
  @JsonValue('export_user_data')
  exportUserData,
  @JsonValue('export_financial_data')
  exportFinancialData,

  // System
  @JsonValue('modify_system_settings')
  modifySystemSettings,
  @JsonValue('delete_institution')
  deleteInstitution,
}

/// Types of review actions
enum ReviewActionType {
  @JsonValue('approve')
  approve,
  @JsonValue('deny')
  deny,
  @JsonValue('request_info')
  requestInfo,
  @JsonValue('delegate')
  delegate,
  @JsonValue('escalate')
  escalate,
  @JsonValue('respond_info')
  respondInfo,
  @JsonValue('withdraw')
  withdraw,
  @JsonValue('comment')
  comment,
}

/// Extension for ApprovalStatus
extension ApprovalStatusExtension on ApprovalStatus {
  String get displayName {
    switch (this) {
      case ApprovalStatus.draft:
        return 'Draft';
      case ApprovalStatus.pendingReview:
        return 'Pending Review';
      case ApprovalStatus.underReview:
        return 'Under Review';
      case ApprovalStatus.awaitingInfo:
        return 'Awaiting Info';
      case ApprovalStatus.escalated:
        return 'Escalated';
      case ApprovalStatus.approved:
        return 'Approved';
      case ApprovalStatus.denied:
        return 'Denied';
      case ApprovalStatus.withdrawn:
        return 'Withdrawn';
      case ApprovalStatus.expired:
        return 'Expired';
      case ApprovalStatus.executed:
        return 'Executed';
      case ApprovalStatus.failed:
        return 'Failed';
    }
  }

  String get colorName {
    switch (this) {
      case ApprovalStatus.draft:
        return 'grey';
      case ApprovalStatus.pendingReview:
        return 'orange';
      case ApprovalStatus.underReview:
        return 'blue';
      case ApprovalStatus.awaitingInfo:
        return 'amber';
      case ApprovalStatus.escalated:
        return 'purple';
      case ApprovalStatus.approved:
        return 'green';
      case ApprovalStatus.denied:
        return 'red';
      case ApprovalStatus.withdrawn:
        return 'grey';
      case ApprovalStatus.expired:
        return 'grey';
      case ApprovalStatus.executed:
        return 'teal';
      case ApprovalStatus.failed:
        return 'red';
    }
  }

  bool get isActive {
    return this == ApprovalStatus.pendingReview ||
        this == ApprovalStatus.underReview ||
        this == ApprovalStatus.awaitingInfo ||
        this == ApprovalStatus.escalated;
  }

  bool get isFinal {
    return this == ApprovalStatus.approved ||
        this == ApprovalStatus.denied ||
        this == ApprovalStatus.withdrawn ||
        this == ApprovalStatus.expired ||
        this == ApprovalStatus.executed ||
        this == ApprovalStatus.failed;
  }
}

/// Extension for ApprovalPriority
extension ApprovalPriorityExtension on ApprovalPriority {
  String get displayName {
    switch (this) {
      case ApprovalPriority.low:
        return 'Low';
      case ApprovalPriority.normal:
        return 'Normal';
      case ApprovalPriority.high:
        return 'High';
      case ApprovalPriority.urgent:
        return 'Urgent';
    }
  }

  String get colorName {
    switch (this) {
      case ApprovalPriority.low:
        return 'grey';
      case ApprovalPriority.normal:
        return 'blue';
      case ApprovalPriority.high:
        return 'orange';
      case ApprovalPriority.urgent:
        return 'red';
    }
  }

  Color get color {
    switch (this) {
      case ApprovalPriority.low:
        return Colors.grey;
      case ApprovalPriority.normal:
        return Colors.blue;
      case ApprovalPriority.high:
        return Colors.orange;
      case ApprovalPriority.urgent:
        return Colors.red;
    }
  }
}

/// Extension for ApprovalRequestType
extension ApprovalRequestTypeExtension on ApprovalRequestType {
  String get displayName {
    switch (this) {
      case ApprovalRequestType.userManagement:
        return 'User Management';
      case ApprovalRequestType.contentManagement:
        return 'Content Management';
      case ApprovalRequestType.financial:
        return 'Financial';
      case ApprovalRequestType.system:
        return 'System';
      case ApprovalRequestType.notifications:
        return 'Notifications';
      case ApprovalRequestType.dataExport:
        return 'Data Export';
      case ApprovalRequestType.adminManagement:
        return 'Admin Management';
    }
  }
}

/// Extension for ApprovalActionType
extension ApprovalActionTypeExtension on ApprovalActionType {
  String get displayName {
    switch (this) {
      case ApprovalActionType.deleteUserAccount:
        return 'Delete User Account';
      case ApprovalActionType.suspendUserAccount:
        return 'Suspend User Account';
      case ApprovalActionType.unsuspendUserAccount:
        return 'Unsuspend User Account';
      case ApprovalActionType.grantAdminRole:
        return 'Grant Admin Role';
      case ApprovalActionType.revokeAdminRole:
        return 'Revoke Admin Role';
      case ApprovalActionType.modifyAdminRole:
        return 'Modify Admin Role';
      case ApprovalActionType.publishContent:
        return 'Publish Content';
      case ApprovalActionType.unpublishContent:
        return 'Unpublish Content';
      case ApprovalActionType.deleteContent:
        return 'Delete Content';
      case ApprovalActionType.deleteProgram:
        return 'Delete Program';
      case ApprovalActionType.deleteInstitutionContent:
        return 'Delete Institution Content';
      case ApprovalActionType.sendBulkNotification:
        return 'Send Bulk Notification';
      case ApprovalActionType.sendPlatformAnnouncement:
        return 'Send Platform Announcement';
      case ApprovalActionType.processLargeRefund:
        return 'Process Large Refund';
      case ApprovalActionType.modifyFeeStructure:
        return 'Modify Fee Structure';
      case ApprovalActionType.adjustCommission:
        return 'Adjust Commission';
      case ApprovalActionType.exportSensitiveData:
        return 'Export Sensitive Data';
      case ApprovalActionType.exportUserData:
        return 'Export User Data';
      case ApprovalActionType.exportFinancialData:
        return 'Export Financial Data';
      case ApprovalActionType.modifySystemSettings:
        return 'Modify System Settings';
      case ApprovalActionType.deleteInstitution:
        return 'Delete Institution';
    }
  }
}

/// Approval action model
@freezed
class ApprovalAction with _$ApprovalAction {
  const factory ApprovalAction({
    required String id,
    @JsonKey(name: 'request_id') required String requestId,
    @JsonKey(name: 'reviewer_id') required String reviewerId,
    @JsonKey(name: 'reviewer_role') required String reviewerRole,
    @JsonKey(name: 'reviewer_level') required int reviewerLevel,
    @JsonKey(name: 'action_type') required String actionType,
    String? notes,
    @JsonKey(name: 'delegated_to') String? delegatedTo,
    @JsonKey(name: 'delegated_reason') String? delegatedReason,
    @JsonKey(name: 'escalated_to_level') int? escalatedToLevel,
    @JsonKey(name: 'escalation_reason') String? escalationReason,
    @JsonKey(name: 'info_requested') String? infoRequested,
    @JsonKey(name: 'mfa_verified') @Default(false) bool mfaVerified,
    @JsonKey(name: 'acted_at') required DateTime actedAt,
    @JsonKey(name: 'reviewer_name') String? reviewerName,
    @JsonKey(name: 'reviewer_email') String? reviewerEmail,
  }) = _ApprovalAction;

  factory ApprovalAction.fromJson(Map<String, dynamic> json) =>
      _$ApprovalActionFromJson(json);
}

/// Approval comment model
@freezed
class ApprovalComment with _$ApprovalComment {
  const factory ApprovalComment({
    required String id,
    @JsonKey(name: 'request_id') required String requestId,
    @JsonKey(name: 'author_id') required String authorId,
    @JsonKey(name: 'author_role') required String authorRole,
    required String content,
    @JsonKey(name: 'is_internal') @Default(false) bool isInternal,
    @Default([]) List<Map<String, String>> attachments,
    @JsonKey(name: 'parent_comment_id') String? parentCommentId,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'deleted_at') DateTime? deletedAt,
    @JsonKey(name: 'author_name') String? authorName,
    @JsonKey(name: 'author_email') String? authorEmail,
    @Default([]) List<ApprovalComment> replies,
  }) = _ApprovalComment;

  factory ApprovalComment.fromJson(Map<String, dynamic> json) =>
      _$ApprovalCommentFromJson(json);
}

/// Approval request model
@freezed
class ApprovalRequest with _$ApprovalRequest {
  const factory ApprovalRequest({
    required String id,
    @JsonKey(name: 'request_number') required String requestNumber,
    @JsonKey(name: 'request_type') required String requestType,
    @JsonKey(name: 'initiated_by') required String initiatedBy,
    @JsonKey(name: 'initiated_by_role') required String initiatedByRole,
    @JsonKey(name: 'initiated_at') required DateTime initiatedAt,
    @JsonKey(name: 'target_resource_type') required String targetResourceType,
    @JsonKey(name: 'target_resource_id') String? targetResourceId,
    @JsonKey(name: 'target_resource_snapshot') Map<String, dynamic>? targetResourceSnapshot,
    @JsonKey(name: 'action_type') required String actionType,
    @JsonKey(name: 'action_payload') @Default({}) Map<String, dynamic> actionPayload,
    required String justification,
    required String priority,
    @JsonKey(name: 'expires_at') DateTime? expiresAt,
    required String status,
    @JsonKey(name: 'current_approval_level') required int currentApprovalLevel,
    @JsonKey(name: 'required_approval_level') required int requiredApprovalLevel,
    @JsonKey(name: 'approval_chain') @Default([]) List<Map<String, dynamic>> approvalChain,
    @JsonKey(name: 'regional_scope') String? regionalScope,
    @Default([]) List<Map<String, String>> attachments,
    Map<String, dynamic>? metadata,
    @JsonKey(name: 'executed_at') DateTime? executedAt,
    @JsonKey(name: 'execution_result') Map<String, dynamic>? executionResult,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    @JsonKey(name: 'initiator_name') String? initiatorName,
    @JsonKey(name: 'initiator_email') String? initiatorEmail,
    @Default([]) List<ApprovalAction> actions,
    @Default([]) List<ApprovalComment> comments,
  }) = _ApprovalRequest;

  factory ApprovalRequest.fromJson(Map<String, dynamic> json) =>
      _$ApprovalRequestFromJson(json);
}

/// Approval request list response
@freezed
class ApprovalRequestListResponse with _$ApprovalRequestListResponse {
  const factory ApprovalRequestListResponse({
    required List<ApprovalRequest> requests,
    required int total,
    required int page,
    @JsonKey(name: 'page_size') required int pageSize,
    @JsonKey(name: 'has_more') required bool hasMore,
  }) = _ApprovalRequestListResponse;

  factory ApprovalRequestListResponse.fromJson(Map<String, dynamic> json) =>
      _$ApprovalRequestListResponseFromJson(json);
}

/// Approval configuration model
@freezed
class ApprovalConfig with _$ApprovalConfig {
  const factory ApprovalConfig({
    required String id,
    @JsonKey(name: 'request_type') required String requestType,
    @JsonKey(name: 'action_type') required String actionType,
    @JsonKey(name: 'target_resource_type') String? targetResourceType,
    @JsonKey(name: 'required_approval_level') required int requiredApprovalLevel,
    @JsonKey(name: 'can_skip_levels') @Default(false) bool canSkipLevels,
    @JsonKey(name: 'skip_level_conditions') @Default({}) Map<String, dynamic> skipLevelConditions,
    @JsonKey(name: 'allowed_initiator_roles') @Default([]) List<String> allowedInitiatorRoles,
    @JsonKey(name: 'allowed_approver_roles') @Default([]) List<String> allowedApproverRoles,
    @JsonKey(name: 'default_priority') @Default('normal') String defaultPriority,
    @JsonKey(name: 'default_expiration_hours') int? defaultExpirationHours,
    @JsonKey(name: 'requires_mfa') @Default(false) bool requiresMfa,
    @JsonKey(name: 'auto_execute') @Default(true) bool autoExecute,
    @JsonKey(name: 'notification_channels') @Default(['in_app', 'email']) List<String> notificationChannels,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    String? description,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _ApprovalConfig;

  factory ApprovalConfig.fromJson(Map<String, dynamic> json) =>
      _$ApprovalConfigFromJson(json);
}

/// Approval statistics model
@freezed
class ApprovalStatistics with _$ApprovalStatistics {
  const factory ApprovalStatistics({
    @JsonKey(name: 'total_requests') @Default(0) int totalRequests,
    @JsonKey(name: 'pending_requests') @Default(0) int pendingRequests,
    @JsonKey(name: 'under_review_requests') @Default(0) int underReviewRequests,
    @JsonKey(name: 'awaiting_info_requests') @Default(0) int awaitingInfoRequests,
    @JsonKey(name: 'approved_requests') @Default(0) int approvedRequests,
    @JsonKey(name: 'denied_requests') @Default(0) int deniedRequests,
    @JsonKey(name: 'withdrawn_requests') @Default(0) int withdrawnRequests,
    @JsonKey(name: 'expired_requests') @Default(0) int expiredRequests,
    @JsonKey(name: 'executed_requests') @Default(0) int executedRequests,
    @JsonKey(name: 'failed_requests') @Default(0) int failedRequests,
    @JsonKey(name: 'requests_today') @Default(0) int requestsToday,
    @JsonKey(name: 'requests_this_week') @Default(0) int requestsThisWeek,
    @JsonKey(name: 'requests_this_month') @Default(0) int requestsThisMonth,
    @JsonKey(name: 'avg_approval_time_hours') double? avgApprovalTimeHours,
    @JsonKey(name: 'approval_rate') double? approvalRate,
    @JsonKey(name: 'by_request_type') @Default({}) Map<String, int> byRequestType,
    @JsonKey(name: 'by_action_type') @Default({}) Map<String, int> byActionType,
    @JsonKey(name: 'by_priority') @Default({}) Map<String, int> byPriority,
  }) = _ApprovalStatistics;

  factory ApprovalStatistics.fromJson(Map<String, dynamic> json) =>
      _$ApprovalStatisticsFromJson(json);
}

/// Pending approval item for dashboard
@freezed
class PendingApprovalItem with _$PendingApprovalItem {
  const factory PendingApprovalItem({
    required String id,
    @JsonKey(name: 'request_number') required String requestNumber,
    @JsonKey(name: 'request_type') required String requestType,
    @JsonKey(name: 'action_type') required String actionType,
    required String priority,
    required String status,
    @JsonKey(name: 'initiated_by') required String initiatedBy,
    @JsonKey(name: 'initiator_name') String? initiatorName,
    @JsonKey(name: 'target_resource_type') required String targetResourceType,
    @JsonKey(name: 'current_approval_level') required int currentApprovalLevel,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'expires_at') DateTime? expiresAt,
  }) = _PendingApprovalItem;

  factory PendingApprovalItem.fromJson(Map<String, dynamic> json) =>
      _$PendingApprovalItemFromJson(json);
}

/// My pending actions response
@freezed
class MyPendingActionsResponse with _$MyPendingActionsResponse {
  const factory MyPendingActionsResponse({
    @JsonKey(name: 'pending_reviews') @Default([]) List<PendingApprovalItem> pendingReviews,
    @JsonKey(name: 'awaiting_my_info') @Default([]) List<PendingApprovalItem> awaitingMyInfo,
    @JsonKey(name: 'delegated_to_me') @Default([]) List<PendingApprovalItem> delegatedToMe,
    @Default(0) int total,
  }) = _MyPendingActionsResponse;

  factory MyPendingActionsResponse.fromJson(Map<String, dynamic> json) =>
      _$MyPendingActionsResponseFromJson(json);
}

/// Audit log entry
@freezed
class ApprovalAuditLogEntry with _$ApprovalAuditLogEntry {
  const factory ApprovalAuditLogEntry({
    required String id,
    @JsonKey(name: 'request_id') required String requestId,
    @JsonKey(name: 'actor_id') required String actorId,
    @JsonKey(name: 'actor_role') required String actorRole,
    @JsonKey(name: 'event_type') required String eventType,
    @JsonKey(name: 'event_description') String? eventDescription,
    @JsonKey(name: 'previous_state') Map<String, dynamic>? previousState,
    @JsonKey(name: 'new_state') Map<String, dynamic>? newState,
    @JsonKey(name: 'ip_address') String? ipAddress,
    @JsonKey(name: 'user_agent') String? userAgent,
    @JsonKey(name: 'session_id') String? sessionId,
    required DateTime timestamp,
    @JsonKey(name: 'actor_name') String? actorName,
    @JsonKey(name: 'actor_email') String? actorEmail,
  }) = _ApprovalAuditLogEntry;

  factory ApprovalAuditLogEntry.fromJson(Map<String, dynamic> json) =>
      _$ApprovalAuditLogEntryFromJson(json);
}

/// Audit log response
@freezed
class ApprovalAuditLogResponse with _$ApprovalAuditLogResponse {
  const factory ApprovalAuditLogResponse({
    required List<ApprovalAuditLogEntry> entries,
    required int total,
    required int page,
    @JsonKey(name: 'page_size') required int pageSize,
    @JsonKey(name: 'has_more') required bool hasMore,
  }) = _ApprovalAuditLogResponse;

  factory ApprovalAuditLogResponse.fromJson(Map<String, dynamic> json) =>
      _$ApprovalAuditLogResponseFromJson(json);
}

/// Create approval request model
@freezed
class CreateApprovalRequest with _$CreateApprovalRequest {
  const factory CreateApprovalRequest({
    required ApprovalRequestType requestType,
    required ApprovalActionType actionType,
    required String targetResourceType,
    String? targetResourceId,
    Map<String, dynamic>? targetResourceSnapshot,
    @Default({}) Map<String, dynamic> actionPayload,
    required String justification,
    @Default(ApprovalPriority.normal) ApprovalPriority priority,
    String? regionalScope,
    @Default([]) List<Map<String, String>> attachments,
    Map<String, dynamic>? metadata,
  }) = _CreateApprovalRequest;

  factory CreateApprovalRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateApprovalRequestFromJson(json);
}

/// Update approval request model
@freezed
class UpdateApprovalRequest with _$UpdateApprovalRequest {
  const factory UpdateApprovalRequest({
    String? justification,
    Map<String, dynamic>? actionPayload,
    ApprovalPriority? priority,
    List<Map<String, String>>? attachments,
    Map<String, dynamic>? metadata,
  }) = _UpdateApprovalRequest;

  factory UpdateApprovalRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateApprovalRequestFromJson(json);
}

/// Approve request model
@freezed
class ApproveRequestData with _$ApproveRequestData {
  const factory ApproveRequestData({
    String? notes,
    @Default(false) bool mfaVerified,
  }) = _ApproveRequestData;

  factory ApproveRequestData.fromJson(Map<String, dynamic> json) =>
      _$ApproveRequestDataFromJson(json);
}

/// Deny request model
@freezed
class DenyRequestData with _$DenyRequestData {
  const factory DenyRequestData({
    required String reason,
    String? notes,
    @Default(false) bool mfaVerified,
  }) = _DenyRequestData;

  factory DenyRequestData.fromJson(Map<String, dynamic> json) =>
      _$DenyRequestDataFromJson(json);
}

/// Request info model
@freezed
class RequestInfoData with _$RequestInfoData {
  const factory RequestInfoData({
    required String infoRequested,
  }) = _RequestInfoData;

  factory RequestInfoData.fromJson(Map<String, dynamic> json) =>
      _$RequestInfoDataFromJson(json);
}

/// Respond to info request model
@freezed
class RespondInfoData with _$RespondInfoData {
  const factory RespondInfoData({
    required String response,
    @Default([]) List<Map<String, String>> attachments,
  }) = _RespondInfoData;

  factory RespondInfoData.fromJson(Map<String, dynamic> json) =>
      _$RespondInfoDataFromJson(json);
}

/// Delegate request model
@freezed
class DelegateRequestData with _$DelegateRequestData {
  const factory DelegateRequestData({
    required String delegateTo,
    required String reason,
  }) = _DelegateRequestData;

  factory DelegateRequestData.fromJson(Map<String, dynamic> json) =>
      _$DelegateRequestDataFromJson(json);
}

/// Escalate request model
@freezed
class EscalateRequestData with _$EscalateRequestData {
  const factory EscalateRequestData({
    required String reason,
  }) = _EscalateRequestData;

  factory EscalateRequestData.fromJson(Map<String, dynamic> json) =>
      _$EscalateRequestDataFromJson(json);
}

/// Create comment model
@freezed
class CreateCommentData with _$CreateCommentData {
  const factory CreateCommentData({
    required String content,
    @Default(false) bool isInternal,
    @Default([]) List<Map<String, String>> attachments,
    String? parentCommentId,
  }) = _CreateCommentData;

  factory CreateCommentData.fromJson(Map<String, dynamic> json) =>
      _$CreateCommentDataFromJson(json);
}

/// Simple approval request create model (using strings for flexibility)
@freezed
class ApprovalRequestCreate with _$ApprovalRequestCreate {
  const factory ApprovalRequestCreate({
    required String requestType,
    required String actionType,
    required String targetResourceType,
    String? targetResourceId,
    Map<String, dynamic>? targetResourceSnapshot,
    @Default({}) Map<String, dynamic> actionPayload,
    required String justification,
    @Default('normal') String priority,
    String? regionalScope,
    @Default([]) List<Map<String, String>> attachments,
    Map<String, dynamic>? metadata,
  }) = _ApprovalRequestCreate;

  factory ApprovalRequestCreate.fromJson(Map<String, dynamic> json) =>
      _$ApprovalRequestCreateFromJson(json);
}

/// Approval request filter
@freezed
class ApprovalRequestFilter with _$ApprovalRequestFilter {
  const factory ApprovalRequestFilter({
    List<ApprovalStatus>? status,
    List<ApprovalRequestType>? requestType,
    List<ApprovalActionType>? actionType,
    List<ApprovalPriority>? priority,
    String? initiatedBy,
    String? regionalScope,
    int? currentApprovalLevel,
    DateTime? fromDate,
    DateTime? toDate,
    String? search,
  }) = _ApprovalRequestFilter;

  factory ApprovalRequestFilter.fromJson(Map<String, dynamic> json) =>
      _$ApprovalRequestFilterFromJson(json);
}
