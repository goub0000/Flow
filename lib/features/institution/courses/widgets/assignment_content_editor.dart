// ignore_for_file: deprecated_member_use, unnecessary_brace_in_string_interps

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/models/quiz_assignment_models.dart';
import 'content_editor_wrapper.dart';

/// Rubric criterion model for grading assignments
class RubricCriterion {
  final String id;
  final String name;
  final String description;
  final int points;
  final int order;

  RubricCriterion({
    required this.id,
    required this.name,
    required this.description,
    required this.points,
    required this.order,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'points': points,
        'order': order,
      };

  factory RubricCriterion.fromJson(Map<String, dynamic> json) => RubricCriterion(
        id: json['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: json['name'] as String? ?? json['criterion'] as String? ?? '',
        description: json['description'] as String? ?? '',
        points: json['points'] as int? ?? 0,
        order: json['order'] as int? ?? 0,
      );

  RubricCriterion copyWith({
    String? id,
    String? name,
    String? description,
    int? points,
    int? order,
  }) {
    return RubricCriterion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      points: points ?? this.points,
      order: order ?? this.order,
    );
  }
}

/// Resource link model for helpful materials
class ResourceLink {
  final String title;
  final String url;
  final String? description;

  ResourceLink({
    required this.title,
    required this.url,
    this.description,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'url': url,
        'description': description,
      };

  factory ResourceLink.fromJson(Map<String, dynamic> json) => ResourceLink(
        title: json['title'] as String,
        url: json['url'] as String,
        description: json['description'] as String?,
      );
}

/// Submission type enumeration
enum SubmissionTypeOption {
  text('text', 'Text Submission', Icons.text_fields, Colors.blue),
  file('file', 'File Upload', Icons.upload_file, Colors.orange),
  url('url', 'URL Submission', Icons.link, Colors.purple),
  combined('combined', 'Text + File', Icons.add_box, Colors.teal);

  final String value;
  final String displayName;
  final IconData icon;
  final Color color;

  const SubmissionTypeOption(this.value, this.displayName, this.icon, this.color);

  static SubmissionTypeOption fromString(String value) {
    return SubmissionTypeOption.values.firstWhere(
      (e) => e.value == value.toLowerCase(),
      orElse: () => SubmissionTypeOption.file,
    );
  }
}

/// Late submission policy enumeration
enum LatePolicy {
  notAllowed('not_allowed', 'Not Allowed'),
  allowedNoPenalty('allowed_no_penalty', 'Allowed, No Penalty'),
  allowedWithPenalty('allowed_with_penalty', 'Allowed with Penalty'),
  allowedUntilDate('allowed_until_date', 'Allowed Until Specific Date');

  final String value;
  final String displayName;

  const LatePolicy(this.value, this.displayName);

  static LatePolicy fromString(String value) {
    return LatePolicy.values.firstWhere(
      (e) => e.value == value.toLowerCase(),
      orElse: () => LatePolicy.notAllowed,
    );
  }
}

/// Allowed file type model
class AllowedFileType {
  final String extension;
  final String mimeType;
  final bool selected;

  const AllowedFileType({
    required this.extension,
    required this.mimeType,
    this.selected = false,
  });

  AllowedFileType copyWith({bool? selected}) {
    return AllowedFileType(
      extension: extension,
      mimeType: mimeType,
      selected: selected ?? this.selected,
    );
  }
}

/// Common file types for assignment submissions
const List<AllowedFileType> commonFileTypes = [
  AllowedFileType(extension: 'pdf', mimeType: 'application/pdf'),
  AllowedFileType(extension: 'doc', mimeType: 'application/msword'),
  AllowedFileType(extension: 'docx', mimeType: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'),
  AllowedFileType(extension: 'txt', mimeType: 'text/plain'),
  AllowedFileType(extension: 'jpg', mimeType: 'image/jpeg'),
  AllowedFileType(extension: 'png', mimeType: 'image/png'),
  AllowedFileType(extension: 'zip', mimeType: 'application/zip'),
  AllowedFileType(extension: 'py', mimeType: 'text/x-python'),
  AllowedFileType(extension: 'java', mimeType: 'text/x-java'),
  AllowedFileType(extension: 'js', mimeType: 'text/javascript'),
  AllowedFileType(extension: 'html', mimeType: 'text/html'),
  AllowedFileType(extension: 'css', mimeType: 'text/css'),
  AllowedFileType(extension: 'xlsx', mimeType: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'),
  AllowedFileType(extension: 'pptx', mimeType: 'application/vnd.openxmlformats-officedocument.presentationml.presentation'),
];

/// A professional assignment content editor for creating college-grade assignments.
/// Supports comprehensive submission settings, rubric building, and grading configuration.
class AssignmentContentEditor extends StatefulWidget {
  final AssignmentContent? initialContent;
  final Function(AssignmentContentRequest) onSave;

  const AssignmentContentEditor({
    super.key,
    this.initialContent,
    required this.onSave,
  });

  @override
  State<AssignmentContentEditor> createState() => _AssignmentContentEditorState();
}

class _AssignmentContentEditorState extends State<AssignmentContentEditor>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  // Basic details
  late TextEditingController _instructionsController;
  int _pointsPossible = 100;
  int _estimatedMinutes = 60;

  // Due date settings
  DateTime? _dueDate;
  TimeOfDay? _dueTime;
  String _timezone = 'America/New_York';

  // Late submission policy
  LatePolicy _latePolicy = LatePolicy.notAllowed;
  int _latePenaltyPercent = 10;
  int _maxLateDays = 7;

  // Submission type
  SubmissionTypeOption _submissionType = SubmissionTypeOption.file;

  // File upload settings
  List<AllowedFileType> _allowedFileTypes = List.from(commonFileTypes);
  int _maxFileSizeMB = 50;
  int _maxFiles = 5;

  // Rubric
  final List<RubricCriterion> _rubricCriteria = [];
  bool _useRubric = false;

  // Group settings
  bool _isGroupAssignment = false;
  int _minGroupSize = 2;
  int _maxGroupSize = 4;

  // Peer review
  bool _enablePeerReview = false;
  int _peersToReview = 3;
  bool _anonymousPeerReview = true;

  // Resources
  final List<ResourceLink> _resources = [];

  // Other settings
  bool _enablePlagiarismCheck = true;
  bool _allowResubmission = true;
  int _maxResubmissions = 3;

  // State tracking
  bool _hasChanges = false;
  bool _isSaving = false;

  late TabController _tabController;

  int get _totalRubricPoints {
    return _rubricCriteria.fold(0, (sum, criterion) => sum + criterion.points);
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);

    _instructionsController = TextEditingController(
      text: widget.initialContent?.instructions ?? '',
    );

    // Load initial content
    if (widget.initialContent != null) {
      final content = widget.initialContent!;
      _pointsPossible = content.pointsPossible;
      // TODO: Fix submission type conversion - currently disabled due to type mismatch
      // _submissionType = SubmissionTypeOption.fromString(content.submissionType);

      if (content.dueDate != null) {
        _dueDate = content.dueDate;
        _dueTime = TimeOfDay.fromDateTime(content.dueDate!);
      }

      // TODO: Re-enable when model is updated with these fields
      // _allowResubmission = content.allowResubmission;
      // _maxResubmissions = content.maxResubmissions ?? 3;

      // Load rubric
      if (content.rubric.isNotEmpty) {
        _useRubric = true;
        for (final item in content.rubric) {
          _rubricCriteria.add(RubricCriterion.fromJson(item));
        }
      }
    }

    // Initialize with some default allowed file types
    _allowedFileTypes = _allowedFileTypes.map((type) {
      if (['pdf', 'doc', 'docx', 'txt'].contains(type.extension)) {
        return type.copyWith(selected: true);
      }
      return type;
    }).toList();

    // Add listeners
    _instructionsController.addListener(_onContentChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  void _onContentChanged() {
    if (!_hasChanges) {
      setState(() => _hasChanges = true);
    }
  }

  bool get _isValid {
    return _instructionsController.text.isNotEmpty &&
        _pointsPossible > 0 &&
        (!_useRubric || _rubricCriteria.isNotEmpty);
  }

  List<String> _validate() {
    final errors = <String>[];

    if (_instructionsController.text.isEmpty) {
      errors.add('Assignment instructions are required');
    }

    if (_instructionsController.text.length < 50) {
      errors.add('Instructions should be at least 50 characters for clarity');
    }

    if (_pointsPossible <= 0) {
      errors.add('Points possible must be greater than 0');
    }

    if (_useRubric) {
      if (_rubricCriteria.isEmpty) {
        errors.add('At least one rubric criterion is required when using rubric');
      } else if (_totalRubricPoints != _pointsPossible) {
        errors.add('Rubric total (${_totalRubricPoints}) should match points possible ($_pointsPossible)');
      }
    }

    if (_submissionType == SubmissionTypeOption.file || _submissionType == SubmissionTypeOption.combined) {
      final selectedTypes = _allowedFileTypes.where((t) => t.selected);
      if (selectedTypes.isEmpty) {
        errors.add('At least one file type must be allowed for file submissions');
      }
    }

    if (_isGroupAssignment && _minGroupSize > _maxGroupSize) {
      errors.add('Minimum group size cannot exceed maximum group size');
    }

    if (_latePolicy == LatePolicy.allowedWithPenalty && _latePenaltyPercent <= 0) {
      errors.add('Late penalty must be greater than 0%');
    }

    return errors;
  }

  @override
  Widget build(BuildContext context) {
    return ContentEditorWrapper(
      title: 'Assignment Content Editor',
      subtitle: 'Create comprehensive assignments with rubrics and settings',
      icon: Icons.assignment,
      themeColor: Colors.green,
      editorContent: _buildEditorContent(),
      previewContent: _buildPreviewContent(),
      onSave: _saveContent,
      onCancel: () => Navigator.pop(context),
      hasUnsavedChanges: () => _hasChanges,
      validate: _validate,
      isValid: _isValid,
      isSaving: _isSaving,
      saveButtonLabel: 'Save Assignment',
      summaryWidget: _buildSummaryWidget(),
    );
  }

  Widget _buildSummaryWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _isValid ? Colors.green.shade50 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _isValid ? Colors.green.shade200 : Colors.orange.shade200,
        ),
      ),
      child: Row(
        children: [
          Icon(
            _isValid ? Icons.check_circle : Icons.warning,
            size: 20,
            color: _isValid ? Colors.green.shade700 : Colors.orange.shade700,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _buildSummaryChip(
                  Icons.star,
                  '$_pointsPossible pts',
                  Colors.blue,
                ),
                _buildSummaryChip(
                  _submissionType.icon,
                  _submissionType.displayName,
                  _submissionType.color,
                ),
                if (_useRubric)
                  _buildSummaryChip(
                    Icons.checklist,
                    '${_rubricCriteria.length} criteria',
                    Colors.purple,
                  ),
                if (_dueDate != null)
                  _buildSummaryChip(
                    Icons.calendar_today,
                    'Due ${_formatDate(_dueDate!)}',
                    Colors.orange,
                  ),
                if (_isGroupAssignment)
                  _buildSummaryChip(
                    Icons.group,
                    'Groups $_minGroupSize-$_maxGroupSize',
                    Colors.teal,
                  ),
                if (_enablePeerReview)
                  _buildSummaryChip(
                    Icons.rate_review,
                    'Peer Review',
                    Colors.amber,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha:0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  Widget _buildEditorContent() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: const [
              Tab(icon: Icon(Icons.description), text: 'Details'),
              Tab(icon: Icon(Icons.upload), text: 'Submission'),
              Tab(icon: Icon(Icons.checklist), text: 'Rubric'),
              Tab(icon: Icon(Icons.settings), text: 'Settings'),
              Tab(icon: Icon(Icons.library_books), text: 'Resources'),
            ],
            labelColor: Colors.green.shade700,
            indicatorColor: Colors.green.shade700,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDetailsTab(),
                _buildSubmissionTab(),
                _buildRubricTab(),
                _buildSettingsTab(),
                _buildResourcesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Instructions
          EditorSection(
            title: 'Assignment Instructions',
            icon: Icons.description,
            iconColor: Colors.blue,
            subtitle: 'What should students do?',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _instructionsController,
                  decoration: const InputDecoration(
                    labelText: 'Instructions *',
                    hintText: 'Provide clear instructions for the assignment...\n\n'
                        '1. What students need to submit\n'
                        '2. Requirements and expectations\n'
                        '3. Grading criteria overview',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 12,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Instructions are required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  '${_instructionsController.text.length} characters',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Points and Time
          EditorSection(
            title: 'Grading & Time',
            icon: Icons.star,
            iconColor: Colors.amber,
            subtitle: 'Set points and estimated time',
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: _pointsPossible.toString(),
                    decoration: const InputDecoration(
                      labelText: 'Points Possible *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.star),
                      suffixText: 'pts',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) {
                      setState(() {
                        _pointsPossible = int.tryParse(value) ?? 100;
                        _hasChanges = true;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      final points = int.tryParse(value);
                      if (points == null || points <= 0) {
                        return 'Must be > 0';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    initialValue: _estimatedMinutes.toString(),
                    decoration: const InputDecoration(
                      labelText: 'Est. Completion Time',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.timer),
                      suffixText: 'min',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) {
                      setState(() {
                        _estimatedMinutes = int.tryParse(value) ?? 60;
                        _hasChanges = true;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Due Date
          EditorSection(
            title: 'Due Date & Time',
            icon: Icons.calendar_today,
            iconColor: Colors.orange,
            subtitle: 'When is this assignment due?',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: InkWell(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _dueDate ?? DateTime.now().add(const Duration(days: 7)),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          );
                          if (date != null) {
                            setState(() {
                              _dueDate = date;
                              _hasChanges = true;
                            });
                          }
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Due Date',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                          child: Text(
                            _dueDate != null ? _formatDate(_dueDate!) : 'Select date',
                            style: TextStyle(
                              color: _dueDate != null ? Colors.black : Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: _dueTime ?? const TimeOfDay(hour: 23, minute: 59),
                          );
                          if (time != null) {
                            setState(() {
                              _dueTime = time;
                              _hasChanges = true;
                            });
                          }
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Time',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.access_time),
                          ),
                          child: Text(
                            _dueTime != null ? _dueTime!.format(context) : '11:59 PM',
                            style: TextStyle(
                              color: _dueTime != null ? Colors.black : Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _timezone,
                  decoration: const InputDecoration(
                    labelText: 'Timezone',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.public),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'America/New_York', child: Text('Eastern Time (ET)')),
                    DropdownMenuItem(value: 'America/Chicago', child: Text('Central Time (CT)')),
                    DropdownMenuItem(value: 'America/Denver', child: Text('Mountain Time (MT)')),
                    DropdownMenuItem(value: 'America/Los_Angeles', child: Text('Pacific Time (PT)')),
                    DropdownMenuItem(value: 'UTC', child: Text('UTC')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _timezone = value ?? 'America/New_York';
                      _hasChanges = true;
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Late Policy
          EditorSection(
            title: 'Late Submission Policy',
            icon: Icons.schedule,
            iconColor: Colors.red,
            subtitle: 'Configure late submission handling',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<LatePolicy>(
                  value: _latePolicy,
                  decoration: const InputDecoration(
                    labelText: 'Late Submissions',
                    border: OutlineInputBorder(),
                  ),
                  items: LatePolicy.values.map((policy) {
                    return DropdownMenuItem(
                      value: policy,
                      child: Text(policy.displayName),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _latePolicy = value ?? LatePolicy.notAllowed;
                      _hasChanges = true;
                    });
                  },
                ),
                if (_latePolicy == LatePolicy.allowedWithPenalty) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: _latePenaltyPercent.toString(),
                          decoration: const InputDecoration(
                            labelText: 'Penalty Per Day',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.remove_circle_outline),
                            suffixText: '%',
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          onChanged: (value) {
                            setState(() {
                              _latePenaltyPercent = int.tryParse(value) ?? 10;
                              _hasChanges = true;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          initialValue: _maxLateDays.toString(),
                          decoration: const InputDecoration(
                            labelText: 'Max Late Days',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.event),
                            suffixText: 'days',
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          onChanged: (value) {
                            setState(() {
                              _maxLateDays = int.tryParse(value) ?? 7;
                              _hasChanges = true;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, size: 20, color: Colors.red.shade700),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Students lose $_latePenaltyPercent% per day, up to $_maxLateDays days late. '
                            'After that, submissions are not accepted.',
                            style: TextStyle(color: Colors.red.shade700, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmissionTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          // Submission Type
          EditorSection(
            title: 'Submission Type',
            icon: Icons.upload,
            iconColor: Colors.blue,
            subtitle: 'How should students submit their work?',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: SubmissionTypeOption.values.map((type) {
                    final isSelected = _submissionType == type;
                    return ChoiceChip(
                      selected: isSelected,
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(type.icon, size: 18, color: isSelected ? type.color : Colors.grey),
                          const SizedBox(width: 8),
                          Text(type.displayName),
                        ],
                      ),
                      selectedColor: type.color.withValues(alpha:0.2),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _submissionType = type;
                            _hasChanges = true;
                          });
                        }
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _submissionType.color.withValues(alpha:0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _submissionType.color.withValues(alpha:0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(_submissionType.icon, color: _submissionType.color),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _getSubmissionTypeDescription(_submissionType),
                          style: TextStyle(color: _submissionType.color),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // File Upload Settings (if applicable)
          if (_submissionType == SubmissionTypeOption.file ||
              _submissionType == SubmissionTypeOption.combined) ...[
            EditorSection(
              title: 'File Upload Settings',
              icon: Icons.folder,
              iconColor: Colors.orange,
              subtitle: 'Configure file upload options',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Allowed file types
                  const Text(
                    'Allowed File Types',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(_allowedFileTypes.length, (index) {
                      final type = _allowedFileTypes[index];
                      return FilterChip(
                        selected: type.selected,
                        label: Text('.${type.extension}'),
                        onSelected: (selected) {
                          setState(() {
                            _allowedFileTypes[index] = type.copyWith(selected: selected);
                            _hasChanges = true;
                          });
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 16),

                  // File limits
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: _maxFileSizeMB.toString(),
                          decoration: const InputDecoration(
                            labelText: 'Max File Size',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.storage),
                            suffixText: 'MB',
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          onChanged: (value) {
                            setState(() {
                              _maxFileSizeMB = int.tryParse(value) ?? 50;
                              _hasChanges = true;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          initialValue: _maxFiles.toString(),
                          decoration: const InputDecoration(
                            labelText: 'Max Files',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.file_copy),
                            suffixText: 'files',
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          onChanged: (value) {
                            setState(() {
                              _maxFiles = int.tryParse(value) ?? 5;
                              _hasChanges = true;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
          ],

          // Resubmission Settings
          EditorSection(
            title: 'Resubmission Settings',
            icon: Icons.refresh,
            iconColor: Colors.teal,
            subtitle: 'Can students resubmit their work?',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabeledSwitch(
                  title: 'Allow Resubmissions',
                  subtitle: 'Students can submit again before the deadline',
                  icon: Icons.refresh,
                  iconColor: Colors.teal,
                  value: _allowResubmission,
                  onChanged: (value) {
                    setState(() {
                      _allowResubmission = value;
                      _hasChanges = true;
                    });
                  },
                ),
                if (_allowResubmission) ...[
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: _maxResubmissions.toString(),
                    decoration: const InputDecoration(
                      labelText: 'Maximum Resubmissions',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.repeat),
                      helperText: 'Set to 0 for unlimited',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) {
                      setState(() {
                        _maxResubmissions = int.tryParse(value) ?? 3;
                        _hasChanges = true;
                      });
                    },
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getSubmissionTypeDescription(SubmissionTypeOption type) {
    switch (type) {
      case SubmissionTypeOption.text:
        return 'Students type their response directly in a text box.';
      case SubmissionTypeOption.file:
        return 'Students upload files (documents, images, code, etc.)';
      case SubmissionTypeOption.url:
        return 'Students submit a URL (GitHub repo, Google Drive, etc.)';
      case SubmissionTypeOption.combined:
        return 'Students can both type a response and upload files.';
    }
  }

  Widget _buildRubricTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          EditorSection(
            title: 'Grading Rubric',
            icon: Icons.checklist,
            iconColor: Colors.purple,
            subtitle: 'Define grading criteria for consistent assessment',
            trailing: _useRubric
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _totalRubricPoints == _pointsPossible
                          ? Colors.green.shade100
                          : Colors.red.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$_totalRubricPoints/$_pointsPossible pts',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _totalRubricPoints == _pointsPossible
                            ? Colors.green.shade700
                            : Colors.red.shade700,
                      ),
                    ),
                  )
                : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabeledSwitch(
                  title: 'Use Rubric',
                  subtitle: 'Enable detailed grading rubric for this assignment',
                  icon: Icons.checklist,
                  iconColor: Colors.purple,
                  value: _useRubric,
                  onChanged: (value) {
                    setState(() {
                      _useRubric = value;
                      _hasChanges = true;
                    });
                  },
                ),

                if (_useRubric) ...[
                  const SizedBox(height: 16),

                  if (_rubricCriteria.isEmpty)
                    _buildEmptyState(
                      icon: Icons.format_list_numbered,
                      title: 'No criteria defined',
                      subtitle: 'Add grading criteria to your rubric',
                    )
                  else
                    ReorderableListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _rubricCriteria.length,
                      onReorder: (oldIndex, newIndex) {
                        setState(() {
                          if (newIndex > oldIndex) newIndex--;
                          final item = _rubricCriteria.removeAt(oldIndex);
                          _rubricCriteria.insert(newIndex, item);
                          _hasChanges = true;
                        });
                      },
                      itemBuilder: (context, index) {
                        final criterion = _rubricCriteria[index];
                        return Card(
                          key: ValueKey(criterion.id),
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.purple.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  '${criterion.points}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.purple.shade700,
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              criterion.name,
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            subtitle: criterion.description.isNotEmpty
                                ? Text(
                                    criterion.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                : null,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, size: 20),
                                  onPressed: () => _showEditCriterionDialog(index),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, size: 20, color: Colors.red.shade400),
                                  onPressed: () {
                                    setState(() {
                                      _rubricCriteria.removeAt(index);
                                      _hasChanges = true;
                                    });
                                  },
                                ),
                                const Icon(Icons.drag_handle),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: _showAddCriterionDialog,
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Add Criterion'),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: () {
                          // Auto-distribute points
                          if (_rubricCriteria.isNotEmpty) {
                            final pointsEach = _pointsPossible ~/ _rubricCriteria.length;
                            final remainder = _pointsPossible % _rubricCriteria.length;
                            setState(() {
                              for (int i = 0; i < _rubricCriteria.length; i++) {
                                final extra = i < remainder ? 1 : 0;
                                _rubricCriteria[i] = _rubricCriteria[i].copyWith(
                                  points: pointsEach + extra,
                                );
                              }
                              _hasChanges = true;
                            });
                          }
                        },
                        icon: const Icon(Icons.auto_fix_high, size: 18),
                        label: const Text('Auto-Distribute Points'),
                      ),
                    ],
                  ),

                  if (_totalRubricPoints != _pointsPossible && _rubricCriteria.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.warning, size: 20, color: Colors.red.shade700),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Rubric total ($_totalRubricPoints pts) does not match points possible ($_pointsPossible pts)',
                              style: TextStyle(color: Colors.red.shade700, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          // Group Assignment Settings
          EditorSection(
            title: 'Group Assignment',
            icon: Icons.group,
            iconColor: Colors.teal,
            subtitle: 'Configure group submission settings',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabeledSwitch(
                  title: 'Group Assignment',
                  subtitle: 'Students work in groups on this assignment',
                  icon: Icons.group,
                  iconColor: Colors.teal,
                  value: _isGroupAssignment,
                  onChanged: (value) {
                    setState(() {
                      _isGroupAssignment = value;
                      _hasChanges = true;
                    });
                  },
                ),
                if (_isGroupAssignment) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: _minGroupSize.toString(),
                          decoration: const InputDecoration(
                            labelText: 'Min Group Size',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          onChanged: (value) {
                            setState(() {
                              _minGroupSize = int.tryParse(value) ?? 2;
                              _hasChanges = true;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          initialValue: _maxGroupSize.toString(),
                          decoration: const InputDecoration(
                            labelText: 'Max Group Size',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.people),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          onChanged: (value) {
                            setState(() {
                              _maxGroupSize = int.tryParse(value) ?? 4;
                              _hasChanges = true;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Peer Review Settings
          EditorSection(
            title: 'Peer Review',
            icon: Icons.rate_review,
            iconColor: Colors.amber,
            subtitle: 'Enable student peer review',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabeledSwitch(
                  title: 'Enable Peer Review',
                  subtitle: 'Students review each other\'s work',
                  icon: Icons.rate_review,
                  iconColor: Colors.amber,
                  value: _enablePeerReview,
                  onChanged: (value) {
                    setState(() {
                      _enablePeerReview = value;
                      _hasChanges = true;
                    });
                  },
                ),
                if (_enablePeerReview) ...[
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _peersToReview.toString(),
                    decoration: const InputDecoration(
                      labelText: 'Number of Peers to Review',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.group),
                      helperText: 'How many submissions each student must review',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) {
                      setState(() {
                        _peersToReview = int.tryParse(value) ?? 3;
                        _hasChanges = true;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  LabeledSwitch(
                    title: 'Anonymous Reviews',
                    subtitle: 'Hide student names during peer review',
                    icon: Icons.visibility_off,
                    iconColor: Colors.grey,
                    value: _anonymousPeerReview,
                    onChanged: (value) {
                      setState(() {
                        _anonymousPeerReview = value;
                        _hasChanges = true;
                      });
                    },
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Academic Integrity
          EditorSection(
            title: 'Academic Integrity',
            icon: Icons.security,
            iconColor: Colors.red,
            subtitle: 'Plagiarism detection settings',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabeledSwitch(
                  title: 'Plagiarism Check',
                  subtitle: 'Automatically check submissions for plagiarism',
                  icon: Icons.find_in_page,
                  iconColor: Colors.red,
                  value: _enablePlagiarismCheck,
                  onChanged: (value) {
                    setState(() {
                      _enablePlagiarismCheck = value;
                      _hasChanges = true;
                    });
                  },
                ),
                if (_enablePlagiarismCheck) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, size: 20, color: Colors.red.shade700),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Submissions will be checked against online sources and previous submissions. Results will be visible to instructors.',
                            style: TextStyle(color: Colors.red.shade700, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourcesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          EditorSection(
            title: 'Helpful Resources',
            icon: Icons.library_books,
            iconColor: Colors.blue,
            subtitle: 'Add links to reference materials',
            trailing: Text(
              '${_resources.length} resources',
              style: TextStyle(
                color: Colors.blue.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_resources.isEmpty)
                  _buildEmptyState(
                    icon: Icons.library_add,
                    title: 'No resources added',
                    subtitle: 'Add helpful links and reference materials',
                  )
                else
                  ...List.generate(_resources.length, (index) {
                    final resource = _resources[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.link,
                            color: Colors.blue.shade700,
                          ),
                        ),
                        title: Text(resource.title),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              resource.url,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue.shade600,
                              ),
                            ),
                            if (resource.description != null)
                              Text(
                                resource.description!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, size: 20, color: Colors.red.shade400),
                          onPressed: () {
                            setState(() {
                              _resources.removeAt(index);
                              _hasChanges = true;
                            });
                          },
                        ),
                      ),
                    );
                  }),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: _showAddResourceDialog,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Resource'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(icon, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.assignment, color: Colors.green.shade700, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.shade700,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$_pointsPossible pts',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _submissionType.color.withValues(alpha:0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(_submissionType.icon, size: 14, color: _submissionType.color),
                              const SizedBox(width: 4),
                              Text(
                                _submissionType.displayName,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: _submissionType.color,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (_dueDate != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade600),
                          const SizedBox(width: 4),
                          Text(
                            'Due: ${_formatDate(_dueDate!)} ${_dueTime?.format(context) ?? '11:59 PM'}',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ],
                    if (_estimatedMinutes > 0) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.timer, size: 16, color: Colors.grey.shade600),
                          const SizedBox(width: 4),
                          Text(
                            'Estimated time: $_estimatedMinutes min',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Instructions
        Text(
          'Instructions',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Text(
            _instructionsController.text.isEmpty
                ? 'No instructions provided'
                : _instructionsController.text,
            style: const TextStyle(height: 1.6),
          ),
        ),

        // Rubric Preview
        if (_useRubric && _rubricCriteria.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text(
            'Grading Rubric',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade50,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        flex: 3,
                        child: Text(
                          'Criterion',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Expanded(
                        flex: 4,
                        child: Text(
                          'Description',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: 80,
                        child: Text(
                          'Points',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.purple.shade700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                ...List.generate(_rubricCriteria.length, (index) {
                  final criterion = _rubricCriteria[index];
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            criterion.name,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Text(
                            criterion.description.isEmpty
                                ? '-'
                                : criterion.description,
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ),
                        SizedBox(
                          width: 80,
                          child: Text(
                            '${criterion.points}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.purple.shade700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        flex: 7,
                        child: Text(
                          'Total',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      SizedBox(
                        width: 80,
                        child: Text(
                          '$_totalRubricPoints',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.purple.shade700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],

        // Settings Summary
        const SizedBox(height: 24),
        Text(
          'Submission Settings',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              _buildSettingRow(
                Icons.upload,
                'Submission Type',
                _submissionType.displayName,
              ),
              if (_submissionType == SubmissionTypeOption.file ||
                  _submissionType == SubmissionTypeOption.combined) ...[
                const Divider(),
                _buildSettingRow(
                  Icons.storage,
                  'Max File Size',
                  '$_maxFileSizeMB MB',
                ),
                const Divider(),
                _buildSettingRow(
                  Icons.file_copy,
                  'Max Files',
                  '$_maxFiles files',
                ),
              ],
              const Divider(),
              _buildSettingRow(
                Icons.refresh,
                'Resubmissions',
                _allowResubmission
                    ? (_maxResubmissions == 0 ? 'Unlimited' : 'Up to $_maxResubmissions')
                    : 'Not allowed',
              ),
              const Divider(),
              _buildSettingRow(
                Icons.schedule,
                'Late Policy',
                _latePolicy.displayName,
              ),
              if (_isGroupAssignment) ...[
                const Divider(),
                _buildSettingRow(
                  Icons.group,
                  'Group Size',
                  '$_minGroupSize - $_maxGroupSize students',
                ),
              ],
              if (_enablePeerReview) ...[
                const Divider(),
                _buildSettingRow(
                  Icons.rate_review,
                  'Peer Review',
                  '$_peersToReview reviews per student',
                ),
              ],
              if (_enablePlagiarismCheck) ...[
                const Divider(),
                _buildSettingRow(
                  Icons.security,
                  'Plagiarism Check',
                  'Enabled',
                ),
              ],
            ],
          ),
        ),

        // Resources
        if (_resources.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text(
            'Helpful Resources',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          ...List.generate(_resources.length, (index) {
            final resource = _resources[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.link, color: Colors.blue.shade700),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          resource.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.blue.shade700,
                          ),
                        ),
                        if (resource.description != null)
                          Text(
                            resource.description!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Icon(Icons.open_in_new, size: 16, color: Colors.blue.shade700),
                ],
              ),
            );
          }),
        ],
      ],
    );
  }

  Widget _buildSettingRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  // Dialog methods
  void _showAddCriterionDialog() {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    final pointsController = TextEditingController(text: '10');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.add_circle, color: Colors.purple),
            SizedBox(width: 12),
            Text('Add Rubric Criterion'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Criterion Name *',
                  hintText: 'e.g., Code Quality',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'What defines excellent performance?',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: pointsController,
                decoration: const InputDecoration(
                  labelText: 'Points *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.star),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                setState(() {
                  _rubricCriteria.add(RubricCriterion(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: nameController.text,
                    description: descController.text,
                    points: int.tryParse(pointsController.text) ?? 10,
                    order: _rubricCriteria.length,
                  ));
                  _hasChanges = true;
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditCriterionDialog(int index) {
    final criterion = _rubricCriteria[index];
    final nameController = TextEditingController(text: criterion.name);
    final descController = TextEditingController(text: criterion.description);
    final pointsController = TextEditingController(text: criterion.points.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.edit, color: Colors.purple),
            SizedBox(width: 12),
            Text('Edit Criterion'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Criterion Name *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: pointsController,
                decoration: const InputDecoration(
                  labelText: 'Points *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.star),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                setState(() {
                  _rubricCriteria[index] = criterion.copyWith(
                    name: nameController.text,
                    description: descController.text,
                    points: int.tryParse(pointsController.text) ?? criterion.points,
                  );
                  _hasChanges = true;
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showAddResourceDialog() {
    final titleController = TextEditingController();
    final urlController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.library_add, color: Colors.blue),
            SizedBox(width: 12),
            Text('Add Resource'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title *',
                  hintText: 'e.g., Style Guide',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: urlController,
                decoration: const InputDecoration(
                  labelText: 'URL *',
                  hintText: 'https://example.com',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descController,
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  hintText: 'Brief description of this resource',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty && urlController.text.isNotEmpty) {
                setState(() {
                  _resources.add(ResourceLink(
                    title: titleController.text,
                    url: urlController.text,
                    description: descController.text.isEmpty ? null : descController.text,
                  ));
                  _hasChanges = true;
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _saveContent() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isSaving = true);

      final selectedFileTypes = _allowedFileTypes
          .where((t) => t.selected)
          .map((t) => '.${t.extension}')
          .toList();

      // Map SubmissionTypeOption to SubmissionType enum
      SubmissionType? mappedSubmissionType;
      switch (_submissionType) {
        case SubmissionTypeOption.text:
          mappedSubmissionType = SubmissionType.text;
          break;
        case SubmissionTypeOption.file:
          mappedSubmissionType = SubmissionType.file;
          break;
        case SubmissionTypeOption.url:
          mappedSubmissionType = SubmissionType.url;
          break;
        case SubmissionTypeOption.combined:
          mappedSubmissionType = SubmissionType.both;
          break;
      }

      final request = AssignmentContentRequest(
        title: 'Assignment', // TODO: Get from lesson title
        instructions: _instructionsController.text,
        pointsPossible: _pointsPossible,
        submissionType: mappedSubmissionType,
        dueDate: _dueDate != null && _dueTime != null
            ? DateTime(
                _dueDate!.year,
                _dueDate!.month,
                _dueDate!.day,
                _dueTime!.hour,
                _dueTime!.minute,
              )
            : _dueDate,
        // allowResubmission: _allowResubmission, // TODO: Add to model when backend supports it
        // maxResubmissions: _allowResubmission ? _maxResubmissions : null, // TODO: Add to model when backend supports it
        rubric: _useRubric && _rubricCriteria.isNotEmpty
            ? _rubricCriteria.map((c) => c.toJson()).toList()
            : null,
        allowedFileTypes: selectedFileTypes.isEmpty ? null : selectedFileTypes,
        maxFileSizeMb: _maxFileSizeMB,
        // maxFiles: _maxFiles, // TODO: Add to model when backend supports it
      );

      widget.onSave(request);
      Navigator.pop(context);
    }
  }
}
