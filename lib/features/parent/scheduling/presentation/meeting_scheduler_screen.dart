import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
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
  String? _selectedStaff;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final _purposeController = TextEditingController();

  @override
  void dispose() {
    _purposeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final children = ref.watch(parentChildrenListProvider);
    final isCounselor = widget.meetingType == MeetingType.counselor;

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
          CustomCard(
            child: DropdownButtonFormField<String>(
              value: _selectedStaff,
              decoration: InputDecoration(
                labelText: isCounselor ? 'Counselor' : 'Teacher',
                prefixIcon: Icon(
                  isCounselor ? Icons.psychology : Icons.person,
                ),
                border: const OutlineInputBorder(),
              ),
              items: _getStaffMembers(isCounselor)
                  .map((staff) => DropdownMenuItem(
                        value: staff,
                        child: Text(staff),
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

          // Meeting Purpose
          Text(
            'Meeting Purpose',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          CustomCard(
            child: TextFormField(
              controller: _purposeController,
              decoration: const InputDecoration(
                labelText: 'Purpose of meeting',
                hintText: 'Describe what you would like to discuss...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.notes),
              ),
              maxLines: 4,
            ),
          ),
          const SizedBox(height: 32),

          // Schedule Button
          ElevatedButton.icon(
            onPressed: _canSchedule() ? _scheduleMeeting : null,
            icon: const Icon(Icons.event_available),
            label: const Text('Schedule Meeting'),
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

  List<String> _getStaffMembers(bool isCounselor) {
    if (isCounselor) {
      return [
        'Dr. Sarah Johnson - Career Counselor',
        'Dr. Michael Chen - Academic Counselor',
        'Ms. Emily Rodriguez - College Counselor',
      ];
    } else {
      return [
        'Mr. John Smith - Mathematics',
        'Ms. Jane Doe - English',
        'Dr. Robert Brown - Science',
        'Mrs. Lisa White - History',
      ];
    }
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
        _purposeController.text.isNotEmpty;
  }

  void _scheduleMeeting() {
    // TODO: Implement backend scheduling
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: AppColors.success,
            ),
            const SizedBox(width: 12),
            const Text('Meeting Scheduled'),
          ],
        ),
        content: Text(
          'Your meeting has been scheduled for ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year} at ${_selectedTime!.format(context)}',
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
  }
}
