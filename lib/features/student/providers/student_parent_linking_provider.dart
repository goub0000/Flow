import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../../../core/providers/service_providers.dart';

/// Model for a pending parent link request
class PendingParentLink {
  final String id;
  final String parentId;
  final String parentName;
  final String parentEmail;
  final String relationship;
  final Map<String, bool> requestedPermissions;
  final DateTime createdAt;

  const PendingParentLink({
    required this.id,
    required this.parentId,
    required this.parentName,
    required this.parentEmail,
    required this.relationship,
    required this.requestedPermissions,
    required this.createdAt,
  });

  factory PendingParentLink.fromJson(Map<String, dynamic> json) {
    return PendingParentLink(
      id: json['id'] ?? '',
      parentId: json['parent_id'] ?? '',
      parentName: json['parent_name'] ?? 'Unknown Parent',
      parentEmail: json['parent_email'] ?? '',
      relationship: json['relationship'] ?? 'parent',
      requestedPermissions: Map<String, bool>.from(json['requested_permissions'] ?? {}),
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}

/// Model for a linked parent (active link)
class LinkedParent {
  final String id;
  final String parentId;
  final String parentName;
  final String parentEmail;
  final String relationship;
  final Map<String, bool> permissions;
  final DateTime linkedAt;

  const LinkedParent({
    required this.id,
    required this.parentId,
    required this.parentName,
    required this.parentEmail,
    required this.relationship,
    required this.permissions,
    required this.linkedAt,
  });

  factory LinkedParent.fromJson(Map<String, dynamic> json) {
    return LinkedParent(
      id: json['id'] ?? '',
      parentId: json['parent_id'] ?? '',
      parentName: json['parent_name'] ?? 'Unknown Parent',
      parentEmail: json['parent_email'] ?? '',
      relationship: json['relationship'] ?? 'parent',
      permissions: {
        'can_view_grades': json['can_view_grades'] ?? false,
        'can_view_activity': json['can_view_activity'] ?? false,
        'can_view_messages': json['can_view_messages'] ?? false,
        'can_receive_alerts': json['can_receive_alerts'] ?? false,
      },
      linkedAt: DateTime.tryParse(json['linked_at'] ?? json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}

/// Model for an invite code
class InviteCode {
  final String id;
  final String code;
  final String studentId;
  final DateTime expiresAt;
  final int maxUses;
  final int usesRemaining;
  final bool isActive;
  final DateTime createdAt;

  const InviteCode({
    required this.id,
    required this.code,
    required this.studentId,
    required this.expiresAt,
    required this.maxUses,
    required this.usesRemaining,
    required this.isActive,
    required this.createdAt,
  });

  factory InviteCode.fromJson(Map<String, dynamic> json) {
    return InviteCode(
      id: json['id'] ?? '',
      code: json['code'] ?? '',
      studentId: json['student_id'] ?? '',
      expiresAt: DateTime.tryParse(json['expires_at'] ?? '') ?? DateTime.now(),
      maxUses: json['max_uses'] ?? 1,
      usesRemaining: json['uses_remaining'] ?? 0,
      isActive: json['is_active'] ?? false,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  bool get isExpired => DateTime.now().isAfter(expiresAt);
  bool get isUsable => isActive && !isExpired && usesRemaining > 0;
}

/// State for student parent linking
class StudentParentLinkingState {
  final List<PendingParentLink> pendingLinks;
  final List<LinkedParent> linkedParents;
  final List<InviteCode> inviteCodes;
  final bool isLoading;
  final String? error;

  const StudentParentLinkingState({
    this.pendingLinks = const [],
    this.linkedParents = const [],
    this.inviteCodes = const [],
    this.isLoading = false,
    this.error,
  });

  StudentParentLinkingState copyWith({
    List<PendingParentLink>? pendingLinks,
    List<LinkedParent>? linkedParents,
    List<InviteCode>? inviteCodes,
    bool? isLoading,
    String? error,
  }) {
    return StudentParentLinkingState(
      pendingLinks: pendingLinks ?? this.pendingLinks,
      linkedParents: linkedParents ?? this.linkedParents,
      inviteCodes: inviteCodes ?? this.inviteCodes,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// StateNotifier for student parent linking
class StudentParentLinkingNotifier extends StateNotifier<StudentParentLinkingState> {
  final ApiClient _apiClient;

  StudentParentLinkingNotifier(this._apiClient) : super(const StudentParentLinkingState()) {
    fetchPendingLinks();
    fetchLinkedParents();
    fetchInviteCodes();
  }

  /// Fetch pending parent link requests
  Future<void> fetchPendingLinks() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _apiClient.get(
        '/student/pending-links',
        fromJson: (data) => data,
      );

      if (response.success && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final links = (data['links'] as List? ?? [])
            .map((l) => PendingParentLink.fromJson(l))
            .toList();
        state = state.copyWith(pendingLinks: links, isLoading: false);
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to fetch pending links',
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch pending links: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Fetch linked parents (active links)
  Future<void> fetchLinkedParents() async {
    try {
      final response = await _apiClient.get(
        '/parent/links',
        fromJson: (data) => data,
      );

      if (response.success && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final parents = (data['links'] as List? ?? [])
            .where((l) => l['status'] == 'active')
            .map((l) => LinkedParent.fromJson(l))
            .toList();
        state = state.copyWith(linkedParents: parents);
      }
    } catch (e) {
      // Silently fail - linked parents are supplementary
    }
  }

  /// Fetch invite codes
  Future<void> fetchInviteCodes() async {
    try {
      final response = await _apiClient.get(
        '/student/invite-codes',
        fromJson: (data) => data,
      );

      if (response.success && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final codes = (data['codes'] as List? ?? [])
            .map((c) => InviteCode.fromJson(c))
            .toList();
        state = state.copyWith(inviteCodes: codes);
      }
    } catch (e) {
      // Silently fail - codes are optional
    }
  }

  /// Approve a parent link request
  Future<bool> approveLink(String linkId) async {
    try {
      final response = await _apiClient.post(
        '/parent/links/$linkId/approve',
        fromJson: (data) => data,
      );

      if (response.success) {
        // Remove the approved link from pending
        final updatedLinks = state.pendingLinks.where((l) => l.id != linkId).toList();
        state = state.copyWith(pendingLinks: updatedLinks);
        // Refresh linked parents to show the new parent
        fetchLinkedParents();
        return true;
      } else {
        state = state.copyWith(error: response.message ?? 'Failed to approve link');
        return false;
      }
    } catch (e) {
      state = state.copyWith(error: 'Failed to approve link: ${e.toString()}');
      return false;
    }
  }

  /// Decline a parent link request
  Future<bool> declineLink(String linkId) async {
    try {
      final response = await _apiClient.post(
        '/student/links/$linkId/decline',
        fromJson: (data) => data,
      );

      if (response.success) {
        // Remove the declined link from pending
        final updatedLinks = state.pendingLinks.where((l) => l.id != linkId).toList();
        state = state.copyWith(pendingLinks: updatedLinks);
        return true;
      } else {
        state = state.copyWith(error: response.message ?? 'Failed to decline link');
        return false;
      }
    } catch (e) {
      state = state.copyWith(error: 'Failed to decline link: ${e.toString()}');
      return false;
    }
  }

  /// Generate a new invite code
  Future<InviteCode?> generateInviteCode({int expiresInDays = 7, int maxUses = 1}) async {
    try {
      final response = await _apiClient.post(
        '/student/invite-codes',
        data: {
          'expires_in_days': expiresInDays,
          'max_uses': maxUses,
        },
        fromJson: (data) => InviteCode.fromJson(data),
      );

      if (response.success && response.data != null) {
        final newCode = response.data!;
        final updatedCodes = [newCode, ...state.inviteCodes];
        state = state.copyWith(inviteCodes: updatedCodes);
        return newCode;
      } else {
        state = state.copyWith(error: response.message ?? 'Failed to generate invite code');
        return null;
      }
    } catch (e) {
      state = state.copyWith(error: 'Failed to generate invite code: ${e.toString()}');
      return null;
    }
  }

  /// Delete/deactivate an invite code
  Future<bool> deleteInviteCode(String codeId) async {
    try {
      await _apiClient.delete('/student/invite-codes/$codeId');

      final updatedCodes = state.inviteCodes.where((c) => c.id != codeId).toList();
      state = state.copyWith(inviteCodes: updatedCodes);
      return true;
    } catch (e) {
      state = state.copyWith(error: 'Failed to delete invite code: ${e.toString()}');
      return false;
    }
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Provider for student parent linking
final studentParentLinkingProvider =
    StateNotifierProvider<StudentParentLinkingNotifier, StudentParentLinkingState>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return StudentParentLinkingNotifier(apiClient);
});

/// Provider for pending links count (for badge)
final pendingLinksCountProvider = Provider<int>((ref) {
  final state = ref.watch(studentParentLinkingProvider);
  return state.pendingLinks.length;
});

/// Provider for active invite codes
final activeInviteCodesProvider = Provider<List<InviteCode>>((ref) {
  final state = ref.watch(studentParentLinkingProvider);
  return state.inviteCodes.where((c) => c.isUsable).toList();
});

/// Provider for linked parents
final linkedParentsProvider = Provider<List<LinkedParent>>((ref) {
  final state = ref.watch(studentParentLinkingProvider);
  return state.linkedParents;
});

/// Provider for linked parents count
final linkedParentsCountProvider = Provider<int>((ref) {
  final state = ref.watch(studentParentLinkingProvider);
  return state.linkedParents.length;
});
