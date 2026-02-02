import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/counseling_models.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../providers/counselor_sessions_provider.dart';
import '../../providers/counselor_students_provider.dart';

class CreateSessionScreen extends ConsumerStatefulWidget {
  final StudentRecord? student;

  const CreateSessionScreen({
    super.key,
    this.student,
  });

  @override
  ConsumerState<CreateSessionScreen> createState() => _CreateSessionScreenState();
}

class _CreateSessionScreenState extends ConsumerState<CreateSessionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();

  StudentRecord? _selectedStudent;
  String _sessionType = 'individual';
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  int _duration = 30;
  String _location = 'office';
  bool _isSubmitting = false;

  final List<String> _sessionTypes = [
    'individual',
    'group',
    'career',
    'academic',
    'personal',
  ];

  final List<int> _durations = [15, 30, 45, 60, 90, 120];

  final List<String> _locations = [
    'office',
    'online',
    'classroom',
    'library',
  ];

  @override
  void initState() {
    super.initState();
    _selectedStudent = widget.student;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (time != null) {
      setState(() => _selectedTime = time);
    }
  }

  Future<void> _saveSession() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedStudent == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.counselorSessionPleaseSelectStudent),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      setState(() => _isSubmitting = true);

      try {
        // Build scheduled date time
        final scheduledDateTime = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          _selectedTime.hour,
          _selectedTime.minute,
        );

        await ref.read(counselorSessionsProvider.notifier).createSession(
          studentId: _selectedStudent!.id,
          studentName: _selectedStudent!.name,
          type: _sessionType,
          scheduledDate: scheduledDateTime,
          duration: Duration(minutes: _duration),
          location: _location,
          notes: _notesController.text.isNotEmpty ? _notesController.text : null,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.counselorSessionScheduledSuccessfully),
              backgroundColor: AppColors.success,
            ),
          );
          context.pop();
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isSubmitting = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.counselorSessionErrorScheduling('$e')),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.counselorSessionScheduleSession),
        actions: [
          TextButton(
            onPressed: _isSubmitting ? null : _saveSession,
            child: _isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.textOnPrimary),
                    ),
                  )
                : Text(
                    context.l10n.counselorSessionSave,
                    style: const TextStyle(
                      color: AppColors.textOnPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Student Selection
            Text(
              context.l10n.counselorSessionStudent,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            CustomCard(
              onTap: widget.student == null
                  ? () async {
                      // Fetch students from provider
                      final students = ref.read(counselorStudentsListProvider);
                      if (students.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(context.l10n.counselorSessionNoStudentsFound),
                            backgroundColor: AppColors.warning,
                          ),
                        );
                        return;
                      }
                      final student = await showDialog<StudentRecord>(
                        context: context,
                        builder: (context) => _StudentPickerDialog(
                          students: students,
                        ),
                      );
                      if (student != null) {
                        setState(() => _selectedStudent = student);
                      }
                    }
                  : null,
              child: Row(
                children: [
                  if (_selectedStudent != null) ...[
                    CircleAvatar(
                      backgroundColor: AppColors.primary,
                      child: Text(
                        _selectedStudent!.initials,
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
                            _selectedStudent!.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            context.l10n.counselorSessionGradeAndGpa(_selectedStudent!.grade, '${_selectedStudent!.gpa}'),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    const Icon(
                      Icons.person_add,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      context.l10n.counselorSessionSelectStudent,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                  if (widget.student == null) const Icon(Icons.chevron_right),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Session Title
            Text(
              context.l10n.counselorSessionTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: context.l10n.counselorSessionTitleHint,
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return context.l10n.counselorSessionPleaseEnterTitle;
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Session Type
            Text(
              context.l10n.counselorSessionType,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _sessionTypes.map((type) {
                final isSelected = _sessionType == type;
                return FilterChip(
                  label: Text(_formatSessionType(type)),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() => _sessionType = type);
                  },
                  backgroundColor: AppColors.surfaceVariant,
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: isSelected
                        ? AppColors.textOnPrimary
                        : AppColors.textPrimary,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Date and Time
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.counselorSessionDate,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomCard(
                        onTap: _selectDate,
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today,
                                color: AppColors.primary),
                            const SizedBox(width: 12),
                            Text(
                              _formatDate(_selectedDate),
                              style: theme.textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.counselorSessionTime,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomCard(
                        onTap: _selectTime,
                        child: Row(
                          children: [
                            const Icon(Icons.access_time,
                                color: AppColors.primary),
                            const SizedBox(width: 12),
                            Text(
                              _selectedTime.format(context),
                              style: theme.textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Duration
            Text(
              context.l10n.counselorSessionDuration,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _durations.map((dur) {
                final isSelected = _duration == dur;
                return ChoiceChip(
                  label: Text(context.l10n.counselorSessionDurationMin('$dur')),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() => _duration = dur);
                  },
                  backgroundColor: AppColors.surfaceVariant,
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: isSelected
                        ? AppColors.textOnPrimary
                        : AppColors.textPrimary,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Location
            Text(
              context.l10n.counselorSessionLocation,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _locations.map((loc) {
                final isSelected = _location == loc;
                return FilterChip(
                  label: Text(_formatLocation(loc)),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() => _location = loc);
                  },
                  backgroundColor: AppColors.surfaceVariant,
                  selectedColor: AppColors.info,
                  labelStyle: TextStyle(
                    color: isSelected
                        ? AppColors.textOnPrimary
                        : AppColors.textPrimary,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Notes
            Text(
              context.l10n.counselorSessionNotesOptional,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _notesController,
              decoration: InputDecoration(
                hintText: context.l10n.counselorSessionNotesHint,
                border: const OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 32),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => context.pop(),
                    child: Text(context.l10n.counselorSessionCancel),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveSession,
                    child: Text(context.l10n.counselorSessionScheduleSession),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatSessionType(String type) {
    return type[0].toUpperCase() + type.substring(1);
  }

  String _formatLocation(String location) {
    return location[0].toUpperCase() + location.substring(1);
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

class _StudentPickerDialog extends StatelessWidget {
  final List<StudentRecord> students;

  const _StudentPickerDialog({required this.students});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.l10n.counselorSessionSelectStudentDialog),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: students.length,
          itemBuilder: (context, index) {
            final student = students[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.primary,
                child: Text(
                  student.initials,
                  style: const TextStyle(
                    color: AppColors.textOnPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(student.name),
              subtitle: Text(context.l10n.counselorSessionGradeAndGpa(student.grade, '${student.gpa}')),
              onTap: () => Navigator.of(context).pop(student),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.l10n.counselorSessionCancel),
        ),
      ],
    );
  }
}
