import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/course_model.dart';
import '../../providers/institution_courses_provider.dart';

/// Create/Edit Course Screen for Institutions
class CreateCourseScreen extends ConsumerStatefulWidget {
  final Course? course; // Null for create, Course object for edit

  const CreateCourseScreen({super.key, this.course});

  @override
  ConsumerState<CreateCourseScreen> createState() => _CreateCourseScreenState();
}

class _CreateCourseScreenState extends ConsumerState<CreateCourseScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _durationController;
  late TextEditingController _priceController;
  late TextEditingController _categoryController;
  late TextEditingController _thumbnailUrlController;
  late TextEditingController _maxStudentsController;

  // Selected values
  late CourseType _selectedType;
  late CourseLevel _selectedLevel;
  late String _selectedCurrency;

  // Lists
  final List<String> _tags = [];
  final List<String> _learningOutcomes = [];
  final List<String> _prerequisites = [];

  // Controllers for list items
  final _tagController = TextEditingController();
  final _outcomeController = TextEditingController();
  final _prerequisiteController = TextEditingController();

  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final course = widget.course;

    _titleController = TextEditingController(text: course?.title ?? '');
    _descriptionController = TextEditingController(text: course?.description ?? '');
    _durationController = TextEditingController(text: course?.durationHours?.toString() ?? '');
    _priceController = TextEditingController(text: course?.price.toString() ?? '0');
    _categoryController = TextEditingController(text: course?.category ?? '');
    _thumbnailUrlController = TextEditingController(text: course?.thumbnailUrl ?? '');
    _maxStudentsController = TextEditingController(text: course?.maxStudents?.toString() ?? '');

    _selectedType = course?.courseType ?? CourseType.video;
    _selectedLevel = course?.level ?? CourseLevel.beginner;
    _selectedCurrency = course?.currency ?? 'USD';

    if (course != null) {
      _tags.addAll(course.tags);
      _learningOutcomes.addAll(course.learningOutcomes);
      _prerequisites.addAll(course.prerequisites);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    _thumbnailUrlController.dispose();
    _maxStudentsController.dispose();
    _tagController.dispose();
    _outcomeController.dispose();
    _prerequisiteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.course != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Course' : 'Create Course'),
        backgroundColor: AppColors.surface,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Error message
            if (_error != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[300]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red[700]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(_error!, style: TextStyle(color: Colors.red[700])),
                    ),
                  ],
                ),
              ),

            // Basic Information Section
            _buildSectionTitle('Basic Information'),
            const SizedBox(height: 12),

            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Course Title *',
                hintText: 'e.g., Introduction to Programming',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Title is required';
                }
                if (value.length < 3) {
                  return 'Title must be at least 3 characters';
                }
                if (value.length > 200) {
                  return 'Title must be less than 200 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description *',
                hintText: 'Describe what students will learn...',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 5,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Description is required';
                }
                if (value.length < 10) {
                  return 'Description must be at least 10 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Course Type and Level
            _buildSectionTitle('Course Details'),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<CourseType>(
                    value: _selectedType,
                    decoration: const InputDecoration(
                      labelText: 'Course Type *',
                      border: OutlineInputBorder(),
                    ),
                    items: CourseType.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type.displayName),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedType = value);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<CourseLevel>(
                    value: _selectedLevel,
                    decoration: const InputDecoration(
                      labelText: 'Difficulty Level *',
                      border: OutlineInputBorder(),
                    ),
                    items: CourseLevel.values.map((level) {
                      return DropdownMenuItem(
                        value: level,
                        child: Text(level.displayName),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedLevel = value);
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _durationController,
                    decoration: const InputDecoration(
                      labelText: 'Duration (hours)',
                      hintText: '10',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _categoryController,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      hintText: 'Computer Science',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Pricing Section
            _buildSectionTitle('Pricing'),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _priceController,
                    decoration: const InputDecoration(
                      labelText: 'Price *',
                      hintText: '0',
                      border: OutlineInputBorder(),
                      prefixText: '\$ ',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Price is required';
                      final price = double.tryParse(value);
                      if (price == null || price < 0) return 'Invalid price';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedCurrency,
                    decoration: const InputDecoration(
                      labelText: 'Currency',
                      border: OutlineInputBorder(),
                    ),
                    items: ['USD', 'EUR', 'GBP', 'KES', 'NGN', 'ZAR']
                        .map((curr) => DropdownMenuItem(value: curr, child: Text(curr)))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) setState(() => _selectedCurrency = value);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _maxStudentsController,
              decoration: const InputDecoration(
                labelText: 'Max Students (optional)',
                hintText: 'Leave empty for unlimited',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 24),

            // Media Section
            _buildSectionTitle('Media'),
            const SizedBox(height: 12),

            TextFormField(
              controller: _thumbnailUrlController,
              decoration: const InputDecoration(
                labelText: 'Thumbnail URL (optional)',
                hintText: 'https://example.com/image.jpg',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // Tags
            _buildSectionTitle('Tags'),
            const SizedBox(height: 12),
            _buildListSection(
              items: _tags,
              controller: _tagController,
              hintText: 'Add tag (e.g., programming, python)',
              onAdd: () {
                if (_tagController.text.trim().isNotEmpty) {
                  setState(() => _tags.add(_tagController.text.trim()));
                  _tagController.clear();
                }
              },
            ),
            const SizedBox(height: 24),

            // Learning Outcomes
            _buildSectionTitle('Learning Outcomes'),
            const SizedBox(height: 12),
            _buildListSection(
              items: _learningOutcomes,
              controller: _outcomeController,
              hintText: 'What will students learn?',
              onAdd: () {
                if (_outcomeController.text.trim().isNotEmpty) {
                  setState(() => _learningOutcomes.add(_outcomeController.text.trim()));
                  _outcomeController.clear();
                }
              },
            ),
            const SizedBox(height: 24),

            // Prerequisites
            _buildSectionTitle('Prerequisites'),
            const SizedBox(height: 12),
            _buildListSection(
              items: _prerequisites,
              controller: _prerequisiteController,
              hintText: 'What do students need to know?',
              onAdd: () {
                if (_prerequisiteController.text.trim().isNotEmpty) {
                  setState(() => _prerequisites.add(_prerequisiteController.text.trim()));
                  _prerequisiteController.clear();
                }
              },
            ),
            const SizedBox(height: 32),

            // Submit Button
            ElevatedButton(
              onPressed: _isLoading ? null : _saveCourse,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(isEditMode ? 'Update Course' : 'Create Course'),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildListSection({
    required List<String> items,
    required TextEditingController controller,
    required String hintText,
    required VoidCallback onAdd,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: hintText,
                  border: const OutlineInputBorder(),
                ),
                onSubmitted: (_) => onAdd(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: onAdd,
              icon: const Icon(Icons.add_circle),
              color: AppColors.primary,
            ),
          ],
        ),
        if (items.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items.map((item) {
              return Chip(
                label: Text(item),
                deleteIcon: const Icon(Icons.close, size: 18),
                onDeleted: () {
                  setState(() => items.remove(item));
                },
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Future<void> _saveCourse() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final courseRequest = CourseRequest(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        courseType: _selectedType,
        level: _selectedLevel,
        durationHours: _durationController.text.isNotEmpty
            ? double.tryParse(_durationController.text)
            : null,
        price: double.parse(_priceController.text),
        currency: _selectedCurrency,
        category: _categoryController.text.trim().isNotEmpty
            ? _categoryController.text.trim()
            : null,
        thumbnailUrl: _thumbnailUrlController.text.trim().isNotEmpty
            ? _thumbnailUrlController.text.trim()
            : null,
        maxStudents: _maxStudentsController.text.isNotEmpty
            ? int.tryParse(_maxStudentsController.text)
            : null,
        tags: _tags,
        learningOutcomes: _learningOutcomes,
        prerequisites: _prerequisites,
      );

      Course? result;
      if (widget.course == null) {
        // Create new course
        result = await ref.read(institutionCoursesProvider.notifier).createCourse(courseRequest);
      } else {
        // Update existing course
        result = await ref.read(institutionCoursesProvider.notifier).updateCourse(
          widget.course!.id,
          courseRequest,
        );
      }

      if (result != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.course == null
                ? 'Course created successfully!'
                : 'Course updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop(); // Go back to courses list
      } else {
        setState(() => _error = 'Failed to save course. Please try again.');
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
