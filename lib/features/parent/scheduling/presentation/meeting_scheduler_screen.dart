import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/meeting_models.dart' as models;
import '../../../../core/providers/meetings_provider.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../providers/parent_children_provider.dart';

enum MeetingType { teacher, counselor }

class MeetingSchedulerScreen extends ConsumerStatefulWidget {
  final MeetingType meetingType;

  const MeetingSchedulerScreen({
    super.key,
    required this.meetingType,
  });

  @override
  ConsumerState<MeetingSchedulerScreen> createState() =>
      _MeetingSchedulerScreenState();
}

class _MeetingSchedulerScreenState
    extends ConsumerState<MeetingSchedulerScreen> {
  String? _selectedChild;
  models.StaffMember? _selectedStaff;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  models.MeetingMode _meetingMode = models.MeetingMode.videoCall;
  int _durationMinutes = 30;
  final _subjectController = TextEditingController();
  final _notesController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _subjectController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final children = ref.watch(parentChildrenListProvider);
    final isCounselor = widget.meetingType == MeetingType.counselor;

    // Fetch staff list based on meeting type
    final staffListState = ref.watch(staffListProvider);
    final staffMembers = isCounselor
        ? staffListState.staffList.where((s) => s.role == models.StaffType.counselor).toList()
        : staffListState.staffList.where((s) => s.role == models.StaffType.teacher).toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
          tooltip: 'Back',
        ),
        title: Text(
          isCounselor ? 'Schedule Counselor Meeting' : 'Schedule Teacher Meeting',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          CustomCard(
            color: (isCounselor ? AppColors.counselorRole : AppColors.info)
                .withValues(alpha: 0.1),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (isCounselor
                            ? AppColors.counselorRole
                            : AppColors.info)
                        .withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isCounselor ? Icons.psychology : Icons.school,
                    color: isCounselor ? AppColors.counselorRole : AppColors.info,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isCounselor
                            ? 'Counselor Meeting'
                            : 'Parent-Teacher Conference',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isCounselor
                            ? 'Discuss guidance and academic planning'
                            : 'Discuss student progress and performance',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
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

          // Select Child
          Text(
            'Select Student',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          if (children.isEmpty)
            CustomCard(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.warning,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'No children added. Please add children to schedule meetings.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ...children.map((child) {
              final isSelected = _selectedChild == child.id;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: CustomCard(
                  onTap: () {
                    setState(() {
                      _selectedChild = child.id;
                    });
                  },
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : null,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: isSelected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        child: Text(
                          child.initials,
                          style: const TextStyle(
                            color: AppColors.textOnPrimary,
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
                              child.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              child.grade,
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
                      if (isSelected)
                        Icon(
                          Icons.check_circle,
                          color: AppColors.success,
                        ),
                    ],
                  ),
                ),
              );
            }),
          const SizedBox(height: 24),

          // Select Staff Member
          Text(
            isCounselor ? 'Select Counselor' : 'Select Teacher',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          if (staffListState.isLoading)
            const CustomCard(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              ),
            )
          else if (staffMembers.isEmpty)
            CustomCard(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.warning,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'No ${isCounselor ? 'counselors' : 'teachers'} available at this time.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            CustomCard(
              child: DropdownButtonFormField<models.StaffMember>(
                value: _selectedStaff,
                decoration: InputDecoration(
                  labelText: isCounselor ? 'Counselor' : 'Teacher',
                  prefixIcon: Icon(
                    isCounselor ? Icons.psychology : Icons.person,
                  ),
                  border: const OutlineInputBorder(),
                ),
                items: staffMembers
                    .map((staff) => DropdownMenuItem(
                          value: staff,
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundImage: staff.photoUrl != null
                                    ? NetworkImage(staff.photoUrl!)
                                    : null,
                                backgroundColor: AppColors.primary,
                                child: staff.photoUrl == null
                                    ? Text(
                                        staff.initials,
                                        style: const TextStyle(
                                          color: AppColors.textOnPrimary,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      staff.displayName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (staff.department != null)
                                      Text(
                                        staff.department!,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedStaff = value;
                  });
                },
              ),
            ),
          const SizedBox(height: 24),

          // Select Date
          Text(
            'Select Date & Time',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: CustomCard(
                  onTap: _selectDate,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Date',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _selectedDate == null
                              ? 'Select date'
                              : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomCard(
                  onTap: _selectTime,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 16,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Time',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _selectedTime == null
                              ? 'Select time'
                              : _selectedTime!.format(context),
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Meeting Mode
          Text(
            'Meeting Mode',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _MeetingModeOption(
                  mode: models.MeetingMode.videoCall,
                  selectedMode: _meetingMode,
                  icon: Icons.videocam,
                  label: 'Video Call',
                  onTap: () => setState(() => _meetingMode = models.MeetingMode.videoCall),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MeetingModeOption(
                  mode: models.MeetingMode.inPerson,
                  selectedMode: _meetingMode,
                  icon: Icons.meeting_room,
                  label: 'In Person',
                  onTap: () => setState(() => _meetingMode = models.MeetingMode.inPerson),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MeetingModeOption(
                  mode: models.MeetingMode.phoneCall,
                  selectedMode: _meetingMode,
                  icon: Icons.phone,
                  label: 'Phone',
                  onTap: () => setState(() => _meetingMode = models.MeetingMode.phoneCall),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Duration
          Text(
            'Duration',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          CustomCard(
            child: DropdownButtonFormField<int>(
              value: _durationMinutes,
              decoration: const InputDecoration(
                labelText: 'Meeting duration',
                prefixIcon: Icon(Icons.schedule),
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 15, child: Text('15 minutes')),
                DropdownMenuItem(value: 30, child: Text('30 minutes')),
                DropdownMenuItem(value: 45, child: Text('45 minutes')),
                DropdownMenuItem(value: 60, child: Text('1 hour')),
                DropdownMenuItem(value: 90, child: Text('1.5 hours')),
                DropdownMenuItem(value: 120, child: Text('2 hours')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _durationMinutes = value);
                }
              },
            ),
          ),
          const SizedBox(height: 24),

          // Meeting Subject
          Text(
            'Meeting Subject',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          CustomCard(
            child: TextFormField(
              controller: _subjectController,
              decoration: const InputDecoration(
                labelText: 'Subject',
                hintText: 'e.g., Math progress discussion',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.subject),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Additional Notes
          Text(
            'Additional Notes (Optional)',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          CustomCard(
            child: TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes',
                hintText: 'Any additional information...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.notes),
              ),
              maxLines: 4,
            ),
          ),
          const SizedBox(height: 32),

          // Schedule Button
          ElevatedButton.icon(
            onPressed: _canSchedule() && !_isSubmitting ? _scheduleMeeting : null,
            icon: _isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.textOnPrimary),
                    ),
                  )
                : const Icon(Icons.event_available),
            label: Text(_isSubmitting ? 'Requesting...' : 'Request Meeting'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textOnPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      setState(() {
        _selectedTime = time;
      });
    }
  }

  bool _canSchedule() {
    return _selectedChild != null &&
        _selectedStaff != null &&
        _selectedDate != null &&
        _selectedTime != null &&
        _subjectController.text.isNotEmpty;
  }

  Future<void> _scheduleMeeting() async {
    if (!_canSchedule() || _isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Combine date and time into DateTime
      final scheduledDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      // Create meeting request DTO
      final meetingRequest = models.MeetingRequestDTO(
        staffId: _selectedStaff!.id,
        studentId: _selectedChild!,
        staffType: _selectedStaff!.role,
        meetingType: widget.meetingType == MeetingType.counselor
            ? models.MeetingType.parentCounselor
            : models.MeetingType.parentTeacher,
        subject: _subjectController.text.trim(),
        durationMinutes: _durationMinutes,
        meetingMode: _meetingMode,
        scheduledDate: scheduledDateTime,
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      );

      // Request meeting via provider
      final notifier = ref.read(parentMeetingsProvider.notifier);
      final success = await notifier.requestMeeting(meetingRequest);

      if (!mounted) return;

      if (success) {
        // Show success dialog
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: AppColors.success,
                ),
                const SizedBox(width: 12),
                const Text('Meeting Request Sent'),
              ],
            ),
            content: Text(
              'Your meeting request has been sent to ${_selectedStaff!.displayName}. '
              'You will be notified once they respond.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        // Show error from provider
        final error = ref.read(parentMeetingsProvider).error;
        _showErrorDialog(error ?? 'Failed to request meeting. Please try again.');
      }
    } catch (e) {
      if (!mounted) return;
      _showErrorDialog(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: AppColors.error,
            ),
            const SizedBox(width: 12),
            const Text('Error'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

/// Widget for meeting mode selection
class _MeetingModeOption extends StatelessWidget {
  final models.MeetingMode mode;
  final models.MeetingMode selectedMode;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MeetingModeOption({
    required this.mode,
    required this.selectedMode,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = mode == selectedMode;

    return CustomCard(
      onTap: onTap,
      color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (isSelected) ...[
              const SizedBox(height: 4),
              Icon(
                Icons.check_circle,
                color: AppColors.success,
                size: 16,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
