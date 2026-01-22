// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'approval_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApprovalActionImpl _$$ApprovalActionImplFromJson(Map<String, dynamic> json) =>
    _$ApprovalActionImpl(
      id: json['id'] as String,
      requestId: json['request_id'] as String,
      reviewerId: json['reviewer_id'] as String,
      reviewerRole: json['reviewer_role'] as String,
      reviewerLevel: (json['reviewer_level'] as num).toInt(),
      actionType: json['action_type'] as String,
      notes: json['notes'] as String?,
      delegatedTo: json['delegated_to'] as String?,
      delegatedReason: json['delegated_reason'] as String?,
      escalatedToLevel: (json['escalated_to_level'] as num?)?.toInt(),
      escalationReason: json['escalation_reason'] as String?,
      infoRequested: json['info_requested'] as String?,
      mfaVerified: json['mfa_verified'] as bool? ?? false,
      actedAt: DateTime.parse(json['acted_at'] as String),
      reviewerName: json['reviewer_name'] as String?,
      reviewerEmail: json['reviewer_email'] as String?,
    );

Map<String, dynamic> _$$ApprovalActionImplToJson(
        _$ApprovalActionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'request_id': instance.requestId,
      'reviewer_id': instance.reviewerId,
      'reviewer_role': instance.reviewerRole,
      'reviewer_level': instance.reviewerLevel,
      'action_type': instance.actionType,
      'notes': instance.notes,
      'delegated_to': instance.delegatedTo,
      'delegated_reason': instance.delegatedReason,
      'escalated_to_level': instance.escalatedToLevel,
      'escalation_reason': instance.escalationReason,
      'info_requested': instance.infoRequested,
      'mfa_verified': instance.mfaVerified,
      'acted_at': instance.actedAt.toIso8601String(),
      'reviewer_name': instance.reviewerName,
      'reviewer_email': instance.reviewerEmail,
    };

_$ApprovalCommentImpl _$$ApprovalCommentImplFromJson(
        Map<String, dynamic> json) =>
    _$ApprovalCommentImpl(
      id: json['id'] as String,
      requestId: json['request_id'] as String,
      authorId: json['author_id'] as String,
      authorRole: json['author_role'] as String,
      content: json['content'] as String,
      isInternal: json['is_internal'] as bool? ?? false,
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map((e) => Map<String, String>.from(e as Map))
              .toList() ??
          const [],
      parentCommentId: json['parent_comment_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
      authorName: json['author_name'] as String?,
      authorEmail: json['author_email'] as String?,
      replies: (json['replies'] as List<dynamic>?)
              ?.map((e) => ApprovalComment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ApprovalCommentImplToJson(
        _$ApprovalCommentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'request_id': instance.requestId,
      'author_id': instance.authorId,
      'author_role': instance.authorRole,
      'content': instance.content,
      'is_internal': instance.isInternal,
      'attachments': instance.attachments,
      'parent_comment_id': instance.parentCommentId,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'deleted_at': instance.deletedAt?.toIso8601String(),
      'author_name': instance.authorName,
      'author_email': instance.authorEmail,
      'replies': instance.replies,
    };

_$ApprovalRequestImpl _$$ApprovalRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$ApprovalRequestImpl(
      id: json['id'] as String,
      requestNumber: json['request_number'] as String,
      requestType: json['request_type'] as String,
      initiatedBy: json['initiated_by'] as String,
      initiatedByRole: json['initiated_by_role'] as String,
      initiatedAt: DateTime.parse(json['initiated_at'] as String),
      targetResourceType: json['target_resource_type'] as String,
      targetResourceId: json['target_resource_id'] as String?,
      targetResourceSnapshot:
          json['target_resource_snapshot'] as Map<String, dynamic>?,
      actionType: json['action_type'] as String,
      actionPayload:
          json['action_payload'] as Map<String, dynamic>? ?? const {},
      justification: json['justification'] as String,
      priority: json['priority'] as String,
      expiresAt: json['expires_at'] == null
          ? null
          : DateTime.parse(json['expires_at'] as String),
      status: json['status'] as String,
      currentApprovalLevel: (json['current_approval_level'] as num).toInt(),
      requiredApprovalLevel: (json['required_approval_level'] as num).toInt(),
      approvalChain: (json['approval_chain'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
      regionalScope: json['regional_scope'] as String?,
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map((e) => Map<String, String>.from(e as Map))
              .toList() ??
          const [],
      metadata: json['metadata'] as Map<String, dynamic>?,
      executedAt: json['executed_at'] == null
          ? null
          : DateTime.parse(json['executed_at'] as String),
      executionResult: json['execution_result'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      initiatorName: json['initiator_name'] as String?,
      initiatorEmail: json['initiator_email'] as String?,
      actions: (json['actions'] as List<dynamic>?)
              ?.map((e) => ApprovalAction.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      comments: (json['comments'] as List<dynamic>?)
              ?.map((e) => ApprovalComment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ApprovalRequestImplToJson(
        _$ApprovalRequestImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'request_number': instance.requestNumber,
      'request_type': instance.requestType,
      'initiated_by': instance.initiatedBy,
      'initiated_by_role': instance.initiatedByRole,
      'initiated_at': instance.initiatedAt.toIso8601String(),
      'target_resource_type': instance.targetResourceType,
      'target_resource_id': instance.targetResourceId,
      'target_resource_snapshot': instance.targetResourceSnapshot,
      'action_type': instance.actionType,
      'action_payload': instance.actionPayload,
      'justification': instance.justification,
      'priority': instance.priority,
      'expires_at': instance.expiresAt?.toIso8601String(),
      'status': instance.status,
      'current_approval_level': instance.currentApprovalLevel,
      'required_approval_level': instance.requiredApprovalLevel,
      'approval_chain': instance.approvalChain,
      'regional_scope': instance.regionalScope,
      'attachments': instance.attachments,
      'metadata': instance.metadata,
      'executed_at': instance.executedAt?.toIso8601String(),
      'execution_result': instance.executionResult,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'initiator_name': instance.initiatorName,
      'initiator_email': instance.initiatorEmail,
      'actions': instance.actions,
      'comments': instance.comments,
    };

_$ApprovalRequestListResponseImpl _$$ApprovalRequestListResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$ApprovalRequestListResponseImpl(
      requests: (json['requests'] as List<dynamic>)
          .map((e) => ApprovalRequest.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      pageSize: (json['page_size'] as num).toInt(),
      hasMore: json['has_more'] as bool,
    );

Map<String, dynamic> _$$ApprovalRequestListResponseImplToJson(
        _$ApprovalRequestListResponseImpl instance) =>
    <String, dynamic>{
      'requests': instance.requests,
      'total': instance.total,
      'page': instance.page,
      'page_size': instance.pageSize,
      'has_more': instance.hasMore,
    };

_$ApprovalConfigImpl _$$ApprovalConfigImplFromJson(Map<String, dynamic> json) =>
    _$ApprovalConfigImpl(
      id: json['id'] as String,
      requestType: json['request_type'] as String,
      actionType: json['action_type'] as String,
      targetResourceType: json['target_resource_type'] as String?,
      requiredApprovalLevel: (json['required_approval_level'] as num).toInt(),
      canSkipLevels: json['can_skip_levels'] as bool? ?? false,
      skipLevelConditions:
          json['skip_level_conditions'] as Map<String, dynamic>? ?? const {},
      allowedInitiatorRoles: (json['allowed_initiator_roles'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      allowedApproverRoles: (json['allowed_approver_roles'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      defaultPriority: json['default_priority'] as String? ?? 'normal',
      defaultExpirationHours:
          (json['default_expiration_hours'] as num?)?.toInt(),
      requiresMfa: json['requires_mfa'] as bool? ?? false,
      autoExecute: json['auto_execute'] as bool? ?? true,
      notificationChannels: (json['notification_channels'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const ['in_app', 'email'],
      isActive: json['is_active'] as bool? ?? true,
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$ApprovalConfigImplToJson(
        _$ApprovalConfigImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'request_type': instance.requestType,
      'action_type': instance.actionType,
      'target_resource_type': instance.targetResourceType,
      'required_approval_level': instance.requiredApprovalLevel,
      'can_skip_levels': instance.canSkipLevels,
      'skip_level_conditions': instance.skipLevelConditions,
      'allowed_initiator_roles': instance.allowedInitiatorRoles,
      'allowed_approver_roles': instance.allowedApproverRoles,
      'default_priority': instance.defaultPriority,
      'default_expiration_hours': instance.defaultExpirationHours,
      'requires_mfa': instance.requiresMfa,
      'auto_execute': instance.autoExecute,
      'notification_channels': instance.notificationChannels,
      'is_active': instance.isActive,
      'description': instance.description,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

_$ApprovalStatisticsImpl _$$ApprovalStatisticsImplFromJson(
        Map<String, dynamic> json) =>
    _$ApprovalStatisticsImpl(
      totalRequests: (json['total_requests'] as num?)?.toInt() ?? 0,
      pendingRequests: (json['pending_requests'] as num?)?.toInt() ?? 0,
      underReviewRequests:
          (json['under_review_requests'] as num?)?.toInt() ?? 0,
      awaitingInfoRequests:
          (json['awaiting_info_requests'] as num?)?.toInt() ?? 0,
      approvedRequests: (json['approved_requests'] as num?)?.toInt() ?? 0,
      deniedRequests: (json['denied_requests'] as num?)?.toInt() ?? 0,
      withdrawnRequests: (json['withdrawn_requests'] as num?)?.toInt() ?? 0,
      expiredRequests: (json['expired_requests'] as num?)?.toInt() ?? 0,
      executedRequests: (json['executed_requests'] as num?)?.toInt() ?? 0,
      failedRequests: (json['failed_requests'] as num?)?.toInt() ?? 0,
      requestsToday: (json['requests_today'] as num?)?.toInt() ?? 0,
      requestsThisWeek: (json['requests_this_week'] as num?)?.toInt() ?? 0,
      requestsThisMonth: (json['requests_this_month'] as num?)?.toInt() ?? 0,
      avgApprovalTimeHours:
          (json['avg_approval_time_hours'] as num?)?.toDouble(),
      approvalRate: (json['approval_rate'] as num?)?.toDouble(),
      byRequestType: (json['by_request_type'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const {},
      byActionType: (json['by_action_type'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const {},
      byPriority: (json['by_priority'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const {},
    );

Map<String, dynamic> _$$ApprovalStatisticsImplToJson(
        _$ApprovalStatisticsImpl instance) =>
    <String, dynamic>{
      'total_requests': instance.totalRequests,
      'pending_requests': instance.pendingRequests,
      'under_review_requests': instance.underReviewRequests,
      'awaiting_info_requests': instance.awaitingInfoRequests,
      'approved_requests': instance.approvedRequests,
      'denied_requests': instance.deniedRequests,
      'withdrawn_requests': instance.withdrawnRequests,
      'expired_requests': instance.expiredRequests,
      'executed_requests': instance.executedRequests,
      'failed_requests': instance.failedRequests,
      'requests_today': instance.requestsToday,
      'requests_this_week': instance.requestsThisWeek,
      'requests_this_month': instance.requestsThisMonth,
      'avg_approval_time_hours': instance.avgApprovalTimeHours,
      'approval_rate': instance.approvalRate,
      'by_request_type': instance.byRequestType,
      'by_action_type': instance.byActionType,
      'by_priority': instance.byPriority,
    };

_$PendingApprovalItemImpl _$$PendingApprovalItemImplFromJson(
        Map<String, dynamic> json) =>
    _$PendingApprovalItemImpl(
      id: json['id'] as String,
      requestNumber: json['request_number'] as String,
      requestType: json['request_type'] as String,
      actionType: json['action_type'] as String,
      priority: json['priority'] as String,
      status: json['status'] as String,
      initiatedBy: json['initiated_by'] as String,
      initiatorName: json['initiator_name'] as String?,
      targetResourceType: json['target_resource_type'] as String,
      currentApprovalLevel: (json['current_approval_level'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      expiresAt: json['expires_at'] == null
          ? null
          : DateTime.parse(json['expires_at'] as String),
    );

Map<String, dynamic> _$$PendingApprovalItemImplToJson(
        _$PendingApprovalItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'request_number': instance.requestNumber,
      'request_type': instance.requestType,
      'action_type': instance.actionType,
      'priority': instance.priority,
      'status': instance.status,
      'initiated_by': instance.initiatedBy,
      'initiator_name': instance.initiatorName,
      'target_resource_type': instance.targetResourceType,
      'current_approval_level': instance.currentApprovalLevel,
      'created_at': instance.createdAt.toIso8601String(),
      'expires_at': instance.expiresAt?.toIso8601String(),
    };

_$MyPendingActionsResponseImpl _$$MyPendingActionsResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$MyPendingActionsResponseImpl(
      pendingReviews: (json['pending_reviews'] as List<dynamic>?)
              ?.map((e) =>
                  PendingApprovalItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      awaitingMyInfo: (json['awaiting_my_info'] as List<dynamic>?)
              ?.map((e) =>
                  PendingApprovalItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      delegatedToMe: (json['delegated_to_me'] as List<dynamic>?)
              ?.map((e) =>
                  PendingApprovalItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      total: (json['total'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$MyPendingActionsResponseImplToJson(
        _$MyPendingActionsResponseImpl instance) =>
    <String, dynamic>{
      'pending_reviews': instance.pendingReviews,
      'awaiting_my_info': instance.awaitingMyInfo,
      'delegated_to_me': instance.delegatedToMe,
      'total': instance.total,
    };

_$ApprovalAuditLogEntryImpl _$$ApprovalAuditLogEntryImplFromJson(
        Map<String, dynamic> json) =>
    _$ApprovalAuditLogEntryImpl(
      id: json['id'] as String,
      requestId: json['request_id'] as String,
      actorId: json['actor_id'] as String,
      actorRole: json['actor_role'] as String,
      eventType: json['event_type'] as String,
      eventDescription: json['event_description'] as String?,
      previousState: json['previous_state'] as Map<String, dynamic>?,
      newState: json['new_state'] as Map<String, dynamic>?,
      ipAddress: json['ip_address'] as String?,
      userAgent: json['user_agent'] as String?,
      sessionId: json['session_id'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      actorName: json['actor_name'] as String?,
      actorEmail: json['actor_email'] as String?,
    );

Map<String, dynamic> _$$ApprovalAuditLogEntryImplToJson(
        _$ApprovalAuditLogEntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'request_id': instance.requestId,
      'actor_id': instance.actorId,
      'actor_role': instance.actorRole,
      'event_type': instance.eventType,
      'event_description': instance.eventDescription,
      'previous_state': instance.previousState,
      'new_state': instance.newState,
      'ip_address': instance.ipAddress,
      'user_agent': instance.userAgent,
      'session_id': instance.sessionId,
      'timestamp': instance.timestamp.toIso8601String(),
      'actor_name': instance.actorName,
      'actor_email': instance.actorEmail,
    };

_$ApprovalAuditLogResponseImpl _$$ApprovalAuditLogResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$ApprovalAuditLogResponseImpl(
      entries: (json['entries'] as List<dynamic>)
          .map((e) => ApprovalAuditLogEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      pageSize: (json['page_size'] as num).toInt(),
      hasMore: json['has_more'] as bool,
    );

Map<String, dynamic> _$$ApprovalAuditLogResponseImplToJson(
        _$ApprovalAuditLogResponseImpl instance) =>
    <String, dynamic>{
      'entries': instance.entries,
      'total': instance.total,
      'page': instance.page,
      'page_size': instance.pageSize,
      'has_more': instance.hasMore,
    };

_$CreateApprovalRequestImpl _$$CreateApprovalRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateApprovalRequestImpl(
      requestType:
          $enumDecode(_$ApprovalRequestTypeEnumMap, json['requestType']),
      actionType: $enumDecode(_$ApprovalActionTypeEnumMap, json['actionType']),
      targetResourceType: json['targetResourceType'] as String,
      targetResourceId: json['targetResourceId'] as String?,
      targetResourceSnapshot:
          json['targetResourceSnapshot'] as Map<String, dynamic>?,
      actionPayload: json['actionPayload'] as Map<String, dynamic>? ?? const {},
      justification: json['justification'] as String,
      priority:
          $enumDecodeNullable(_$ApprovalPriorityEnumMap, json['priority']) ??
              ApprovalPriority.normal,
      regionalScope: json['regionalScope'] as String?,
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map((e) => Map<String, String>.from(e as Map))
              .toList() ??
          const [],
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$CreateApprovalRequestImplToJson(
        _$CreateApprovalRequestImpl instance) =>
    <String, dynamic>{
      'requestType': _$ApprovalRequestTypeEnumMap[instance.requestType]!,
      'actionType': _$ApprovalActionTypeEnumMap[instance.actionType]!,
      'targetResourceType': instance.targetResourceType,
      'targetResourceId': instance.targetResourceId,
      'targetResourceSnapshot': instance.targetResourceSnapshot,
      'actionPayload': instance.actionPayload,
      'justification': instance.justification,
      'priority': _$ApprovalPriorityEnumMap[instance.priority]!,
      'regionalScope': instance.regionalScope,
      'attachments': instance.attachments,
      'metadata': instance.metadata,
    };

const _$ApprovalRequestTypeEnumMap = {
  ApprovalRequestType.userManagement: 'user_management',
  ApprovalRequestType.contentManagement: 'content_management',
  ApprovalRequestType.financial: 'financial',
  ApprovalRequestType.system: 'system',
  ApprovalRequestType.notifications: 'notifications',
  ApprovalRequestType.dataExport: 'data_export',
  ApprovalRequestType.adminManagement: 'admin_management',
};

const _$ApprovalActionTypeEnumMap = {
  ApprovalActionType.deleteUserAccount: 'delete_user_account',
  ApprovalActionType.suspendUserAccount: 'suspend_user_account',
  ApprovalActionType.unsuspendUserAccount: 'unsuspend_user_account',
  ApprovalActionType.grantAdminRole: 'grant_admin_role',
  ApprovalActionType.revokeAdminRole: 'revoke_admin_role',
  ApprovalActionType.modifyAdminRole: 'modify_admin_role',
  ApprovalActionType.publishContent: 'publish_content',
  ApprovalActionType.unpublishContent: 'unpublish_content',
  ApprovalActionType.deleteContent: 'delete_content',
  ApprovalActionType.deleteProgram: 'delete_program',
  ApprovalActionType.deleteInstitutionContent: 'delete_institution_content',
  ApprovalActionType.sendBulkNotification: 'send_bulk_notification',
  ApprovalActionType.sendPlatformAnnouncement: 'send_platform_announcement',
  ApprovalActionType.processLargeRefund: 'process_large_refund',
  ApprovalActionType.modifyFeeStructure: 'modify_fee_structure',
  ApprovalActionType.adjustCommission: 'adjust_commission',
  ApprovalActionType.exportSensitiveData: 'export_sensitive_data',
  ApprovalActionType.exportUserData: 'export_user_data',
  ApprovalActionType.exportFinancialData: 'export_financial_data',
  ApprovalActionType.modifySystemSettings: 'modify_system_settings',
  ApprovalActionType.deleteInstitution: 'delete_institution',
};

const _$ApprovalPriorityEnumMap = {
  ApprovalPriority.low: 'low',
  ApprovalPriority.normal: 'normal',
  ApprovalPriority.high: 'high',
  ApprovalPriority.urgent: 'urgent',
};

_$UpdateApprovalRequestImpl _$$UpdateApprovalRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$UpdateApprovalRequestImpl(
      justification: json['justification'] as String?,
      actionPayload: json['actionPayload'] as Map<String, dynamic>?,
      priority:
          $enumDecodeNullable(_$ApprovalPriorityEnumMap, json['priority']),
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => Map<String, String>.from(e as Map))
          .toList(),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$UpdateApprovalRequestImplToJson(
        _$UpdateApprovalRequestImpl instance) =>
    <String, dynamic>{
      'justification': instance.justification,
      'actionPayload': instance.actionPayload,
      'priority': _$ApprovalPriorityEnumMap[instance.priority],
      'attachments': instance.attachments,
      'metadata': instance.metadata,
    };

_$ApproveRequestDataImpl _$$ApproveRequestDataImplFromJson(
        Map<String, dynamic> json) =>
    _$ApproveRequestDataImpl(
      notes: json['notes'] as String?,
      mfaVerified: json['mfaVerified'] as bool? ?? false,
    );

Map<String, dynamic> _$$ApproveRequestDataImplToJson(
        _$ApproveRequestDataImpl instance) =>
    <String, dynamic>{
      'notes': instance.notes,
      'mfaVerified': instance.mfaVerified,
    };

_$DenyRequestDataImpl _$$DenyRequestDataImplFromJson(
        Map<String, dynamic> json) =>
    _$DenyRequestDataImpl(
      reason: json['reason'] as String,
      notes: json['notes'] as String?,
      mfaVerified: json['mfaVerified'] as bool? ?? false,
    );

Map<String, dynamic> _$$DenyRequestDataImplToJson(
        _$DenyRequestDataImpl instance) =>
    <String, dynamic>{
      'reason': instance.reason,
      'notes': instance.notes,
      'mfaVerified': instance.mfaVerified,
    };

_$RequestInfoDataImpl _$$RequestInfoDataImplFromJson(
        Map<String, dynamic> json) =>
    _$RequestInfoDataImpl(
      infoRequested: json['infoRequested'] as String,
    );

Map<String, dynamic> _$$RequestInfoDataImplToJson(
        _$RequestInfoDataImpl instance) =>
    <String, dynamic>{
      'infoRequested': instance.infoRequested,
    };

_$RespondInfoDataImpl _$$RespondInfoDataImplFromJson(
        Map<String, dynamic> json) =>
    _$RespondInfoDataImpl(
      response: json['response'] as String,
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map((e) => Map<String, String>.from(e as Map))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$RespondInfoDataImplToJson(
        _$RespondInfoDataImpl instance) =>
    <String, dynamic>{
      'response': instance.response,
      'attachments': instance.attachments,
    };

_$DelegateRequestDataImpl _$$DelegateRequestDataImplFromJson(
        Map<String, dynamic> json) =>
    _$DelegateRequestDataImpl(
      delegateTo: json['delegateTo'] as String,
      reason: json['reason'] as String,
    );

Map<String, dynamic> _$$DelegateRequestDataImplToJson(
        _$DelegateRequestDataImpl instance) =>
    <String, dynamic>{
      'delegateTo': instance.delegateTo,
      'reason': instance.reason,
    };

_$EscalateRequestDataImpl _$$EscalateRequestDataImplFromJson(
        Map<String, dynamic> json) =>
    _$EscalateRequestDataImpl(
      reason: json['reason'] as String,
    );

Map<String, dynamic> _$$EscalateRequestDataImplToJson(
        _$EscalateRequestDataImpl instance) =>
    <String, dynamic>{
      'reason': instance.reason,
    };

_$CreateCommentDataImpl _$$CreateCommentDataImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateCommentDataImpl(
      content: json['content'] as String,
      isInternal: json['isInternal'] as bool? ?? false,
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map((e) => Map<String, String>.from(e as Map))
              .toList() ??
          const [],
      parentCommentId: json['parentCommentId'] as String?,
    );

Map<String, dynamic> _$$CreateCommentDataImplToJson(
        _$CreateCommentDataImpl instance) =>
    <String, dynamic>{
      'content': instance.content,
      'isInternal': instance.isInternal,
      'attachments': instance.attachments,
      'parentCommentId': instance.parentCommentId,
    };

_$ApprovalRequestCreateImpl _$$ApprovalRequestCreateImplFromJson(
        Map<String, dynamic> json) =>
    _$ApprovalRequestCreateImpl(
      requestType: json['requestType'] as String,
      actionType: json['actionType'] as String,
      targetResourceType: json['targetResourceType'] as String,
      targetResourceId: json['targetResourceId'] as String?,
      targetResourceSnapshot:
          json['targetResourceSnapshot'] as Map<String, dynamic>?,
      actionPayload: json['actionPayload'] as Map<String, dynamic>? ?? const {},
      justification: json['justification'] as String,
      priority: json['priority'] as String? ?? 'normal',
      regionalScope: json['regionalScope'] as String?,
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map((e) => Map<String, String>.from(e as Map))
              .toList() ??
          const [],
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$ApprovalRequestCreateImplToJson(
        _$ApprovalRequestCreateImpl instance) =>
    <String, dynamic>{
      'requestType': instance.requestType,
      'actionType': instance.actionType,
      'targetResourceType': instance.targetResourceType,
      'targetResourceId': instance.targetResourceId,
      'targetResourceSnapshot': instance.targetResourceSnapshot,
      'actionPayload': instance.actionPayload,
      'justification': instance.justification,
      'priority': instance.priority,
      'regionalScope': instance.regionalScope,
      'attachments': instance.attachments,
      'metadata': instance.metadata,
    };

_$ApprovalRequestFilterImpl _$$ApprovalRequestFilterImplFromJson(
        Map<String, dynamic> json) =>
    _$ApprovalRequestFilterImpl(
      status: (json['status'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$ApprovalStatusEnumMap, e))
          .toList(),
      requestType: (json['requestType'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$ApprovalRequestTypeEnumMap, e))
          .toList(),
      actionType: (json['actionType'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$ApprovalActionTypeEnumMap, e))
          .toList(),
      priority: (json['priority'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$ApprovalPriorityEnumMap, e))
          .toList(),
      initiatedBy: json['initiatedBy'] as String?,
      regionalScope: json['regionalScope'] as String?,
      currentApprovalLevel: (json['currentApprovalLevel'] as num?)?.toInt(),
      fromDate: json['fromDate'] == null
          ? null
          : DateTime.parse(json['fromDate'] as String),
      toDate: json['toDate'] == null
          ? null
          : DateTime.parse(json['toDate'] as String),
      search: json['search'] as String?,
    );

Map<String, dynamic> _$$ApprovalRequestFilterImplToJson(
        _$ApprovalRequestFilterImpl instance) =>
    <String, dynamic>{
      'status':
          instance.status?.map((e) => _$ApprovalStatusEnumMap[e]!).toList(),
      'requestType': instance.requestType
          ?.map((e) => _$ApprovalRequestTypeEnumMap[e]!)
          .toList(),
      'actionType': instance.actionType
          ?.map((e) => _$ApprovalActionTypeEnumMap[e]!)
          .toList(),
      'priority':
          instance.priority?.map((e) => _$ApprovalPriorityEnumMap[e]!).toList(),
      'initiatedBy': instance.initiatedBy,
      'regionalScope': instance.regionalScope,
      'currentApprovalLevel': instance.currentApprovalLevel,
      'fromDate': instance.fromDate?.toIso8601String(),
      'toDate': instance.toDate?.toIso8601String(),
      'search': instance.search,
    };

const _$ApprovalStatusEnumMap = {
  ApprovalStatus.draft: 'draft',
  ApprovalStatus.pendingReview: 'pending_review',
  ApprovalStatus.underReview: 'under_review',
  ApprovalStatus.awaitingInfo: 'awaiting_info',
  ApprovalStatus.escalated: 'escalated',
  ApprovalStatus.approved: 'approved',
  ApprovalStatus.denied: 'denied',
  ApprovalStatus.withdrawn: 'withdrawn',
  ApprovalStatus.expired: 'expired',
  ApprovalStatus.executed: 'executed',
  ApprovalStatus.failed: 'failed',
};
