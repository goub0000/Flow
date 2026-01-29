import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_config.dart';
import '../../../../core/providers/service_providers.dart';

const _uuid = Uuid();

/// Communication campaign model
class Campaign {
  final String id;
  final String title;
  final String type; // 'email', 'sms', 'push', 'in_app'
  final String status; // 'draft', 'scheduled', 'sent', 'failed'
  final String? message;
  final List<String> targetRoles;
  final DateTime? scheduledAt;
  final DateTime? sentAt;
  final int? recipientCount;
  final int? deliveredCount;
  final int? openedCount;
  final DateTime createdAt;

  const Campaign({
    required this.id,
    required this.title,
    required this.type,
    required this.status,
    this.message,
    this.targetRoles = const [],
    this.scheduledAt,
    this.sentAt,
    this.recipientCount,
    this.deliveredCount,
    this.openedCount,
    required this.createdAt,
  });

  static Campaign mockCampaign(int index) {
    final types = ['email', 'sms', 'push', 'in_app'];
    final statuses = ['draft', 'scheduled', 'sent'];

    return Campaign(
      id: 'campaign_$index',
      title: 'Campaign ${index + 1}',
      type: types[index % types.length],
      status: statuses[index % statuses.length],
      message: 'Sample message for campaign ${index + 1}',
      targetRoles: ['student', 'parent'],
      scheduledAt: index % 2 == 0 ? DateTime.now().add(Duration(days: index)) : null,
      sentAt: index % 3 == 0 ? DateTime.now().subtract(Duration(days: index)) : null,
      recipientCount: 100 + (index * 50),
      deliveredCount: 95 + (index * 45),
      openedCount: 60 + (index * 30),
      createdAt: DateTime.now().subtract(Duration(days: index * 2)),
    );
  }
}

/// State class for admin communications
class AdminCommunicationsState {
  final List<Campaign> campaigns;
  final bool isLoading;
  final String? error;

  const AdminCommunicationsState({
    this.campaigns = const [],
    this.isLoading = false,
    this.error,
  });

  AdminCommunicationsState copyWith({
    List<Campaign>? campaigns,
    bool? isLoading,
    String? error,
  }) {
    return AdminCommunicationsState(
      campaigns: campaigns ?? this.campaigns,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// StateNotifier for admin communications
class AdminCommunicationsNotifier extends StateNotifier<AdminCommunicationsState> {
  final ApiClient _apiClient;

  AdminCommunicationsNotifier(this._apiClient) : super(const AdminCommunicationsState()) {
    fetchCampaigns();
  }

  /// Fetch all campaigns from backend API
  Future<void> fetchCampaigns() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _apiClient.get(
        '${ApiConfig.admin}/communications/campaigns',
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (response.success && response.data != null) {
        final campaignsData = response.data!['campaigns'] as List<dynamic>? ?? [];
        final campaigns = campaignsData.map((campaignData) {
          final contentData = campaignData['content'] as Map<String, dynamic>? ?? {};
          final targetAudience = campaignData['target_audience'] as Map<String, dynamic>? ?? {};
          final statsData = campaignData['stats'] as Map<String, dynamic>? ?? {};

          return Campaign(
            id: campaignData['id'] ?? '',
            title: campaignData['name'] ?? contentData['title'] ?? '',
            type: campaignData['type'] ?? 'email',
            status: campaignData['status'] ?? 'draft',
            message: contentData['message'] ?? contentData['body'],
            targetRoles: (targetAudience['roles'] as List<dynamic>?)?.cast<String>() ?? [],
            scheduledAt: campaignData['scheduled_at'] != null
                ? DateTime.parse(campaignData['scheduled_at'])
                : null,
            sentAt: campaignData['sent_at'] != null
                ? DateTime.parse(campaignData['sent_at'])
                : null,
            recipientCount: statsData['sent'] as int? ?? 0,
            deliveredCount: statsData['delivered'] as int? ?? 0,
            openedCount: statsData['opened'] as int? ?? 0,
            createdAt: campaignData['created_at'] != null
                ? DateTime.parse(campaignData['created_at'])
                : DateTime.now(),
          );
        }).toList();

        state = state.copyWith(
          campaigns: campaigns,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to fetch campaigns',
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch campaigns: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Create campaign via backend API
  Future<bool> createCampaign(Campaign campaign) async {
    try {
      final response = await _apiClient.post(
        '${ApiConfig.admin}/communications/campaigns',
        data: {
          'name': campaign.title,
          'type': campaign.type,
          'target_audience': {'roles': campaign.targetRoles},
          'content': {
            'title': campaign.title,
            'message': campaign.message,
          },
          'scheduled_at': campaign.scheduledAt?.toIso8601String(),
        },
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (response.success) {
        // Refresh campaigns to get the new one from backend
        await fetchCampaigns();
        return true;
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to create campaign',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to create campaign: ${e.toString()}',
      );
      return false;
    }
  }

  /// Send announcement to all users via backend API
  Future<bool> sendAnnouncement({
    required String title,
    required String message,
    required List<String> targetRoles,
    required String type,
  }) async {
    try {
      final response = await _apiClient.post(
        '${ApiConfig.admin}/communications/announcements',
        data: {
          'title': title,
          'message': message,
          'target_roles': targetRoles,
          'type': type,
        },
        fromJson: (data) => data,
      );

      if (response.success) {
        // Create a campaign record for local state
        final campaign = Campaign(
          id: _uuid.v4(),
          title: title,
          type: type,
          status: 'sent',
          message: message,
          targetRoles: targetRoles,
          sentAt: DateTime.now(),
          recipientCount: response.data?['recipient_count'] ?? 0,
          deliveredCount: response.data?['delivered_count'] ?? 0,
          openedCount: 0,
          createdAt: DateTime.now(),
        );

        final updatedCampaigns = [campaign, ...state.campaigns];
        state = state.copyWith(campaigns: updatedCampaigns);

        return true;
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to send announcement',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to send announcement: ${e.toString()}',
      );
      return false;
    }
  }

  /// Schedule campaign
  /// TODO: Connect to backend API
  Future<bool> scheduleCampaign(String campaignId, DateTime scheduledTime) async {
    try {
      // TODO: Update in backend API and set up scheduled job
      await Future.delayed(const Duration(milliseconds: 500));

      final updatedCampaigns = state.campaigns.map((c) {
        if (c.id == campaignId) {
          return Campaign(
            id: c.id,
            title: c.title,
            type: c.type,
            status: 'scheduled',
            message: c.message,
            targetRoles: c.targetRoles,
            scheduledAt: scheduledTime,
            sentAt: c.sentAt,
            recipientCount: c.recipientCount,
            deliveredCount: c.deliveredCount,
            openedCount: c.openedCount,
            createdAt: c.createdAt,
          );
        }
        return c;
      }).toList();

      state = state.copyWith(campaigns: updatedCampaigns);

      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to schedule campaign: ${e.toString()}',
      );
      return false;
    }
  }

  /// Delete campaign
  Future<bool> deleteCampaign(String campaignId) async {
    try {
      // TODO: Delete from backend API
      await Future.delayed(const Duration(milliseconds: 300));

      final updatedCampaigns = state.campaigns.where((c) => c.id != campaignId).toList();
      state = state.copyWith(campaigns: updatedCampaigns);

      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to delete campaign: ${e.toString()}',
      );
      return false;
    }
  }

  /// Get campaign statistics
  Map<String, dynamic> getCampaignStatistics() {
    int totalSent = 0;
    int totalDelivered = 0;
    int totalOpened = 0;

    for (final campaign in state.campaigns) {
      if (campaign.status == 'sent') {
        totalSent++;
        totalDelivered += campaign.deliveredCount ?? 0;
        totalOpened += campaign.openedCount ?? 0;
      }
    }

    final avgOpenRate = totalDelivered > 0
        ? (totalOpened / totalDelivered * 100)
        : 0.0;

    return {
      'total': state.campaigns.length,
      'draft': state.campaigns.where((c) => c.status == 'draft').length,
      'scheduled': state.campaigns.where((c) => c.status == 'scheduled').length,
      'sent': totalSent,
      'totalDelivered': totalDelivered,
      'totalOpened': totalOpened,
      'averageOpenRate': avgOpenRate,
    };
  }
}

/// Provider for admin communications state
final adminCommunicationsProvider = StateNotifierProvider<AdminCommunicationsNotifier, AdminCommunicationsState>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AdminCommunicationsNotifier(apiClient);
});

/// Provider for campaigns list
final adminCampaignsListProvider = Provider<List<Campaign>>((ref) {
  final commsState = ref.watch(adminCommunicationsProvider);
  return commsState.campaigns;
});

/// Provider for campaign statistics
final adminCampaignStatisticsProvider = Provider<Map<String, dynamic>>((ref) {
  final notifier = ref.watch(adminCommunicationsProvider.notifier);
  return notifier.getCampaignStatistics();
});

/// Provider for checking if communications is loading
final adminCommunicationsLoadingProvider = Provider<bool>((ref) {
  final commsState = ref.watch(adminCommunicationsProvider);
  return commsState.isLoading;
});

/// Provider for communications error
final adminCommunicationsErrorProvider = Provider<String?>((ref) {
  final commsState = ref.watch(adminCommunicationsProvider);
  return commsState.error;
});
