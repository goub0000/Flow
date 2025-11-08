import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

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
  AdminCommunicationsNotifier() : super(const AdminCommunicationsState()) {
    fetchCampaigns();
  }

  /// Fetch all campaigns
  /// TODO: Connect to backend API (Firebase Firestore)
  Future<void> fetchCampaigns() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: Replace with actual Firebase query
      await Future.delayed(const Duration(seconds: 1));

      final mockCampaigns = List.generate(
        15,
        (index) => Campaign.mockCampaign(index),
      );

      state = state.copyWith(
        campaigns: mockCampaigns,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch campaigns: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Create campaign
  /// TODO: Connect to backend API (Firebase Firestore)
  Future<bool> createCampaign(Campaign campaign) async {
    try {
      // TODO: Save to Firebase
      await Future.delayed(const Duration(milliseconds: 500));

      final updatedCampaigns = [campaign, ...state.campaigns];
      state = state.copyWith(campaigns: updatedCampaigns);

      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to create campaign: ${e.toString()}',
      );
      return false;
    }
  }

  /// Send announcement to all users
  /// TODO: Connect to messaging service
  Future<bool> sendAnnouncement({
    required String title,
    required String message,
    required List<String> targetRoles,
    required String type,
  }) async {
    try {
      // TODO: Send via appropriate channel (FCM, email service, SMS)
      await Future.delayed(const Duration(seconds: 2));

      final campaign = Campaign(
        id: _uuid.v4(),
        title: title,
        type: type,
        status: 'sent',
        message: message,
        targetRoles: targetRoles,
        sentAt: DateTime.now(),
        recipientCount: 500,
        deliveredCount: 495,
        openedCount: 300,
        createdAt: DateTime.now(),
      );

      final updatedCampaigns = [campaign, ...state.campaigns];
      state = state.copyWith(campaigns: updatedCampaigns);

      return true;
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
      // TODO: Update in Firebase and set up scheduled job
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
      // TODO: Delete from Firebase
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
  return AdminCommunicationsNotifier();
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
