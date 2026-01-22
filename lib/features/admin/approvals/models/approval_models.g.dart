// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'approval_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApprovalActionImpl _$$ApprovalActionImplFromJson(Map<String, dynamic> json) =>
    _$ApprovalActionImpl(
      id: json['id'] as String,
      requestId: json['requestId'] as String,
      reviewerId: json['reviewerId'] as String,
      reviewerRole: json['reviewerRole'] as String,
      reviewerLevel: (json['reviewerLevel'] as num).toInt(),
      actionType: json['actionType'] as String,
      notes: json['notes'] as String?,
      delegatedTo: json['delegatedTo'] as String?,
      delegatedReason: json['delegatedReason'] as String?,
      escalatedToLevel: (json['escalatedToLevel'] as num?)?.toInt(),
      escalationReason: json['escalationReason'] as String?,
      infoRequested: json['infoRequested'] as String?,
      mfaVerified: json['mfaVerified'] as bool? ?? false,
      actedAt: DateTime.parse(json['actedAt'] as String),
      reviewerName: json['reviewerName'] as String?,
      reviewerEmail: json['reviewerEmail'] as String?,
    );

Map<String, dynamic> _$$ApprovalActionImplToJson(
        _$ApprovalActionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'requestId': instance.requestId,
      'reviewerId': instance.reviewerId,
      'reviewerRole': instance.reviewerRole,
      'reviewerLevel': instance.reviewerLevel,
      'actionType': instance.actionType,
      'notes': instance.notes,
      'delegatedTo': instance.delegatedTo,
      'delegatedReason': instance.delegatedReason,
      'escalatedToLevel': instance.escalatedToLevel,
      'escalationReason': instance.escalationReason,
      'infoRequested': instance.infoRequested,
      'mfaVerified': instance.mfaVerified,
      'actedAt': instance.actedAt.toIso8601String(),
      'reviewerName': instance.reviewerName,
      'reviewerEmail': instance.reviewerEmail,
    };

_$ApprovalCommentImpl _$$ApprovalCommentImplFromJson(
        Map<String, dynamic> json) =>
    _$ApprovalCommentImpl(
      id: json['id'] as String,
      requestId: json['requestId'] as String,
      authorId: json['authorId'] as String,
      authorRole: json['authorRole'] as String,
      content: json['content'] as String,
      isInternal: json['isInternal'] as bool? ?? false,
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map((e) => Map<String, String>.from(e as Map))
              .toList() ??
          const [],
      parentCommentId: json['parentCommentId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      authorName: json['authorName'] as String?,
      authorEmail: json['authorEmail'] as String?,
      replies: (json['replies'] as List<dynamic>?)
              ?.map((e) => ApprovalComment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ApprovalCommentImplToJson(
        _$ApprovalCommentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'requestId': instance.requestId,
      'authorId': instance.authorId,
      'authorRole': instance.authorRole,
      'content': instance.content,
      'isInternal': instance.isInternal,
      'attachments': instance.attachments,
      'parentCommentId': instance.parentCommentId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'authorName': instance.authorName,
      'authorEmail': instance.authorEmail,
      'replies': instance.replies,
    };

_$ApprovalRequestImpl _$$ApprovalRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$ApprovalRequestImpl(
      id: json['id'] as String,
      requestNumber: json['requestNumber'] as String,
      requestType: json['requestType'] as String,
      initiatedBy: json['initiatedBy'] as String,
      initiatedByRole: json['initiatedByRole'] as String,
      initiatedAt: DateTime.parse(json['initiatedAt'] as String),
      targetResourceType: json['targetResourceType'] as String,
      targetResourceId: json['targetResourceId'] as String?,
      targetResourceSnapshot:
          json['targetResourceSnapshot'] as Map<String, dynamic>?,
      actionType: json['actionType'] as String,
      actionPayload: json['actionPayload'] as Map<String, dynamic>? ?? const {},
      justification: json['justification'] as String,
      priority: json['priority'] as String,
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      status: json['status'] as String,
      currentApprovalLevel: (json['currentApprovalLevel'] as num).toInt(),
      requiredApprovalLevel: (json['requiredApprovalLevel'] as num).toInt(),
      approvalChain: (json['approvalChain'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
      regionalScope: json['regionalScope'] as String?,
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map((e) => Map<String, String>.from(e as Map))
              .toList() ??
          const [],
      metadata: json['metadata'] as Map<String, dynamic>?,
      executedAt: json['executedAt'] == null
          ? null
          : DateTime.parse(json['executedAt'] as String),
      executionResult: json['executionResult'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      initiatorName: json['initiatorName'] as String?,
      initiatorEmail: json['initiatorEmail'] as String?,
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
      'requestNumber': instance.requestNumber,
      'requestType': instance.requestType,
      'initiatedBy': instance.initiatedBy,
      'initiatedByRole': instance.initiatedByRole,
      'initiatedAt': instance.initiatedAt.toIso8601String(),
      'targetResourceType': instance.targetResourceType,
      'targetResourceId': instance.targetResourceId,
      'targetResourceSnapshot': instance.targetResourceSnapshot,
      'actionType': instance.actionType,
      'actionPayload': instance.actionPayload,
      'justification': instance.justification,
      'priority': instance.priority,
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'status': instance.status,
      'currentApprovalLevel': instance.currentApprovalLevel,
      'requiredApprovalLevel': instance.requiredApprovalLevel,
      'approvalChain': instance.approvalChain,
      'regionalScope': instance.regionalScope,
      'attachments': instance.attachments,
      'metadata': instance.metadata,
      'executedAt': instance.executedAt?.toIso8601String(),
      'executionResult': instance.executionResult,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'initiatorName': instance.initiatorName,
      'initiatorEmail': instance.initiatorEmail,
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
      pageSize: (json['pageSize'] as num).toInt(),
      hasMore: json['hasMore'] as bool,
    );

Map<String, dynamic> _$$ApprovalRequestListResponseImplToJson(
        _$ApprovalRequestListResponseImpl instance) =>
    <String, dynamic>{
      'requests': instance.requests,
      'total': instance.total,
      'page': instance.page,
      'pageSize': instance.pageSize,
      'hasMore': instance.hasMore,
    };

_$ApprovalConfigImpl _$$ApprovalConfigImplFromJson(Map<String, dynamic> json) =>
    _$ApprovalConfigImpl(
      id: json['id'] as String,
      requestType: json['requestType'] as String,
      actionType: json['actionType'] as String,
      targetResourceType: json['targetResourceType'] as String?,
      requiredApprovalLevel: (json['requiredApprovalLevel'] as num).toInt(),
      canSkipLevels: json['canSkipLevels'] as bool? ?? false,
      skipLevelConditions:
          json['skipLevelConditions'] as Map<String, dynamic>? ?? const {},
      allowedInitiatorRoles: (json['allowedInitiatorRoles'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      allowedApproverRoles: (json['allowedApproverRoles'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      defaultPriority: json['defaultPriority'] as String? ?? 'normal',
      defaultExpirationHours: (json['defaultExpirationHours'] as num?)?.toInt(),
      requiresMfa: json['requiresMfa'] as bool? ?? false,
      autoExecute: json['autoExecute'] as bool? ?? true,
      notificationChannels: (json['notificationChannels'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const ['in_app', 'email'],
      isActive: json['isActive'] as bool? ?? true,
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ApprovalConfigImplToJson(
        _$ApprovalConfigImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'requestType': instance.requestType,
      'actionType': instance.actionType,
      'targetResourceType': instance.targetResourceType,
      'requiredApprovalLevel': instance.requiredApprovalLevel,
      'canSkipLevels': instance.canSkipLevels,
      'skipLevelConditions': instance.skipLevelConditions,
      'allowedInitiatorRoles': instance.allowedInitiatorRoles,
      'allowedApproverRoles': instance.allowedApproverRoles,
      'defaultPriority': instance.defaultPriority,
      'defaultExpirationHours': instance.defaultExpirationHours,
      'requiresMfa': instance.requiresMfa,
      'autoExecute': instance.autoExecute,
      'notificationChannels': instance.notificationChannels,
      'isActive': instance.isActive,
      'description': instance.description,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_$ApprovalStatisticsImpl _$$ApprovalStatisticsImplFromJson(
        Map<String, dynamic> json) =>
    _$ApprovalStatisticsImpl(
      totalRequests: (json['totalRequests'] as num?)?.toInt() ?? 0,
      pendingRequests: (json['pendingRequests'] as num?)?.toInt() ?? 0,
      underReviewRequests: (json['underReviewRequests'] as num?)?.toInt() ?? 0,
      awaitingInfoRequests:
          (json['awaitingInfoRequests'] as num?)?.toInt() ?? 0,
      approvedRequests: (json['approvedRequests'] as num?)?.toInt() ?? 0,
      deniedRequests: (json['deniedRequests'] as num?)?.toInt() ?? 0,
      withdrawnRequests: (json['withdrawnRequests'] as num?)?.toInt() ?? 0,
      expiredRequests: (json['expiredRequests'] as num?)?.toInt() ?? 0,
      executedRequests: (json['executedRequests'] as num?)?.toInt() ?? 0,
      failedRequests: (json['failedRequests'] as num?)?.toInt() ?? 0,
      requestsToday: (json['requestsToday'] as num?)?.toInt() ?? 0,
      requestsThisWeek: (json['requestsThisWeek'] as num?)?.toInt() ?? 0,
      requestsThisMonth: (json['requestsThisMonth'] as num?)?.toInt() ?? 0,
      avgApprovalTimeHours: (json['avgApprovalTimeHours'] as num?)?.toDouble(),
      approvalRate: (json['approvalRate'] as num?)?.toDouble(),
      byRequestType: (json['byRequestType'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const {},
      byActionType: (json['byActionType'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const {},
      byPriority: (json['byPriority'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const {},
    );

Map<String, dynamic> _$$ApprovalStatisticsImplToJson(
        _$ApprovalStatisticsImpl instance) =>
    <String, dynamic>{
      'totalRequests': instance.totalRequests,
      'pendingRequests': instance.pendingRequests,
      'underReviewRequests': instance.underReviewRequests,
      'awaitingInfoRequests': instance.awaitingInfoRequests,
      'approvedRequests': instance.approvedRequests,
      'deniedRequests': instance.deniedRequests,
      'withdrawnRequests': instance.withdrawnRequests,
      'expiredRequests': instance.expiredRequests,
      'executedRequests': instance.executedRequests,
      'failedRequests': instance.failedRequests,
      'requestsToday': instance.requestsToday,
      'requestsThisWeek': instance.requestsThisWeek,
      'requestsThisMonth': instance.requestsThisMonth,
      'avgApprovalTimeHours': instance.avgApprovalTimeHours,
      'approvalRate': instance.approvalRate,
      'byRequestType': instance.byRequestType,
      'byActionType': instance.byActionType,
      'byPriority': instance.byPriority,
    };

_$PendingApprovalItemImpl _$$PendingApprovalItemImplFromJson(
        Map<String, dynamic> json) =>
    _$PendingApprovalItemImpl(
      id: json['id'] as String,
      requestNumber: json['requestNumber'] as String,
      requestType: json['requestType'] as String,
      actionType: json['actionType'] as String,
      priority: json['priority'] as String,
      status: json['status'] as String,
      initiatedBy: json['initiatedBy'] as String,
      initiatorName: json['initiatorName'] as String?,
      targetResourceType: json['targetResourceType'] as String,
      currentApprovalLevel: (json['currentApprovalLevel'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
    );

Map<String, dynamic> _$$PendingApprovalItemImplToJson(
        _$PendingApprovalItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'requestNumber': instance.requestNumber,
      'requestType': instance.requestType,
      'actionType': instance.actionType,
      'priority': instance.priority,
      'status': instance.status,
      'initiatedBy': instance.initiatedBy,
      'initiatorName': instance.initiatorName,
      'targetResourceType': instance.targetResourceType,
      'currentApprovalLevel': instance.currentApprovalLevel,
      'createdAt': instance.createdAt.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
    };

_$MyPendingActionsResponseImpl _$$MyPendingActionsResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$MyPendingActionsResponseImpl(
      pendingReviews: (json['pendingReviews'] as List<dynamic>?)
              ?.map((e) =>
                  PendingApprovalItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      awaitingMyInfo: (json['awaitingMyInfo'] as List<dynamic>?)
              ?.map((e) =>
                  PendingApprovalItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      delegatedToMe: (json['delegatedToMe'] as List<dynamic>?)
              ?.map((e) =>
                  PendingApprovalItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      total: (json['total'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$MyPendingActionsResponseImplToJson(
        _$MyPendingActionsResponseImpl instance) =>
    <String, dynamic>{
      'pendingReviews': instance.pendingReviews,
      'awaitingMyInfo': instance.awaitingMyInfo,
      'delegatedToMe': instance.delegatedToMe,
      'total': instance.total,
    };

_$ApprovalAuditLogEntryImpl _$$ApprovalAuditLogEntryImplFromJson(
        Map<String, dynamic> json) =>
    _$ApprovalAuditLogEntryImpl(
      id: json['id'] as String,
      requestId: json['requestId'] as String,
      actorId: json['actorId'] as String,
      actorRole: json['actorRole'] as String,
      eventType: json['eventType'] as String,
      eventDescription: json['eventDescription'] as String?,
      previousState: json['previousState'] as Map<String, dynamic>?,
      newState: json['newState'] as Map<String, dynamic>?,
      ipAddress: json['ipAddress'] as String?,
      userAgent: json['userAgent'] as String?,
      sessionId: json['sessionId'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      actorName: json['actorName'] as String?,
      actorEmail: json['actorEmail'] as String?,
    );

Map<String, dynamic> _$$ApprovalAuditLogEntryImplToJson(
        _$ApprovalAuditLogEntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'requestId': instance.requestId,
      'actorId': instance.actorId,
      'actorRole': instance.actorRole,
      'eventType': instance.eventType,
      'eventDescription': instance.eventDescription,
      'previousState': instance.previousState,
      'newState': instance.newState,
      'ipAddress': instance.ipAddress,
      'userAgent': instance.userAgent,
      'sessionId': instance.sessionId,
      'timestamp': instance.timestamp.toIso8601String(),
      'actorName': instance.actorName,
      'actorEmail': instance.actorEmail,
    };

_$ApprovalAuditLogResponseImpl _$$ApprovalAuditLogResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$ApprovalAuditLogResponseImpl(
      entries: (json['entries'] as List<dynamic>)
          .map((e) => ApprovalAuditLogEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      pageSize: (json['pageSize'] as num).toInt(),
      hasMore: json['hasMore'] as bool,
    );

Map<String, dynamic> _$$ApprovalAuditLogResponseImplToJson(
        _$ApprovalAuditLogResponseImpl instance) =>
    <String, dynamic>{
      'entries': instance.entries,
      'total': instance.total,
      'page': instance.page,
      'pageSize': instance.pageSize,
      'hasMore': instance.hasMore,
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
