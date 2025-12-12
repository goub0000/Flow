import 'package:flutter/material.dart';
import '../../../../core/models/quiz_assignment_models.dart';

class AssignmentContentEditor extends StatefulWidget {
  final AssignmentContent? initialContent;
  final Function(AssignmentContentRequest) onSave;

  const AssignmentContentEditor({
    super.key,
    this.initialContent,
    required this.onSave,
  });

  @override
  State<AssignmentContentEditor> createState() =>
      _AssignmentContentEditorState();
}

class _AssignmentContentEditorState extends State<AssignmentContentEditor> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _instructionsController;
  late TextEditingController _pointsController;
  DateTime? _dueDate;
  SubmissionType _submissionType = SubmissionType.both;
  final List<String> _allowedFileTypes = [];
  final List<Map<String, dynamic>> _rubricCriteria = [];
  int? _maxFileSize;

  @override
  void initState() {
    super.initState();
    _instructionsController = TextEditingController(
      text: widget.initialContent?.instructions ?? '',
    );
    _pointsController = TextEditingController(
      text: widget.initialContent?.pointsPossible.toString() ?? '100',
    );
    _dueDate = widget.initialContent?.dueDate;
    _submissionType = widget.initialContent?.submissionType ?? SubmissionType.both;
    if (widget.initialContent?.allowedFileTypes != null) {
      _allowedFileTypes.addAll(widget.initialContent!.allowedFileTypes!);
    }
    if (widget.initialContent?.rubric != null) {
      _rubricCriteria.addAll(widget.initialContent!.rubric!);
    }
    _maxFileSize = widget.initialContent?.maxFileSize;
  }

  @override
  void dispose() {
    _instructionsController.dispose();
    _pointsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Assignment Content',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _instructionsController,
              decoration: const InputDecoration(
                labelText: 'Instructions',
                hintText: 'Enter assignment instructions...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 8,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter instructions';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _pointsController,
                    decoration: const InputDecoration(
                      labelText: 'Points Possible',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.star),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Invalid number';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    onTap: _selectDueDate,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Due Date',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      child: Text(
                        _dueDate == null
                            ? 'No due date'
                            : '${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<SubmissionType>(
              value: _submissionType,
              decoration: const InputDecoration(
                labelText: 'Submission Type',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.upload_file),
              ),
              items: SubmissionType.values
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Row(
                          children: [
                            Icon(type.icon, size: 20),
                            const SizedBox(width: 8),
                            Text(type.displayName),
                          ],
                        ),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _submissionType = value!;
                });
              },
            ),
            if (_submissionType == SubmissionType.file ||
                _submissionType == SubmissionType.both) ...[
              const SizedBox(height: 16),
              _buildAllowedFileTypesSection(),
              const SizedBox(height: 16),
              DropdownButtonFormField<int?>(
                value: _maxFileSize,
                decoration: const InputDecoration(
                  labelText: 'Maximum File Size',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.storage),
                ),
                items: const [
                  DropdownMenuItem(
                    value: null,
                    child: Text('No limit'),
                  ),
                  DropdownMenuItem(
                    value: 5,
                    child: Text('5 MB'),
                  ),
                  DropdownMenuItem(
                    value: 10,
                    child: Text('10 MB'),
                  ),
                  DropdownMenuItem(
                    value: 25,
                    child: Text('25 MB'),
                  ),
                  DropdownMenuItem(
                    value: 50,
                    child: Text('50 MB'),
                  ),
                  DropdownMenuItem(
                    value: 100,
                    child: Text('100 MB'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _maxFileSize = value;
                  });
                },
              ),
            ],
            const SizedBox(height: 16),
            _buildRubricSection(),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _saveContent,
                  icon: const Icon(Icons.save),
                  label: const Text('Save Assignment Content'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllowedFileTypesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Allowed File Types',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: _addFileType,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Type'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_allowedFileTypes.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                'All file types allowed',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _allowedFileTypes.map((type) {
              return Chip(
                label: Text(type),
                onDeleted: () {
                  setState(() {
                    _allowedFileTypes.remove(type);
                  });
                },
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildRubricSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Grading Rubric',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: _addRubricCriteria,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Criteria'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_rubricCriteria.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                'No rubric criteria added',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          )
        else
          ...List.generate(_rubricCriteria.length, (index) {
            final criteria = _rubricCriteria[index];
            return Card(
              child: ListTile(
                title: Text(criteria['criterion'] as String),
                subtitle: Text('${criteria['points']} points'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      _rubricCriteria.removeAt(index);
                    });
                  },
                ),
              ),
            );
          }),
      ],
    );
  }

  Future<void> _selectDueDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      setState(() {
        _dueDate = date;
      });
    }
  }

  void _addFileType() {
    final commonTypes = [
      '.pdf',
      '.doc',
      '.docx',
      '.txt',
      '.jpg',
      '.png',
      '.zip',
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add File Type'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: commonTypes
              .map((type) => ListTile(
                    title: Text(type),
                    onTap: () {
                      if (!_allowedFileTypes.contains(type)) {
                        setState(() {
                          _allowedFileTypes.add(type);
                        });
                      }
                      Navigator.pop(context);
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }

  void _addRubricCriteria() {
    final criterionController = TextEditingController();
    final pointsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Rubric Criteria'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: criterionController,
              decoration: const InputDecoration(
                labelText: 'Criterion',
                hintText: 'e.g., Code Quality',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: pointsController,
              decoration: const InputDecoration(
                labelText: 'Points',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (criterionController.text.isNotEmpty &&
                  pointsController.text.isNotEmpty) {
                setState(() {
                  _rubricCriteria.add({
                    'criterion': criterionController.text,
                    'points': int.parse(pointsController.text),
                  });
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
    if (_formKey.currentState!.validate()) {
      final request = AssignmentContentRequest(
        instructions: _instructionsController.text,
        pointsPossible: int.parse(_pointsController.text),
        dueDate: _dueDate,
        submissionType: _submissionType,
        allowedFileTypes:
            _allowedFileTypes.isEmpty ? null : _allowedFileTypes,
        maxFileSize: _maxFileSize,
        rubric: _rubricCriteria.isEmpty ? null : _rubricCriteria,
      );

      widget.onSave(request);
      Navigator.pop(context);
    }
  }
}
