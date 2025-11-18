import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/meeting_models.dart';
import '../services/meetings_api_service.dart';
import '../../features/authentication/providers/auth_provider.dart';

/// Provider for Meetings API Service with authentication
final meetingsApiServiceProvider = Provider.autoDispose<MeetingsApiService>((ref) {
  final authState = ref.watch(authProvider);
  return MeetingsApiService(accessToken: authState.accessToken);
});

// ==================== Parent Meetings State ====================

/// State class for parent meetings
class ParentMeetingsState {
  final List<Meeting> meetings;
  final bool isLoading;
  final String? error;
  final String? statusFilter;

  const ParentMeetingsState({
    this.meetings = const [],
    this.isLoading = false,
    this.error,
    this.statusFilter,
  });

  ParentMeetingsState copyWith({
    List<Meeting>? meetings,
    bool? isLoading,
    String? error,
    String? statusFilter,
  }) {
    return ParentMeetingsState(
      meetings: meetings ?? this.meetings,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      statusFilter: statusFilter ?? this.statusFilter,
    );
  }
}

/// StateNotifier for parent meetings
class ParentMeetingsNotifier extends StateNotifier<ParentMeetingsState> {
  final MeetingsApiService _apiService;
  final String _parentId;

  ParentMeetingsNotifier(this._apiService, this._parentId)
      : super(const ParentMeetingsState()) {
    fetchMeetings();
  }

  /// Fetch parent meetings
  Future<void> fetchMeetings({String? statusFilter}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final meetings = await _apiService.getParentMeetings(
        parentId: _parentId,
        statusFilter: statusFilter,
      );

      state = state.copyWith(
        meetings: meetings,
        isLoading: false,
        statusFilter: statusFilter,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch meetings: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Request a new meeting
  Future<bool> requestMeeting(MeetingRequestDTO meetingData) async {
    try {
      final meeting = await _apiService.requestMeeting(meetingData);
      final updatedMeetings = [...state.meetings, meeting];
      state = state.copyWith(meetings: updatedMeetings);
      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to request meeting: ${e.toString()}',
      );
      return false;
    }
  }

  /// Cancel a meeting
  Future<bool> cancelMeeting({
    required String meetingId,
    String? cancellationReason,
  }) async {
    try {
      final updatedMeeting = await _apiService.cancelMeeting(
        meetingId: meetingId,
        cancellationReason: cancellationReason,
      );

      final updatedMeetings = state.meetings.map((m) {
        return m.id == meetingId ? updatedMeeting : m;
      }).toList();

      state = state.copyWith(meetings: updatedMeetings);
      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to cancel meeting: ${e.toString()}',
      );
      return false;
    }
  }

  /// Get upcoming meetings
  List<Meeting> getUpcomingMeetings() {
    return state.meetings.where((m) => m.isUpcoming).toList()
      ..sort((a, b) => a.scheduledDate!.compareTo(b.scheduledDate!));
  }

  /// Get pending meetings
  List<Meeting> getPendingMeetings() {
    return state.meetings
        .where((m) => m.status == MeetingStatus.pending)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// Get past meetings
  List<Meeting> getPastMeetings() {
    return state.meetings.where((m) => m.isPast).toList()
      ..sort((a, b) => b.scheduledDate!.compareTo(a.scheduledDate!));
  }
}

// ==================== Staff Meetings State ====================

/// State class for staff meetings
class StaffMeetingsState {
  final List<Meeting> meetings;
  final bool isLoading;
  final String? error;
  final String? statusFilter;

  const StaffMeetingsState({
    this.meetings = const [],
    this.isLoading = false,
    this.error,
    this.statusFilter,
  });

  StaffMeetingsState copyWith({
    List<Meeting>? meetings,
    bool? isLoading,
    String? error,
    String? statusFilter,
  }) {
    return StaffMeetingsState(
      meetings: meetings ?? this.meetings,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      statusFilter: statusFilter ?? this.statusFilter,
    );
  }
}

/// StateNotifier for staff meetings
class StaffMeetingsNotifier extends StateNotifier<StaffMeetingsState> {
  final MeetingsApiService _apiService;
  final String _staffId;

  StaffMeetingsNotifier(this._apiService, this._staffId)
      : super(const StaffMeetingsState()) {
    fetchMeetings();
  }

  /// Fetch staff meetings
  Future<void> fetchMeetings({String? statusFilter}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final meetings = await _apiService.getStaffMeetings(
        staffId: _staffId,
        statusFilter: statusFilter,
      );

      state = state.copyWith(
        meetings: meetings,
        isLoading: false,
        statusFilter: statusFilter,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch meetings: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Approve a meeting
  Future<bool> approveMeeting({
    required String meetingId,
    required MeetingApprovalDTO approvalData,
  }) async {
    try {
      final updatedMeeting = await _apiService.approveMeeting(
        meetingId: meetingId,
        approvalData: approvalData,
      );

      final updatedMeetings = state.meetings.map((m) {
        return m.id == meetingId ? updatedMeeting : m;
      }).toList();

      state = state.copyWith(meetings: updatedMeetings);
      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to approve meeting: ${e.toString()}',
      );
      return false;
    }
  }

  /// Decline a meeting
  Future<bool> declineMeeting({
    required String meetingId,
    required MeetingDeclineDTO declineData,
  }) async {
    try {
      final updatedMeeting = await _apiService.declineMeeting(
        meetingId: meetingId,
        declineData: declineData,
      );

      final updatedMeetings = state.meetings.map((m) {
        return m.id == meetingId ? updatedMeeting : m;
      }).toList();

      state = state.copyWith(meetings: updatedMeetings);
      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to decline meeting: ${e.toString()}',
      );
      return false;
    }
  }

  /// Cancel a meeting
  Future<bool> cancelMeeting({
    required String meetingId,
    String? cancellationReason,
  }) async {
    try {
      final updatedMeeting = await _apiService.cancelMeeting(
        meetingId: meetingId,
        cancellationReason: cancellationReason,
      );

      final updatedMeetings = state.meetings.map((m) {
        return m.id == meetingId ? updatedMeeting : m;
      }).toList();

      state = state.copyWith(meetings: updatedMeetings);
      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to cancel meeting: ${e.toString()}',
      );
      return false;
    }
  }

  /// Get pending requests (meetings awaiting approval)
  List<Meeting> getPendingRequests() {
    return state.meetings
        .where((m) => m.status == MeetingStatus.pending)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// Get upcoming approved meetings
  List<Meeting> getUpcomingMeetings() {
    return state.meetings.where((m) => m.isUpcoming).toList()
      ..sort((a, b) => a.scheduledDate!.compareTo(b.scheduledDate!));
  }

  /// Get today's meetings
  List<Meeting> getTodayMeetings() {
    final now = DateTime.now();
    return state.meetings.where((m) {
      return m.scheduledDate != null &&
          m.scheduledDate!.year == now.year &&
          m.scheduledDate!.month == now.month &&
          m.scheduledDate!.day == now.day &&
          m.status == MeetingStatus.approved;
    }).toList()
      ..sort((a, b) => a.scheduledDate!.compareTo(b.scheduledDate!));
  }
}

// ==================== Staff Availability State ====================

/// State class for staff availability
class StaffAvailabilityState {
  final List<StaffAvailability> availabilitySlots;
  final bool isLoading;
  final String? error;

  const StaffAvailabilityState({
    this.availabilitySlots = const [],
    this.isLoading = false,
    this.error,
  });

  StaffAvailabilityState copyWith({
    List<StaffAvailability>? availabilitySlots,
    bool? isLoading,
    String? error,
  }) {
    return StaffAvailabilityState(
      availabilitySlots: availabilitySlots ?? this.availabilitySlots,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// StateNotifier for staff availability
class StaffAvailabilityNotifier extends StateNotifier<StaffAvailabilityState> {
  final MeetingsApiService _apiService;
  final String _staffId;

  StaffAvailabilityNotifier(this._apiService, this._staffId)
      : super(const StaffAvailabilityState()) {
    fetchAvailability();
  }

  /// Fetch staff availability
  Future<void> fetchAvailability() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final availability = await _apiService.getStaffAvailability(_staffId);

      state = state.copyWith(
        availabilitySlots: availability,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch availability: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Set availability
  Future<bool> setAvailability({
    required int dayOfWeek,
    required String startTime,
    required String endTime,
  }) async {
    try {
      final availability = await _apiService.setStaffAvailability(
        dayOfWeek: dayOfWeek,
        startTime: startTime,
        endTime: endTime,
      );

      final updatedSlots = [...state.availabilitySlots, availability];
      state = state.copyWith(availabilitySlots: updatedSlots);
      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to set availability: ${e.toString()}',
      );
      return false;
    }
  }

  /// Update availability
  Future<bool> updateAvailability({
    required String availabilityId,
    String? startTime,
    String? endTime,
    bool? isActive,
  }) async {
    try {
      final updatedAvailability = await _apiService.updateStaffAvailability(
        availabilityId: availabilityId,
        startTime: startTime,
        endTime: endTime,
        isActive: isActive,
      );

      final updatedSlots = state.availabilitySlots.map((a) {
        return a.id == availabilityId ? updatedAvailability : a;
      }).toList();

      state = state.copyWith(availabilitySlots: updatedSlots);
      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to update availability: ${e.toString()}',
      );
      return false;
    }
  }

  /// Delete availability
  Future<bool> deleteAvailability(String availabilityId) async {
    try {
      await _apiService.deleteStaffAvailability(availabilityId);

      final updatedSlots = state.availabilitySlots
          .where((a) => a.id != availabilityId)
          .toList();

      state = state.copyWith(availabilitySlots: updatedSlots);
      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to delete availability: ${e.toString()}',
      );
      return false;
    }
  }
}

// ==================== Staff List State ====================

/// State class for staff list
class StaffListState {
  final List<StaffMember> staffList;
  final bool isLoading;
  final String? error;
  final String? roleFilter;

  const StaffListState({
    this.staffList = const [],
    this.isLoading = false,
    this.error,
    this.roleFilter,
  });

  StaffListState copyWith({
    List<StaffMember>? staffList,
    bool? isLoading,
    String? error,
    String? roleFilter,
  }) {
    return StaffListState(
      staffList: staffList ?? this.staffList,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      roleFilter: roleFilter ?? this.roleFilter,
    );
  }
}

/// StateNotifier for staff list
class StaffListNotifier extends StateNotifier<StaffListState> {
  final MeetingsApiService _apiService;

  StaffListNotifier(this._apiService) : super(const StaffListState()) {
    fetchStaffList();
  }

  /// Fetch staff list
  Future<void> fetchStaffList({String? role}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final staffList = await _apiService.getStaffList(role: role);

      state = state.copyWith(
        staffList: staffList,
        isLoading: false,
        roleFilter: role,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch staff list: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Filter by role
  List<StaffMember> filterByRole(StaffType role) {
    return state.staffList.where((s) => s.role == role).toList();
  }

  /// Get teachers
  List<StaffMember> getTeachers() {
    return filterByRole(StaffType.teacher);
  }

  /// Get counselors
  List<StaffMember> getCounselors() {
    return filterByRole(StaffType.counselor);
  }
}

// ==================== Providers ====================

/// Parent meetings provider (requires parent ID from auth)
final parentMeetingsProvider =
    StateNotifierProvider.autoDispose<ParentMeetingsNotifier, ParentMeetingsState>((ref) {
  final apiService = ref.watch(meetingsApiServiceProvider);
  final authState = ref.watch(authProvider);
  final parentId = authState.user?.id ?? '';
  return ParentMeetingsNotifier(apiService, parentId);
});

/// Staff meetings provider (requires staff ID from auth)
final staffMeetingsProvider =
    StateNotifierProvider.autoDispose<StaffMeetingsNotifier, StaffMeetingsState>((ref) {
  final apiService = ref.watch(meetingsApiServiceProvider);
  final authState = ref.watch(authProvider);
  final staffId = authState.user?.id ?? '';
  return StaffMeetingsNotifier(apiService, staffId);
});

/// Staff availability provider (requires staff ID from auth)
final staffAvailabilityProvider =
    StateNotifierProvider.autoDispose<StaffAvailabilityNotifier, StaffAvailabilityState>((ref) {
  final apiService = ref.watch(meetingsApiServiceProvider);
  final authState = ref.watch(authProvider);
  final staffId = authState.user?.id ?? '';
  return StaffAvailabilityNotifier(apiService, staffId);
});

/// Staff list provider
final staffListProvider =
    StateNotifierProvider.autoDispose<StaffListNotifier, StaffListState>((ref) {
  final apiService = ref.watch(meetingsApiServiceProvider);
  return StaffListNotifier(apiService);
});

// ==================== Derived Providers ====================

/// Parent's upcoming meetings
final parentUpcomingMeetingsProvider = Provider.autoDispose<List<Meeting>>((ref) {
  final notifier = ref.watch(parentMeetingsProvider.notifier);
  return notifier.getUpcomingMeetings();
});

/// Parent's pending meetings
final parentPendingMeetingsProvider = Provider.autoDispose<List<Meeting>>((ref) {
  final notifier = ref.watch(parentMeetingsProvider.notifier);
  return notifier.getPendingMeetings();
});

/// Parent's past meetings
final parentPastMeetingsProvider = Provider.autoDispose<List<Meeting>>((ref) {
  final notifier = ref.watch(parentMeetingsProvider.notifier);
  return notifier.getPastMeetings();
});

/// Staff's pending requests
final staffPendingRequestsProvider = Provider.autoDispose<List<Meeting>>((ref) {
  final notifier = ref.watch(staffMeetingsProvider.notifier);
  return notifier.getPendingRequests();
});

/// Staff's upcoming meetings
final staffUpcomingMeetingsProvider = Provider.autoDispose<List<Meeting>>((ref) {
  final notifier = ref.watch(staffMeetingsProvider.notifier);
  return notifier.getUpcomingMeetings();
});

/// Staff's today's meetings
final staffTodayMeetingsProvider = Provider.autoDispose<List<Meeting>>((ref) {
  final notifier = ref.watch(staffMeetingsProvider.notifier);
  return notifier.getTodayMeetings();
});

/// Teachers list
final teachersListProvider = Provider.autoDispose<List<StaffMember>>((ref) {
  final notifier = ref.watch(staffListProvider.notifier);
  return notifier.getTeachers();
});

/// Counselors list
final counselorsListProvider = Provider.autoDispose<List<StaffMember>>((ref) {
  final notifier = ref.watch(staffListProvider.notifier);
  return notifier.getCounselors();
});

/// Meeting statistics provider
final meetingStatisticsProvider = FutureProvider.autoDispose<MeetingStatistics>((ref) async {
  final apiService = ref.watch(meetingsApiServiceProvider);
  return await apiService.getMeetingStatistics();
});

/// Available slots provider (family with parameters)
final availableSlotsProvider = FutureProvider.autoDispose
    .family<List<AvailableSlot>, AvailableSlotsParams>((ref, params) async {
  final apiService = ref.watch(meetingsApiServiceProvider);
  return await apiService.getAvailableSlots(
    staffId: params.staffId,
    startDate: params.startDate,
    endDate: params.endDate,
    durationMinutes: params.durationMinutes,
  );
});

/// Parameters for available slots request
class AvailableSlotsParams {
  final String staffId;
  final DateTime startDate;
  final DateTime endDate;
  final int durationMinutes;

  AvailableSlotsParams({
    required this.staffId,
    required this.startDate,
    required this.endDate,
    required this.durationMinutes,
  });
}

/// Single meeting provider (family with meeting ID)
final singleMeetingProvider =
    FutureProvider.autoDispose.family<Meeting, String>((ref, meetingId) async {
  final apiService = ref.watch(meetingsApiServiceProvider);
  return await apiService.getMeeting(meetingId);
});
