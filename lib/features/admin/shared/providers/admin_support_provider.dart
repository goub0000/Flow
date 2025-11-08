import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// Support ticket model
class SupportTicket {
  final String id;
  final String userId;
  final String userName;
  final String userRole;
  final String subject;
  final String description;
  final String category; // 'technical', 'billing', 'account', 'course', 'other'
  final String priority; // 'low', 'medium', 'high', 'urgent'
  final String status; // 'open', 'in_progress', 'resolved', 'closed'
  final String? assignedTo;
  final List<String> messages;
  final DateTime createdAt;
  final DateTime? resolvedAt;

  const SupportTicket({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userRole,
    required this.subject,
    required this.description,
    required this.category,
    required this.priority,
    required this.status,
    this.assignedTo,
    this.messages = const [],
    required this.createdAt,
    this.resolvedAt,
  });

  static SupportTicket mockTicket(int index) {
    final categories = ['technical', 'billing', 'account', 'course', 'other'];
    final priorities = ['low', 'medium', 'high', 'urgent'];
    final statuses = ['open', 'in_progress', 'resolved', 'closed'];

    return SupportTicket(
      id: 'ticket_$index',
      userId: 'user_$index',
      userName: 'User ${index + 1}',
      userRole: 'student',
      subject: 'Support Issue ${index + 1}',
      description: 'Description for support ticket ${index + 1}',
      category: categories[index % categories.length],
      priority: priorities[index % priorities.length],
      status: statuses[index % statuses.length],
      assignedTo: index % 2 == 0 ? 'Admin ${index % 3 + 1}' : null,
      messages: [],
      createdAt: DateTime.now().subtract(Duration(days: index)),
      resolvedAt: index % 4 == 0 ? DateTime.now().subtract(Duration(hours: index)) : null,
    );
  }
}

/// State class for admin support
class AdminSupportState {
  final List<SupportTicket> tickets;
  final bool isLoading;
  final String? error;

  const AdminSupportState({
    this.tickets = const [],
    this.isLoading = false,
    this.error,
  });

  AdminSupportState copyWith({
    List<SupportTicket>? tickets,
    bool? isLoading,
    String? error,
  }) {
    return AdminSupportState(
      tickets: tickets ?? this.tickets,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// StateNotifier for admin support
class AdminSupportNotifier extends StateNotifier<AdminSupportState> {
  AdminSupportNotifier() : super(const AdminSupportState()) {
    fetchTickets();
  }

  /// Fetch all support tickets
  /// TODO: Connect to backend API (Firebase Firestore)
  Future<void> fetchTickets() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: Replace with actual Firebase query
      await Future.delayed(const Duration(seconds: 1));

      final mockTickets = List.generate(
        30,
        (index) => SupportTicket.mockTicket(index),
      );

      state = state.copyWith(
        tickets: mockTickets,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch tickets: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Update ticket status
  /// TODO: Connect to backend API (Firebase Firestore)
  Future<bool> updateTicketStatus(String ticketId, String newStatus) async {
    try {
      // TODO: Update in Firebase
      await Future.delayed(const Duration(milliseconds: 300));

      final updatedTickets = state.tickets.map((ticket) {
        if (ticket.id == ticketId) {
          return SupportTicket(
            id: ticket.id,
            userId: ticket.userId,
            userName: ticket.userName,
            userRole: ticket.userRole,
            subject: ticket.subject,
            description: ticket.description,
            category: ticket.category,
            priority: ticket.priority,
            status: newStatus,
            assignedTo: ticket.assignedTo,
            messages: ticket.messages,
            createdAt: ticket.createdAt,
            resolvedAt: newStatus == 'resolved' || newStatus == 'closed'
                ? DateTime.now()
                : ticket.resolvedAt,
          );
        }
        return ticket;
      }).toList();

      state = state.copyWith(tickets: updatedTickets);

      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to update ticket status: ${e.toString()}',
      );
      return false;
    }
  }

  /// Assign ticket to admin
  /// TODO: Connect to backend API (Firebase Firestore)
  Future<bool> assignTicket(String ticketId, String adminName) async {
    try {
      // TODO: Update in Firebase
      await Future.delayed(const Duration(milliseconds: 300));

      final updatedTickets = state.tickets.map((ticket) {
        if (ticket.id == ticketId) {
          return SupportTicket(
            id: ticket.id,
            userId: ticket.userId,
            userName: ticket.userName,
            userRole: ticket.userRole,
            subject: ticket.subject,
            description: ticket.description,
            category: ticket.category,
            priority: ticket.priority,
            status: 'in_progress',
            assignedTo: adminName,
            messages: ticket.messages,
            createdAt: ticket.createdAt,
            resolvedAt: ticket.resolvedAt,
          );
        }
        return ticket;
      }).toList();

      state = state.copyWith(tickets: updatedTickets);

      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to assign ticket: ${e.toString()}',
      );
      return false;
    }
  }

  /// Add response to ticket
  /// TODO: Connect to backend API (Firebase Firestore)
  Future<bool> addResponse(String ticketId, String message) async {
    try {
      // TODO: Add message to Firebase and notify user
      await Future.delayed(const Duration(milliseconds: 500));

      final updatedTickets = state.tickets.map((ticket) {
        if (ticket.id == ticketId) {
          return SupportTicket(
            id: ticket.id,
            userId: ticket.userId,
            userName: ticket.userName,
            userRole: ticket.userRole,
            subject: ticket.subject,
            description: ticket.description,
            category: ticket.category,
            priority: ticket.priority,
            status: ticket.status,
            assignedTo: ticket.assignedTo,
            messages: [...ticket.messages, message],
            createdAt: ticket.createdAt,
            resolvedAt: ticket.resolvedAt,
          );
        }
        return ticket;
      }).toList();

      state = state.copyWith(tickets: updatedTickets);

      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to add response: ${e.toString()}',
      );
      return false;
    }
  }

  /// Filter tickets
  List<SupportTicket> filterTickets({
    String? status,
    String? category,
    String? priority,
  }) {
    var filtered = state.tickets;

    if (status != null && status != 'all') {
      filtered = filtered.where((t) => t.status == status).toList();
    }

    if (category != null && category != 'all') {
      filtered = filtered.where((t) => t.category == category).toList();
    }

    if (priority != null && priority != 'all') {
      filtered = filtered.where((t) => t.priority == priority).toList();
    }

    return filtered;
  }

  /// Get ticket statistics
  Map<String, int> getTicketStatistics() {
    return {
      'total': state.tickets.length,
      'open': state.tickets.where((t) => t.status == 'open').length,
      'inProgress': state.tickets.where((t) => t.status == 'in_progress').length,
      'resolved': state.tickets.where((t) => t.status == 'resolved').length,
      'closed': state.tickets.where((t) => t.status == 'closed').length,
      'urgent': state.tickets.where((t) => t.priority == 'urgent').length,
    };
  }

  /// Get average resolution time (in hours)
  double getAverageResolutionTime() {
    final resolvedTickets = state.tickets.where((t) => t.resolvedAt != null);

    if (resolvedTickets.isEmpty) return 0.0;

    int totalHours = 0;
    for (final ticket in resolvedTickets) {
      final diff = ticket.resolvedAt!.difference(ticket.createdAt);
      totalHours += diff.inHours;
    }

    return totalHours / resolvedTickets.length;
  }
}

/// Provider for admin support state
final adminSupportProvider = StateNotifierProvider<AdminSupportNotifier, AdminSupportState>((ref) {
  return AdminSupportNotifier();
});

/// Provider for tickets list
final adminTicketsListProvider = Provider<List<SupportTicket>>((ref) {
  final supportState = ref.watch(adminSupportProvider);
  return supportState.tickets;
});

/// Provider for ticket statistics
final adminTicketStatisticsProvider = Provider<Map<String, int>>((ref) {
  final notifier = ref.watch(adminSupportProvider.notifier);
  return notifier.getTicketStatistics();
});

/// Provider for average resolution time
final adminAverageResolutionTimeProvider = Provider<double>((ref) {
  final notifier = ref.watch(adminSupportProvider.notifier);
  return notifier.getAverageResolutionTime();
});

/// Provider for checking if support is loading
final adminSupportLoadingProvider = Provider<bool>((ref) {
  final supportState = ref.watch(adminSupportProvider);
  return supportState.isLoading;
});

/// Provider for support error
final adminSupportErrorProvider = Provider<String?>((ref) {
  final supportState = ref.watch(adminSupportProvider);
  return supportState.error;
});
