import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/program_model.dart';
import '../../../../core/utils/validators.dart';
import '../../providers/institution_programs_provider.dart';
import '../../../authentication/providers/auth_provider.dart';

const _uuid = Uuid();

class CreateProgramScreen extends ConsumerStatefulWidget {
  const CreateProgramScreen({super.key});

  @override
  ConsumerState<CreateProgramScreen> createState() => _CreateProgramScreenState();
}

class _CreateProgramScreenState extends ConsumerState<CreateProgramScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  // Form controllers
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _feeController = TextEditingController();
  final _maxStudentsController = TextEditingController();

  // Form values
  String? _selectedCategory;
  String? _selectedLevel;
  int _durationMonths = 12;
  DateTime _startDate = DateTime.now().add(const Duration(days: 90));
  DateTime _applicationDeadline = DateTime.now().add(const Duration(days: 45));
  final List<String> _requirements = [];
  final _requirementController = TextEditingController();

  final List<String> _categories = [
    'Technology',
    'Business',
    'Science',
    'Health Sciences',
    'Arts',
    'Engineering',
  ];

  final List<Map<String, String>> _levels = [
    {'value': 'certificate', 'label': 'Certificate'},
    {'value': 'diploma', 'label': 'Diploma'},
    {'value': 'undergraduate', 'label': 'Undergraduate'},
    {'value': 'postgraduate', 'label': 'Postgraduate'},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _feeController.dispose();
    _maxStudentsController.dispose();
    _requirementController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Program'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Program Name
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Program Name *',
                hintText: 'e.g., Bachelor of Computer Science',
                prefixIcon: Icon(Icons.school),
                border: OutlineInputBorder(),
              ),
              validator: Validators.compose([
                Validators.required('Program name is required'),
                Validators.minLength(5, 'Program name'),
                Validators.maxLength(100, 'Program name'),
              ]),
            ),
            const SizedBox(height: 16),

            // Description
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description *',
                hintText: 'Describe the program...',
                prefixIcon: Icon(Icons.description),
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
              validator: Validators.compose([
                Validators.required('Description is required'),
                Validators.minLength(20, 'Description'),
                Validators.maxLength(500, 'Description'),
              ]),
            ),
            const SizedBox(height: 16),

            // Category Dropdown
            DropdownButtonFormField<String>(
              initialValue: 'Technology',
              decoration: const InputDecoration(
                labelText: 'Category *',
                prefixIcon: Icon(Icons.category),
                border: OutlineInputBorder(),
              ),
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (_) {},
              onSaved: (value) {
                _selectedCategory = value;
              },
            ),
            const SizedBox(height: 16),

            // Level Dropdown
            DropdownButtonFormField<String>(
              initialValue: 'undergraduate',
              decoration: const InputDecoration(
                labelText: 'Level *',
                prefixIcon: Icon(Icons.trending_up),
                border: OutlineInputBorder(),
              ),
              items: _levels.map((level) {
                return DropdownMenuItem(
                  value: level['value'],
                  child: Text(level['label']!),
                );
              }).toList(),
              onChanged: (_) {},
              onSaved: (value) {
                _selectedLevel = value;
              },
            ),
            const SizedBox(height: 16),

            // Duration Slider
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Duration',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          _formatDuration(_durationMonths),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: _durationMonths.toDouble(),
                      min: 1,
                      max: 60,
                      divisions: 59,
                      label: _formatDuration(_durationMonths),
                      onChanged: (value) {
                        setState(() => _durationMonths = value.toInt());
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Fee
            TextFormField(
              controller: _feeController,
              decoration: const InputDecoration(
                labelText: 'Program Fee (USD) *',
                hintText: '0.00',
                prefixIcon: Icon(Icons.attach_money),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              validator: Validators.compose([
                Validators.required('Fee is required'),
                Validators.positiveNumber,
              ]),
            ),
            const SizedBox(height: 16),

            // Max Students
            TextFormField(
              controller: _maxStudentsController,
              decoration: const InputDecoration(
                labelText: 'Maximum Students *',
                hintText: 'e.g., 100',
                prefixIcon: Icon(Icons.people),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: Validators.compose([
                Validators.required('Maximum students is required'),
                Validators.positiveNumber,
                Validators.numberInRange(1, 10000),
              ]),
            ),
            const SizedBox(height: 16),

            // Start Date
            Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Start Date'),
                subtitle: Text(_formatDate(_startDate)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _startDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 730)),
                  );
                  if (date != null) {
                    setState(() => _startDate = date);
                  }
                },
              ),
            ),
            const SizedBox(height: 12),

            // Application Deadline
            Card(
              child: ListTile(
                leading: const Icon(Icons.event),
                title: const Text('Application Deadline'),
                subtitle: Text(_formatDate(_applicationDeadline)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _applicationDeadline,
                    firstDate: DateTime.now(),
                    lastDate: _startDate,
                  );
                  if (date != null) {
                    setState(() => _applicationDeadline = date);
                  }
                },
              ),
            ),
            const SizedBox(height: 24),

            // Requirements Section
            Text(
              'Requirements',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _requirementController,
                            decoration: const InputDecoration(
                              hintText: 'Add a requirement...',
                              border: OutlineInputBorder(),
                            ),
                            onSubmitted: (_) => _addRequirement(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: _addRequirement,
                          icon: const Icon(Icons.add_circle),
                          color: AppColors.primary,
                          iconSize: 32,
                        ),
                      ],
                    ),
                    if (_requirements.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      ...(_requirements.map((req) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: AppColors.success,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(child: Text(req)),
                              IconButton(
                                icon: const Icon(Icons.delete, size: 20),
                                color: AppColors.error,
                                onPressed: () {
                                  setState(() => _requirements.remove(req));
                                },
                              ),
                            ],
                          ),
                        );
                      })),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitForm,
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Create Program'),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _addRequirement() {
    final requirement = _requirementController.text.trim();
    if (requirement.isNotEmpty && !_requirements.contains(requirement)) {
      setState(() {
        _requirements.add(requirement);
        _requirementController.clear();
      });
    }
  }

  String _formatDuration(int months) {
    if (months < 12) {
      return '$months ${months == 1 ? 'month' : 'months'}';
    } else {
      final years = (months / 12).floor();
      final remainingMonths = months % 12;
      if (remainingMonths == 0) {
        return '$years ${years == 1 ? 'year' : 'years'}';
      } else {
        return '$years ${years == 1 ? 'year' : 'years'} $remainingMonths ${remainingMonths == 1 ? 'month' : 'months'}';
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    if (_requirements.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one requirement'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    if (_applicationDeadline.isAfter(_startDate)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Application deadline must be before start date'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // Get current user
      final user = ref.read(currentUserProvider);
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Create Program model instance
      final program = Program(
        id: _uuid.v4(),
        institutionId: user.id, // Use logged-in user's ID as institution ID
        institutionName: user.displayName ?? user.email, // Use display name or email
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _selectedCategory ?? 'Technology',
        level: _selectedLevel ?? 'undergraduate',
        duration: Duration(days: (_durationMonths * 30).round()),
        fee: double.parse(_feeController.text),
        maxStudents: int.parse(_maxStudentsController.text),
        enrolledStudents: 0, // New program starts with 0 enrolled
        requirements: _requirements,
        applicationDeadline: _applicationDeadline,
        startDate: _startDate,
        isActive: true,
        createdAt: DateTime.now(),
      );

      // Create program via provider
      final success = await ref.read(institutionProgramsProvider.notifier).createProgram(program);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Program created successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
        context.pop();
      } else if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to create program'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating program: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}
