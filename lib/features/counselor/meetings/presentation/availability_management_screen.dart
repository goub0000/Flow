import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/meeting_models.dart';
import '../../../../core/providers/meetings_provider.dart';
import '../../../shared/widgets/custom_card.dart';

class AvailabilityManagementScreen extends ConsumerStatefulWidget {
  const AvailabilityManagementScreen({super.key});

  @override
  ConsumerState<AvailabilityManagementScreen> createState() =>
      _AvailabilityManagementScreenState();
}

class _AvailabilityManagementScreenState
    extends ConsumerState<AvailabilityManagementScreen> {
  bool _isAddingSlot = false;
  int? _selectedDay;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  List<String> _daysOfWeek(BuildContext context) => [
    context.l10n.counselorMeetingSunday,
    context.l10n.counselorMeetingMonday,
    context.l10n.counselorMeetingTuesday,
    context.l10n.counselorMeetingWednesday,
    context.l10n.counselorMeetingThursday,
    context.l10n.counselorMeetingFriday,
    context.l10n.counselorMeetingSaturday,
  ];

  @override
  Widget build(BuildContext context) {
    final availabilityState = ref.watch(staffAvailabilityProvider);
    final availabilityNotifier = ref.read(staffAvailabilityProvider.notifier);

    // Group availability by day
    final availabilityByDay = <int, List<StaffAvailability>>{};
    for (var slot in availabilityState.availabilitySlots) {
      availabilityByDay.putIfAbsent(slot.dayOfWeek, () => []).add(slot);
    }

    // Sort slots within each day
    for (var slots in availabilityByDay.values) {
      slots.sort((a, b) => a.startTime.compareTo(b.startTime));
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
          tooltip: context.l10n.counselorMeetingBack,
        ),
        title: Text(context.l10n.counselorMeetingManageAvailability),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => availabilityNotifier.fetchAvailability(),
            tooltip: context.l10n.counselorMeetingRefresh,
          ),
        ],
      ),
      body: availabilityState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Header Card
                CustomCard(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.event_available,
                          color: AppColors.primary,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.l10n.counselorMeetingWeeklyAvailability,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              context.l10n.counselorMeetingSetAvailableHours,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Error message
                if (availabilityState.error != null) ...[
                  CustomCard(
                    color: AppColors.error.withValues(alpha: 0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: AppColors.error),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              availabilityState.error!,
                              style: TextStyle(color: AppColors.error),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Weekly Schedule
                for (int day = 0; day < 7; day++) ...[
                  _buildDaySection(
                    context,
                    day,
                    _daysOfWeek(context)[day],
                    availabilityByDay[day] ?? [],
                    availabilityNotifier,
                  ),
                  const SizedBox(height: 16),
                ],

                // Add Slot Button
                if (!_isAddingSlot)
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _isAddingSlot = true;
                        _selectedDay = null;
                        _startTime = null;
                        _endTime = null;
                      });
                    },
                    icon: const Icon(Icons.add),
                    label: Text(context.l10n.counselorMeetingAddAvailabilitySlot),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textOnPrimary,
                    ),
                  ),

                // Add Slot Form
                if (_isAddingSlot) ...[
                  CustomCard(
                    color: AppColors.primary.withValues(alpha: 0.05),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.counselorMeetingAddNewAvailability,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<int>(
                            value: _selectedDay,
                            decoration: InputDecoration(
                              labelText: context.l10n.counselorMeetingDayOfWeek,
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.calendar_today),
                            ),
                            items: List.generate(
                              7,
                              (index) => DropdownMenuItem(
                                value: index,
                                child: Text(_daysOfWeek(context)[index]),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _selectedDay = value;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () async {
                                    final time = await showTimePicker(
                                      context: context,
                                      initialTime: _startTime ?? const TimeOfDay(hour: 9, minute: 0),
                                    );
                                    if (time != null) {
                                      setState(() {
                                        _startTime = time;
                                      });
                                    }
                                  },
                                  icon: const Icon(Icons.access_time),
                                  label: Text(
                                    _startTime != null
                                        ? context.l10n.counselorMeetingStartWithTime(_startTime!.format(context))
                                        : context.l10n.counselorMeetingStartTime,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () async {
                                    final time = await showTimePicker(
                                      context: context,
                                      initialTime: _endTime ?? const TimeOfDay(hour: 17, minute: 0),
                                    );
                                    if (time != null) {
                                      setState(() {
                                        _endTime = time;
                                      });
                                    }
                                  },
                                  icon: const Icon(Icons.access_time),
                                  label: Text(
                                    _endTime != null
                                        ? context.l10n.counselorMeetingEndWithTime(_endTime!.format(context))
                                        : context.l10n.counselorMeetingEndTime,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    setState(() {
                                      _isAddingSlot = false;
                                      _selectedDay = null;
                                      _startTime = null;
                                      _endTime = null;
                                    });
                                  },
                                  child: Text(context.l10n.counselorMeetingCancel),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _canSaveSlot()
                                      ? () => _saveSlot(availabilityNotifier)
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.success,
                                    foregroundColor: AppColors.textOnPrimary,
                                  ),
                                  child: Text(context.l10n.counselorMeetingSave),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
    );
  }

  Widget _buildDaySection(
    BuildContext context,
    int dayIndex,
    String dayName,
    List<StaffAvailability> slots,
    StaffAvailabilityNotifier notifier,
  ) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    dayName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                if (slots.isEmpty) ...[
                  const SizedBox(width: 12),
                  Text(
                    context.l10n.counselorMeetingNotAvailable,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (slots.isNotEmpty)
            ...slots.map((slot) => _buildAvailabilitySlot(context, slot, notifier)),
        ],
      ),
    );
  }

  Widget _buildAvailabilitySlot(
    BuildContext context,
    StaffAvailability slot,
    StaffAvailabilityNotifier notifier,
  ) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: slot.isActive
            ? AppColors.success.withValues(alpha: 0.1)
            : AppColors.textSecondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: slot.isActive
              ? AppColors.success.withValues(alpha: 0.3)
              : AppColors.textSecondary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.schedule,
            color: slot.isActive ? AppColors.success : AppColors.textSecondary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_formatTime(slot.startTime)} - ${_formatTime(slot.endTime)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: slot.isActive ? null : AppColors.textSecondary,
                  ),
                ),
                if (!slot.isActive)
                  Text(
                    context.l10n.counselorMeetingInactive,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              slot.isActive ? Icons.pause_circle : Icons.play_circle,
              color: slot.isActive ? AppColors.warning : AppColors.success,
              size: 20,
            ),
            onPressed: () => _toggleSlotStatus(slot, notifier),
            tooltip: slot.isActive ? context.l10n.counselorMeetingDeactivate : context.l10n.counselorMeetingActivate,
          ),
          IconButton(
            icon: const Icon(
              Icons.delete,
              color: AppColors.error,
              size: 20,
            ),
            onPressed: () => _deleteSlot(slot, notifier),
            tooltip: context.l10n.counselorMeetingDelete,
          ),
        ],
      ),
    );
  }

  bool _canSaveSlot() {
    return _selectedDay != null && _startTime != null && _endTime != null;
  }

  Future<void> _saveSlot(StaffAvailabilityNotifier notifier) async {
    if (!_canSaveSlot()) return;

    final startTime = '${_startTime!.hour.toString().padLeft(2, '0')}:'
        '${_startTime!.minute.toString().padLeft(2, '0')}:00';
    final endTime = '${_endTime!.hour.toString().padLeft(2, '0')}:'
        '${_endTime!.minute.toString().padLeft(2, '0')}:00';

    final success = await notifier.setAvailability(
      dayOfWeek: _selectedDay!,
      startTime: startTime,
      endTime: endTime,
    );

    if (success && mounted) {
      setState(() {
        _isAddingSlot = false;
        _selectedDay = null;
        _startTime = null;
        _endTime = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.counselorMeetingAvailabilityAdded),
          backgroundColor: AppColors.success,
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ref.read(staffAvailabilityProvider).error ?? context.l10n.counselorMeetingFailedToAddAvailability),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _toggleSlotStatus(
    StaffAvailability slot,
    StaffAvailabilityNotifier notifier,
  ) async {
    final success = await notifier.updateAvailability(
      availabilityId: slot.id,
      isActive: !slot.isActive,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(slot.isActive ? context.l10n.counselorMeetingSlotDeactivated : context.l10n.counselorMeetingSlotActivated),
          backgroundColor: AppColors.success,
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.counselorMeetingFailedToUpdateAvailability),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _deleteSlot(
    StaffAvailability slot,
    StaffAvailabilityNotifier notifier,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.counselorMeetingDeleteAvailability),
        content: Text(context.l10n.counselorMeetingConfirmDeleteSlot(slot.dayName)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.counselorMeetingCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(context.l10n.counselorMeetingDelete),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final success = await notifier.deleteAvailability(slot.id);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.counselorMeetingAvailabilityDeleted),
          backgroundColor: AppColors.success,
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.counselorMeetingFailedToDeleteAvailability),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  String _formatTime(String time) {
    // time is in HH:MM:SS format
    final parts = time.split(':');
    if (parts.length >= 2) {
      final hour = int.parse(parts[0]);
      final minute = parts[1];
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '$displayHour:$minute $period';
    }
    return time;
  }
}
