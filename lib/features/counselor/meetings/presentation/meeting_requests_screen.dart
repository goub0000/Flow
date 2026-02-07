// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/meeting_models.dart';
import '../../../../core/providers/meetings_provider.dart';
import '../../../shared/widgets/custom_card.dart';

class MeetingRequestsScreen extends ConsumerStatefulWidget {
  const MeetingRequestsScreen({super.key});

  @override
  ConsumerState<MeetingRequestsScreen> createState() =>
      _MeetingRequestsScreenState();
}

class _MeetingRequestsScreenState extends ConsumerState<MeetingRequestsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final meetingsState = ref.watch(staffMeetingsProvider);
    final meetingsNotifier = ref.read(staffMeetingsProvider.notifier);
    final pendingRequests = ref.watch(staffPendingRequestsProvider);
    final upcomingMeetings = ref.watch(staffUpcomingMeetingsProvider);
    final todayMeetings = ref.watch(staffTodayMeetingsProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
          tooltip: context.l10n.counselorMeetingBack,
        ),
        title: Text(context.l10n.counselorMeetingRequests),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => meetingsNotifier.fetchMeetings(),
            tooltip: context.l10n.counselorMeetingRefresh,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              icon: Badge(
                label: Text('${pendingRequests.length}'),
                isLabelVisible: pendingRequests.isNotEmpty,
                child: const Icon(Icons.pending_actions),
              ),
              text: context.l10n.counselorMeetingPending,
            ),
            Tab(
              icon: Badge(
                label: Text('${todayMeetings.length}'),
                isLabelVisible: todayMeetings.isNotEmpty,
                child: const Icon(Icons.today),
              ),
              text: context.l10n.counselorMeetingToday,
            ),
            Tab(
              icon: Badge(
                label: Text('${upcomingMeetings.length}'),
                isLabelVisible: upcomingMeetings.isNotEmpty,
                child: const Icon(Icons.event),
              ),
              text: context.l10n.counselorMeetingUpcoming,
            ),
          ],
        ),
      ),
      body: meetingsState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildPendingTab(pendingRequests, meetingsNotifier),
                _buildTodayTab(todayMeetings, meetingsNotifier),
                _buildUpcomingTab(upcomingMeetings, meetingsNotifier),
              ],
            ),
    );
  }

  Widget _buildPendingTab(
    List<Meeting> meetings,
    StaffMeetingsNotifier notifier,
  ) {
    if (meetings.isEmpty) {
      return _buildEmptyState(
        icon: Icons.inbox,
        title: context.l10n.counselorMeetingNoPendingRequests,
        message: context.l10n.counselorMeetingNoPendingRequestsMessage,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: meetings.length,
      itemBuilder: (context, index) {
        final meeting = meetings[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildPendingRequestCard(meeting, notifier),
        );
      },
    );
  }

  Widget _buildTodayTab(
    List<Meeting> meetings,
    StaffMeetingsNotifier notifier,
  ) {
    if (meetings.isEmpty) {
      return _buildEmptyState(
        icon: Icons.event_busy,
        title: context.l10n.counselorMeetingNoMeetingsToday,
        message: context.l10n.counselorMeetingNoMeetingsTodayMessage,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: meetings.length,
      itemBuilder: (context, index) {
        final meeting = meetings[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildMeetingCard(meeting, notifier, isToday: true),
        );
      },
    );
  }

  Widget _buildUpcomingTab(
    List<Meeting> meetings,
    StaffMeetingsNotifier notifier,
  ) {
    if (meetings.isEmpty) {
      return _buildEmptyState(
        icon: Icons.event_available,
        title: context.l10n.counselorMeetingNoUpcomingMeetings,
        message: context.l10n.counselorMeetingNoUpcomingMeetingsMessage,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: meetings.length,
      itemBuilder: (context, index) {
        final meeting = meetings[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildMeetingCard(meeting, notifier),
        );
      },
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String message,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: AppColors.textSecondary),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPendingRequestCard(
    Meeting meeting,
    StaffMeetingsNotifier notifier,
  ) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                child: Text(
                  meeting.studentName?.substring(0, 1).toUpperCase() ?? 'S',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meeting.parentName ?? context.l10n.counselorMeetingParent,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      context.l10n.counselorMeetingStudentLabel(meeting.studentName ?? context.l10n.counselorMeetingUnknown),
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  context.l10n.counselorMeetingPendingBadge,
                  style: TextStyle(
                    color: AppColors.warning,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 24),

          // Subject
          Row(
            children: [
              Icon(Icons.subject, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  meeting.subject,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Meeting Details
          _buildDetailRow(
            Icons.schedule,
            context.l10n.counselorMeetingMinutes('${meeting.durationMinutes}'),
          ),
          _buildDetailRow(
            _getMeetingModeIcon(meeting.meetingMode),
            meeting.meetingMode.displayName,
          ),
          if (meeting.scheduledDate != null)
            _buildDetailRow(
              Icons.calendar_today,
              context.l10n.counselorMeetingRequested(DateFormat('MMM d, y - h:mm a').format(meeting.scheduledDate!)),
            ),
          if (meeting.parentNotes != null && meeting.parentNotes!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.textSecondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.notes, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      meeting.parentNotes!,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showDeclineDialog(meeting, notifier),
                  icon: const Icon(Icons.close, size: 18),
                  label: Text(context.l10n.counselorMeetingDecline),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showApproveDialog(meeting, notifier),
                  icon: const Icon(Icons.check, size: 18),
                  label: Text(context.l10n.counselorMeetingApprove),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    foregroundColor: AppColors.textOnPrimary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMeetingCard(
    Meeting meeting,
    StaffMeetingsNotifier notifier, {
    bool isToday = false,
  }) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.success.withValues(alpha: 0.2),
                child: Text(
                  meeting.studentName?.substring(0, 1).toUpperCase() ?? 'S',
                  style: const TextStyle(
                    color: AppColors.success,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meeting.parentName ?? context.l10n.counselorMeetingParent,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      context.l10n.counselorMeetingStudentLabel(meeting.studentName ?? context.l10n.counselorMeetingUnknown),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (meeting.isUrgent)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.warning_amber, size: 12, color: AppColors.warning),
                      const SizedBox(width: 4),
                      Text(
                        context.l10n.counselorMeetingSoon,
                        style: TextStyle(
                          color: AppColors.warning,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Subject
          Text(
            meeting.subject,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 8),

          // Meeting Details
          if (meeting.scheduledDate != null) ...[
            _buildDetailRow(
              Icons.calendar_today,
              DateFormat('EEEE, MMM d, y').format(meeting.scheduledDate!),
            ),
            _buildDetailRow(
              Icons.access_time,
              context.l10n.counselorMeetingTimeWithDuration(DateFormat('h:mm a').format(meeting.scheduledDate!), '${meeting.durationMinutes}'),
            ),
          ],
          _buildDetailRow(
            _getMeetingModeIcon(meeting.meetingMode),
            meeting.meetingMode.displayName,
          ),
          if (meeting.meetingLink != null && meeting.meetingLink!.isNotEmpty)
            _buildDetailRow(
              Icons.link,
              meeting.meetingLink!,
              isLink: true,
            ),
          if (meeting.location != null && meeting.location!.isNotEmpty)
            _buildDetailRow(
              Icons.location_on,
              meeting.location!,
            ),
          const SizedBox(height: 8),

          // Cancel Button
          OutlinedButton.icon(
            onPressed: () => _showCancelDialog(meeting, notifier),
            icon: const Icon(Icons.cancel_outlined, size: 16),
            label: Text(context.l10n.counselorMeetingCancelMeeting),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text, {bool isLink = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: isLink ? AppColors.primary : AppColors.textSecondary,
                decoration: isLink ? TextDecoration.underline : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getMeetingModeIcon(MeetingMode mode) {
    switch (mode) {
      case MeetingMode.videoCall:
        return Icons.videocam;
      case MeetingMode.phoneCall:
        return Icons.phone;
      case MeetingMode.inPerson:
        return Icons.meeting_room;
    }
  }

  void _showApproveDialog(Meeting meeting, StaffMeetingsNotifier notifier) {
    DateTime? selectedDate = meeting.scheduledDate;
    TimeOfDay? selectedTime = meeting.scheduledDate != null
        ? TimeOfDay.fromDateTime(meeting.scheduledDate!)
        : null;
    int duration = meeting.durationMinutes;
    final linkController = TextEditingController(text: meeting.meetingLink);
    final locationController = TextEditingController(text: meeting.location);
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(context.l10n.counselorMeetingApproveMeeting),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.counselorMeetingApproveWith(meeting.parentName ?? '')),
                const SizedBox(height: 16),

                // Date & Time
                OutlinedButton.icon(
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate ?? DateTime.now().add(const Duration(days: 1)),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 90)),
                    );
                    if (date != null) {
                      setState(() => selectedDate = date);
                    }
                  },
                  icon: const Icon(Icons.calendar_today),
                  label: Text(
                    selectedDate != null
                        ? DateFormat('MMM d, y').format(selectedDate!)
                        : context.l10n.counselorMeetingSelectDate,
                  ),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: selectedTime ?? TimeOfDay.now(),
                    );
                    if (time != null) {
                      setState(() => selectedTime = time);
                    }
                  },
                  icon: const Icon(Icons.access_time),
                  label: Text(
                    selectedTime != null
                        ? selectedTime!.format(context)
                        : context.l10n.counselorMeetingSelectTime,
                  ),
                ),
                const SizedBox(height: 12),

                // Duration
                DropdownButtonFormField<int>(
                  value: duration,
                  decoration: InputDecoration(
                    labelText: context.l10n.counselorMeetingDuration,
                    border: const OutlineInputBorder(),
                  ),
                  items: [
                    DropdownMenuItem(value: 15, child: Text(context.l10n.counselorMeetingMinutes('15'))),
                    DropdownMenuItem(value: 30, child: Text(context.l10n.counselorMeetingMinutes('30'))),
                    DropdownMenuItem(value: 45, child: Text(context.l10n.counselorMeetingMinutes('45'))),
                    DropdownMenuItem(value: 60, child: Text(context.l10n.counselorMeeting1Hour)),
                    DropdownMenuItem(value: 90, child: Text(context.l10n.counselorMeeting1Point5Hours)),
                    DropdownMenuItem(value: 120, child: Text(context.l10n.counselorMeeting2Hours)),
                  ],
                  onChanged: (value) {
                    if (value != null) setState(() => duration = value);
                  },
                ),
                const SizedBox(height: 12),

                // Meeting Link (for video calls)
                if (meeting.meetingMode == MeetingMode.videoCall)
                  TextField(
                    controller: linkController,
                    decoration: InputDecoration(
                      labelText: context.l10n.counselorMeetingMeetingLink,
                      hintText: 'https://meet.google.com/...',
                      border: const OutlineInputBorder(),
                    ),
                  ),

                // Location (for in-person)
                if (meeting.meetingMode == MeetingMode.inPerson) ...[
                  const SizedBox(height: 12),
                  TextField(
                    controller: locationController,
                    decoration: InputDecoration(
                      labelText: context.l10n.counselorMeetingLocation,
                      hintText: context.l10n.counselorMeetingLocationHint,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ],
                const SizedBox(height: 12),

                // Notes
                TextField(
                  controller: notesController,
                  decoration: InputDecoration(
                    labelText: context.l10n.counselorMeetingNotesOptional,
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(context.l10n.counselorMeetingCancel),
            ),
            ElevatedButton(
              onPressed: selectedDate != null && selectedTime != null
                  ? () async {
                      final scheduledDateTime = DateTime(
                        selectedDate!.year,
                        selectedDate!.month,
                        selectedDate!.day,
                        selectedTime!.hour,
                        selectedTime!.minute,
                      );

                      final approval = MeetingApprovalDTO(
                        scheduledDate: scheduledDateTime,
                        durationMinutes: duration,
                        meetingLink: linkController.text.trim().isEmpty
                            ? null
                            : linkController.text.trim(),
                        location: locationController.text.trim().isEmpty
                            ? null
                            : locationController.text.trim(),
                        staffNotes: notesController.text.trim().isEmpty
                            ? null
                            : notesController.text.trim(),
                      );

                      final success = await notifier.approveMeeting(
                        meetingId: meeting.id,
                        approvalData: approval,
                      );

                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              success
                                  ? context.l10n.counselorMeetingApprovedSuccessfully
                                  : context.l10n.counselorMeetingFailedToApprove,
                            ),
                            backgroundColor:
                                success ? AppColors.success : AppColors.error,
                          ),
                        );
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                foregroundColor: AppColors.textOnPrimary,
              ),
              child: Text(context.l10n.counselorMeetingApprove),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeclineDialog(Meeting meeting, StaffMeetingsNotifier notifier) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.counselorMeetingDeclineMeeting),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.counselorMeetingDeclineFrom(meeting.parentName ?? '')),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: InputDecoration(
                labelText: context.l10n.counselorMeetingReasonForDeclining,
                hintText: context.l10n.counselorMeetingProvideReason,
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.counselorMeetingCancel),
          ),
          ElevatedButton(
            onPressed: () async {
              if (reasonController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(context.l10n.counselorMeetingPleaseProvideReason),
                    backgroundColor: AppColors.error,
                  ),
                );
                return;
              }

              final decline = MeetingDeclineDTO(
                staffNotes: reasonController.text.trim(),
              );

              final success = await notifier.declineMeeting(
                meetingId: meeting.id,
                declineData: decline,
              );

              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success ? context.l10n.counselorMeetingDeclined : context.l10n.counselorMeetingFailedToDecline,
                    ),
                    backgroundColor: success ? AppColors.success : AppColors.error,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.textOnPrimary,
            ),
            child: Text(context.l10n.counselorMeetingDecline),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(Meeting meeting, StaffMeetingsNotifier notifier) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.counselorMeetingCancelMeeting),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.counselorMeetingCancelWith(meeting.parentName ?? '')),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: InputDecoration(
                labelText: context.l10n.counselorMeetingCancellationReasonOptional,
                border: const OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.counselorMeetingBackButton),
          ),
          ElevatedButton(
            onPressed: () async {
              final success = await notifier.cancelMeeting(
                meetingId: meeting.id,
                cancellationReason: reasonController.text.trim().isEmpty
                    ? null
                    : reasonController.text.trim(),
              );

              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success ? context.l10n.counselorMeetingCancelled : context.l10n.counselorMeetingFailedToCancel,
                    ),
                    backgroundColor: success ? AppColors.success : AppColors.error,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.textOnPrimary,
            ),
            child: Text(context.l10n.counselorMeetingCancelMeeting),
          ),
        ],
      ),
    );
  }
}
